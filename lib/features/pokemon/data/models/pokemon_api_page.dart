class PokemonApiPage {
  const PokemonApiPage({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<PokemonApiResult> results;

  factory PokemonApiPage.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'] as List<dynamic>? ?? <dynamic>[];

    return PokemonApiPage(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: rawResults
          .map((dynamic item) => PokemonApiResult.fromJson(
                item as Map<String, dynamic>,
              ))
          .toList(),
    );
  }
}

class PokemonApiResult {
  const PokemonApiResult({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  factory PokemonApiResult.fromJson(Map<String, dynamic> json) {
    return PokemonApiResult(
      name: json['name'] as String? ?? 'unknown',
      url: json['url'] as String? ?? '',
    );
  }
}
