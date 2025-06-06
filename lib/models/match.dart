import 'team.dart';

class Match {
  final String id;
  final Team team1;
  final Team team2;
  final Team? winner;
  final MatchStatus status;
  final DateTime createdAt;

  Match({
    required this.id,
    required this.team1,
    required this.team2,
    this.winner,
    this.status = MatchStatus.pending,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Match copyWith({
    String? id,
    Team? team1,
    Team? team2,
    Team? winner,
    MatchStatus? status,
    DateTime? createdAt,
  }) {
    return Match(
      id: id ?? this.id,
      team1: team1 ?? this.team1,
      team2: team2 ?? this.team2,
      winner: winner ?? this.winner,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Match setWinner(Team winnerTeam) {
    if (winnerTeam.id != team1.id && winnerTeam.id != team2.id) {
      throw Exception('Time vencedor deve ser um dos times da partida');
    }

    return copyWith(
      winner: winnerTeam,
      status: MatchStatus.finished,
    );
  }

  Team get loser {
    if (winner == null) throw Exception('Partida ainda não foi finalizada');
    return winner!.id == team1.id ? team2 : team1;
  }

  bool get isFinished => status == MatchStatus.finished;
  bool get isPending => status == MatchStatus.pending;
  bool get isInProgress => status == MatchStatus.inProgress;

  Match startMatch() => copyWith(status: MatchStatus.inProgress);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Match &&
        other.id == id &&
        other.team1 == team1 &&
        other.team2 == team2 &&
        other.winner == winner &&
        other.status == status;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      team1.hashCode ^
      team2.hashCode ^
      winner.hashCode ^
      status.hashCode;

  @override
  String toString() => 'Match(${team1.name} vs ${team2.name}, status: $status)';
}

enum MatchStatus {
  pending,
  inProgress,
  finished,
}
