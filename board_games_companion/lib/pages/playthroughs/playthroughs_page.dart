import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/animation_tags.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/enums/collection_type.dart';
import '../../extensions/page_controller_extensions.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/hive/playthrough.dart';
import '../../models/playthrough_player.dart';
import '../../stores/board_game_playthroughs_store.dart';
import '../../stores/players_store.dart';
import '../../stores/playthroughs_store.dart';
import '../../stores/start_playthrough_store.dart';
import '../../utilities/navigator_helper.dart';
import '../../widgets/board_games/board_game_image.dart';
import '../../widgets/common/bottom_tabs/custom_bottom_navigation_bar_item_widget.dart';
import '../../widgets/common/cunsumer_future_builder_widget.dart';
import '../../widgets/common/page_container_widget.dart';
import '../../widgets/playthrough/playthrough_item_widget.dart';
import '../../widgets/playthrough/playthrough_no_players.dart';
import '../../widgets/playthrough/playthrough_players.dart';
import '../base_page_state.dart';
import 'playthroughs_statistics.dart';

class PlaythroughsPage extends StatefulWidget {
  const PlaythroughsPage(
    this.boardGameDetails,
    this.collectionType, {
    Key key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;
  final CollectionType collectionType;

  @override
  _PlaythroughsPageState createState() => _PlaythroughsPageState();
}

class _PlaythroughsPageState extends BasePageState<PlaythroughsPage> {
  BoardGamePlaythroughsStore boardGamePlaythoughsStore;
  PageController pageController;
  PlaythroughsStore playthroughsStore;

  @override
  void initState() {
    super.initState();

    boardGamePlaythoughsStore = Provider.of<BoardGamePlaythroughsStore>(
      context,
      listen: false,
    );
    pageController = PageController(
      initialPage: boardGamePlaythoughsStore.boardGamePlaythroughPageIndex,
    );
    playthroughsStore = Provider.of<PlaythroughsStore>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.boardGameDetails.name ?? ''),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.info,
              color: AppTheme.accentColor,
            ),
            onPressed: () async {
              await _goToBoardGameDetails(context, widget.boardGameDetails);
            },
          )
        ],
      ),
      body: SafeArea(
        child: PageContainer(
          child: PageView(
            controller: pageController,
            onPageChanged: (index) => _onTabPageChanged(index, boardGamePlaythoughsStore),
            children: <Widget>[
              _Statistcs(
                boardGameDetails: widget.boardGameDetails,
                collectionType: widget.collectionType,
              ),
              _History(
                widget.boardGameDetails,
                playthroughsStore,
              ),
              Consumer<PlayersStore>(
                builder: (_, __, ___) {
                  return _NewPlaythrough(
                    widget.boardGameDetails,
                    pageController,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<BoardGamePlaythroughsStore>(
        builder: (_, store, __) {
          return BottomNavigationBar(
            backgroundColor: AppTheme.bottomTabBackgroundColor,
            items: <BottomNavigationBarItem>[
              CustomBottomNavigationBarItem('Stats', Icons.multiline_chart),
              CustomBottomNavigationBarItem('History', Icons.history),
              CustomBottomNavigationBarItem('New Game', Icons.play_arrow),
            ],
            onTap: (index) async {
              await _onTabChanged(index, pageController);
            },
            currentIndex: store.boardGamePlaythroughPageIndex,
          );
        },
      ),
    );
  }

  Future<void> _onTabChanged(int index, PageController pageController) async {
    await pageController.animateToTab(index);
  }

  void _onTabPageChanged(int pageIndex, BoardGamePlaythroughsStore boardGamePlaythroughsStore) {
    boardGamePlaythroughsStore.boardGamePlaythroughPageIndex = pageIndex;
  }

  Future<void> _goToBoardGameDetails(
    BuildContext context,
    BoardGameDetails boardGameDetails,
  ) async {
    await NavigatorHelper.navigateToBoardGameDetails(
      context,
      boardGameDetails?.id,
      boardGameDetails?.name,
      PlaythroughsPage,
    );
  }
}

class _Statistcs extends StatefulWidget {
  const _Statistcs({
    @required this.boardGameDetails,
    @required this.collectionType,
    Key key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;
  final CollectionType collectionType;

  @override
  _StatistcsState createState() => _StatistcsState();
}

class _StatistcsState extends State<_Statistcs> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          floating: false,
          expandedHeight: Constants.BoardGameDetailsImageHeight,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            centerTitle: true,
            background: BoardGameImage(
              widget.boardGameDetails,
              minImageHeight: Constants.BoardGameDetailsImageHeight,
              heroTag: '${AnimationTags.boardGamePlaythroughImageHeroTag}_${widget.collectionType}',
            ),
          ),
        ),
        SliverPadding(
          sliver: SliverToBoxAdapter(
            child: ChangeNotifierProvider.value(
              value: widget.boardGameDetails,
              child: const PlaythroughsStatistics(),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.standardSpacing,
          ),
        )
      ],
    );
  }
}

class _NewPlaythrough extends StatefulWidget {
  const _NewPlaythrough(
    this.boardGameDetails,
    this.pageController, {
    Key key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;
  final PageController pageController;

  @override
  _NewPlaythroughState createState() => _NewPlaythroughState();
}

class _NewPlaythroughState extends State<_NewPlaythrough> {
  StartPlaythroughStore startPlaythroughStore;

  @override
  void initState() {
    super.initState();

    startPlaythroughStore = Provider.of<StartPlaythroughStore>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConsumerFutureBuilder<List<PlaythroughPlayer>, StartPlaythroughStore>(
      future: startPlaythroughStore.loadPlaythroughPlayers(),
      success: (_, StartPlaythroughStore store) {
        if (store.playthroughPlayers?.isNotEmpty ?? false) {
          return PlaythroughPlayers(
            playthroughPlayers: store.playthroughPlayers,
            boardGameDetails: widget.boardGameDetails,
            pageController: widget.pageController,
          );
        }

        return const PlaythroughNoPlayers();
      },
    );
  }
}

class _History extends StatefulWidget {
  const _History(
    this.boardGameDetails,
    this.playthroughsStore, {
    Key key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;
  final PlaythroughsStore playthroughsStore;

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<_History> {
  static const double _maxPlaythroughItemHeight = 300;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        const SizedBox(
          height: Dimensions.standardSpacing,
        ),
        Expanded(
          child: ConsumerFutureBuilder<List<Playthrough>, PlaythroughsStore>(
            future: widget.playthroughsStore.loadPlaythroughs(widget.boardGameDetails),
            success: (_, PlaythroughsStore store) {
              final hasPlaythroughs = store.playthroughs?.isNotEmpty ?? false;
              if (hasPlaythroughs) {
                store.playthroughs.sort((a, b) => b.startDate?.compareTo(a.startDate));
                return ListView.separated(
                  itemBuilder: (_, index) {
                    return SizedBox(
                      height: math.max(
                          _maxPlaythroughItemHeight, MediaQuery.of(context).size.height / 3),
                      child: PlaythroughItem(
                        store.playthroughs[index],
                        store.playthroughs.length - index,
                        key: ValueKey(store.playthroughs[index].id),
                      ),
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
