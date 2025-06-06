import 'package:flutter/material.dart';
import 'package:volei_randomizer/models/team.dart';
import 'package:volei_randomizer/screens/matches/constants.dart';
import 'package:volei_randomizer/screens/matches/styles.dart';

class StatusPanel extends StatelessWidget {
  final List<Team> teams;
  final int finishedMatches;
  final int activeMatches;
  final Team? waitingTeam;
  final bool canCreateMatches;

  const StatusPanel({
    super.key,
    required this.teams,
    required this.finishedMatches,
    required this.activeMatches,
    this.waitingTeam,
    required this.canCreateMatches,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(MatchesScreenConstants.defaultPadding),
      color: Colors.green[50],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatusCard(
                MatchesScreenConstants.availableTeamsLabel,
                '${teams.length}',
                Icons.group,
                MatchesScreenConstants.primaryColor,
              ),
              _buildStatusCard(
                MatchesScreenConstants.finishedMatchesLabel,
                '$finishedMatches',
                Icons.sports_volleyball,
                MatchesScreenConstants.successColor,
              ),
              _buildStatusCard(
                MatchesScreenConstants.activeMatchesLabel,
                '$activeMatches',
                Icons.timer,
                MatchesScreenConstants.warningColor,
              ),
            ],
          ),
          if (waitingTeam != null) ...[
            const SizedBox(height: MatchesScreenConstants.defaultPadding),
            Container(
              padding:
                  const EdgeInsets.all(MatchesScreenConstants.defaultPadding),
              decoration: MatchesScreenStyles.infoDecoration,
              child: Row(
                children: [
                  Icon(
                    Icons.hourglass_empty,
                    color: MatchesScreenConstants.infoColor,
                  ),
                  const SizedBox(width: MatchesScreenConstants.smallPadding),
                  Expanded(
                    child: Text(
                      '${waitingTeam!.name} ${MatchesScreenConstants.waitingTeamMessage}',
                      style: MatchesScreenStyles.bodyStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: MatchesScreenConstants.infoColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (!canCreateMatches) ...[
            const SizedBox(height: MatchesScreenConstants.defaultPadding),
            Container(
              padding:
                  const EdgeInsets.all(MatchesScreenConstants.defaultPadding),
              decoration: MatchesScreenStyles.warningDecoration,
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: MatchesScreenConstants.warningColor,
                  ),
                  const SizedBox(width: MatchesScreenConstants.smallPadding),
                  Expanded(
                    child: Text(
                      MatchesScreenConstants.minTeamsWarning,
                      style: MatchesScreenStyles.bodyStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusCard(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: MatchesScreenConstants.largeIconSize,
        ),
        const SizedBox(height: MatchesScreenConstants.smallPadding),
        Text(
          value,
          style: MatchesScreenStyles.titleStyle.copyWith(
            color: color,
          ),
        ),
        Text(
          title,
          style: MatchesScreenStyles.bodyStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
