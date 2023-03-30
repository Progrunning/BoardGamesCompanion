import 'dart:async';
import 'dart:io';

import 'package:basics/basics.dart';
import 'package:board_games_companion/common/enums/collection_type.dart';
import 'package:board_games_companion/common/enums/plays_tab.dart';
import 'package:board_games_companion/extensions/int_extensions.dart';
import 'package:board_games_companion/extensions/string_extensions.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/pages/edit_playthrough/edit_playthrough_page.dart';
import 'package:board_games_companion/pages/plays/game_spinner_filters.dart';
import 'package:board_games_companion/pages/plays/game_spinner_game_selected_dialog.dart';
import 'package:board_games_companion/pages/plays/plays_page_visual_states.dart';
import 'package:board_games_companion/pages/playthroughs/playthroughs_page.dart';
import 'package:board_games_companion/widgets/common/collection_toggle_button.dart';
import 'package:board_games_companion/widgets/common/segmented_buttons/bgc_segmented_buttons_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../common/animation_tags.dart';
import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
import '../../models/navigation/edit_playthrough_page_arguments.dart';
import '../../models/navigation/playthroughs_page_arguments.dart';
import '../../widgets/animations/image_fade_in_animation.dart';
import '../../widgets/board_games/board_game_name.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/app_bar/app_bar_bottom_tab.dart';
import '../../widgets/common/bgc_checkbox.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/panel_container.dart';
import '../../widgets/common/segmented_buttons/bgc_segmented_button.dart';
import '../../widgets/common/slivers/bgc_sliver_title_header_delegate.dart';
import '../board_game_details/board_game_details_page.dart';
import '../home/home_page.dart';
import 'board_game_playthrough.dart';
import 'grouped_board_game_playthroughs.dart';
import 'plays_view_model.dart';

