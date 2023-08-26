import 'package:board_games_companion/utilities/launcher_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
import '../common/bgc_shimmer.dart';
import '../common/empty_page_information_panel.dart';
import '../common/search/search_result_game_details.dart';
import '../common/slivers/bgc_sliver_title_header_delegate.dart';
import '../common/sorting/sort_by_chip.dart';
import 'board_game_search_error.dart';

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
              return Padding(
                padding: const EdgeInsets.all(Dimensions.standardSpacing),
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) => const _SearchResultShimmer(),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: Dimensions.standardSpacing),
                  itemCount: 10,
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return _SearchError(
                  error: snapshot.error as BoardGameSearchError,
                );
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

class _SearchResultShimmer extends StatelessWidget {
  const _SearchResultShimmer();

  @override
  Widget build(BuildContext context) {
    return PanelContainer(
      child: BgcShimmer(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: Dimensions.collectionSearchResultBoardGameImageHeight,
                width: Dimensions.collectionSearchResultBoardGameImageWidth,
                decoration: const BoxDecoration(
                  borderRadius: AppTheme.defaultBorderRadius,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: Dimensions.standardSpacing),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: Dimensions.largeFontSize,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(height: Dimensions.standardSpacing),
                    Row(
                      children: [
                        Container(
                          height: Dimensions.smallButtonIconSize,
                          width: Dimensions.smallButtonIconSize,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: Dimensions.standardSpacing),
                        Container(
                          height: Dimensions.mediumFontSize,
                          width: 80,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.standardSpacing),
                    Row(
                      children: [
                        Container(
                          height: Dimensions.smallButtonIconSize,
                          width: Dimensions.smallButtonIconSize,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: Dimensions.standardSpacing),
                        Container(
                          height: Dimensions.mediumFontSize,
                          width: 110,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.standardSpacing),
                    Row(
                      children: [
                        Container(
                          height: Dimensions.smallButtonIconSize,
                          width: Dimensions.smallButtonIconSize,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: Dimensions.standardSpacing),
                        Container(
                          height: Dimensions.mediumFontSize,
                          width: 60,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    final locale = Localizations.localeOf(context);
    final countryCode = locale.countryCode?.toLowerCase();
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
                      Expanded(child: SearchResultGameDetails(boardGame: boardGame)),
                    ],
                  ),
                ),
                if (boardGame.hasLowestPricesForRegion(countryCode))
                  Builder(builder: (context) {
                    final prices = boardGame.pricesByRegion[countryCode]!;
                    return _SearchResultGamePrices(
                      lowestPrice: prices.lowest!,
                      lowestPriceStoreName: prices.lowestStoreName,
                      pricesWebsiteUrl: prices.websiteUrl,
                      updatedAt: boardGame.lastModified,
                      currencyFormat: NumberFormat.simpleCurrency(locale: locale.toString()),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResultGamePrices extends StatelessWidget {
  const _SearchResultGamePrices({
    required this.lowestPrice,
    required this.lowestPriceStoreName,
    required this.pricesWebsiteUrl,
    required this.updatedAt,
    required this.currencyFormat,
  });

  final double lowestPrice;
  final String? lowestPriceStoreName;
  final String pricesWebsiteUrl;
  final DateTime? updatedAt;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: Dimensions.doubleStandardSpacing),
        const Divider(),
        const SizedBox(height: Dimensions.standardSpacing),
        InkWell(
          onTap: () => LauncherHelper.launchUri(context, pricesWebsiteUrl),
          child: Row(
            children: [
              Chip(
                padding: const EdgeInsets.all(Dimensions.standardSpacing),
                backgroundColor: AppColors.accentColor,
                label: Text(
                  currencyFormat.format(lowestPrice),
                  style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (lowestPriceStoreName != null) ...[
                const SizedBox(width: Dimensions.standardSpacing),
                Expanded(
                  child: Text(
                    // TODO Move to AppText
                    'at ${lowestPriceStoreName!}',
                    style: AppTheme.theme.textTheme.bodyMedium!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: Dimensions.standardSpacing),
              ],
              if (lowestPriceStoreName == null) const Expanded(child: SizedBox.shrink()),
              Column(
                children: [
                  // TODO Move to AppText
                  Text(
                    'powered by',
                    style: AppTheme.theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: Dimensions.halfStandardSpacing),
                  SvgPicture.asset(
                    'assets/icons/boardgameoracle_logo_name.svg',
                    height: 18,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ],
          ),
        ),
        // if (updatedAt != null) ...[
        //   const Expanded(child: SizedBox.shrink()),
        //   Text(
        //     sprintf(AppText.searchBoardGamesPriceUpdatedAtFormat, [updatedAt!.toDaysAgo()]),
        //     style: AppTheme.theme.textTheme.titleSmall,
        //   ),
        // ]
      ],
    );
  }
}

class _SearchError extends StatelessWidget {
  const _SearchError({
    required this.error,
    Key? key,
  }) : super(key: key);

  final BoardGameSearchError error;

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
          EmptyPageInformationPanel(
            title: AppText.searchBoardGamesErrorTitle,
            icon: const Icon(
              FontAwesomeIcons.faceSadTear,
              size: Dimensions.emptyPageTitleIconSize,
              color: AppColors.primaryColor,
            ),
            subtitle: error.when(
              timout: () => AppText.searchBoardGamesTimeoutError,
              generic: () => AppText.searchBoardGamesGenericError,
            ),
          ),
          const SizedBox(height: Dimensions.doubleStandardSpacing),
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
          const EmptyPageInformationPanel(
            title: "We didn't find any board games",
            icon: Icon(
              FontAwesomeIcons.faceSadTear,
              size: Dimensions.emptyPageTitleIconSize,
              color: AppColors.primaryColor,
            ),
            subtitle:
                'The search is done using the BoardGamesGeek database, which is the biggest community based catalog of games but some of the titles might still be missing.\n\nYou can create any missing games and add them to your collections manually by clicking the below button.',
          ),
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
