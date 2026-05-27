import 'package:get/get.dart';

import '../../domain/entities/pokemon_collection.dart';
import '../../domain/entities/pokemon_entry.dart';
import '../../domain/repositories/pokemon_repository.dart';

class PokemonController extends GetxController {
  PokemonController(this._repository);

  final PokemonRepository _repository;

  final RxList<PokemonEntry> items = <PokemonEntry>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  Future<void> loadInitial() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final snapshot = await _repository.loadInitial();
      _applySnapshot(snapshot);
    } catch (error) {
      errorMessage.value = 'No se pudo cargar la lista de Pokémon.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value || !hasMore.value) {
      return;
    }

    isLoadingMore.value = true;

    try {
      final snapshot = await _repository.loadMore();
      _applySnapshot(snapshot);
    } catch (error) {
      errorMessage.value = 'No se pudieron cargar más Pokémon.';
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshVisibleList() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    items.refresh();
  }

  Future<void> createPokemon({
    required String name,
    required String url,
  }) async {
    final snapshot = await _repository.createPokemon(name: name, url: url);
    _applySnapshot(snapshot);
  }

  Future<void> updatePokemon(PokemonEntry pokemon) async {
    final snapshot = await _repository.updatePokemon(pokemon);
    _applySnapshot(snapshot);
  }

  Future<void> deletePokemon(String id) async {
    final snapshot = await _repository.deletePokemon(id);
    _applySnapshot(snapshot);
  }

  Future<PokemonEntry?> findById(String id) {
    return _repository.findById(id);
  }

  void _applySnapshot(PokemonCollection snapshot) {
    items.assignAll(snapshot.items);
    hasMore.value = snapshot.hasMore;
  }
}
