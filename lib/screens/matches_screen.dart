import 'package:flutter/material.dart';
import 'package:volei_randomizer/models/match.dart';
import 'package:volei_randomizer/models/team.dart';
import 'package:volei_randomizer/screens/matches/constants.dart';
import 'package:volei_randomizer/screens/matches/events.dart';
import 'package:volei_randomizer/screens/matches/styles.dart';
import 'package:volei_randomizer/screens/matches/translations.dart';
import 'package:volei_randomizer/screens/matches/widgets/empty_state.dart';
import 'package:volei_randomizer/screens/matches/widgets/match_card.dart';
import 'package:volei_randomizer/screens/matches/widgets/status_panel.dart';
import 'package:volei_randomizer/services/volleyball_service.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final VolleyballService _service = VolleyballService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    setState(() {});
  }

  void _createFirstMatch() {
    if (_service.teams.length < 2) {
      MatchesScreenEvents.showMinTeamsWarning(context);
      return;
    }

    _service.createNextMatch();
    MatchesScreenEvents.showFirstMatchCreated(context);
  }

  void _setWinner(Match match, Team winnerTeam) {
    MatchesScreenEvents.showWinnerConfirmationDialog(
      context: context,
      match: match,
      winnerTeam: winnerTeam,
      service: _service,
    );
  }

  @override
  Widget build(BuildContext context) {
    final matches = _service.matches;
    final teams = _service.teams;
    final waitingTeam = _service.getWaitingTeam();
    final canCreateMatches = teams.length >= 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text(MatchesScreenTranslations.appBarTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          StatusPanel(
            teams: teams,
            finishedMatches: matches.where((m) => m.isFinished).length,
            activeMatches: matches.where((m) => !m.isFinished).length,
            waitingTeam: waitingTeam,
            canCreateMatches: canCreateMatches,
          ),
          if (matches.isEmpty && canCreateMatches)
            Padding(
              padding:
                  const EdgeInsets.all(MatchesScreenConstants.defaultPadding),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _createFirstMatch,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text(MatchesScreenTranslations.startFirstMatch),
                  style: MatchesScreenStyles.primaryButton,
                ),
              ),
            ),
          Expanded(
            child: matches.isEmpty
                ? const EmptyState()
                : ListView.builder(
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      final match = matches[matches.length - 1 - index];
                      return MatchCard(
                        match: match,
                        isCurrent: index == 0,
                        onSetWinner: _setWinner,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
