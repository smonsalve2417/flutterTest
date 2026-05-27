import '../../domain/entities/pokemon_collection.dart';
import '../../domain/entities/pokemon_entry.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_memory_data_source.dart';
import '../datasources/pokemon_remote_data_source.dart';
import '../models/pokemon_api_page.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  PokemonRepositoryImpl({
    required PokemonRemoteDataSource remoteDataSource,
    required PokemonMemoryDataSource memoryDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _memoryDataSource = memoryDataSource;

  final PokemonRemoteDataSource _remoteDataSource;
  final PokemonMemoryDataSource _memoryDataSource;

  String? _nextPageUrl;
  bool _isInitialLoaded = false;

  @override
  Future<PokemonCollection> loadInitial() async {
    if (_isInitialLoaded && _memoryDataSource.items.isNotEmpty) {
      return _memoryDataSource.snapshot(hasMore: _nextPageUrl != null);
    }

    final page = await _remoteDataSource.fetchPage();
    final entries = page.results.map<PokemonEntry>(_toEntry).toList();

    _nextPageUrl = page.next;
    _isInitialLoaded = true;
    _memoryDataSource.replaceAll(entries);

    return _memoryDataSource.snapshot(hasMore: _nextPageUrl != null);
  }

  @override
  Future<PokemonCollection> loadMore() async {
    if (_nextPageUrl == null) {
      return _memoryDataSource.snapshot(hasMore: false);
    }

    final page = await _remoteDataSource.fetchPage(nextUrl: _nextPageUrl);
    final entries = page.results.map<PokemonEntry>(_toEntry).toList();

    _nextPageUrl = page.next;
    _memoryDataSource.appendAll(entries);

    return _memoryDataSource.snapshot(hasMore: _nextPageUrl != null);
  }

  @override
  Future<PokemonCollection> createPokemon({
    required String name,
    required String url,
  }) async {
    final entry = PokemonEntry(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      url: url.trim().isEmpty ? _buildLocalUrl(name) : url.trim(),
      isLocal: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _memoryDataSource.upsert(entry);
    return _memoryDataSource.snapshot(hasMore: _nextPageUrl != null);
  }

  @override
  Future<PokemonCollection> updatePokemon(PokemonEntry pokemon) async {
    _memoryDataSource.upsert(
      pokemon.copyWith(
        name: pokemon.name.trim(),
        url: pokemon.url.trim().isEmpty
            ? _buildLocalUrl(pokemon.name)
            : pokemon.url.trim(),
        updatedAt: DateTime.now(),
      ),
    );

    return _memoryDataSource.snapshot(hasMore: _nextPageUrl != null);
  }

  @override
  Future<PokemonCollection> deletePokemon(String id) async {
    _memoryDataSource.removeById(id);
    return _memoryDataSource.snapshot(hasMore: _nextPageUrl != null);
  }

  @override
  Future<PokemonEntry?> findById(String id) async {
    return _memoryDataSource.findById(id);
  }

  PokemonEntry _toEntry(PokemonApiResult result) {
    final idMatch = RegExp(r'/(\d+)/?$').firstMatch(result.url);
    final id = idMatch?.group(1) ?? result.name;

    return PokemonEntry(
      id: id,
      name: result.name,
      url: result.url,
      isLocal: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  String _buildLocalUrl(String name) {
    final normalized =
        name.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    final slug = normalized.replaceAll(RegExp(r'^-|-$'), '');
    return 'local://pokemon/${slug.isEmpty ? 'untitled' : slug}';
  }
}
