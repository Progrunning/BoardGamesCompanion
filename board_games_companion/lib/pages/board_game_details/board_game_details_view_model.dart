// ignore_for_file: library_private_types_in_public_api

import 'package:board_games_companion/models/hive/board_game_expansion.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../common/analytics.dart';
import '../../common/enums/collection_type.dart';
import '../../models/hive/board_game_details.dart';
import '../../services/analytics_service.dart';
import '../../stores/board_games_store.dart';

part 'board_game_details_view_model.g.dart';

@injectable
class BoardGameDetailsViewModel = _BoardGameDetailsViewModel with _$BoardGameDetailsViewModel;

abstract class _BoardGameDetailsViewModel with Store {
  _BoardGameDetailsViewModel(this._boardGamesStore, this._analyticsService) {
    _htmlUnescape = HtmlUnescape();
  }

  final BoardGamesStore _boardGamesStore;
  final AnalyticsService _analyticsService;

  late HtmlUnescape _htmlUnescape;
  late String _boardGameId;

  @computed
  BoardGameDetails get boardGame => _boardGamesStore.allBoardGames.firstWhere(
        (BoardGameDetails boardGame) => boardGame.id == _boardGameId,
      );

  @computed
  String get boardGameName => boardGame.name;

  @computed
  String get boardGameId => boardGame.id;

  @computed
  String? get boardGameImageUrl => boardGame.imageUrl;

  @computed
  bool get isMainGame => boardGame.isMainGame;

  @computed
  bool get isExpansion => boardGame.isExpansion ?? false;

  @computed
  List<BoardGamesExpansion> get expansions => boardGame.expansions;

  @computed
  bool get hasExpansions => boardGame.expansions.isNotEmpty;

  @computed
  int get totalExpansionsOwned =>
      expansions.where((expansion) => expansion.isInCollection ?? false).length;

  @computed
  String get unescapedDescription => _htmlUnescape.convert(boardGame.description ?? '');

  @observable
  ObservableFuture<void>? futureLoadBoardGameDetails;

  @action
  void loadBoardGameDetails() =>
      futureLoadBoardGameDetails = ObservableFuture(_loadBoardGameDetails());

  void setBoardGameId(String boardGameId) => _boardGameId = boardGameId;

  Future<void> captureLinkAnalytics(String linkName) async {
    await _analyticsService.logEvent(
      name: Analytics.boardGameDetailsLinks,
      parameters: <String, String>{
        Analytics.boardGameDetailsLinksName: linkName,
      },
    );
  }

  Future<void> toggleCollection(CollectionType collectionType) async {
    switch (collectionType) {
      case CollectionType.owned:
        boardGame.isOwned = !boardGame.isOwned!;
        if (boardGame.isOwned!) {
          boardGame.isOnWishlist = false;
          boardGame.isFriends = false;
        }
        break;
      case CollectionType.friends:
        if (boardGame.isOwned!) {
          boardGame.isOwned = false;
        }
        boardGame.isFriends = !boardGame.isFriends!;
        break;
      case CollectionType.wishlist:
        if (boardGame.isOwned!) {
          boardGame.isOwned = false;
        }
        boardGame.isOnWishlist = !boardGame.isOnWishlist!;
        break;
    }

    // ! MK If a game is an expansion and the main board game has been sync'd with BGG and lacks details then need to fetch details

    await _boardGamesStore.addOrUpdateBoardGame(boardGame);
  }

  Future<void> _loadBoardGameDetails() async {
    try {
      await _boardGamesStore.refreshBoardGameDetails(_boardGameId);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