class PlaysPage extends StatefulWidget {
  const PlaysPage({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final PlaysViewModel viewModel;

  @override
  State<PlaysPage> createState() => _PlaysPageState();
}

class _PlaysPageState extends State<PlaysPage> with SingleTickerProviderStateMixin {
  static const int _spinAnimationTimeInMilliseconds = 2000;

  late TabController _tabController;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    _tabController
        .addListener(() => widget.viewModel.setSelectTab(_tabController.index.toPlaysTab()));

    _scrollController = FixedExtentScrollController();

    widget.viewModel.loadGamesPlaythroughs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Observer(
        builder: (_) {
          switch (widget.viewModel.futureLoadGamesPlaythroughs?.status ?? FutureStatus.pending) {
            case FutureStatus.pending:
            case FutureStatus.rejected:
              return CustomScrollView(
                slivers: [
                  Observer(
                    builder: (_) {
                      return _AppBar(
                        tabVisualState: widget.viewModel.visualState,
                        tabController: _tabController,
                        onTabSelected: (tabIndex) => widget.viewModel.trackTabChange(tabIndex),
                      );
                    },
                  ),
                  const SliverFillRemaining(child: LoadingIndicator()),
                ],
              );
            case FutureStatus.fulfilled:
              return CustomScrollView(
                slivers: [
                  Observer(
                    builder: (_) {
                      return _AppBar(
                        tabVisualState: widget.viewModel.visualState,
                        tabController: _tabController,
                        onTabSelected: (tabIndex) => widget.viewModel.trackTabChange(tabIndex),
                      );
                    },
                  ),
                  Observer(
                    builder: (_) {
                      return widget.viewModel.visualState?.when(
                            history: (tab, finishedPlaythroughs) {
                              if (!widget.viewModel.hasAnyFinishedPlaythroughs) {
                                return const _NoPlaythroughsSliver();
                              } else {
                                return MultiSliver(
                                  children: [
                                    if (widget.viewModel.hasAnyFinishedPlaythroughs) ...[
                                      for (final groupedBoardGamePlaythroughs
                                          in widget.viewModel.finishedBoardGamePlaythroughs) ...[
                                        _PlaythroughGroupHeaderSliver(
                                          widget: widget,
                                          groupedBoardGamePlaythroughs:
                                              groupedBoardGamePlaythroughs,
                                        ),
                                        _PlaythroughGroupListSliver(
                                          groupedBoardGamePlaythroughs:
                                              groupedBoardGamePlaythroughs,
                                        ),
                                        if (groupedBoardGamePlaythroughs ==
                                            widget.viewModel.finishedBoardGamePlaythroughs.last)
                                          const SliverToBoxAdapter(
                                            child: SizedBox(height: Dimensions.bottomTabTopHeight),
                                          ),
                                      ]
                                    ]
                                  ],
                                );
                              }
                            },
                            statistics: (tab) => const SliverToBoxAdapter(),
                            selectGame: (tab, shuffledBoardGames) {
                              if (!widget.viewModel.hasAnyBoardGames) {
                                return const _NoBoardGamesSliver();
                              }

                              return MultiSliver(
                                children: [
                                  if (!widget.viewModel.hasAnyBoardGamesToShuffle)
                                    const _NoBoardGamesToShuffleSliver(),
                                  if (widget.viewModel.hasAnyBoardGamesToShuffle)
                                    _GameSpinnerSliver(
                                      scrollController: _scrollController,
                                      shuffledBoardGames: shuffledBoardGames,
                                      onSpin: () => _spin(),
                                      onGameSelected: () => _selectGame(),
                                    ),
                                  SliverPersistentHeader(
                                    delegate: BgcSliverTitleHeaderDelegate.title(
                                      primaryTitle: AppText.playsPageGameSpinnerFilterSectionTitle,
                                    ),
                                  ),
                                  Observer(
                                    builder: (_) {
                                      return _GameSpinnerFilters(
                                        gameSpinnerFilters: widget.viewModel.gameSpinnerFilters,
                                        minNumberOfPlayers: widget.viewModel.minNumberOfPlayers,
                                        maxNumberOfPlayers: widget.viewModel.maxNumberOfPlayers,
                                        onCollectionToggled: (collectionTyp) => widget.viewModel
                                            .toggleGameSpinnerCollectionFilter(collectionTyp),
                                        onIncludeExpansionsToggled: (isChecked) => widget.viewModel
                                            .toggleIncludeExpansionsFilter(isChecked),
                                        onNumberOfPlayersChanged: (numberOfPlayers) => widget
                                            .viewModel
                                            .updateNumberOfPlayersNumberFilter(numberOfPlayers),
                                        onPlaytimeChanged: (playtime) =>
                                            widget.viewModel.updatePlaytimeFilter(playtime),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ) ??
                          const SliverToBoxAdapter();
                    },
                  ),
                ],
              );
          }
        },
      );

  Future<void> _spin() async {
    await _scrollController.animateToItem(
      widget.viewModel.randomItemIndex,
      duration: const Duration(milliseconds: _spinAnimationTimeInMilliseconds),
      curve: Curves.elasticInOut,
    );
  }

  Future<void> _selectGame() async {
    unawaited(widget.viewModel.trackGameSelected());
    final selectedBoardGame = widget.viewModel.shuffledBoardGames[
        _scrollController.selectedItem % widget.viewModel.shuffledBoardGames.length];
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (_, __, ___) {
        return GameSpinnerGameSelectedDialog(selectedBoardGame: selectedBoardGame);
      },
    );
  }
}

class _GameSpinnerFilters extends StatelessWidget {
  const _GameSpinnerFilters({
    required this.gameSpinnerFilters,
    required this.minNumberOfPlayers,
    required this.maxNumberOfPlayers,
    required this.onCollectionToggled,
    required this.onIncludeExpansionsToggled,
    required this.onNumberOfPlayersChanged,
    required this.onPlaytimeChanged,
    Key? key,
  }) : super(key: key);

  final GameSpinnerFilters gameSpinnerFilters;
  final int minNumberOfPlayers;
  final int maxNumberOfPlayers;
  final void Function(CollectionType collectionTyp) onCollectionToggled;
  final void Function(bool? isChecked) onIncludeExpansionsToggled;
  final void Function(NumberOfPlayersFilter numberOfPlayersFilter) onNumberOfPlayersChanged;
  final void Function(PlaytimeFilter playtimeFilter) onPlaytimeChanged;

  static const Map<int, CollectionType> collectionsMap = <int, CollectionType>{
    0: CollectionType.owned,
    1: CollectionType.friends,
  };

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(Dimensions.standardSpacing),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  AppText.playsPageGameSpinnerCollectionsFilter,
                  style: AppTheme.theme.textTheme.bodyMedium,
                ),
                const Spacer(),
                ToggleButtons(
                  isSelected: [
                    gameSpinnerFilters.hasOwnedCollection,
                    gameSpinnerFilters.hasFriendsCollection,
                  ],
                  onPressed: (int index) => onCollectionToggled(collectionsMap[index]!),
                  children: [
                    CollectionToggleButton(
                      icon: Icons.grid_on,
                      title: AppText.ownedCollectionToggleButtonText,
                      isSelected: gameSpinnerFilters.hasOwnedCollection,
                    ),
                    CollectionToggleButton(
                      icon: Icons.group,
                      title: AppText.friendsCollectionToggleButtonText,
                      isSelected: gameSpinnerFilters.hasFriendsCollection,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: Dimensions.standardSpacing),
            Row(
              children: [
                Text(
                  AppText.playsPageGameSpinnerExpansionsFilter,
                  style: AppTheme.theme.textTheme.bodyMedium,
                ),
                const Spacer(),
                BgcCheckbox(
                  isChecked: gameSpinnerFilters.includeExpansions,
                  onChanged: (isChecked) => onIncludeExpansionsToggled(isChecked),
                  borderColor: AppColors.accentColor,
                ),
              ],
            ),
            const SizedBox(height: Dimensions.standardSpacing),
            _PlayersFilter(
              numberOfPlayersFilter: gameSpinnerFilters.numberOfPlayersFilter,
              minNumberOfPlayers: minNumberOfPlayers,
              maxNumberOfPlayers: maxNumberOfPlayers,
              onChanged: (numberOfPlayers) => onNumberOfPlayersChanged(numberOfPlayers),
            ),
            const SizedBox(height: Dimensions.standardSpacing),
            _PlaytimeFilter(
              playtimeFilter: gameSpinnerFilters.playtimeFilter,
              onChanged: (playtime) => onPlaytimeChanged(playtime),
            ),
            const SizedBox(height: Dimensions.bottomTabTopHeight + Dimensions.standardSpacing),
          ],
        ),
      );
}

class _PlayersFilter extends StatelessWidget {
  _PlayersFilter({
    Key? key,
    required this.numberOfPlayersFilter,
    required this.minNumberOfPlayers,
    required this.maxNumberOfPlayers,
    required this.onChanged,
  }) : super(key: key);

  final NumberOfPlayersFilter numberOfPlayersFilter;
  final int minNumberOfPlayers;
  final int maxNumberOfPlayers;
  final void Function(NumberOfPlayersFilter numberOfPlayersFilter) onChanged;

  late double sliderMinValue;
  late double sliderMaxValue;
  late double sliderAnyNumberValue;
  late double? sliderSinglePlayerOnlyValue;
  late double sliderValue;
  late int sliderDivisions;
  late bool hasSoloGames;

  @override
  Widget build(BuildContext context) {
    hasSoloGames = minNumberOfPlayers == 1;
    sliderMinValue = hasSoloGames ? minNumberOfPlayers - 2 : minNumberOfPlayers - 1;
    if (hasSoloGames) {
      sliderSinglePlayerOnlyValue = sliderMinValue + 1;
    }
    sliderAnyNumberValue = sliderMinValue;
    sliderMaxValue = maxNumberOfPlayers.toDouble();
    sliderDivisions = (sliderMaxValue - sliderMinValue).toInt();

    return Row(
      children: [
        Text(
          AppText.playsPageGameSpinnerNumberOfPlayersFilter,
          style: AppTheme.theme.textTheme.bodyMedium,
        ),
        const SizedBox(width: Dimensions.standardSpacing),
        Expanded(
          child: Slider(
            value: _getSliderValue(),
            min: sliderMinValue,
            divisions: sliderDivisions,
            max: sliderMaxValue,
            label: _formatSliderLabelText(),
            onChanged: (value) => _handleOnChanged(value.round()),
            activeColor: AppColors.accentColor,
          ),
        ),
      ],
    );
  }

  String _formatSliderLabelText() {
    return numberOfPlayersFilter.when(
      any: () => AppText.gameFiltersAnyNumberOfPlayers,
      singlePlayerOnly: () => AppText.gameFiltersSinglePlayerOnly,
      moreThan: (numberOfPlayers) => '$numberOfPlayers+',
    );
  }

  double _getSliderValue() {
    return numberOfPlayersFilter.when(
      any: () => sliderAnyNumberValue,
      singlePlayerOnly: () => sliderSinglePlayerOnlyValue ?? 0,
      moreThan: (numberOfPlayers) => numberOfPlayers.toDouble(),
    );
  }

  void _handleOnChanged(int value) {
    late NumberOfPlayersFilter numberOfPlayersFilter;
    if (value == sliderAnyNumberValue) {
      numberOfPlayersFilter = const NumberOfPlayersFilter.any();
    } else if (hasSoloGames && value == sliderSinglePlayerOnlyValue) {
      numberOfPlayersFilter = const NumberOfPlayersFilter.singlePlayerOnly();
    } else {
      numberOfPlayersFilter = NumberOfPlayersFilter.moreThan(moreThanNumberOfPlayers: value);
    }

    onChanged(numberOfPlayersFilter);
  }
}

class _PlaytimeFilter extends StatelessWidget {
  const _PlaytimeFilter({
    required this.playtimeFilter,
    required this.onChanged,
  });

  final PlaytimeFilter playtimeFilter;
  final void Function(PlaytimeFilter) onChanged;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppText.playsPageGameSpinnerPlaytimeFilter,
            style: AppTheme.theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: Dimensions.doubleStandardSpacing),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: Dimensions.standardSpacing),
              child: BgcSegmentedButtonsContainer(
                height: Dimensions.collectionFilterHexagonSize + Dimensions.doubleStandardSpacing,
                child: Row(
                  children: [
                    _FilterPlaytime.time(
                      isSelected: playtimeFilter == const PlaytimeFilter.any(),
                      onSelected: (playtimeFilter) => onChanged(playtimeFilter),
                      playtimeFilter: const PlaytimeFilter.any(),
                    ),
                    _FilterPlaytime.time(
                      isSelected:
                          playtimeFilter == const PlaytimeFilter.lessThan(playtimeInMinutes: 90),
                      onSelected: (playtimeFilter) => onChanged(playtimeFilter),
                      playtimeFilter: const PlaytimeFilter.lessThan(playtimeInMinutes: 90),
                    ),
                    _FilterPlaytime.time(
                      isSelected:
                          playtimeFilter == const PlaytimeFilter.lessThan(playtimeInMinutes: 60),
                      onSelected: (playtimeFilter) => onChanged(playtimeFilter),
                      playtimeFilter: const PlaytimeFilter.lessThan(playtimeInMinutes: 60),
                    ),
                    _FilterPlaytime.time(
                      isSelected:
                          playtimeFilter == const PlaytimeFilter.lessThan(playtimeInMinutes: 45),
                      onSelected: (playtimeFilter) => onChanged(playtimeFilter),
                      playtimeFilter: const PlaytimeFilter.lessThan(playtimeInMinutes: 45),
                    ),
                    _FilterPlaytime.time(
                      isSelected:
                          playtimeFilter == const PlaytimeFilter.lessThan(playtimeInMinutes: 30),
                      onSelected: (playtimeFilter) => onChanged(playtimeFilter),
                      playtimeFilter: const PlaytimeFilter.lessThan(playtimeInMinutes: 30),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

class _GameSpinnerSliver extends StatefulWidget {
  const _GameSpinnerSliver({
    Key? key,
    required this.scrollController,
    required this.shuffledBoardGames,
    required this.onSpin,
    required this.onGameSelected,
  }) : super(key: key);

  static const double _gameSpinnerItemHeight = 80;
  static const double _gameSpinnerItemSqueeze = 1.2;

  final ScrollController scrollController;
  final List<BoardGameDetails> shuffledBoardGames;
  final VoidCallback onSpin;
  final VoidCallback onGameSelected;

  @override
  State<_GameSpinnerSliver> createState() => _GameSpinnerSliverState();
}

class _GameSpinnerSliverState extends State<_GameSpinnerSliver> {
  static const int _debounceSpinnerThresholdInMilliseconds = 300;

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.standardSpacing),
        child: SizedBox(
          height: Dimensions.gameSpinnerHeight,
          child: Row(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollStartNotification &&
                        (_debounce?.isActive ?? false)) {
                      _debounce!.cancel();
                    }

                    if (scrollNotification is ScrollEndNotification) {
                      _debounce = Timer(
                        const Duration(milliseconds: _debounceSpinnerThresholdInMilliseconds),
                        () => widget.onGameSelected(),
                      );
                    }

                    return false;
                  },
                  child: ListWheelScrollView.useDelegate(
                    controller: widget.scrollController,
                    itemExtent: _GameSpinnerSliver._gameSpinnerItemHeight,
                    squeeze: _GameSpinnerSliver._gameSpinnerItemSqueeze,
                    perspective: 0.0035,
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: [
                        for (final boardGame in widget.shuffledBoardGames) ...[
                          Center(
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: Dimensions.gameSpinnerMaxWidth,
                              ),
                              child: Stack(
                                children: [
                                  if (boardGame.imageUrl.isNotNullOrBlank)
                                    Positioned.fill(
                                      child: _GameSpinnerItem(
                                        boardGameId: boardGame.id,
                                        boardGameImageUrl: boardGame.imageUrl!,
                                      ),
                                    ),
                                  if (boardGame.imageUrl.isNullOrBlank)
                                    Container(decoration: AppStyles.tileGradientBoxDecoration),
                                  Center(
                                    child: BoardGameName(
                                      name: boardGame.name,
                                      fontSize: Dimensions.mediumFontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.standardSpacing),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => widget.onSpin(),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.standardSpacing),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        FaIcon(FontAwesomeIcons.arrowsSpin),
                        Text(AppText.playsPageGameSpinnerSpinButtonText),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameSpinnerItem extends StatelessWidget {
  const _GameSpinnerItem({
    Key? key,
    required this.boardGameId,
    required this.boardGameImageUrl,
  }) : super(key: key);

  final String boardGameId;
  final String boardGameImageUrl;

  @override
  Widget build(BuildContext context) => Hero(
        tag: '${AnimationTags.gameSpinnerBoardGameHeroTag}$boardGameId',
        child: LayoutBuilder(
          builder: (_, BoxConstraints boxConstraints) {
            return boardGameImageUrl.toImageType().when(
                  web: () => CachedNetworkImage(
                    maxHeightDiskCache: boxConstraints.maxWidth.toInt(),
                    imageUrl: boardGameImageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: AppTheme.defaultBorderRadius,
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => Container(
                      decoration: AppStyles.tileGradientBoxDecoration,
                    ),
                    errorWidget: (context, url, dynamic error) => Container(
                      decoration: AppStyles.tileGradientBoxDecoration,
                    ),
                  ),
                  file: () => ClipRRect(
                    borderRadius: AppTheme.defaultBorderRadius,
                    child: Image.file(
                      File(boardGameImageUrl),
                      fit: BoxFit.cover,
                      cacheHeight: boxConstraints.maxWidth.toInt(),
                      frameBuilder: (_, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }

                        return ImageFadeInAnimation(frame: frame, child: child);
                      },
                    ),
                  ),
                  undefined: () => const SizedBox.shrink(),
                );
          },
        ),
      );
}

class _PlaythroughGroupListSliver extends StatelessWidget {
  const _PlaythroughGroupListSliver({
    Key? key,
    required this.groupedBoardGamePlaythroughs,
  }) : super(key: key);

  final GroupedBoardGamePlaythroughs groupedBoardGamePlaythroughs;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          final boardGamePlaythrough = groupedBoardGamePlaythroughs.boardGamePlaythroughs[index];
          final isFirst = index == 0;
          return Padding(
            padding: EdgeInsets.only(
              top: isFirst ? Dimensions.standardSpacing : 0,
              bottom: Dimensions.standardSpacing,
              left: Dimensions.standardSpacing,
              right: Dimensions.standardSpacing,
            ),
            child: PanelContainer(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppStyles.panelContainerCornerRadius),
                  onTap: () => _navigateToEditPlaythrough(
                    context,
                    boardGamePlaythrough.boardGameDetails.id,
                    boardGamePlaythrough.playthrough.id,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.standardSpacing),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              SizedBox(
                                height: Dimensions.collectionSearchResultBoardGameImageHeight,
                                width: Dimensions.collectionSearchResultBoardGameImageWidth,
                                child: BoardGameTile(
                                  id: boardGamePlaythrough.id,
                                  imageUrl:
                                      boardGamePlaythrough.boardGameDetails.thumbnailUrl ?? '',
                                ),
                              ),
                              const SizedBox(width: Dimensions.standardSpacing),
                              Expanded(
                                child: _PlaythroughDetails(
                                  boardGamePlaythrough: boardGamePlaythrough,
                                ),
                              ),
                              _PlaythroughActions(
                                onTapBoardGameDetails: () =>
                                    _navigateToBoardGameDetails(context, boardGamePlaythrough),
                                onTapPlaythroughs: () =>
                                    _navigateToPlaythrough(context, boardGamePlaythrough),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        childCount: groupedBoardGamePlaythroughs.boardGamePlaythroughs.length,
      ),
    );
  }

  Future<void> _navigateToPlaythrough(
    BuildContext context,
    BoardGamePlaythrough boardGamePlaythrough,
  ) =>
      Navigator.pushNamed(
        context,
        PlaythroughsPage.pageRoute,
        arguments: PlaythroughsPageArguments(
          boardGameDetails: boardGamePlaythrough.boardGameDetails,
          boardGameImageHeroId: boardGamePlaythrough.id,
        ),
      );

  void _navigateToBoardGameDetails(
    BuildContext context,
    BoardGamePlaythrough boardGamePlaythrough,
  ) {
    Navigator.pushNamed(
      context,
      BoardGamesDetailsPage.pageRoute,
      arguments: BoardGameDetailsPageArguments(
        boardGameId: boardGamePlaythrough.boardGameDetails.id,
        boardGameImageHeroId: boardGamePlaythrough.id,
        navigatingFromType: PlaysPage,
      ),
    );
  }

  void _navigateToEditPlaythrough(
    BuildContext context,
    String boardGameId,
    String playthroughId,
  ) {
    Navigator.pushNamed(
      context,
      EditPlaythroughPage.pageRoute,
      arguments: EditPlaythroughPageArguments(
        boardGameId: boardGameId,
        playthroughId: playthroughId,
        goBackPageRoute: HomePage.pageRoute,
      ),
    );
  }
}

class _PlaythroughDetails extends StatelessWidget {
  const _PlaythroughDetails({
    Key? key,
    required this.boardGamePlaythrough,
  }) : super(key: key);

  static const double _playthroughStatsIconSize = 16;
  static const double _playthroughStatsFontAwesomeIconSize = _playthroughStatsIconSize - 4;

  final BoardGamePlaythrough boardGamePlaythrough;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          boardGamePlaythrough.boardGameDetails.name,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        _PlaythroughGeneralStats(
          icon: const Icon(
            FontAwesomeIcons.trophy,
            size: _playthroughStatsFontAwesomeIconSize,
          ),
          statistic: boardGamePlaythrough.gameResultTextFormatted,
        ),
        _PlaythroughGeneralStats(
          icon: const Icon(Icons.people, size: _playthroughStatsIconSize),
          statistic: '${boardGamePlaythrough.playthrough.playerScores.length} players',
        ),
        _PlaythroughGeneralStats(
          icon: const Icon(Icons.hourglass_bottom, size: _playthroughStatsIconSize),
          statistic: boardGamePlaythrough.playthrough.duration.inSeconds
              .toPlaytimeDuration(showSeconds: false),
        ),
      ],
    );
  }
}

class _PlaythroughGeneralStats extends StatelessWidget {
  const _PlaythroughGeneralStats({
    Key? key,
    required this.icon,
    required this.statistic,
  }) : super(key: key);

  final Widget icon;
  final String statistic;

  static const double _uniformedIconSize = 20;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: _uniformedIconSize, child: Center(child: icon)),
        const SizedBox(width: Dimensions.standardSpacing),
        Expanded(
          child: Text(
            statistic,
            style: AppTheme.subTitleTextStyle.copyWith(color: AppColors.whiteColor),
          ),
        ),
      ],
    );
  }
}

class _PlaythroughActions extends StatelessWidget {
  const _PlaythroughActions({
    Key? key,
    required this.onTapBoardGameDetails,
    required this.onTapPlaythroughs,
  }) : super(key: key);

  final VoidCallback onTapBoardGameDetails;
  final VoidCallback onTapPlaythroughs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => onTapBoardGameDetails(),
        ),
        const Expanded(child: SizedBox.shrink()),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.dice),
          onPressed: () => onTapPlaythroughs(),
        ),
      ],
    );
  }
}

