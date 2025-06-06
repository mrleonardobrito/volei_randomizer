import 'player.dart';

class Team {
  final String id;
  final String name;
  final List<Player> players;
  final int maxPlayers;

  Team({
    required this.id,
    required this.name,
    required this.players,
    this.maxPlayers = 6,
  });

  Team copyWith({
    String? id,
    String? name,
    List<Player>? players,
    int? maxPlayers,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      players: players ?? List.from(this.players),
      maxPlayers: maxPlayers ?? this.maxPlayers,
    );
  }

  bool get isFull => players.length >= maxPlayers;
  bool get isEmpty => players.isEmpty;
  int get availableSlots => maxPlayers - players.length;

  bool canAddPlayer() => !isFull;

  Team addPlayer(Player player) {
    if (isFull) {
      throw Exception('Time já está completo');
    }

    final newPlayers = List<Player>.from(players);
    newPlayers.add(player);

    return copyWith(players: newPlayers);
  }

  Team removePlayer(String playerId) {
    final newPlayers = players.where((p) => p.id != playerId).toList();
    return copyWith(players: newPlayers);
  }

  Team replacePlayer(String oldPlayerId, Player newPlayer) {
    final newPlayers = List<Player>.from(players);
    final index = newPlayers.indexWhere((p) => p.id == oldPlayerId);

    if (index != -1) {
      newPlayers[index] = newPlayer;
    }

    return copyWith(players: newPlayers);
  }

  List<Player> get titulares =>
      players.where((p) => p.type == PlayerType.titular).toList();
  List<Player> get reservas =>
      players.where((p) => p.type == PlayerType.reserva).toList();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Team &&
        other.id == id &&
        other.name == name &&
        _listEquals(other.players, players) &&
        other.maxPlayers == maxPlayers;
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ players.hashCode ^ maxPlayers.hashCode;

  @override
  String toString() =>
      'Team(id: $id, name: $name, players: ${players.length}/$maxPlayers)';
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  if (identical(a, b)) return true;
  for (int index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) return false;
  }
  return true;
}
