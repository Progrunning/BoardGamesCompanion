import 'package:board_games_companion/common/enums/game_family.dart';

class ParsePlaysXmlArguments {
  ParsePlaysXmlArguments(this.responseData, this.gameFamily);

  String? responseData;
  GameFamily gameFamily;
}
