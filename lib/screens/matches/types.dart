import 'package:volei_randomizer/models/match.dart';
import 'package:volei_randomizer/models/team.dart';

typedef OnSetWinnerCallback = void Function(Match match, Team winnerTeam);
typedef OnCreateFirstMatchCallback = void Function();
