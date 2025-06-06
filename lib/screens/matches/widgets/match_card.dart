import 'package:flutter/material.dart';
import 'package:volei_randomizer/models/match.dart';
import 'package:volei_randomizer/models/team.dart';
import 'package:volei_randomizer/screens/matches/constants.dart';
import 'package:volei_randomizer/screens/matches/styles.dart';
import 'package:volei_randomizer/screens/matches/widgets/team_info.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final bool isCurrent;
  final Function(Match, Team) onSetWinner;

  const MatchCard({
    super.key,
    required this.match,
    required this.isCurrent,
    required this.onSetWinner,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: MatchesScreenConstants.defaultPadding,
        vertical: MatchesScreenConstants.smallPadding,
      ),
      elevation: isCurrent
          ? MatchesScreenConstants.cardElevation
          : MatchesScreenConstants.defaultElevation,
      color: isCurrent ? Colors.green[50] : null,
      child: Padding(
        padding: const EdgeInsets.all(MatchesScreenConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: MatchesScreenConstants.defaultPadding),
            _buildTeamsSection(),
            if (!match.isFinished && isCurrent) _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          match.isFinished
              ? Icons.check_circle
              : isCurrent
                  ? Icons.play_circle
                  : Icons.schedule,
          color: match.isFinished
              ? MatchesScreenConstants.successColor
              : isCurrent
                  ? MatchesScreenConstants.warningColor
                  : MatchesScreenConstants.defaultColor,
          size: MatchesScreenConstants.defaultIconSize,
        ),
        const SizedBox(width: MatchesScreenConstants.smallPadding),
        Text(
          isCurrent
              ? MatchesScreenConstants.currentMatchStatus
              : match.isFinished
                  ? MatchesScreenConstants.finishedMatchStatus
                  : MatchesScreenConstants.waitingMatchStatus,
          style: TextStyle(
            fontSize: MatchesScreenConstants.defaultFontSize,
            fontWeight: FontWeight.bold,
            color: match.isFinished
                ? MatchesScreenConstants.successColor
                : isCurrent
                    ? MatchesScreenConstants.warningColor
                    : MatchesScreenConstants.defaultColor,
          ),
        ),
        const Spacer(),
        if (match.isFinished && match.winner != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: MatchesScreenConstants.smallPadding,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: MatchesScreenConstants.successColor,
              borderRadius: BorderRadius.circular(
                  MatchesScreenConstants.largeBorderRadius),
            ),
            child: Text(
              '${MatchesScreenConstants.winnerPrefix}${match.winner!.name}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: MatchesScreenConstants.defaultFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTeamsSection() {
    return Row(
      children: [
        Expanded(
          child: TeamInfo(
            team: match.team1,
            isWinner: match.winner?.id == match.team1.id,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
              horizontal: MatchesScreenConstants.defaultPadding),
          child: const Text(
            'VS',
            style: TextStyle(
              fontSize: MatchesScreenConstants.extraLargeFontSize,
              fontWeight: FontWeight.bold,
              color: MatchesScreenConstants.defaultColor,
            ),
          ),
        ),
        Expanded(
          child: TeamInfo(
            team: match.team2,
            isWinner: match.winner?.id == match.team2.id,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: MatchesScreenConstants.defaultPadding),
        const Divider(),
        const SizedBox(height: MatchesScreenConstants.smallPadding),
        Text(
          MatchesScreenConstants.defineWinnerMessage,
          style: MatchesScreenStyles.subtitleStyle,
        ),
        const SizedBox(height: MatchesScreenConstants.smallPadding),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => onSetWinner(match, match.team1),
                style: MatchesScreenStyles.primaryButton,
                child: Text(match.team1.name),
              ),
            ),
            const SizedBox(width: MatchesScreenConstants.defaultPadding),
            Expanded(
              child: ElevatedButton(
                onPressed: () => onSetWinner(match, match.team2),
                style: MatchesScreenStyles.primaryButton,
                child: Text(match.team2.name),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
