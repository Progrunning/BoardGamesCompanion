import 'dart:math' as math;

import 'package:board_games_companion/common/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/enums/enums.dart';
import '../../extensions/int_extensions.dart';
import '../../extensions/player_score_extensions.dart';
import '../../injectable.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/playthrough.dart';
import '../../services/player_service.dart';
import '../../services/score_service.dart';
import '../../stores/playthrough_duration_store.dart';
import '../../stores/playthrough_store.dart';
import '../../stores/playthroughs_store.dart';
import '../../utilities/navigator_helper.dart';
import '../../widgets/common/cunsumer_future_builder_widget.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/panel_container_widget.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/common/text/item_property_value_widget.dart';
import '../../widgets/common/tile_positioned_rank_ribbon.dart';
import '../../widgets/player/player_avatar.dart';
import '../../widgets/playthrough/calendar_card.dart';

class PlaythroughsHistoryPage extends StatefulWidget {
  const PlaythroughsHistoryPage(
    this.boardGameDetails,
    this.playthroughsStore, {
    Key key,
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
                store.playthroughs.sort((a, b) => b.startDate?.compareTo(a.startDate));
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.standardSpacing),
                  itemBuilder: (_, index) {
                    return _Playthrough(
                      widget.playthroughsStore,
                      store.playthroughs[index],
                      store.playthroughs.length - index,
                      key: ValueKey(store.playthroughs[index].id),
                    );
                  },
                  separatorBuilder: (_, index) {
                    return const SizedBox(
                      height: Dimensions.doubleStandardSpacing,
                    );
                  },
                  itemCount: store.playthroughs.length,
                );
              }

              return const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.doubleStandardSpacing,
                ),
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
  const _Playthrough(
    this._playthroughsStore,
    this._playthrough,
    this._playthroughNumber, {
    Key key,
  }) : super(key: key);

  final PlaythroughsStore _playthroughsStore;
  final Playthrough _playthrough;
  final int _playthroughNumber;

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

                    debugPrint(store.playthrough.endDate?.toIso8601String() ?? '');

                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _PlaythroughGameStats(
                          playthroughsStore: _playthroughsStore,
                          playthroughStore: store,
                          playthroughNumber: _playthroughNumber,
                          playthrough: store.playthrough,
                        ),
                        const SizedBox(
                          width: Dimensions.doubleStandardSpacing,
                        ),
                        Expanded(
                          child: _PlaythroughPlayersStats(
                            playthroughsStore: _playthroughsStore,
                            playthroughStore: store,
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
      ),
    );
  }

  PlaythroughStore _createAndLoadPlatythroughStore(BuildContext context) {
    // TODO MK Fix dependencies to be injectable (if possible)
    final playerService = getIt<PlayerService>();
    final scoreService = getIt<ScoreService>();
    final playthroughsStore = getIt<PlaythroughsStore>();
    final playthroughStore = PlaythroughStore(playerService, scoreService, playthroughsStore);
    playthroughStore.loadPlaythrough(_playthrough);
    return playthroughStore;
  }
}

class _PlaythroughPlayersStats extends StatelessWidget {
  const _PlaythroughPlayersStats({
    Key key,
    @required this.playthroughsStore,
    @required this.playthroughStore,
  }) : super(key: key);

  final PlaythroughsStore playthroughsStore;
  final PlaythroughStore playthroughStore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: _PlaythroughPlayerList(
            playthroughStore: playthroughStore,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconAndTextButton(
              title: Strings.Edit,
              icon: const DefaultIcon(Icons.edit),
              color: AppTheme.accentColor,
              onPressed: () async =>
                  NavigatorHelper.navigateToEditPlaythrough(context, playthroughStore),
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
    Key key,
    @required PlaythroughStore playthroughStore,
  })  : _playthroughStore = playthroughStore,
        super(key: key);

  final PlaythroughStore _playthroughStore;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _playthroughStore.playerScores?.length ?? 0,
      separatorBuilder: (context, index) {
        return const SizedBox(
          width: Dimensions.doubleStandardSpacing,
        );
      },
      itemBuilder: (context, index) {
        return Column(
          children: [
            SizedBox(
              height: Dimensions.smallPlayerAvatarSize,
              width: Dimensions.smallPlayerAvatarSize,
              child: Stack(
                children: [
                  PlayerAvatar(
                    _playthroughStore.playerScores[index].player,
                    playerHeroIdSuffix: _playthroughStore.playthrough.id,
                  ),
                  if (_playthroughStore.playerScores[index].place != null)
                    PositionedTileRankRibbon(
                      rank: _playthroughStore.playerScores[index].place,
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: Dimensions.standardSpacing,
            ),
            Text(
              _playthroughStore.playerScores[index]?.score?.value ?? '-',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.doubleExtraLargeFontSize,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlaythroughGameStats extends StatelessWidget {
  const _PlaythroughGameStats({
    Key key,
    @required this.playthroughsStore,
    @required this.playthroughStore,
    @required this.playthroughNumber,
    @required this.playthrough,
  }) : super(key: key);

  final PlaythroughsStore playthroughsStore;
  final PlaythroughStore playthroughStore;
  final int playthroughNumber;
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
        ChangeNotifierProvider(
          create: (_) => PlaythroughDurationStore(playthrough),
          child: Consumer2<PlaythroughDurationStore, PlaythroughStore>(
            builder: (_, durationStore, __, ___) {
              // TODO MK The duration store most likely needs to be refactored as it's not being update currently after the duration being changed
              return _PlaythroughItemDetail(
                durationStore.durationInSeconds.toPlaythroughDuration(),
                'duration',
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PlaythroughItemDetail extends StatelessWidget {
  const _PlaythroughItemDetail(
    this.title,
    this.subtitle, {
    Key key,
  }) : super(key: key);

  final String subtitle;
  final String title;

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
