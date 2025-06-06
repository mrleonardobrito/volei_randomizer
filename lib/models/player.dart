class Player {
  final String id;
  final String name;
  final PlayerType type;

  Player({
    required this.id,
    required this.name,
    required this.type,
  });

  Player copyWith({
    String? id,
    String? name,
    PlayerType? type,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Player &&
        other.id == id &&
        other.name == name &&
        other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ type.hashCode;

  @override
  String toString() => 'Player(id: $id, name: $name, type: $type)';
}

enum PlayerType {
  titular,
  reserva,
}
