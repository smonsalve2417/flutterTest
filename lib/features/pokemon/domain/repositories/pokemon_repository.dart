import '../entities/pokemon_collection.dart';
import '../entities/pokemon_entry.dart';

abstract class PokemonRepository {
  Future<PokemonCollection> loadInitial();

  Future<PokemonCollection> loadMore();

  Future<PokemonCollection> createPokemon({
    required String name,
    required String url,
  });

  Future<PokemonCollection> updatePokemon(PokemonEntry pokemon);

  Future<PokemonCollection> deletePokemon(String id);

  Future<PokemonEntry?> findById(String id);
}