class _PlaythroughGroupHeaderSliver extends StatelessWidget {
  const _PlaythroughGroupHeaderSliver({
    Key? key,
    required this.widget,
    required this.groupedBoardGamePlaythroughs,
  }) : super(key: key);

  final PlaysPage widget;
  final GroupedBoardGamePlaythroughs groupedBoardGamePlaythroughs;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: BgcSliverTitleHeaderDelegate.title(
          primaryTitle: groupedBoardGamePlaythroughs.dateFormtted),
    );
  }
}

class _NoPlaythroughsSliver extends StatelessWidget {
  const _NoPlaythroughsSliver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
        sliver: SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              SizedBox(height: Dimensions.emptyPageTitleTopSpacing),
              Center(
                child: Text(
                  AppText.playsPageHistoryTabEmptyTitle,
                  style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
                ),
              ),
              SizedBox(height: Dimensions.doubleStandardSpacing),
              FaIcon(
                FontAwesomeIcons.dice,
                size: Dimensions.emptyPageTitleIconSize,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: Dimensions.doubleStandardSpacing),
              Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(text: AppText.playPageHistoryTabEmptySubtitle),
                  ],
                ),
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: Dimensions.mediumFontSize),
              ),
            ],
          ),
        ),
      );
}

class _NoBoardGamesSliver extends StatelessWidget {
  const _NoBoardGamesSliver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
        sliver: SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              SizedBox(height: Dimensions.emptyPageTitleTopSpacing),
              Center(
                child: Text(
                  AppText.playsPageSelectGameTabEmptyTitle,
                  style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
                ),
              ),
              SizedBox(height: Dimensions.doubleStandardSpacing),
              FaIcon(
                Icons.grid_on,
                size: Dimensions.emptyPageTitleIconSize,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: Dimensions.doubleStandardSpacing),
              Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(text: AppText.playsPageSelectGameTabEmptySubtitle),
                  ],
                ),
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: Dimensions.mediumFontSize),
              ),
            ],
          ),
        ),
      );
}

