import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon_api_page.dart';

class PokemonRemoteDataSource {
  PokemonRemoteDataSource(this.httpClient);

  final http.Client httpClient;

  static const String _baseHost = 'pokeapi.co';
  static const String _pokemonPath = '/api/v2/pokemon';

  Future<PokemonApiPage> fetchPage({String? nextUrl}) async {
    final uri = nextUrl == null
        ? Uri.https(
            _baseHost,
            _pokemonPath,
            const {'limit': '20', 'offset': '0'},
          )
        : Uri.parse(nextUrl);

    final response = await httpClient.get(uri);

    if (response.statusCode != 200) {
      throw Exception('No se pudo consultar PokeAPI (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return PokemonApiPage.fromJson(decoded);
  }
}
