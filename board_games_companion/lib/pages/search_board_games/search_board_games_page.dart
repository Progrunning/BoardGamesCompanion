import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../models/board_game.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
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
          _SearchBar(
            viewModel: widget.viewModel,
            searchFocusNode: searchFocusNode,
          ),
          _Search(
            viewModel: widget.viewModel,
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
    required this.viewModel,
    required this.searchFocusNode,
    Key? key,
  }) : super(key: key);

  final SearchBoardGamesViewModel viewModel;
  final FocusNode searchFocusNode;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
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
      title: Padding(
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
            hintText: AppText.searchBoardGamesSearchBarHint,
            suffixIcon: Observer(
              builder: (_) {
                return _SearchIcon(
                  isSearchPhraseEmpty: widget.viewModel.isSearchPhraseEmpty,
                  onClear: () {
                    searchController.text = '';
                    widget.viewModel.clearSearchResults();
                  },
                );
              },
            ),
          ),
          onChanged: (searchPhrase) => widget.viewModel.setSearchPhrase(searchPhrase),
          onSubmitted: (searchPhrase) => widget.viewModel.searchBoardGames(),
        ),
      ),
    );
  }
}

class _SearchIcon extends StatelessWidget {
  const _SearchIcon({
    Key? key,
    required this.isSearchPhraseEmpty,
    required this.onClear,
  }) : super(key: key);

  final bool isSearchPhraseEmpty;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (isSearchPhraseEmpty) {
      return const Icon(Icons.search, color: AppColors.accentColor);
    }

    return IconButton(
      icon: const Icon(Icons.clear),
      color: AppColors.accentColor,
      onPressed: () => onClear(),
    );
  }
}

class _Search extends StatefulWidget {
  const _Search({
    Key? key,
    required this.viewModel,
    required this.onBoardGameTapped,
  }) : super(key: key);

  final SearchBoardGamesViewModel viewModel;
  final void Function(BoardGame) onBoardGameTapped;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<_Search> {
  @override
  void initState() {
    super.initState();

    widget.viewModel.searchBoardGames();
  }

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          return widget.viewModel.searchResults.when(
            results: (searchResults) {
              if (searchResults.isEmpty) {
                return _NoResults(
                  searchPhrase: widget.viewModel.searchPhrase!,
                  onRetry: () => widget.viewModel.searchBoardGames(),
                );
              }

              return _SearchResultsSliver(
                searchResults: searchResults,
                onTap: (boardGame) => widget.onBoardGameTapped(boardGame),
              );
            },
            searching: (searchPhrase) {
              return const SliverPersistentHeader(
                delegate: _SearchResultsTemplate(
                  child: LoadingIndicator(),
                ),
              );
            },
            init: () {
              return const SliverPersistentHeader(
                delegate: _SearchResultsTemplate(
                  child: Text(
                    AppText.searchBoardGamesPageSearchInstructions,
                    textAlign: TextAlign.justify,
                  ),
                ),
              );
            },
            failure: () {
              return const SliverPersistentHeader(
                delegate: _SearchResultsTemplate(
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.doubleStandardSpacing),
                    child: Center(child: GenericErrorMessage()),
                  ),
                ),
              );
            },
          );
        },
      );
}

class _SearchResultsSliver extends StatelessWidget {
  const _SearchResultsSliver({
    required this.searchResults,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final List<BoardGame> searchResults;
  final void Function(BoardGame) onTap;

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.all(Dimensions.standardSpacing),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              final int itemIndex = index ~/ 2;
              final boardGame = searchResults[itemIndex];
              if (index.isEven) {
                return Material(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
                  elevation: 4,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppStyles.defaultCornerRadius),
                    onTap: () => onTap(boardGame),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.standardSpacing),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            boardGame.name,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.titleTextStyle,
                          ),
                          if (boardGame.yearPublished != null)
                            Text(
                              boardGame.yearPublished.toString(),
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
            childCount: math.max(0, searchResults.length * 2 - 1),
          ),
        ),
      );
}

class _SearchResultsTemplate extends SliverPersistentHeaderDelegate {
  const _SearchResultsTemplate({required this.child});

  static const double defaultHeight = 100;

  final Widget child;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
      child: Center(child: child),
    );
  }

  @override
  double get maxExtent => defaultHeight;

  @override
  double get minExtent => defaultHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class _NoResults extends StatelessWidget {
  const _NoResults({
    Key? key,
    required this.searchPhrase,
    required this.onRetry,
  }) : super(key: key);

  final String searchPhrase;
  final VoidCallback onRetry;

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
                    text: '$searchPhrase.',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.standardSpacing),
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
            // TODO Test
            Center(
              child: ElevatedIconButton(
                title: AppText.searchBoardGamesSearchRetry,
                icon: const DefaultIcon(Icons.refresh),
                onPressed: () => onRetry(),
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
