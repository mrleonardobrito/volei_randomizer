import 'package:flutter/material.dart';
import 'package:volei_randomizer/models/player.dart';
import 'package:volei_randomizer/models/team.dart';
import 'package:volei_randomizer/models/match.dart';

class VolleyballService extends ChangeNotifier {
  static final VolleyballService _instance = VolleyballService._internal();
  factory VolleyballService() => _instance;
  VolleyballService._internal();

  final List<Player> _allPlayers = [];
  final List<Team> _teams = [];
  final List<Match> _matches = [];
  final List<Player> _reservas = [];

  final Map<String, String> _playerSubstitutions = {};

  List<Player> get allPlayers => List.unmodifiable(_allPlayers);
  List<Team> get teams => List.unmodifiable(_teams);
  List<Match> get matches => List.unmodifiable(_matches);
  List<Player> get reservas => List.unmodifiable(_reservas);
  Map<String, String> get playerSubstitutions =>
      Map.unmodifiable(_playerSubstitutions);

  List<Player> get titulares =>
      _allPlayers.where((p) => p.type == PlayerType.titular).toList();

  void addPlayer(String name, PlayerType type) {
    final player = Player(
      id: name,
      name: name,
      type: type,
    );

    if (_allPlayers.any((p) => p.id == name)) {
      throw Exception('Jogador já existe');
    }

    _allPlayers.add(player);

    if (type == PlayerType.reserva) {
      _reservas.add(player);
    } else {
      _distributePlayerToTeams(player);
    }

    notifyListeners();
  }

  void removePlayer(String playerId) {
    _allPlayers.removeWhere((p) => p.id == playerId);
    _reservas.removeWhere((p) => p.id == playerId);
    _playerSubstitutions.remove(playerId);

    for (int i = 0; i < _teams.length; i++) {
      if (_teams[i].players.any((p) => p.id == playerId)) {
        _teams[i] = _teams[i].removePlayer(playerId);
      }
    }

    _removeEmptyTeams();
    notifyListeners();
  }

  void _distributePlayerToTeams(Player player) {
    for (int i = 0; i < _teams.length && i < 2; i++) {
      if (_teams[i].canAddPlayer()) {
        _teams[i] = _teams[i].addPlayer(player);
        return;
      }
    }

    if (_teams.length < 3) {
      final newTeam = Team(
        id: 'time-${_teams.length + 1}',
        name: 'Time ${_teams.length + 1}',
        players: [player],
      );
      _teams.add(newTeam);
      return;
    }

    if (_teams.length == 3 && _teams[2].canAddPlayer()) {
      _teams[2] = _teams[2].addPlayer(player);
      return;
    }

    if (!_reservas.contains(player)) {
      _reservas.add(player);
    }
  }

  void regenerateTeams() {
    final allTitulares = titulares;
    _teams.clear();
    _playerSubstitutions.clear();

    allTitulares.shuffle();

    for (final player in allTitulares) {
      _distributePlayerToTeams(player);
    }

    notifyListeners();
  }

  void _removeEmptyTeams() {
    _teams.removeWhere((team) => team.isEmpty);

    for (int i = 0; i < _teams.length; i++) {
      _teams[i] = _teams[i].copyWith(name: 'Time ${i + 1}');
    }
  }

  void substitutePlayer(String titularId, String reservaId) {
    final titular = _allPlayers.firstWhere((p) => p.id == titularId);
    final reserva = _allPlayers.firstWhere((p) => p.id == reservaId);

    for (int i = 0; i < _teams.length; i++) {
      if (_teams[i].players.any((p) => p.id == titularId)) {
        _teams[i] = _teams[i].replacePlayer(titularId, reserva);

        _playerSubstitutions[titularId] = reservaId;

        if (!_reservas.any((p) => p.id == titularId)) {
          _reservas.add(titular);
        }

        _reservas.removeWhere((p) => p.id == reservaId);

        break;
      }
    }

    notifyListeners();
  }

  void revertSubstitution(String originalTitularId) {
    final reservaId = _playerSubstitutions[originalTitularId];
    if (reservaId == null) return;

    final titular = _allPlayers.firstWhere((p) => p.id == originalTitularId);
    final reserva = _allPlayers.firstWhere((p) => p.id == reservaId);

    for (int i = 0; i < _teams.length; i++) {
      if (_teams[i].players.any((p) => p.id == reservaId)) {
        _teams[i] = _teams[i].replacePlayer(reservaId, titular);

        _playerSubstitutions.remove(originalTitularId);

        if (!_reservas.any((p) => p.id == reservaId)) {
          _reservas.add(reserva);
        }

        _reservas.removeWhere((p) => p.id == originalTitularId);

        break;
      }
    }

    notifyListeners();
  }

  void createMatch(String team1Id, String team2Id) {
    final team1 = _teams.firstWhere((t) => t.id == team1Id);
    final team2 = _teams.firstWhere((t) => t.id == team2Id);

    final match = Match(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      team1: team1,
      team2: team2,
    );

    _matches.add(match);
    notifyListeners();
  }

  void setMatchWinner(String matchId, String winnerTeamId) {
    final matchIndex = _matches.indexWhere((m) => m.id == matchId);
    if (matchIndex == -1) return;

    final match = _matches[matchIndex];
    final winnerTeam =
        match.team1.id == winnerTeamId ? match.team1 : match.team2;

    _matches[matchIndex] = match.setWinner(winnerTeam);
    notifyListeners();
  }

  Team? getWaitingTeam() {
    if (_teams.length < 3) return null;
    // Se não houver times suficientes, retorna null
    if (_matches.isEmpty) return _teams[2];

    final lastMatch = _matches.last;
    if (!lastMatch.isFinished) return null;

    final teamsInLastMatch = [lastMatch.team1.id, lastMatch.team2.id];
    for (final team in _teams) {
      if (!teamsInLastMatch.contains(team.id)) {
        return team;
      }
    }

    return null;
  }

  void createNextMatch() {
    if (_teams.length < 2) return;

    if (_matches.isEmpty) {
      if (_teams.length >= 2) {
        createMatch(_teams[0].id, _teams[1].id);
      }
      return;
    }

    final lastMatch = _matches.last;
    if (!lastMatch.isFinished) return;

    final winner = lastMatch.winner!;
    final waitingTeam = getWaitingTeam();

    if (waitingTeam != null && winner.id != waitingTeam.id) {
      createMatch(winner.id, waitingTeam.id);
    } else if (waitingTeam != null && winner.id == waitingTeam.id) {
      final availableTeam = _teams.firstWhere(
        (team) => team.id != winner.id,
        orElse: () => _teams[0],
      );

      createMatch(winner.id, availableTeam.id);
    }
  }

  bool canCreateTeams() => titulares.length >= 6;

  int get totalPlayersInTeams {
    return _teams.fold(0, (sum, team) => sum + team.players.length);
  }

  bool get hasActiveMatch {
    return _matches.isNotEmpty &&
        _matches.any((m) => m.status == MatchStatus.inProgress);
  }

  void clearAll() {
    _allPlayers.clear();
    _teams.clear();
    _matches.clear();
    _reservas.clear();
    _playerSubstitutions.clear();
    notifyListeners();
  }
}
