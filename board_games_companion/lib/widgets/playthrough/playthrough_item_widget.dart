import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/services/score_service.dart';
import 'package:board_games_companion/stores/playthrough_store.dart';
import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:board_games_companion/widgets/player/player_score_widget.dart';
import 'package:board_games_companion/widgets/playthrough/calendar_card.dart';
import 'package:board_games_companion/widgets/playthrough/playthrough_item_detail_widget.dart';
import 'package:board_games_companion/extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaythroughItem extends StatelessWidget {
  final Playthrough _playthrough;
  final int _playthroughNumber;

  const PlaythroughItem(
    this._playthrough,
    this._playthroughNumber, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        Dimensions.standardSpacing,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(
            Styles.defaultCornerRadius,
          )),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).accentColor,
              offset: Styles.defaultShadowOffset,
              blurRadius: Styles.defaultShadowRadius,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            Dimensions.standardSpacing,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.standardSpacing,
            ),
            child: ChangeNotifierProvider(
              create: (context) {
                final playerService = Provider.of<PlayerService>(
                  context,
                  listen: false,
                );
                final scoreService = Provider.of<ScoreService>(
                  context,
                  listen: false,
                );
                final playthroughStore =
                    PlaythroughStore(playerService, scoreService);
                playthroughStore.loadPlaythrough(_playthrough);
                return playthroughStore;
              },
              child: Consumer<PlaythroughStore>(
                builder: (_, store, __) {
                  if (store.loadDataState == LoadDataState.Loaded) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            CalendarCard(store.playthrough.startDate),
                            SizedBox(
                              height: Dimensions.standardSpacing,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    PlaythroughItemDetail(
                                        store.daysSinceStart?.toString(),
                                        'day(s) ago'),
                                    Divider(
                                      height: Dimensions.standardSpacing,
                                    ),
                                    PlaythroughItemDetail(
                                        '$_playthroughNumber${_playthroughNumber.toOrdinalAbbreviations()}',
                                        'game'),
                                    Divider(
                                      height: Dimensions.standardSpacing,
                                    ),
                                    PlaythroughItemDetail(
                                      store.highScore,
                                      'highscore',
                                    ),
                                    Divider(
                                      height: Dimensions.standardSpacing,
                                    ),
                                    PlaythroughItemDetail(store.durationInSeconds.toPlaythroughDuration(), 'duration'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: Dimensions.standardSpacing,
                        ),
                        Expanded(
                          child: ListView.separated(
                              itemCount: 4,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: Dimensions.standardSpacing,
                                );
                              },
                              itemBuilder: (context, index) {
                                return PlayerScore(
                                  medal: MedalEnum.Bronze,
                                );
                              }),
                        )
                      ],
                    );
                  } else if (store.loadDataState == LoadDataState.Error) {
                    return Center(
                      child: GenericErrorMessage(),
                    );
                  }

                  return Center(
                    child: LoadingIndicator(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
