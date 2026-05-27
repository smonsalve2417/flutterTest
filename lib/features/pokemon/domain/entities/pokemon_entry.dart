class PokemonEntry {
  PokemonEntry({
    required this.id,
    required this.name,
    required this.url,
    required this.isLocal,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? createdAt ?? DateTime.now();

  final String id;
  final String name;
  final String url;
  final bool isLocal;
  final DateTime createdAt;
  final DateTime updatedAt;

  PokemonEntry copyWith({
    String? id,
    String? name,
    String? url,
    bool? isLocal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PokemonEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      isLocal: isLocal ?? this.isLocal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  String get originLabel => isLocal ? 'Local' : 'PokeAPI';

  int? get numericId => int.tryParse(id);

  @override
  String toString() {
    return 'PokemonEntry(id: $id, name: $name, url: $url, isLocal: $isLocal)';
  }
}
