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
import '../../utilities/periodic_boardcast_stream.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/panel_container_widget.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/common/text/item_property_value_widget.dart';
import '../../widgets/playthrough/calendar_card.dart';
import '../../widgets/playthrough/player_score_rank_avatar.dart';
import '../edit_playthrough/edit_playthrough_page.dart';
import 'playthrough_view_model.dart';
import 'playthroughs_history_view_model.dart';

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

            return Observer(
              builder: (_) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.standardSpacing),
                  itemBuilder: (_, index) {
                    final playthroughViewModel = getIt<PlaythroughViewModel>();
                    playthroughViewModel.loadPlaythrough(viewModel.playthroughs[index]);

                    return _Playthrough(
                      viewModel: playthroughViewModel,
                      playthroughNumber: viewModel.playthroughs.length - index,
                      isLast: index == viewModel.playthroughs.length - 1,
                    );
                  },
                  separatorBuilder: (_, index) {
                    return const SizedBox(height: Dimensions.doubleStandardSpacing);
                  },
                  itemCount: viewModel.playthroughs.length,
                );
              },
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
    required this.viewModel,
    required this.isLast,
    this.playthroughNumber,
    Key? key,
  }) : super(key: key);

  final PlaythroughViewModel viewModel;
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
            child: Observer(
              builder: (_) {
                switch (widget.viewModel.futureLoadPlaythrough?.status ?? FutureStatus.pending) {
                  case FutureStatus.pending:
                    return const LoadingIndicator();

                  case FutureStatus.rejected:
                    return const Center(child: GenericErrorMessage());

                  case FutureStatus.fulfilled:
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _PlaythroughGameStats(
                          playthroughViewModel: widget.viewModel,
                          playthroughNumber: widget.playthroughNumber,
                        ),
                        const SizedBox(width: Dimensions.doubleStandardSpacing),
                        Expanded(
                          child: _PlaythroughPlayersStats(playthroughViewModel: widget.viewModel),
                        ),
                      ],
                    );
                }
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
    required this.playthroughViewModel,
  }) : super(key: key);

  final PlaythroughViewModel playthroughViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(child: _PlaythroughPlayerList(playthroughViewModel: playthroughViewModel)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedIconButton(
              title: AppText.edit,
              icon: const DefaultIcon(Icons.edit),
              color: AppColors.accentColor,
              onPressed: () => Navigator.pushNamed(
                context,
                EditPlaythoughPage.pageRoute,
                arguments: EditPlaythroughPageArguments(playthroughViewModel),
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
    required PlaythroughViewModel playthroughViewModel,
  })  : _playthroughStore = playthroughViewModel,
        super(key: key);

  final PlaythroughViewModel _playthroughStore;

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
    required this.playthroughViewModel,
    required this.playthroughNumber,
  }) : super(key: key);

  final PlaythroughViewModel playthroughViewModel;
  final int? playthroughNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CalendarCard(playthroughViewModel.playthrough.startDate),
        _PlaythroughItemDetail(
          playthroughViewModel.daysSinceStart?.toString(),
          'day(s) ago',
        ),
        _PlaythroughItemDetail(
          '$playthroughNumber${playthroughNumber.toOrdinalAbbreviations()}',
          'game',
        ),
        _PlaythroughDuration(viewModel: playthroughViewModel),
      ],
    );
  }
}

class _PlaythroughDuration extends StatefulWidget {
  const _PlaythroughDuration({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final PlaythroughViewModel viewModel;

  @override
  _PlaythroughDurationState createState() => _PlaythroughDurationState();
}

class _PlaythroughDurationState extends State<_PlaythroughDuration> {
  final PeriodicBroadcastStream periodicBroadcastStream =
      PeriodicBroadcastStream(const Duration(seconds: 1));

  @override
  void initState() {
    super.initState();

    if (!widget.viewModel.playthoughEnded) {
      periodicBroadcastStream.stream.listen(_updateDuration);
    }
  }

  @override
  void dispose() {
    if (!widget.viewModel.playthoughEnded) {
      periodicBroadcastStream.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PlaythroughItemDetail(
      widget.viewModel.duration.inSeconds.toPlaytimeDuration(),
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
