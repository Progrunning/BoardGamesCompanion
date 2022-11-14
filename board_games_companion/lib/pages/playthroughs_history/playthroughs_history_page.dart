import 'dart:math';

import 'package:board_games_companion/pages/playthroughs_history/playthroughs_history_view_model.dart';
import 'package:board_games_companion/widgets/common/panel_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/loading_indicator_widget.dart';

class PlaythroughsHistoryPage extends StatefulWidget {
  const PlaythroughsHistoryPage({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final PlaythroughsHistoryViewModel viewModel;

  @override
  State<PlaythroughsHistoryPage> createState() => _PlaythroughsHistoryPageState();
}

class _PlaythroughsHistoryPageState extends State<PlaythroughsHistoryPage> {
  @override
  void initState() {
    super.initState();

    widget.viewModel.loadGamesPlaythroughs();
  }

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          switch (widget.viewModel.futureLoadGamesPlaythroughs?.status ?? FutureStatus.pending) {
            case FutureStatus.pending:
            case FutureStatus.rejected:
              return const CustomScrollView(
                slivers: [
                  _AppBar(),
                  SliverFillRemaining(child: LoadingIndicator()),
                ],
              );
            case FutureStatus.fulfilled:
              return CustomScrollView(
                slivers: [
                  const _AppBar(),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, index) {
                        final int itemIndex = index ~/ 2;
                        final boardGamePlaythrough =
                            widget.viewModel.finishedPlaythroughs.values.toList()[itemIndex];
                        if (index.isEven) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: Dimensions.standardSpacing,
                              bottom: Dimensions.standardSpacing,
                              left: Dimensions.standardSpacing,
                              right: Dimensions.standardSpacing,
                            ),
                            child: PanelContainer(
                              child: Padding(
                                padding: const EdgeInsets.all(Dimensions.standardSpacing),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: Dimensions.collectionSearchResultBoardGameImageHeight,
                                      width: Dimensions.collectionSearchResultBoardGameImageWidth,
                                      child: BoardGameTile(
                                        id: boardGamePlaythrough.boardGameDetails.id,
                                        imageUrl:
                                            boardGamePlaythrough.boardGameDetails.thumbnailUrl ??
                                                '',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return const SizedBox(height: Dimensions.doubleStandardSpacing);
                      },
                      childCount: max(0, widget.viewModel.finishedPlaythroughs.length * 2 - 1),
                    ),
                  ),
                ],
              );
          }
        },
      );
}

class _AppBar extends StatelessWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      pinned: true,
      floating: true,
      titleSpacing: Dimensions.standardSpacing,
      foregroundColor: AppColors.accentColor,
      title: Text(AppText.playHistoryPageTitle, style: AppTheme.titleTextStyle),
    );
  }
}
