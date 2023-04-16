import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/search_history_entry.dart';
import '../../models/results/bgg_search_result.dart';
import '../../models/sort_by.dart';
import '../../pages/collections/collections_page.dart';
import '../../pages/collections/search_suggestion.dart';
import '../../pages/home/home_page.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/common/panel_container.dart';
import '../common/loading_indicator_widget.dart';
import '../common/slivers/bgc_sliver_title_header_delegate.dart';
import '../common/sorting/sort_by_chip.dart';

/// [SearchDelegate] for the online (i.e. BGG) search.
/// Controller by the [HomeViewModel].
/// Returns the [BggSearchResult]
class BggSearch extends SearchDelegate<BggSearchResult?> {
  BggSearch({
    required this.searchHistory,
    required this.sortByOptions,
    required this.onResultAction,
    required this.searchResultsStream,
    required this.onSortyByUpdate,
    required this.onQueryChanged,
    required this.onRefresh,
  });

  static const int _maxSearchHistoryEntriesToShow = 10;

  final List<SearchHistoryEntry> searchHistory;
  final List<SortBy> sortByOptions;
  final Stream<List<BoardGameDetails>> searchResultsStream;
  final BoardGameResultAction onResultAction;
  final void Function(SortBy) onSortyByUpdate;
  final void Function(String) onQueryChanged;
  final VoidCallback onRefresh;

  @override
  ThemeData appBarTheme(BuildContext context) => AppTheme.theme.copyWith(
        textTheme: const TextTheme(titleLarge: AppTheme.defaultTextFieldStyle),
      );

  @override
  String? get searchFieldLabel => AppText.onlineSearchHintText;

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isEmpty) {
      return [const SizedBox()];
    }

    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return PageContainer(child: ListView());
    }

    return PageContainer(
      child: StreamBuilder<List<BoardGameDetails>>(
        stream: searchResultsStream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const LoadingIndicator();
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const _SearchError();
              }

              final foundGames = snapshot.data;
              if (foundGames?.isEmpty ?? true) {
                return _NoSearchResults(
                  query: query,
                  onCreateGame: () =>
                      close(context, BggSearchResult.createGame(boardGameName: query)),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    delegate: BgcSliverTitleHeaderDelegate.title(
                      primaryTitle: AppText.onlineSearchSortingSectionTitle,
                    ),
                  ),
                  _SearchFilters(
                    sortByOptions: sortByOptions,
                    onSortByChange: (SortBy selctedSortBy) {
                      onSortyByUpdate(selctedSortBy);
                      showResults(context);
                    },
                  ),
                  SliverPersistentHeader(
                    delegate: BgcSliverTitleHeaderDelegate.title(
                      primaryTitle: sprintf(
                        AppText.onlineSearchResultsSectionTitleFormat,
                        [foundGames!.length],
                      ),
                    ),
                    pinned: true,
                  ),
                  _SearchResults(foundGames: foundGames, onResultAction: onResultAction),
                ],
              );
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onQueryChanged(query);

    if (query.isEmpty) {
      return ListView();
    }

    final suggestions = _findSuggestions(query);
    if (suggestions.isEmpty) {
      return ListView();
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (_, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: Icon(
            suggestion.type == SuggestionType.boardGame ? Icons.search : Icons.history,
            color: AppColors.whiteColor,
          ),
          title: Text(suggestion.suggestion),
          onTap: () {
            query = suggestion.suggestion;
            onQueryChanged(query);
            showResults(context);
          },
        );
      },
    );
  }

  List<SearchSuggestion> _findSuggestions(String query) {
    final suggestions = <SearchSuggestion>[];
    final queryLowercased = query.toLowerCase();

    suggestions.addAll(
      searchHistory
          .where((SearchHistoryEntry entry) => entry.query.toLowerCase().contains(queryLowercased))
          .take(_maxSearchHistoryEntriesToShow)
          .map((SearchHistoryEntry entry) => SearchSuggestion(
                suggestion: entry.query,
                type: SuggestionType.historicalSearch,
              ))
          .toList(),
    );

    return suggestions;
  }
}

class _SearchFilters extends StatelessWidget {
  const _SearchFilters({
    required this.sortByOptions,
    required this.onSortByChange,
  });

