import 'package:flutter/material.dart';
import 'package:volei_randomizer/screens/matches/constants.dart';
import 'package:volei_randomizer/screens/matches/styles.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(MatchesScreenConstants.largePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_volleyball,
              size: MatchesScreenConstants.extraLargeIconSize,
              color: MatchesScreenConstants.defaultColor,
            ),
            const SizedBox(height: MatchesScreenConstants.defaultPadding),
            Text(
              MatchesScreenConstants.emptyStateTitle,
              style: MatchesScreenStyles.titleStyle.copyWith(
                color: MatchesScreenConstants.defaultColor,
              ),
            ),
            const SizedBox(height: MatchesScreenConstants.smallPadding),
            Text(
              MatchesScreenConstants.emptyStateMessage,
              style: MatchesScreenStyles.bodyStyle.copyWith(
                color: MatchesScreenConstants.defaultColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
