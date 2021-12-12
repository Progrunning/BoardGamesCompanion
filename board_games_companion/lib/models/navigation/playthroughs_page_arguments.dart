import '../../common/enums/collection_type.dart';
import '../hive/board_game_details.dart';

class PlaythroughsPageArguments {
  const PlaythroughsPageArguments(this.boardGameDetails, this.collectionType);

  final BoardGameDetails boardGameDetails;
  final CollectionType collectionType;
}
