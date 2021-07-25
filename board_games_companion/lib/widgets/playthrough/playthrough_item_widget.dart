import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/dimensions.dart';
import '../../common/enums/enums.dart';
import '../../common/enums/playthrough_status.dart';
import '../../extensions/int_extensions.dart';
import '../../extensions/player_score_extensions.dart';
import '../../models/hive/playthrough.dart';
import '../../services/player_service.dart';
import '../../services/score_service.dart';
import '../../stores/playthrough_duration_store.dart';
import '../../stores/playthrough_store.dart';
import '../../stores/playthroughs_store.dart';
import '../common/generic_error_message_widget.dart';
import '../common/icon_and_text_button.dart';
import '../common/loading_indicator_widget.dart';
import '../common/panel_container_widget.dart';
import '../player/scores/player_score_widget.dart';
import 'calendar_card.dart';
import 'playthrough_item_detail_widget.dart';

class PlaythroughItem extends StatelessWidget {
  const PlaythroughItem(
    this._playthrough,
    this._playthroughNumber, {
    Key key,
  }) : super(key: key);

  final Playthrough _playthrough;
  final int _playthroughNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.standardSpacing,
      ),
      child: PanelContainer(
        child: Padding(
          padding: const EdgeInsets.all(
            Dimensions.standardSpacing,
          ),
          child: ChangeNotifierProvider<PlaythroughStore>(
            create: (context) => _createAndLoadPlatythroughStore(context),
            child: Consumer<PlaythroughStore>(
              builder: (_, store, __) {
                if (store.loadDataState == LoadDataState.Loaded) {
                  store.playerScores.sortByScore();
                  store.playerScores
                      .where((ps) => ps?.score?.value?.isNotEmpty ?? false)
                      .toList()
                      .asMap()
                      .forEach((index, ps) => ps.updatePlayerPlace(index + 1));

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          CalendarCard(store.playthrough.startDate),
                          const SizedBox(
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
                                const SizedBox(
                                  height: Dimensions.standardSpacing,
                                ),
                                PlaythroughItemDetail(
                                  '$_playthroughNumber${_playthroughNumber.toOrdinalAbbreviations()}',
                                  'game',
                                ),
                                const SizedBox(
                                  height: Dimensions.standardSpacing,
                                ),
                                ChangeNotifierProvider(
                                  create: (_) => PlaythroughDurationStore(_playthrough),
                                  child: Consumer<PlaythroughDurationStore>(
                                    builder: (_, store, __) {
                                      return PlaythroughItemDetail(
                                        store.durationInSeconds.toPlaythroughDuration(),
                                        'duration',
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: Dimensions.doubleStandardSpacing,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: store.playerScores?.length ?? 0,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    width: Dimensions.doubleStandardSpacing,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return PlayerScore(
                                    store.playerScores[index],
                                    readonly: false,
                                    playthroughStore: store,
                                  );
                                },
                              ),
                            ),
                            if (store.playthrough.status == PlaythroughStatus.Started)
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconAndTextButton(
                                  icon: Icons.stop,
                                  backgroundColor: Colors.blue,
                                  horizontalPadding: Dimensions.standardSpacing,
                                  verticalPadding: Dimensions.standardSpacing,
                                  onPressed: () => _stopPlaythrough(store),
                                ),
                              ),
                            if (store.playthrough.status == PlaythroughStatus.Finished)
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconAndTextButton(
                                  icon: Icons.delete,
                                  backgroundColor: Colors.red,
                                  horizontalPadding: Dimensions.standardSpacing,
                                  verticalPadding: Dimensions.standardSpacing,
                                  onPressed: () => _deletePlaythrough(context, store),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (store.loadDataState == LoadDataState.Error) {
                  return const Center(
                    child: GenericErrorMessage(),
                  );
                }

                return const Center(
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
    final playthroughStore = PlaythroughStore(playerService, scoreService, playthroughsStore);
    playthroughStore.loadPlaythrough(_playthrough);
    return playthroughStore;
  }

  Future<void> _stopPlaythrough(PlaythroughStore store) async {
    await store.stopPlaythrough();
  }

  Future<void> _deletePlaythrough(BuildContext context, PlaythroughStore playthroughStore) async {
    await showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete this game?'),
          elevation: Dimensions.defaultElevation,
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('Delete'),
              color: Colors.red,
              onPressed: () async {
                final playthroughsStore = Provider.of<PlaythroughsStore>(
                  context,
                  listen: false,
                );

                await playthroughsStore.deletePlaythrough(playthroughStore.playthrough.id);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
