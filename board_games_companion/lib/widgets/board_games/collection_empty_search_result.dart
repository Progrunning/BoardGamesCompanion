import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/stores/board_games_store.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:flutter/material.dart';

class CollectionEmptySearchResult extends StatelessWidget {
  const CollectionEmptySearchResult({
    Key key,
    @required BoardGamesStore boardGamesStore,
  })  : _boardGamesStore = boardGamesStore,
        super(key: key);

  final BoardGamesStore _boardGamesStore;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.doubleStandardSpacing,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'It looks like you don\'t have any board games in your collection that match the search phrase ',
                  ),
                  TextSpan(
                    text: '${_boardGamesStore.searchPhrase}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: Dimensions.standardSpacing,
            ),
            Center(
              child: IconAndTextButton(
                title: 'Clear search',
                icon: Icons.clear,
                onPressed: () {
                  _boardGamesStore.updateSearchResults('');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
