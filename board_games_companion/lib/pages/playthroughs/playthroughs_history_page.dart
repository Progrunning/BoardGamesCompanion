import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/dimensions.dart';
import '../../extensions/int_extensions.dart';
import '../../injectable.dart';
import '../../models/navigation/edit_playthrough_page_arguments.dart';
import '../../models/playthroughs/playthrough_details.dart';
import '../../utilities/periodic_boardcast_stream.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/panel_container.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/common/text/item_property_value_widget.dart';
import '../../widgets/playthrough/calendar_card.dart';
import '../../widgets/playthrough/player_score_rank_avatar.dart';
import '../edit_playthrough/edit_playthrough_page.dart';
import 'playthroughs_history_view_model.dart';
import 'playthroughs_page.dart';

class PlaythroughsHistoryPage extends StatefulWidget {
  const PlaythroughsHistoryPage({Key? key}) : super(key: key);

  @override
  PlaythroughsHistoryPageState createState() => PlaythroughsHistoryPageState();
}

class PlaythroughsHistoryPageState extends State<PlaythroughsHistoryPage> {
  late PlaythroughsHistoryViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = getIt<PlaythroughsHistoryViewModel>();
    viewModel.loadPlaythroughs();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        switch (viewModel.futureloadPlaythroughs?.status ?? FutureStatus.pending) {
          case FutureStatus.pending:
            return const LoadingIndicator();
          case FutureStatus.fulfilled:
            if (!viewModel.hasAnyPlaythroughs) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.doubleStandardSpacing),
                child: Center(
                  child: Text("It looks like you haven't played this game yet"),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.standardSpacing),
              itemBuilder: (_, index) {
                return _Playthrough(
                  playthroughDetails: viewModel.playthroughs[index],
                  playthroughNumber: viewModel.playthroughs.length - index,
                  isLast: index == viewModel.playthroughs.length - 1,
                );
              },
              separatorBuilder: (_, index) {
                return const SizedBox(height: Dimensions.doubleStandardSpacing);
              },
              itemCount: viewModel.playthroughs.length,
            );

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class _Playthrough extends StatefulWidget {
  const _Playthrough({
    required this.playthroughDetails,
    required this.isLast,
    this.playthroughNumber,
    Key? key,
  }) : super(key: key);

  final PlaythroughDetails playthroughDetails;
  final int? playthroughNumber;
  final bool isLast;

  static const double _maxPlaythroughItemHeight = 240;

  @override
  State<_Playthrough> createState() => _PlaythroughState();
}

class _PlaythroughState extends State<_Playthrough> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.standardSpacing,
        right: Dimensions.standardSpacing,
        bottom: widget.isLast ? Dimensions.bottomTabTopHeight : 0,
      ),
      child: PanelContainer(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: math.max(
                _Playthrough._maxPlaythroughItemHeight, MediaQuery.of(context).size.height / 3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.standardSpacing),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _PlaythroughGameStats(
                  playthroughDetails: widget.playthroughDetails,
                  playthroughNumber: widget.playthroughNumber,
                ),
                const SizedBox(width: Dimensions.doubleStandardSpacing),
                Expanded(
                  child: _PlaythroughPlayersStats(playthroughDetails: widget.playthroughDetails),
                ),
              ],
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
    required this.playthroughDetails,
  }) : super(key: key);

  final PlaythroughDetails playthroughDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(child: _PlaythroughPlayerList(playthroughDetails: playthroughDetails)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (playthroughDetails.hasNotes)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.sticky_note_2_outlined, color: AppColors.accentColor),
                    const SizedBox(width: Dimensions.standardSpacing),
                    Expanded(
                      child: Text(
                        playthroughDetails.latestNote!.text,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    const SizedBox(width: Dimensions.standardSpacing),
                  ],
                ),
              ),
            if (!playthroughDetails.hasNotes) const Spacer(),
            ElevatedIconButton(
              title: AppText.edit,
              icon: const DefaultIcon(Icons.edit),
              color: AppColors.accentColor,
              onPressed: () => Navigator.pushNamed(
                context,
                EditPlaythroughPage.pageRoute,
                arguments: EditPlaythroughPageArguments(
                  boardGameId: playthroughDetails.boardGameId,
                  playthroughId: playthroughDetails.id,
                  goBackPageRoute: PlaythroughsPage.pageRoute,
                ),
              ),
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
    required PlaythroughDetails playthroughDetails,
  })  : _playthroughDetails = playthroughDetails,
        super(key: key);

  final PlaythroughDetails _playthroughDetails;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _playthroughDetails.playerScores.length,
      separatorBuilder: (context, index) {
        return const SizedBox(width: Dimensions.doubleStandardSpacing);
      },
      itemBuilder: (context, index) {
        return PlayerScoreRankAvatar(
          player: _playthroughDetails.playerScores[index].player,
          playerHeroIdSuffix: _playthroughDetails.id,
          rank: _playthroughDetails.playerScores[index].place,
          score: _playthroughDetails.playerScores[index].score.value,
        );
      },
    );
  }
}

class _PlaythroughGameStats extends StatelessWidget {
  const _PlaythroughGameStats({
    Key? key,
    required this.playthroughDetails,
    required this.playthroughNumber,
  }) : super(key: key);

  final PlaythroughDetails playthroughDetails;
  final int? playthroughNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CalendarCard(playthroughDetails.startDate),
        _PlaythroughItemDetail(
          playthroughDetails.daysSinceStart?.toString(),
          'day(s) ago',
        ),
        _PlaythroughItemDetail(
          '$playthroughNumber${playthroughNumber.toOrdinalAbbreviations()}',
          'game',
        ),
        _PlaythroughDuration(playthroughDetails: playthroughDetails),
      ],
    );
  }
}

class _PlaythroughDuration extends StatefulWidget {
  const _PlaythroughDuration({
    required this.playthroughDetails,
    Key? key,
  }) : super(key: key);

  final PlaythroughDetails playthroughDetails;

  @override
  _PlaythroughDurationState createState() => _PlaythroughDurationState();
}

class _PlaythroughDurationState extends State<_PlaythroughDuration> {
  final PeriodicBroadcastStream periodicBroadcastStream =
      PeriodicBroadcastStream(const Duration(seconds: 1));

  @override
  void initState() {
    super.initState();

    if (!widget.playthroughDetails.playthoughEnded) {
      periodicBroadcastStream.stream.listen(_updateDuration);
    }
  }

  @override
  void dispose() {
    if (!widget.playthroughDetails.playthoughEnded) {
      periodicBroadcastStream.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PlaythroughItemDetail(
      widget.playthroughDetails.duration.inSeconds.toPlaytimeDuration(),
      'duration',
    );
  }

  void _updateDuration(void _) {
    if (mounted) {
      setState(() {});
    }
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