class _NoBoardGamesToShuffleSliver extends StatelessWidget {
  const _NoBoardGamesToShuffleSliver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.doubleStandardSpacing,
          vertical: Dimensions.standardSpacing,
        ),
        sliver: SliverToBoxAdapter(
          child: SizedBox(
            height: Dimensions.gameSpinnerHeight,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Center(
                    child: Text(
                      AppText.playsPageSelectGameNoBoardGamesToShuffleTitle,
                      style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
                    ),
                  ),
                  SizedBox(height: Dimensions.doubleStandardSpacing),
                  FaIcon(
                    FontAwesomeIcons.arrowsSpin,
                    size: Dimensions.emptyPageTitleIconSize,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(height: Dimensions.doubleStandardSpacing),
                  Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(text: AppText.playsPageSelectGameNoBoardGamesToShuffleSubtitle),
                      ],
                    ),
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: Dimensions.mediumFontSize),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.tabVisualState,
    required this.tabController,
    required this.onTabSelected,
    Key? key,
  }) : super(key: key);

  final PlaysPageVisualState? tabVisualState;
  final TabController tabController;
  final void Function(int tabIndex) onTabSelected;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      forceElevated: true,
      elevation: Dimensions.defaultElevation,
      titleSpacing: Dimensions.standardSpacing,
      foregroundColor: AppColors.accentColor,
      title: const Text(AppText.playsPageTitle, style: AppTheme.titleTextStyle),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: TabBar(
          overlayColor: MaterialStateColor.resolveWith((states) => AppColors.accentColor),
          controller: tabController,
          tabs: <Widget>[
            AppBarBottomTab(
              AppText.playsPageHistoryTabTitle,
              Icons.history,
              isSelected: tabVisualState?.playsTab == PlaysTab.history,
            ),
            // TODO Add stats page
            // AppBarBottomTab(
            //   AppText.playsPageStatisticsTabTitle,
            //   Icons.multiline_chart,
            //   isSelected: tabVisualState?.playsTab == PlaysTab.statistics,
            // ),
            AppBarBottomTab(
              AppText.playsPageSelectGameTabTitle,
              Icons.shuffle,
              isSelected: tabVisualState?.playsTab == PlaysTab.selectGame,
            ),
          ],
          indicatorColor: AppColors.accentColor,
          onTap: (int tabIndex) => onTabSelected(tabIndex),
        ),
      ),
    );
  }
}

class _FilterPlaytime extends BgcSegmentedButton<PlaytimeFilter> {
  _FilterPlaytime.time({
    required bool isSelected,
    required PlaytimeFilter playtimeFilter,
    required Function(PlaytimeFilter) onSelected,
  }) : super(
          value: playtimeFilter,
          isSelected: isSelected,
          onTapped: (_) => onSelected(playtimeFilter),
          child: Center(
            child: Text(
              playtimeFilter.toFormattedText(),
              style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                color: isSelected ? AppColors.defaultTextColor : AppColors.secondaryTextColor,
              ),
            ),
          ),
        );
}
