import 'package:flutter/material.dart';
import 'package:volei_randomizer/models/match.dart';
import 'package:volei_randomizer/models/team.dart';
import 'package:volei_randomizer/screens/matches/constants.dart';
import 'package:volei_randomizer/screens/matches/translations.dart';
import 'package:volei_randomizer/services/volleyball_service.dart';

class MatchesScreenEvents {
  static void showWinnerConfirmationDialog({
    required BuildContext context,
    required Match match,
    required Team winnerTeam,
    required VolleyballService service,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(MatchesScreenTranslations.confirmWinner),
        content: Text(
          MatchesScreenTranslations.getConfirmWinnerMessage(winnerTeam.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(MatchesScreenTranslations.cancel),
          ),
          TextButton(
            onPressed: () {
              service.setMatchWinner(match.id, winnerTeam.id);
              Navigator.pop(context);

              Future.delayed(const Duration(milliseconds: 500), () {
                service.createNextMatch();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    MatchesScreenTranslations.getWinnerMessage(winnerTeam.name),
                  ),
                ),
              );
            },
            child: const Text(MatchesScreenTranslations.confirm),
          ),
        ],
      ),
    );
  }

  static void showMinTeamsWarning(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(MatchesScreenConstants.minTeamsWarning),
      ),
    );
  }

  static void showFirstMatchCreated(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(MatchesScreenTranslations.firstMatchCreated),
      ),
    );
  }
}
