import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/analytics.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../../models/board_game.dart';
import '../../services/analytics_service.dart';
import '../../stores/hot_board_games_store.dart';
import '../../stores/search_bar_board_games_store.dart';
import '../../stores/search_board_games_store.dart';
import '../../utilities/launcher_helper.dart';
import '../../utilities/navigator_helper.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/page_container_widget.dart';
import '../../widgets/common/rippler_effect.dart';

class SearchBoardGamesPage extends StatefulWidget {
  const SearchBoardGamesPage({Key key}) : super(key: key);

  @override
  _SearchBoardGamesPageState createState() => _SearchBoardGamesPageState();
}

class _SearchBoardGamesPageState extends State<SearchBoardGamesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageContainer(
        child: CustomScrollView(
          slivers: <Widget>[
            _SearchBar(),
            const _SearchResults(),
            SliverPersistentHeader(
              pinned: true,
              delegate: _HotBoardGamesHeader(),
            ),
            const _HotBoardGames(),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  _SearchBar({
    Key key,
  }) : super(key: key);

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchBoardGamesStore = Provider.of<SearchBoardGamesStore>(
      context,
      listen: false,
    );

    return SliverAppBar(
      titleSpacing: 0,
      title: Consumer<SearchBarBoardGamesStore>(
        builder: (_, store, __) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.standardSpacing,
            ),
            child: TextField(
              controller: _searchController,
              style: AppTheme.defaultTextFieldStyle,
              textAlignVertical: TextAlignVertical.center,
              decoration: AppTheme.defaultTextFieldInputDecoration.copyWith(
                hintText: 'Search...',
                suffixIcon: retrieveSearchBarSuffixIcon(
                  store,
                  searchBoardGamesStore,
                ),
              ),
              onChanged: (searchPhrase) {
                store.searchPhrase = searchPhrase;
              },
              onSubmitted: (searchPhrase) {
                searchBoardGamesStore.updateSearchResults();
              },
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
          _searchController.text = '';
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
  const _SearchResults({Key key}) : super(key: key);

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<_SearchResults> {
  SearchBarBoardGamesStore searchBarBoardGamesStore;

  @override
  void initState() {
    super.initState();
    searchBarBoardGamesStore = Provider.of<SearchBarBoardGamesStore>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchBoardGamesStore = Provider.of<SearchBoardGamesStore>(context);
    return FutureBuilder(
      future: searchBoardGamesStore.search(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final searchResults = snapshot.data as List<BoardGame>;
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
                          borderRadius: BorderRadius.circular(
                            Styles.defaultCornerRadius,
                          ),
                          boxShadow: const <BoxShadow>[
                            AppTheme.defaultBoxShadow,
                          ],
                        ),
                        child: RippleEffect(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              Dimensions.standardSpacing,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  searchResults[itemIndex].name,
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
                          onTap: () async {
                            final boardGame = searchResults[itemIndex];
                            await NavigatorHelper.navigateToBoardGameDetails(
                                context, boardGame?.id, boardGame?.name, SearchBoardGamesPage);
                          },
                        ),
                      );
                    }

                    return const Divider(
                      height: Dimensions.standardSpacing,
                    );
                  },
                  childCount: math.max(0, searchResults.length * 2 - 1),
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
                'To search for board games, please type a board game title in the above search bar.',
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
}

class _SearchResultsTemplate extends SliverPersistentHeaderDelegate {
  const _SearchResultsTemplate({
    @required this.child,
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
    Key key,
    @required this.searchBarBoardGamesStore,
    @required this.searchBoardGamesStore,
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
            const SizedBox(
              height: Dimensions.doubleStandardSpacing,
            ),
            Center(
              child: IconAndTextButton(
                title: 'Retry',
                icon: const DefaultIcon(
                  Icons.refresh,
                ),
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

class _HotBoardGames extends StatefulWidget {
  const _HotBoardGames({Key key}) : super(key: key);

  @override
  _HotBoardGamesState createState() => _HotBoardGamesState();
}

class _HotBoardGamesState extends State<_HotBoardGames> {
  AnalyticsService _analytics;

  @override
  void initState() {
    super.initState();
    _analytics = Provider.of<AnalyticsService>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _hotBoardGamesStore = Provider.of<HotBoardGamesStore>(context);

    return FutureBuilder(
      future: _hotBoardGamesStore.load(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data is List<BoardGame> && (snapshot.data as List<BoardGame>).isNotEmpty) {
            return SliverPadding(
              padding: const EdgeInsets.all(
                Dimensions.standardSpacing,
              ),
              sliver: SliverGrid.extent(
                crossAxisSpacing: Dimensions.standardSpacing,
                mainAxisSpacing: Dimensions.standardSpacing,
                maxCrossAxisExtent: Dimensions.boardGameItemCollectionImageWidth,
                children: List<BoardGameTile>.generate(
                  (snapshot.data as List<BoardGame>).length,
                  (int index) {
                    final BoardGame boardGame = snapshot.data[index] as BoardGame;
                    return BoardGameTile(
                      boardGame: boardGame,
                      onTap: () async {
                        await _analytics.logEvent(
                          name: Analytics.ViewHotBoardGame,
                          parameters: <String, String>{
                            Analytics.BoardGameIdParameter: boardGame.id,
                            Analytics.BoardGameNameParameter: boardGame.name,
                          },
                        );

                        await NavigatorHelper.navigateToBoardGameDetails(
                          context,
                          boardGame?.id,
                          boardGame?.name,
                          SearchBoardGamesPage,
                        );
                      },
                    );
                  },
                ),
              ),
            );
          }

          return SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(
                  Dimensions.doubleStandardSpacing,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(Dimensions.standardSpacing),
                      child: Center(
                        child: Text(
                            '''We couldn't retrieve any board games. Check your Internet connectivity and try again.'''),
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.standardSpacing,
                    ),
                    IconAndTextButton(
                      icon: const DefaultIcon(
                        Icons.add,
                      ),
                      title: 'Refresh',
                      onPressed: () async {
                        await _hotBoardGamesStore.refresh();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const SliverFillRemaining(
            child: Padding(
              padding: EdgeInsets.all(
                Dimensions.doubleStandardSpacing,
              ),
              child: Center(
                child: GenericErrorMessage(),
              ),
            ),
          );
        }

        return const SliverFillRemaining(
          child: LoadingIndicator(),
        );
      },
    );
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
