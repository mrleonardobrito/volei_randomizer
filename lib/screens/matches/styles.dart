import 'package:flutter/material.dart';
import 'package:volei_randomizer/screens/matches/constants.dart';

class MatchesScreenStyles {
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(MatchesScreenConstants.defaultPadding),
    textStyle: const TextStyle(fontSize: MatchesScreenConstants.largeFontSize),
    backgroundColor: MatchesScreenConstants.primaryColor,
    foregroundColor: Colors.white,
  );

  static TextStyle titleStyle = const TextStyle(
    fontSize: MatchesScreenConstants.titleFontSize,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subtitleStyle = const TextStyle(
    fontSize: MatchesScreenConstants.largeFontSize,
    fontWeight: FontWeight.bold,
  );

  static TextStyle bodyStyle = const TextStyle(
    fontSize: MatchesScreenConstants.defaultFontSize,
  );

  static BoxDecoration cardDecoration(bool isHighlighted) => BoxDecoration(
        color: isHighlighted ? Colors.green[50] : Colors.white,
        borderRadius:
            BorderRadius.circular(MatchesScreenConstants.borderRadius),
        border: Border.all(
          color: isHighlighted
              ? MatchesScreenConstants.successColor
              : MatchesScreenConstants.defaultColor,
          width: isHighlighted ? 2 : 1,
        ),
      );

  static BoxDecoration warningDecoration = BoxDecoration(
    color: Colors.amber[100],
    borderRadius: BorderRadius.circular(MatchesScreenConstants.borderRadius),
    border: Border.all(color: MatchesScreenConstants.warningColor),
  );

  static BoxDecoration infoDecoration = BoxDecoration(
    color: Colors.blue[100],
    borderRadius: BorderRadius.circular(MatchesScreenConstants.borderRadius),
    border: Border.all(color: MatchesScreenConstants.infoColor),
  );

  static BoxDecoration successDecoration = BoxDecoration(
    color: Colors.green[100],
    borderRadius: BorderRadius.circular(MatchesScreenConstants.borderRadius),
    border: Border.all(color: MatchesScreenConstants.successColor),
  );
}
