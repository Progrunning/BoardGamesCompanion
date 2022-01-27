import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/analytics.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../../models/board_game.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
import '../../services/analytics_service.dart';
import '../../stores/hot_board_games_store.dart';
import '../../stores/search_bar_board_games_store.dart';
import '../../stores/search_board_games_store.dart';
import '../../utilities/launcher_helper.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/page_container_widget.dart';
import '../../widgets/common/ripple_effect.dart';
import '../board_game_details/board_game_details_page.dart';

class SearchBoardGamesPage extends StatefulWidget {
  const SearchBoardGamesPage({
    required this.analyticsService,
    Key? key,
  }) : super(key: key);

  final AnalyticsService analyticsService;

  @override
  _SearchBoardGamesPageState createState() => _SearchBoardGamesPageState();
}

class _SearchBoardGamesPageState extends State<SearchBoardGamesPage> {
  late FocusNode searchFocusNode;

  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageContainer(
        child: CustomScrollView(
          slivers: <Widget>[
            _SearchBar(searchFocusNode: searchFocusNode),
            _SearchResults(
              onBoardGameTapped: (BoardGame boardGame) => _navigateToBoardGameDetails(boardGame),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _HotBoardGamesHeader(),
            ),
            _HotBoardGames(
              analyticsService: widget.analyticsService,
              onBoardGameTapped: (BoardGame boardGame) => _navigateToBoardGameDetails(boardGame),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToBoardGameDetails(BoardGame boardGame) async {
    searchFocusNode.unfocus();
    await Navigator.pushNamed(
      context,
      BoardGamesDetailsPage.pageRoute,
      arguments: BoardGameDetailsPageArguments(
        boardGame.id,
        boardGame.name,
        SearchBoardGamesPage,
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.searchFocusNode,
    Key? key,
  }) : super(key: key);

  final FocusNode searchFocusNode;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late TextEditingController searchController;
  late SearchBoardGamesStore searchBoardGamesStore;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchBoardGamesStore = Provider.of<SearchBoardGamesStore>(
      context,
      listen: false,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      titleSpacing: 0,
      title: Consumer<SearchBarBoardGamesStore>(
        builder: (_, store, __) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.standardSpacing,
            ),
            child: TextField(
              controller: searchController,
              style: AppTheme.defaultTextFieldStyle,
              focusNode: widget.searchFocusNode,
              textInputAction: TextInputAction.search,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: retrieveSearchBarSuffixIcon(store, searchBoardGamesStore),
              ),
              onChanged: (searchPhrase) => store.searchPhrase = searchPhrase,
              onSubmitted: (searchPhrase) => searchBoardGamesStore.updateSearchResults(),
            ),
          );
        },
      ),
    );
  }

  Widget retrieveSearchBarSuffixIcon(
    SearchBarBoardGamesStore searchBarBoardGamesStore,
    SearchBoardGamesStore searchBoardGamesStore,
  ) {
    if (searchBarBoardGamesStore.searchPhrase?.isNotEmpty ?? false) {
      return IconButton(
        icon: const Icon(
          Icons.clear,
        ),
        color: AppTheme.accentColor,
        onPressed: () {
          searchController.text = '';
          searchBarBoardGamesStore.searchPhrase = null;
          searchBoardGamesStore.updateSearchResults();
        },
      );
    }

    return const Icon(
      Icons.search,
      color: AppTheme.accentColor,
    );
  }
}

class _SearchResults extends StatefulWidget {
  const _SearchResults({
    Key? key,
    required this.onBoardGameTapped,
  }) : super(key: key);

  final void Function(BoardGame) onBoardGameTapped;

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<_SearchResults> {
  late SearchBarBoardGamesStore searchBarBoardGamesStore;

  @override
  void initState() {
    super.initState();
    searchBarBoardGamesStore = Provider.of<SearchBarBoardGamesStore>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final searchBoardGamesStore = Provider.of<SearchBoardGamesStore>(context);
    return FutureBuilder(
      future: searchBoardGamesStore.search(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final searchResults = snapshot.data as List<BoardGame>?;
          if (searchResults?.isNotEmpty ?? false) {
            return SliverPadding(
              padding: const EdgeInsets.all(
                Dimensions.standardSpacing,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    final int itemIndex = index ~/ 2;
                    if (index.isEven) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
                          boxShadow: const <BoxShadow>[AppTheme.defaultBoxShadow],
                        ),
                        child: RippleEffect(
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.standardSpacing),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  searchResults![itemIndex].name,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.titleTextStyle,
                                ),
                                if (searchResults[itemIndex].yearPublished != null)
                                  Text(
                                    searchResults[itemIndex].yearPublished.toString(),
                                    style: AppTheme.subTitleTextStyle,
                                  ),
                                const SizedBox(
                                  height: Dimensions.halfStandardSpacing,
                                ),
                              ],
                            ),
                          ),
                          onTap: () async =>
                              _navigateToBoardGameDetails(searchResults, itemIndex, context),
                        ),
                      );
                    }

                    return const Divider(height: Dimensions.standardSpacing);
                  },
                  childCount: math.max(0, searchResults!.length * 2 - 1),
                ),
              ),
            );
          }

          if (searchBarBoardGamesStore.searchPhrase?.isNotEmpty ?? false) {
            return _NoResults(
              searchBarBoardGamesStore: searchBarBoardGamesStore,
              searchBoardGamesStore: searchBoardGamesStore,
            );
          }

          return const SliverPersistentHeader(
            delegate: _SearchResultsTemplate(
              child: Text(
                AppText.searchBoardGamesPageSearchInstructions,
                textAlign: TextAlign.justify,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const SliverPersistentHeader(
            delegate: _SearchResultsTemplate(
              child: Padding(
                padding: EdgeInsets.all(
                  Dimensions.doubleStandardSpacing,
                ),
                child: Center(
                  child: GenericErrorMessage(),
                ),
              ),
            ),
          );
        }

        return const SliverPersistentHeader(
          delegate: _SearchResultsTemplate(
            child: LoadingIndicator(),
          ),
        );
      },
    );
  }

  Future _navigateToBoardGameDetails(
    List<BoardGame> searchResults,
    int itemIndex,
    BuildContext context,
  ) async {
    final boardGame = searchResults[itemIndex];
    widget.onBoardGameTapped(boardGame);
  }
}