  final List<SortBy> sortByOptions;
  final void Function(SortBy) onSortByChange;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
        child: Row(
          children: [
            for (final sortByOption in sortByOptions) ...[
              SortByChip(
                sortBy: sortByOption,
                onSortByChange: (sortBy) => onSortByChange(sortBy),
              ),
              const SizedBox(width: Dimensions.standardSpacing),
            ],
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    Key? key,
    required this.foundGames,
    required this.onResultAction,
  }) : super(key: key);

  final List<BoardGameDetails> foundGames;
  final BoardGameResultAction onResultAction;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        [
          for (final boardGame in foundGames) ...[
            _SearchResultGame(
              boardGame: boardGame,
              isFirstItem: foundGames.first == boardGame,
              isLastItem: foundGames.last == boardGame,
              onResultAction: onResultAction,
            ),
            const SizedBox(height: Dimensions.standardSpacing)
          ]
        ],
      ),
    );
  }
}

class _SearchResultGame extends StatelessWidget {
  const _SearchResultGame({
    Key? key,
    required this.boardGame,
    required this.isFirstItem,
    required this.isLastItem,
    required this.onResultAction,
  }) : super(key: key);

  final BoardGameDetails boardGame;
  final bool isFirstItem;
  final bool isLastItem;
  final BoardGameResultAction onResultAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: isFirstItem ? Dimensions.standardSpacing : 0,
        bottom: isLastItem ? Dimensions.standardSpacing : 0,
        left: Dimensions.standardSpacing,
        right: Dimensions.standardSpacing,
      ),
      child: PanelContainer(
        child: InkWell(
          borderRadius: AppTheme.defaultBorderRadius,
          onTap: () => onResultAction(boardGame, BoardGameResultActionType.details),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.standardSpacing),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Dimensions.collectionSearchResultBoardGameImageHeight,
                        width: Dimensions.collectionSearchResultBoardGameImageWidth,
                        child: BoardGameTile(
                          id: boardGame.id,
                          imageUrl: boardGame.imageUrl ?? '',
                        ),
                      ),
                      const SizedBox(width: Dimensions.standardSpacing),
                      Expanded(child: _SearchResultGameDetails(boardGame: boardGame)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResultGameDetails extends StatelessWidget {
  const _SearchResultGameDetails({
    Key? key,
    required this.boardGame,
  }) : super(key: key);

  final BoardGameDetails boardGame;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          boardGame.name,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        if (boardGame.yearPublished != null)
          Text(
            sprintf(AppText.onlineSearchGamePublishYearFormat, [boardGame.yearPublished]),
            overflow: TextOverflow.ellipsis,
            style: AppTheme.theme.textTheme.titleMedium,
          ),
      ],
    );
  }
}

class _SearchError extends StatelessWidget {
  const _SearchError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.standardSpacing,
        horizontal: Dimensions.doubleStandardSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          SizedBox(height: Dimensions.emptyPageTitleTopSpacing),
          Center(
            child: Icon(
              FontAwesomeIcons.faceSadTear,
              size: Dimensions.emptyPageTitleIconSize,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: Dimensions.doubleStandardSpacing),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'Sorry, we ran into a problem when searching for board games. Check your internet connectivity and try again.',
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.doubleStandardSpacing),
        ],
      ),
    );
  }
}

class _NoSearchResults extends StatelessWidget {
  const _NoSearchResults({
    Key? key,
    required this.query,
    required this.onCreateGame,
  }) : super(key: key);

  final String query;
  final VoidCallback onCreateGame;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.standardSpacing,
        horizontal: Dimensions.doubleStandardSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: Dimensions.emptyPageTitleTopSpacing),
          const Center(
            child: Icon(
              FontAwesomeIcons.faceSadTear,
              size: Dimensions.emptyPageTitleIconSize,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: Dimensions.doubleStandardSpacing),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                    text: '''Sorry, we couldn't find any board game titles for your query: '''),
                TextSpan(
                  text: '$query.',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.standardSpacing),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text:
                        '''The search is done using the BoardGamesGeek database, which is the biggest community based catalog of games but some of the titles might still be missing.'''),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.standardSpacing),
          const Text(
              'You can create any missing games and add them to your collections manually by clicking the below button.'),
          const SizedBox(height: Dimensions.doubleStandardSpacing),
          Row(
            children: [
              const Spacer(),
              ElevatedIconButton(
                title: AppText.searchBoardGamesCreateGame,
                icon: const DefaultIcon(Icons.add),
                onPressed: () => onCreateGame(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
