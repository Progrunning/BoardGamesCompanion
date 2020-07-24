import 'package:board_games_companion/common/constants.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/stores/search_bar_board_games_store.dart';
import 'package:board_games_companion/stores/search_board_games_store.dart';
import 'package:board_games_companion/utilities/launcher_helper.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SearchBoardGamesNoResults extends StatelessWidget {
  const SearchBoardGamesNoResults({
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
                  TextSpan(
                    text:
                        'Sorry, we couldn\'t find any results for the search phrase ',
                  ),
                  TextSpan(
                    text: '${searchBarBoardGamesStore.searchPhrase}.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dimensions.standardSpacing,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'Please try again or if the problem persists please contact support ',
                  ),
                  TextSpan(
                    text: 'feedback@progrunning.net',
                    style: TextStyle(
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
            SizedBox(
              height: Dimensions.doubleStandardSpacing,
            ),
            Center(
              child: IconAndTextButton(
                title: 'Retry',
                icon: Icons.refresh,
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
