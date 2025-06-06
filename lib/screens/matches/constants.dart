import 'package:flutter/material.dart';

class MatchesScreenConstants {
  static const double cardElevation = 8.0;
  static const double defaultElevation = 2.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 32.0;

  static const double defaultIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 64.0;

  static const double defaultFontSize = 14.0;
  static const double largeFontSize = 16.0;
  static const double extraLargeFontSize = 20.0;
  static const double titleFontSize = 24.0;

  static const double borderRadius = 8.0;
  static const double largeBorderRadius = 12.0;

  static const Color primaryColor = Colors.blue;
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.amber;
  static const Color infoColor = Colors.blue;
  static const Color defaultColor = Colors.grey;

  static const String emptyStateTitle = 'Nenhuma partida criada';
  static const String emptyStateMessage =
      'Crie times primeiro e depois inicie a primeira partida';
  static const String minTeamsWarning =
      'É necessário pelo menos 2 times para criar partidas';
  static const String waitingTeamMessage = 'está aguardando no banco';
  static const String defineWinnerMessage = 'Defina o vencedor:';
  static const String winnerPrefix = 'VENCEDOR: ';

  static const String currentMatchStatus = 'PARTIDA ATUAL';
  static const String finishedMatchStatus = 'PARTIDA FINALIZADA';
  static const String waitingMatchStatus = 'AGUARDANDO';

  static const String availableTeamsLabel = 'Times Disponíveis';
  static const String finishedMatchesLabel = 'Partidas Realizadas';
  static const String activeMatchesLabel = 'Partidas Ativas';
}
