import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../models/board_game.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
import '../../stores/search_bar_board_games_store.dart';
import '../../stores/search_board_games_store.dart';
import '../../utilities/launcher_helper.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/common/slivers/bgc_sliver_header_delegate.dart';
import '../board_game_details/board_game_details_page.dart';
import 'search_board_games_view_model.dart';

class SearchBoardGamesPage extends StatefulWidget {
  const SearchBoardGamesPage({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final SearchBoardGamesViewModel viewModel;

  @override
  SearchBoardGamesPageState createState() => SearchBoardGamesPageState();
}

class SearchBoardGamesPageState extends State<SearchBoardGamesPage> {
  late FocusNode searchFocusNode;

  @override
  void initState() {
    super.initState();
    widget.viewModel.loadHotBoardGames();
    searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: CustomScrollView(
        slivers: <Widget>[
          _SearchBar(searchFocusNode: searchFocusNode),
          _SearchResults(
            onBoardGameTapped: (BoardGame boardGame) => _navigateToBoardGameDetails(boardGame),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate:
                BgcSliverHeaderDelegate(primaryTitle: AppText.hotBoardGamesSliverSectionTitle),
          ),
          _HotBoardGames(
            viewModel: widget.viewModel,
            onBoardGameTapped: (BoardGame boardGame) => _navigateToBoardGameDetails(boardGame),
          ),
        ],
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
        boardGameImageUrl: widget.viewModel.getHotBoardGameDetails(boardGame.id)?.imageUrl,
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
      foregroundColor: AppColors.accentColor,
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
        color: AppColors.accentColor,
        onPressed: () {
          searchController.text = '';
          searchBarBoardGamesStore.searchPhrase = null;
          searchBoardGamesStore.updateSearchResults();
        },
      );
    }

    return const Icon(
      Icons.search,
      color: AppColors.accentColor,
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
              padding: const EdgeInsets.all(Dimensions.standardSpacing),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    final int itemIndex = index ~/ 2;
                    if (index.isEven) {
                      return Material(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
                        elevation: 4,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
                          onTap: () =>
                              _navigateToBoardGameDetails(searchResults!, itemIndex, context),
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
                                const SizedBox(height: Dimensions.halfStandardSpacing),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return const SizedBox(height: Dimensions.standardSpacing);
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
  const _SearchResultsTemplate({required this.child});

  static const double defaultHeight = 100;

  final Widget child;

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
  double get maxExtent => defaultHeight;

  @override
  double get minExtent => defaultHeight;

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
                          'mailto:${Constants.feedbackEmailAddress}?subject=BGC%20Feedback',
                        );
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.doubleStandardSpacing),
            Center(
              child: ElevatedIconButton(
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
    required this.viewModel,
    required this.onBoardGameTapped,
    Key? key,
  }) : super(key: key);

  final SearchBoardGamesViewModel viewModel;
  final void Function(BoardGame) onBoardGameTapped;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        switch (viewModel.futureLoadHotBoardGames?.status ?? FutureStatus.pending) {
          case FutureStatus.pending:
            return const SliverFillRemaining(child: LoadingIndicator());
          case FutureStatus.rejected:
            return const SliverFillRemaining(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.doubleStandardSpacing),
                child: Center(child: GenericErrorMessage()),
              ),
            );
          case FutureStatus.fulfilled:
            if (viewModel.hasAnyHotBoardGames) {
              return SliverPadding(
                padding: const EdgeInsets.only(
                  left: Dimensions.standardSpacing,
                  top: Dimensions.standardSpacing,
                  right: Dimensions.standardSpacing,
                  bottom: Dimensions.standardSpacing + Dimensions.bottomTabTopHeight,
                ),
                sliver: SliverGrid.extent(
                  crossAxisSpacing: Dimensions.standardSpacing,
                  mainAxisSpacing: Dimensions.standardSpacing,
                  maxCrossAxisExtent: Dimensions.boardGameItemCollectionImageWidth,
                  children: [
                    for (final hotBoardGame in viewModel.hotBoardGames!)
                      BoardGameTile(
                        id: hotBoardGame.id,
                        name: hotBoardGame.name,
                        imageUrl: hotBoardGame.thumbnailUrl ?? '',
                        rank: hotBoardGame.rank,
                        elevation: AppStyles.defaultElevation,
                        onTap: () async => _navigateToBoardGameDetails(hotBoardGame, context),
                      ),
                  ],
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
                      child: ElevatedIconButton(
                        icon: const DefaultIcon(Icons.refresh),
                        title: AppText.searchBoardGamesPageHotBoardGamesErrorRetryButtonText,
                        onPressed: () => viewModel.refresh(),
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }

  void _navigateToBoardGameDetails(BoardGame boardGame, BuildContext context) {
    viewModel.trackViewHotBoardGame(boardGame);

    onBoardGameTapped(boardGame);
  }
}
