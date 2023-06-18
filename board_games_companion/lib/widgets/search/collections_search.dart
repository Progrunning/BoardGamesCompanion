import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../injectable.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/search_history_entry.dart';
import '../../pages/collections/collection_search_result_view_model.dart';
import '../../pages/collections/collections_page.dart';
import '../../pages/collections/search_suggestion.dart';
import '../../pages/home/home_page.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/common/panel_container.dart';
import '../common/search/search_result_game_details.dart';

class CollectionsSearch extends SearchDelegate<BoardGameDetails?> {
  CollectionsSearch({
    required this.searchHistory,
    required this.allBoardGames,
    required this.onResultAction,
    required this.onSearch,
  });

  static const int _maxSearchHistoryEntriesToShow = 10;

  final List<SearchHistoryEntry> searchHistory;
  final List<BoardGameDetails> allBoardGames;
  final BoardGameResultAction onResultAction;
  final SearchCallback onSearch;

  @override
  ThemeData appBarTheme(BuildContext context) => AppTheme.theme.copyWith(
        textTheme: const TextTheme(titleLarge: AppTheme.defaultTextFieldStyle),
      );

  @override
  String? get searchFieldLabel => AppText.collectionsSearchHintText;

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isEmpty) {
      return [const SizedBox()];
    }

    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
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

    return FutureBuilder(
      future: onSearch(query),
      builder: (context, AsyncSnapshot<List<BoardGameDetails>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            final filteredGames = snapshot.data;
            if (filteredGames?.isEmpty ?? true) {
              return PageContainer(
                child: _NoSearchResults(
                  query: query,
                  onClear: () => query = '',
                ),
              );
            }

            return PageContainer(
              child: _SearchResults(filteredGames: filteredGames!, onResultAction: onResultAction),
            );
        }

        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
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
    suggestions.addAll(
      allBoardGames
          .where((BoardGameDetails boardGame) =>
              boardGame.name.toLowerCase().contains(queryLowercased))
          .map((BoardGameDetails boardGame) => SearchSuggestion(
                suggestion: boardGame.name,
                type: SuggestionType.boardGame,
              ))
          .toList(),
    );

    return suggestions;
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    Key? key,
    required this.filteredGames,
    required this.onResultAction,
  }) : super(key: key);

  final List<BoardGameDetails> filteredGames;
  final BoardGameResultAction onResultAction;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: filteredGames.length,
      separatorBuilder: (_, index) => const SizedBox(height: Dimensions.standardSpacing),
      itemBuilder: (_, index) {
        final boardGame = filteredGames[index];
        final viewModel = getIt<CollectionSearchResultViewModel>();
        viewModel.setBoardGameId(boardGame.id);

        return Observer(
          builder: (_) {
            return _SearchResultGame(
              boardGame: viewModel.boardGame!,
              expansions: viewModel.expansions,
              hasIncompleteDetails: viewModel.boardGame!.hasIncompleteDetails,
              isFirstItem: index == 0,
              isLastItem: index == filteredGames.length - 1,
              onResultAction: onResultAction,
              onRefresh: () => viewModel.refreshBoardGameDetails(),
            );
          },
        );
      },
    );
  }
}

class _SearchResultGame extends StatelessWidget {
  const _SearchResultGame({
    Key? key,
    required this.boardGame,
    required this.expansions,
    required this.hasIncompleteDetails,
    required this.isFirstItem,
    required this.isLastItem,
    required this.onResultAction,
    required this.onRefresh,
  }) : super(key: key);

