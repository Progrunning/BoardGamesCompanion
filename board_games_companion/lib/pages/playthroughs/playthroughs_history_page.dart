import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../extensions/int_extensions.dart';
import '../../extensions/player_score_extensions.dart';
import '../../injectable.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/playthrough.dart';
import '../../models/navigation/edit_playthrough_page_arguments.dart';
import '../../stores/playthrough_store.dart';
import '../../stores/playthroughs_store.dart';
import '../../utilities/periodic_boardcast_stream.dart';
import '../../widgets/common/cunsumer_future_builder_widget.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/panel_container_widget.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/common/text/item_property_value_widget.dart';
import '../../widgets/playthrough/calendar_card.dart';
import '../../widgets/playthrough/player_score_rank_avatar.dart';
import '../edit_playthrough/edit_playthrough_page.dart';

class PlaythroughsHistoryPage extends StatefulWidget {
  const PlaythroughsHistoryPage({
    required this.boardGameDetails,
    required this.playthroughsStore,
    Key? key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;
  final PlaythroughsStore playthroughsStore;

  @override
  _PlaythroughsHistoryPageState createState() => _PlaythroughsHistoryPageState();
}

class _PlaythroughsHistoryPageState extends State<PlaythroughsHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: ConsumerFutureBuilder<List<Playthrough>, PlaythroughsStore>(
            future: widget.playthroughsStore.loadPlaythroughs(widget.boardGameDetails),
            success: (_, PlaythroughsStore store) {
              final hasPlaythroughs = store.playthroughs?.isNotEmpty ?? false;
              if (hasPlaythroughs) {
                store.playthroughs!.sort((a, b) => b.startDate.compareTo(a.startDate));
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.standardSpacing),
                  itemBuilder: (_, index) {
                    final PlaythroughStore playthroughStore = getIt<PlaythroughStore>();

                    final _Playthrough playthough = _Playthrough(
                      playthroughsStore: widget.playthroughsStore,
                      playthroughStore: playthroughStore,
                      playthrough: store.playthroughs![index],
                      playthroughNumber: store.playthroughs!.length - index,
                    );
                    
                    // Last playthough
                    if (index == store.playthroughs!.length - 1) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: Dimensions.bottomTabTopHeight),
                        child: playthough,
                      );
                    }
                    return playthough;
                  },
                  separatorBuilder: (_, index) {
                    return const SizedBox(height: Dimensions.doubleStandardSpacing);
                  },
                  itemCount: store.playthroughs!.length,
                );
              }

              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.doubleStandardSpacing),
                child: Center(
                  child: Text(
                    "It looks like you haven't played this game yet",
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Playthrough extends StatelessWidget {
  const _Playthrough({
    required this.playthroughsStore,
    required this.playthroughStore,
    required this.playthrough,
    this.playthroughNumber,
    Key? key,
  }) : super(key: key);

  final PlaythroughsStore playthroughsStore;
  final PlaythroughStore playthroughStore;
  final Playthrough playthrough;
  final int? playthroughNumber;

  static const double _maxPlaythroughItemHeight = 240;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.standardSpacing,
      ),
      child: PanelContainer(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: math.max(_maxPlaythroughItemHeight, MediaQuery.of(context).size.height / 3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              Dimensions.standardSpacing,
            ),
            child: FutureBuilder<void>(
              future: playthroughStore.loadPlaythrough(playthrough),
              builder: (_, AsyncSnapshot<void> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: GenericErrorMessage(),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  playthroughStore.playerScores.sortByScore();
                  playthroughStore.playerScores!
                      .where((ps) => ps.score.value?.isNotEmpty ?? false)
                      .toList()
                      .asMap()
                      .forEach((index, ps) => ps.updatePlayerPlace(index + 1));

                  debugPrint(playthroughStore.playthrough.endDate?.toIso8601String() ?? '');

                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _PlaythroughGameStats(
                        playthroughStore: playthroughStore,
                        playthroughNumber: playthroughNumber,
                        playthrough: playthroughStore.playthrough,
                      ),
                      const SizedBox(width: Dimensions.doubleStandardSpacing),
                      Expanded(child: _PlaythroughPlayersStats(playthroughStore: playthroughStore)),
                    ],
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
}

class _PlaythroughPlayersStats extends StatelessWidget {
  const _PlaythroughPlayersStats({
    Key? key,
    required this.playthroughStore,
  }) : super(key: key);

  final PlaythroughStore playthroughStore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(child: _PlaythroughPlayerList(playthroughStore: playthroughStore)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconAndTextButton(
              title: AppText.Edit,
              icon: const DefaultIcon(Icons.edit),
              color: AppTheme.accentColor,
              onPressed: () => Navigator.pushNamed(
                context,
                EditPlaythoughPage.pageRoute,
                arguments: EditPlaythroughPageArguments(playthroughStore),
              ),
              splashColor: AppTheme.whiteColor,
            ),
          ],
        ),
      ],
    );
  }
}

class _PlaythroughPlayerList extends StatelessWidget {
  const _PlaythroughPlayerList({
    Key? key,
    required PlaythroughStore playthroughStore,
  })  : _playthroughStore = playthroughStore,
        super(key: key);

  final PlaythroughStore _playthroughStore;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _playthroughStore.playerScores?.length ?? 0,
      separatorBuilder: (context, index) {
        return const SizedBox(width: Dimensions.doubleStandardSpacing);
      },
      itemBuilder: (context, index) {
        return PlayerScoreRankAvatar(
          player: _playthroughStore.playerScores![index].player,
          playerHeroIdSuffix: _playthroughStore.playthrough.id,
          rank: _playthroughStore.playerScores![index].place,
          score: _playthroughStore.playerScores![index].score.value,
        );
      },
    );
  }
}

class _PlaythroughGameStats extends StatelessWidget {
  const _PlaythroughGameStats({
    Key? key,
    required this.playthroughStore,
    required this.playthroughNumber,
    required this.playthrough,
  }) : super(key: key);

  final PlaythroughStore playthroughStore;
  final int? playthroughNumber;
  final Playthrough playthrough;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CalendarCard(playthroughStore.playthrough.startDate),
        _PlaythroughItemDetail(
          playthroughStore.daysSinceStart?.toString(),
          'day(s) ago',
        ),
        _PlaythroughItemDetail(
          '$playthroughNumber${playthroughNumber.toOrdinalAbbreviations()}',
          'game',
        ),
        _PlaythroughDuration(playthroughStore: playthroughStore),
      ],
    );
  }
}

class _PlaythroughDuration extends StatefulWidget {
  const _PlaythroughDuration({required this.playthroughStore});

  final PlaythroughStore playthroughStore;

  @override
  _PlaythroughDurationState createState() => _PlaythroughDurationState();
}

class _PlaythroughDurationState extends State<_PlaythroughDuration> {
  final PeriodicBroadcastStream periodicBroadcastStream =
      PeriodicBroadcastStream(const Duration(seconds: 1));

  @override
  void initState() {
    periodicBroadcastStream.stream.listen(_updateDuration);
    super.initState();
  }

  @override
  void dispose() {
    periodicBroadcastStream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PlaythroughItemDetail(
      widget.playthroughStore.duration.inSeconds.toPlaytimeDuration(),
      'duration',
    );
  }

  void _updateDuration(void _) {
    setState(() {});
  }
}

class _PlaythroughItemDetail extends StatelessWidget {
  const _PlaythroughItemDetail(
    this.title,
    this.subtitle, {
    Key? key,
  }) : super(key: key);

  final String subtitle;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ItemPropertyValue(title),
        ItemPropertyTitle(subtitle),
      ],
    );
  }
}
