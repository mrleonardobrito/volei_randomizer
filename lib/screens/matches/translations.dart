class MatchesScreenTranslations {
  static const String appBarTitle = 'Partidas e Chaveamento';
  static const String startFirstMatch = 'Iniciar Primeira Partida';
  static const String firstMatchCreated = 'Primeira partida criada!';
  static const String confirmWinner = 'Confirmar Vencedor';
  static const String confirmWinnerMessage =
      'Confirma que o {team} foi o vencedor desta partida?';
  static const String cancel = 'Cancelar';
  static const String confirm = 'Confirmar';
  static const String winnerMessage =
      '{team} venceu! Próxima partida criada automaticamente.';

  static String getConfirmWinnerMessage(String teamName) {
    return confirmWinnerMessage.replaceAll('{team}', teamName);
  }

  static String getWinnerMessage(String teamName) {
    return winnerMessage.replaceAll('{team}', teamName);
  }
}
