import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums.dart';
import 'package:board_games_companion/common/styles.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/services/player_service.dart';
import 'package:board_games_companion/services/score_service.dart';
import 'package:board_games_companion/stores/playthrough_duration_store.dart';
import 'package:board_games_companion/stores/playthrough_store.dart';
import 'package:board_games_companion/stores/playthroughs_store.dart';
import 'package:board_games_companion/widgets/common/generic_error_message_widget.dart';
import 'package:board_games_companion/widgets/common/icon_and_text_button.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:board_games_companion/widgets/player/scores/player_score_widget.dart';
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
          child: ChangeNotifierProvider<PlaythroughStore>(
            create: (context) => _createAndLoadPlatythroughStore(context),
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
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                PlaythroughItemDetail(
                                  store.daysSinceStart?.toString(),
                                  'day(s) ago',
                                ),
                                SizedBox(
                                  height: Dimensions.standardSpacing,
                                ),
                                PlaythroughItemDetail(
                                  '$_playthroughNumber${_playthroughNumber.toOrdinalAbbreviations()}',
                                  'game',
                                ),
                                SizedBox(
                                  height: Dimensions.standardSpacing,
                                ),
                                ChangeNotifierProvider(
                                  create: (_) =>
                                      PlaythroughDurationStore(_playthrough),
                                  child: Consumer<PlaythroughDurationStore>(
                                    builder: (_, store, __) {
                                      return PlaythroughItemDetail(
                                        store.durationInSeconds
                                            .toPlaythroughDuration(),
                                        'duration',
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.standardSpacing,
                          ),
                          if (store.playthrough.status ==
                              PlaythroughStatus.Started)
                            IconAndTextButton(
                              icon: Icons.stop,
                              backgroundColor: Colors.blue,
                              horizontalPadding: Dimensions.standardSpacing,
                              verticalPadding: Dimensions.standardSpacing,
                              onPressed: () => _stopPlaythrough(store),
                            ),
                          if (store.playthrough.status ==
                              PlaythroughStatus.Finished)
                            IconAndTextButton(
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
                              horizontalPadding: Dimensions.standardSpacing,
                              verticalPadding: Dimensions.standardSpacing,
                              onPressed: () =>
                                  _deletePlaythrough(context, store),
                            ),
                        ],
                      ),
                      SizedBox(
                        width: Dimensions.standardSpacing,
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: store.playerScores?.length ?? 0,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: Dimensions.standardSpacing,
                            );
                          },
                          itemBuilder: (context, index) {
                            return PlayerScore(
                              store.playerScores[index],
                              readonly: false,
                            );
                          },
                        ),
                      ),
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
    );
  }

  PlaythroughStore _createAndLoadPlatythroughStore(BuildContext context) {
    final playerService = Provider.of<PlayerService>(
      context,
      listen: false,
    );
    final scoreService = Provider.of<ScoreService>(
      context,
      listen: false,
    );
    final playthroughsStore = Provider.of<PlaythroughsStore>(
      context,
      listen: false,
    );
    final playthroughStore =
        PlaythroughStore(playerService, scoreService, playthroughsStore);
    playthroughStore.loadPlaythrough(_playthrough);
    return playthroughStore;
  }

  Future<void> _stopPlaythrough(PlaythroughStore store) async {
    await store.stopPlaythrough();
  }

  Future<void> _deletePlaythrough(
      BuildContext context, PlaythroughStore playthroughStore) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this game?'),
          elevation: 2,
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Delete'),
              color: Colors.red,
              onPressed: () async {
                final playthroughsStore = Provider.of<PlaythroughsStore>(
                  context,
                  listen: false,
                );

                await playthroughsStore
                    .deletePlaythrough(playthroughStore.playthrough.id);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
