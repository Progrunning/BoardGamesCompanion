import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/page_container.dart';
import '../board_game_details/board_game_details_page.dart';
import 'hot_board_games_view_model.dart';

class HotBoardGamesPage extends StatefulWidget {
  const HotBoardGamesPage({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final HotBoardGamesViewModel viewModel;

  @override
  HotBoardGamesPageState createState() => HotBoardGamesPageState();
}

class HotBoardGamesPageState extends State<HotBoardGamesPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadHotBoardGames();
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: CustomScrollView(
        slivers: <Widget>[
          _AppBar(viewModel: widget.viewModel),
          _HotBoardGames(
            viewModel: widget.viewModel,
            onBoardGameTapped: (BoardGameDetails boardGame) =>
                _navigateToBoardGameDetails(boardGame),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToBoardGameDetails(BoardGameDetails boardGame) async {
    await Navigator.pushNamed(
      context,
      BoardGamesDetailsPage.pageRoute,
      arguments: BoardGameDetailsPageArguments(
        boardGameId: boardGame.id,
        boardGameImageHeroId: boardGame.id,
        boardGameName: boardGame.name,
        navigatingFromType: HotBoardGamesPage,
        boardGameImageUrl: widget.viewModel.getHotBoardGameDetails(boardGame.id)?.imageUrl,
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final HotBoardGamesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      titleSpacing: 0,
      forceElevated: true,
      elevation: Dimensions.defaultElevation,
      foregroundColor: AppColors.accentColor,
      title: Text(AppText.hotBoardGamesPageTitle, style: AppTheme.titleTextStyle),
    );
  }
}

class _HotBoardGames extends StatelessWidget {
  const _HotBoardGames({
    required this.viewModel,
    required this.onBoardGameTapped,
    Key? key,
  }) : super(key: key);

  final HotBoardGamesViewModel viewModel;
  final void Function(BoardGameDetails) onBoardGameTapped;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        switch (viewModel.futureLoadHotBoardGames?.status ?? FutureStatus.pending) {
          case FutureStatus.pending:
            return const SliverFillRemaining(child: LoadingIndicator());
          case FutureStatus.rejected:
            return const SliverFillRemaining(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.doubleStandardSpacing),
                child: Center(child: GenericErrorMessage()),
              ),
            );
          case FutureStatus.fulfilled:
            if (viewModel.hasAnyHotBoardGames) {
              return SliverPadding(
                padding: const EdgeInsets.only(
                  left: Dimensions.standardSpacing,
                  top: Dimensions.standardSpacing,
                  right: Dimensions.standardSpacing,
                  bottom: Dimensions.standardSpacing + Dimensions.bottomTabTopHeight,
                ),
                sliver: SliverGrid.extent(
                  crossAxisSpacing: Dimensions.standardSpacing,
                  mainAxisSpacing: Dimensions.standardSpacing,
                  maxCrossAxisExtent: Dimensions.boardGameItemCollectionImageWidth,
                  children: [
                    for (final hotBoardGame in viewModel.hotBoardGames!)
                      BoardGameTile(
                        id: hotBoardGame.id,
                        name: hotBoardGame.name,
                        imageUrl: hotBoardGame.thumbnailUrl ?? '',
                        rank: hotBoardGame.rank,
                        elevation: AppStyles.defaultElevation,
                        onTap: () async => _navigateToBoardGameDetails(hotBoardGame, context),
                      ),
                  ],
                ),
              );
            }

            return SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      AppText.searchBoardGamesPageHotBoardGamesErrorPartOne,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: Dimensions.standardSpacing),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedIconButton(
                        icon: const DefaultIcon(Icons.refresh),
                        title: AppText.searchBoardGamesPageHotBoardGamesErrorRetryButtonText,
                        onPressed: () => viewModel.refresh(),
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }

  void _navigateToBoardGameDetails(BoardGameDetails boardGame, BuildContext context) {
    viewModel.trackViewHotBoardGame(boardGame);

    onBoardGameTapped(boardGame);
  }
}
