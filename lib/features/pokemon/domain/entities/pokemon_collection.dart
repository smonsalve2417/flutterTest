import 'pokemon_entry.dart';

class PokemonCollection {
  const PokemonCollection({
    required this.items,
    required this.hasMore,
  });

  final List<PokemonEntry> items;
  final bool hasMore;
}
