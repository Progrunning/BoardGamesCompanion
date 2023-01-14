import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/pages/home/home_page.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/search_history_entry.dart';
import '../../pages/collections/search_suggestion.dart';
import '../../utilities/launcher_helper.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/common/panel_container.dart';

class BggSearch extends SearchDelegate<BoardGameDetails?> {
  BggSearch({
    required this.searchHistory,
    required this.onResultAction,
    required this.onSearch,
  });

  static const int _maxSearchHistoryEntriesToShow = 10;

  final List<SearchHistoryEntry> searchHistory;
  final SearchCallback onSearch;
  final BoardGameResultAction onResultAction;

  @override
  ThemeData appBarTheme(BuildContext context) => AppTheme.theme.copyWith(
        textTheme: const TextTheme(headline6: AppTheme.defaultTextFieldStyle),
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

    return PageContainer(
      child: FutureBuilder<List<BoardGameDetails>>(
        future: onSearch(query),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const LoadingIndicator();
            case ConnectionState.done:
              if (snapshot.hasError) {
                return _SearchError(onRetry: () => query = query);
              }

              final filteredGames = snapshot.data;
              if (filteredGames?.isEmpty ?? true) {
                return _NoSearchResults(
                  query: query,
                  onRetry: () => query = query,
                );
              }

              return _SearchResults(filteredGames: filteredGames!, onResultAction: onResultAction);
          }
        },
      ),
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

        return _SearchResultGame(
          boardGame: boardGame,
          isFirstItem: index == 0,
          isLastItem: index == filteredGames.length - 1,
          onResultAction: onResultAction,
        );
      },
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

class _SearchError extends StatelessWidget {
  const _SearchError({
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.standardSpacing,
        horizontal: Dimensions.doubleStandardSpacing,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'Sorry, there was a problem when searching. Check your internet connectivity and try again.',
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.doubleStandardSpacing),
          Row(
            children: [
              const Spacer(),
              ElevatedIconButton(
                title: AppText.searchBoardGamesSearchRetry,
                icon: const DefaultIcon(Icons.refresh),
                onPressed: () => onRetry(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// TODO MK Update to show a button to add a game manually
// TODO MK Update copy to say that it could be because BGG failed or there's no board game like that in the BGG database
class _NoSearchResults extends StatelessWidget {
  const _NoSearchResults({
    Key? key,
    required this.query,
    required this.onRetry,
  }) : super(key: key);

  final String query;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.standardSpacing,
        horizontal: Dimensions.doubleStandardSpacing,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: '''Sorry, we couldn't find any results for your query '''),
                TextSpan(
                  text: '$query.',
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
          Row(
            children: [
              const Spacer(),
              ElevatedIconButton(
                title: AppText.searchBoardGamesSearchRetry,
                icon: const DefaultIcon(Icons.refresh),
                onPressed: () => onRetry(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
