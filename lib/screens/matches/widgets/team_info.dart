import 'package:flutter/material.dart';
import 'package:volei_randomizer/models/team.dart';
import 'package:volei_randomizer/screens/matches/constants.dart';
import 'package:volei_randomizer/screens/matches/styles.dart';
import 'package:volei_randomizer/services/volleyball_service.dart';

class TeamInfo extends StatelessWidget {
  final Team team;
  final bool isWinner;

  const TeamInfo({
    super.key,
    required this.team,
    required this.isWinner,
  });

  @override
  Widget build(BuildContext context) {
    final volleyballService = VolleyballService();

    return Container(
      padding: const EdgeInsets.all(MatchesScreenConstants.defaultPadding),
      decoration: MatchesScreenStyles.cardDecoration(isWinner),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isWinner ? Icons.emoji_events : Icons.group,
                color: isWinner
                    ? MatchesScreenConstants.successColor
                    : MatchesScreenConstants.defaultColor,
                size: MatchesScreenConstants.defaultIconSize,
              ),
              const SizedBox(width: MatchesScreenConstants.smallPadding),
              Expanded(
                child: Text(
                  team.name,
                  style: TextStyle(
                    fontSize: MatchesScreenConstants.largeFontSize,
                    fontWeight: FontWeight.bold,
                    color: isWinner
                        ? MatchesScreenConstants.successColor
                        : MatchesScreenConstants.defaultColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: MatchesScreenConstants.smallPadding),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: team.players.map((player) {
              final isSubstitute = volleyballService.playerSubstitutions.values
                  .contains(player.id);
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isSubstitute ? Colors.orange[200] : Colors.white,
                  borderRadius: BorderRadius.circular(
                      MatchesScreenConstants.borderRadius),
                  border: Border.all(
                    color: isSubstitute
                        ? MatchesScreenConstants.warningColor
                        : MatchesScreenConstants.defaultColor,
                  ),
                ),
                child: Text(
                  player.name,
                  style: TextStyle(
                    fontSize: MatchesScreenConstants.defaultFontSize,
                    fontWeight:
                        isSubstitute ? FontWeight.bold : FontWeight.normal,
                    color: isSubstitute
                        ? Colors.orange[700]
                        : MatchesScreenConstants.defaultColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
