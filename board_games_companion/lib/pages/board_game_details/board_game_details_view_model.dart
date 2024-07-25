// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../common/analytics.dart';
import '../../common/enums/collection_type.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/board_game_expansion.dart';
import '../../services/analytics_service.dart';
import '../../stores/board_games_store.dart';
import 'board_game_details_visual_state.dart';

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
  late String _boardGameImageHeroId;

  String get id => _boardGameId;

  String get imageHeroId => _boardGameImageHeroId;

  @observable
  BoardGameDetailsVisualState visualState = const BoardGameDetailsVisualState.loading();

  @computed
  BoardGameDetails get boardGame => _boardGamesStore.allBoardGamesMap[_boardGameId]!;

  @computed
  String get name => boardGame.name;

  @computed
  String? get imageUrl => boardGame.imageUrl;

  @computed
  bool get isBaseGame => boardGame.isBaseGame;

  @computed
  bool get isExpansion => boardGame.isExpansion ?? false;

  @computed
  List<BoardGameExpansion> get expansions => boardGame.expansions;

  @computed
  Map<String, BoardGameDetails> get expansionsOwnedById =>
      {for (final expansion in _boardGamesStore.ownedExpansions) expansion.id: expansion};

  @computed
  bool get hasExpansions => boardGame.expansions.isNotEmpty;

  @computed
  int get totalExpansionsOwned {
    final expansionIds = expansions.map((expansion) => expansion.id);
    return _boardGamesStore.allBoardGames
        .where((boardGame) =>
            !boardGame.isBaseGame &&
            expansionIds.contains(boardGame.id) &&
            (boardGame.isOwned ?? false))
        .length;
  }

  @computed
  String get unescapedDescription => _htmlUnescape.convert(boardGame.description ?? '');

  @computed
  bool get isCreatedByUser => boardGame.isCreatedByUser;

  @observable
  ObservableFuture<void>? futureLoadBoardGameDetails;

  @action
  void loadBoardGameDetails() =>
      futureLoadBoardGameDetails = ObservableFuture(_loadBoardGameDetails());

  @action
  Future<void> toggleCollection(CollectionType collectionType) async {
    final BoardGameDetails updatedBoardGame = boardGame.toggleCollection(collectionType);

    await _boardGamesStore.addOrUpdateBoardGame(updatedBoardGame);
  }

  void setBoardGameId(String boardGameId) => _boardGameId = boardGameId;

  void setBoardGameImageHeroId(String boardGameImageHeroId) =>
      _boardGameImageHeroId = boardGameImageHeroId;

  Future<void> captureLinkAnalytics(String linkName) async {
    await _analyticsService.logEvent(
      name: Analytics.boardGameDetailsLinks,
      parameters: <String, String>{
        Analytics.boardGameDetailsLinksName: linkName,
      },
    );
  }

  Future<void> _loadBoardGameDetails() async {
    try {
      if (isCreatedByUser) {
        visualState = BoardGameDetailsVisualState.detailsLoaded(boardGameDetails: boardGame);
        return;
      }

      visualState = const BoardGameDetailsVisualState.loading();

      await _boardGamesStore.refreshBoardGameDetails(_boardGameId);

      visualState = BoardGameDetailsVisualState.detailsLoaded(boardGameDetails: boardGame);
    } catch (e, stack) {
      visualState = const BoardGameDetailsVisualState.loadingFailed();
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
