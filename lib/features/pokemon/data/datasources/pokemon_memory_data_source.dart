import '../../domain/entities/pokemon_collection.dart';
import '../../domain/entities/pokemon_entry.dart';

class PokemonMemoryDataSource {
  final List<PokemonEntry> _items = <PokemonEntry>[];

  List<PokemonEntry> get items => List<PokemonEntry>.unmodifiable(_items);

  void replaceAll(Iterable<PokemonEntry> items) {
    _items
      ..clear()
      ..addAll(items);
  }

  void appendAll(Iterable<PokemonEntry> items) {
    for (final item in items) {
      final index =
          _items.indexWhere((PokemonEntry current) => current.id == item.id);
      if (index == -1) {
        _items.add(item);
      } else {
        _items[index] = item;
      }
    }
  }

  void upsert(PokemonEntry pokemon) {
    final index =
        _items.indexWhere((PokemonEntry current) => current.id == pokemon.id);
    if (index == -1) {
      _items.add(pokemon);
    } else {
      _items[index] = pokemon;
    }
  }

  bool removeById(String id) {
    final index = _items.indexWhere((PokemonEntry current) => current.id == id);
    if (index == -1) {
      return false;
    }

    _items.removeAt(index);
    return true;
  }

  PokemonEntry? findById(String id) {
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  PokemonCollection snapshot({required bool hasMore}) {
    return PokemonCollection(items: items, hasMore: hasMore);
  }
}