class _SearchResultsTemplate extends SliverPersistentHeaderDelegate {
  const _SearchResultsTemplate({
    required this.child,
    this.height = defaultHeight,
  });

  static const double defaultHeight = 100;

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.all(
        Dimensions.doubleStandardSpacing,
      ),
      child: Center(
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({
    Key? key,
    required this.searchBarBoardGamesStore,
    required this.searchBoardGamesStore,
  }) : super(key: key);

  final SearchBarBoardGamesStore searchBarBoardGamesStore;
  final SearchBoardGamesStore searchBoardGamesStore;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.standardSpacing,
          horizontal: Dimensions.doubleStandardSpacing,
        ),
        child: Column(
          children: <Widget>[
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: '''Sorry, we couldn't find any results for the search phrase ''',
                  ),
                  TextSpan(
                    text: '${searchBarBoardGamesStore.searchPhrase}.',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: Dimensions.standardSpacing,
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Please try again or if the problem persists please contact support ',
                  ),
                  TextSpan(
                    text: 'feedback@progrunning.net',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await LauncherHelper.launchUri(
                          context,
                          'mailto:${Constants.FeedbackEmailAddress}?subject=BGC%20Feedback',
                        );
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.doubleStandardSpacing),
            Center(
              child: IconAndTextButton(
                title: 'Retry',
                icon: const DefaultIcon(Icons.refresh),
                onPressed: () {
                  searchBoardGamesStore.updateSearchResults();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HotBoardGames extends StatelessWidget {
  const _HotBoardGames({
    required this.analyticsService,
    required this.onBoardGameTapped,
    Key? key,
  }) : super(key: key);

  final AnalyticsService analyticsService;
  final void Function(BoardGame) onBoardGameTapped;

  @override
  Widget build(BuildContext context) {
    final _hotBoardGamesStore = Provider.of<HotBoardGamesStore>(context);

    return FutureBuilder(
      future: _hotBoardGamesStore.load(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final boardGames = snapshot.data as List<BoardGame>;
          if (boardGames != null && boardGames.isNotEmpty) {
            return SliverPadding(
              padding: const EdgeInsets.all(
                Dimensions.standardSpacing,
              ),
              sliver: SliverGrid.extent(
                crossAxisSpacing: Dimensions.standardSpacing,
                mainAxisSpacing: Dimensions.standardSpacing,
                maxCrossAxisExtent: Dimensions.boardGameItemCollectionImageWidth,
                children: List<BoardGameTile>.generate(
                  boardGames.length,
                  (int index) {
                    final BoardGame boardGame = boardGames[index];
                    return BoardGameTile(
                      boardGame: boardGame,
                      onTap: () async => _navigateToBoardGameDetails(boardGame, context),
                    );
                  },
                ),
              ),
            );
          }

          return SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    AppText.searchBoardGamesPageHotBoardGamesErrorPartOne,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: Dimensions.standardSpacing),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconAndTextButton(
                      icon: const DefaultIcon(Icons.refresh),
                      title: AppText.searchBoardGamesPageHotBoardGamesErrorRetryButtonText,
                      onPressed: () => _hotBoardGamesStore.refresh(),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const SliverFillRemaining(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.doubleStandardSpacing),
              child: Center(child: GenericErrorMessage()),
            ),
          );
        }

        return const SliverFillRemaining(child: LoadingIndicator());
      },
    );
  }

  Future _navigateToBoardGameDetails(BoardGame boardGame, BuildContext context) async {
    await analyticsService.logEvent(
      name: Analytics.ViewHotBoardGame,
      parameters: <String, String?>{
        Analytics.BoardGameIdParameter: boardGame.id,
        Analytics.BoardGameNameParameter: boardGame.name,
      },
    );

    onBoardGameTapped(boardGame);
  }
}

class _HotBoardGamesHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.primaryColor,
      padding: const EdgeInsets.all(
        Dimensions.standardSpacing,
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Hot Board Games',
          style: AppTheme.titleTextStyle,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
