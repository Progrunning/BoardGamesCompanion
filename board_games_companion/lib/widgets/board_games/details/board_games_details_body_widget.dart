import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/stores/board_game_details_store.dart';
import 'package:board_games_companion/widgets/board_games/details/board_game_details_credits_widget.dart';
import 'package:board_games_companion/widgets/board_games/details/board_game_details_first_row_info_panels_widget.dart';
import 'package:board_games_companion/widgets/board_games/details/board_game_details_second_row_info_panels_widget.dart';
import 'package:board_games_companion/widgets/board_games/details/board_game_details_section_header_widget.dart';
import 'package:board_games_companion/widgets/board_games/details/board_game_details_stats_widget.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

class BoardGamesDetailsBody extends StatelessWidget {
  const BoardGamesDetailsBody({
    @required boardGameId,
    @required boardGameName,
    @required boardGameDetailsStore,
    Key key,
  })  : _boardGameId = boardGameId,
        _boardGameName = boardGameName,
        _boardGameDetailsStore = boardGameDetailsStore,
        super(key: key);

  final String _boardGameId;
  final String _boardGameName;
  final BoardGameDetailsStore _boardGameDetailsStore;

  static const _spacingBetweenSecions = Dimensions.doubleStandardSpacing;

  @override
  Widget build(BuildContext context) {
    final htmlUnescape = new HtmlUnescape();
    return FutureBuilder(
      future: _boardGameDetailsStore.loadBoardGameDetails(_boardGameId),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(
                    Dimensions.doubleStandardSpacing,
                  ),
                  child: Text(
                    'Sorry, we couldn\'t retrieve $_boardGameName\'s details. Check your Internet connectivity and try again. If the problem persists, please contact support at feedback@progrunning.net',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            );
          }

          return ChangeNotifierProvider<BoardGameDetailsStore>.value(
            value: _boardGameDetailsStore,
            child: Consumer<BoardGameDetailsStore>(
              builder: (_, store, __) {
                return SliverPadding(
                  padding: EdgeInsets.all(
                    Dimensions.standardSpacing,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed(
                      <Widget>[
                        BoardGameDetailsSectionHeader(
                          title: 'Stats',
                        ),
                        BoardGameDetailsStats(
                          boardGameDetails:
                              _boardGameDetailsStore.boardGameDetails,
                        ),
                        SizedBox(
                          height: _spacingBetweenSecions,
                        ),
                        BoardGameDetailsSectionHeader(
                          title: 'General',
                        ),
                        BoardGameDetailsFirstRowInfoPanels(
                          boardGameDetails:
                              _boardGameDetailsStore.boardGameDetails,
                        ),
                        SizedBox(
                          height: _spacingBetweenSecions,
                        ),
                        BoardGameDetailsSecondRowInfoPanels(
                          boardGameDetails:
                              _boardGameDetailsStore.boardGameDetails,
                        ),
                        SizedBox(
                          height: _spacingBetweenSecions,
                        ),
                        BoardGameDetailsSectionHeader(
                          title: 'Credits',
                        ),
                        BoardGameDetailsCredits(
                          boardGameDetails:
                              _boardGameDetailsStore.boardGameDetails,
                        ),
                        SizedBox(
                          height: _spacingBetweenSecions,
                        ),
                        BoardGameDetailsSectionHeader(
                          title: 'Categories',
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: Dimensions.standardSpacing,
                          alignment: WrapAlignment.spaceEvenly,
                          children: _boardGameDetailsStore
                              .boardGameDetails.categories
                              .map<Widget>((category) {
                            return Chip(
                              padding: EdgeInsets.all(
                                Dimensions.standardSpacing,
                              ),
                              backgroundColor: AppTheme.primaryColor.withAlpha(
                                Styles.opacity80Percent,
                              ),
                              label: Text(
                                category.name,
                                style: TextStyle(
                                  color: AppTheme.defaultTextColor,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: _spacingBetweenSecions,
                        ),
                        BoardGameDetailsSectionHeader(
                          title: 'Description',
                        ),
                        Text(
                          htmlUnescape
                              .convert(store.boardGameDetails.description),
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: Dimensions.mediumFontSize),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.standardSpacing),
                    child: Center(
                      child: Text(
                          'We couldn\'t retrieve any board games. Check your Internet connectivity and try again.'),
                    ),
                  ),
                  SizedBox(height: Dimensions.standardSpacing),
                  IconAndTextButton(
                    title: 'Refresh',
                    icon: Icons.refresh,
                    onPressed: () => _refreshBoardGameDetails(
                        _boardGameId, _boardGameDetailsStore),
                  )
                ],
              ),
            ),
          );
        }

        return SliverFillRemaining(
          child: LoadingIndicator(),
        );
      },
    );
  }

  Future<void> _refreshBoardGameDetails(
    String boardGameDetailsId,
    BoardGameDetailsStore boardGameDetailsStore,
  ) async {
    await boardGameDetailsStore.loadBoardGameDetails(boardGameDetailsId);
  }
}