  final BoardGameDetails boardGame;
  final List<BoardGameDetails>? expansions;
  final bool hasIncompleteDetails;
  final bool isFirstItem;
  final bool isLastItem;
  final BoardGameResultAction onResultAction;
  final VoidCallback onRefresh;

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
                        imageUrl: boardGame.thumbnailUrl ?? '',
                      ),
                    ),
                    const SizedBox(width: Dimensions.standardSpacing),
                    Expanded(child: SearchResultGameDetails(boardGame: boardGame)),
                    _SearchResultGameActions(boardGame: boardGame, onResultAction: onResultAction),
                  ],
                ),
              ),
              if (boardGame.hasIncompleteDetails)
                _SearchResultGameRefreshData(
                  boardGame: boardGame,
                  onRefresh: onRefresh,
                ),
              if (expansions?.isNotEmpty ?? false)
                _SearchResultGameExpansions(
                  expansions: expansions!,
                  onResultAction: onResultAction,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchResultGameExpansions extends StatelessWidget {
  const _SearchResultGameExpansions({
    required this.expansions,
    required this.onResultAction,
    Key? key,
  }) : super(key: key);

  final List<BoardGameDetails> expansions;
  final BoardGameResultAction onResultAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimensions.doubleStandardSpacing),
        const Divider(),
        const SizedBox(height: Dimensions.standardSpacing),
        Text(
          sprintf(AppText.gamesPageSearchResultExpansionsSectionTitleFormat, [expansions.length]),
          style: AppTheme.theme.textTheme.titleMedium,
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        SizedBox(
          height: Dimensions.collectionSearchResultExpansionsImageHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: expansions.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: Dimensions.doubleStandardSpacing),
            itemBuilder: (context, index) {
              final BoardGameDetails expansion = expansions[index];
              return SizedBox(
                height: Dimensions.collectionSearchResultExpansionsImageHeight,
                width: Dimensions.collectionSearchResultExpansionsImageWidth,
                // TODO MK Need to fix hero animation if the expansion is shown in the main game results and as well as a regular search result
                child: BoardGameTile(
                  id: '${expansion.id}-exp',
                  name: expansion.name,
                  nameFontSize: Dimensions.extraSmallFontSize,
                  imageUrl: expansion.thumbnailUrl ?? '',
                  elevation: AppStyles.defaultElevation,
                  onTap: () async => onResultAction(expansion, BoardGameResultActionType.details),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchResultGameRefreshData extends StatefulWidget {
  const _SearchResultGameRefreshData({
    required this.boardGame,
    required this.onRefresh,
    Key? key,
  }) : super(key: key);

  final BoardGameDetails boardGame;
  final VoidCallback onRefresh;

  @override
  State<_SearchResultGameRefreshData> createState() => _SearchResultGameRefreshDataState();
}

class _SearchResultGameRefreshDataState extends State<_SearchResultGameRefreshData>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Dimensions.doubleStandardSpacing),
        const Divider(),
        const SizedBox(height: Dimensions.standardSpacing),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outlined, size: Dimensions.smallButtonIconSize),
            const SizedBox(width: Dimensions.standardSpacing),
            Expanded(
              child: Text(
                AppText.gamesPageSearchResultRefreshDetails,
                style: AppTheme.theme.textTheme.titleMedium,
              ),
            ),
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  _controller.repeat();
                  widget.onRefresh();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SearchResultGameActions extends StatelessWidget {
  const _SearchResultGameActions({
    Key? key,
    required this.boardGame,
    required this.onResultAction,
  }) : super(key: key);

  final BoardGameDetails boardGame;
  final BoardGameResultAction onResultAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => onResultAction(boardGame, BoardGameResultActionType.details),
        ),
        const SizedBox(height: Dimensions.doubleStandardSpacing),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.dice),
          onPressed: () => onResultAction(boardGame, BoardGameResultActionType.playthroughs),
        ),
      ],
    );
  }
}

class _NoSearchResults extends StatelessWidget {
  const _NoSearchResults({
    Key? key,
    required this.query,
    required this.onClear,
  }) : super(key: key);

  final String query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.doubleStandardSpacing),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: AppText.gamesPageSearchNoSearchResults),
                TextSpan(
                  text: query,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: Dimensions.standardSpacing),
          Center(
            child: ElevatedIconButton(
              title: AppText.gamesPageSearchClearSaerch,
              icon: const DefaultIcon(Icons.clear),
              onPressed: onClear,
            ),
          ),
        ],
      ),
    );
  }
}
