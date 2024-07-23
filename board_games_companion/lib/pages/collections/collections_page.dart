import 'dart:async';
import 'dart:io';

import 'package:basics/basics.dart';
import 'package:board_games_companion/extensions/build_context_extensions.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tuple/tuple.dart';

import '../../common/analytics.dart';
import '../../common/animation_tags.dart';
import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/dimensions.dart';
import '../../common/enums/collection_type.dart';
import '../../common/enums/games_tab.dart';
import '../../injectable.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/navigation/playthroughs_page_arguments.dart';
import '../../services/analytics_service.dart';
import '../../services/rate_and_review_service.dart';
import '../../stores/board_games_filters_store.dart';
import '../../utilities/screenshot_generator.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/app_bar/app_bar_bottom_tab.dart';
import '../../widgets/common/bgg_community_member_text_widget.dart';
import '../../widgets/common/bgg_community_member_user_name_text_field_widget.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/import_collections_button.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/slivers/bgc_sliver_title_header_delegate.dart';
import '../playthroughs/playthroughs_page.dart';
import 'collections_filter_panel.dart';
import 'collections_view_model.dart';

enum BoardGameResultActionType {
  details,
  playthroughs,
}

class CollectionsPage extends StatefulWidget {
  const CollectionsPage(
    this.viewModel,
    this.boardGamesFiltersStore,
    this.analyticsService,
    this.rateAndReviewService, {
    super.key,
  });

  final CollectionsViewModel viewModel;
  final BoardGamesFiltersStore boardGamesFiltersStore;
  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;

  @override
  CollectionsPageState createState() => CollectionsPageState();
}

class CollectionsPageState extends State<CollectionsPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _topTabController;
  late final ScreenshotGenerator _screenshotGenerator;
  late final ReactionDisposer _screenshotGeneratorReacitonDisposer;

  @override
  void initState() {
    super.initState();

    _screenshotGenerator = getIt<ScreenshotGenerator>();
    _screenshotGeneratorReacitonDisposer =
        reaction((_) => _screenshotGenerator.visualState, (generatorState) {
      generatorState.maybeWhen(
        generated: (screenshotFile) async => _shareScreenshot(context, screenshotFile),
        orElse: () {},
      );
    });

    _topTabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.viewModel.selectedTab.index,
    );
    widget.viewModel.loadBoardGames();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        switch (widget.viewModel.futureLoadBoardGames?.status ?? FutureStatus.pending) {
          case FutureStatus.pending:
            return const LoadingIndicator();
          case FutureStatus.rejected:
            return const Center(child: GenericErrorMessage());
          case FutureStatus.fulfilled:
            // TODO Use visual states instead
            if (!widget.viewModel.anyBoardGamesInCollections &&
                (widget.viewModel.isUserNameEmpty)) {
              return const _Empty();
            }

            return Observer(
              builder: (_) {
                return _Collection(
                  viewModel: widget.viewModel,
                  isCollectionEmpty: widget.viewModel.isCollectionEmpty,
                  hasBaseGames: widget.viewModel.anyBaseGamesInCollection,
                  baseGames: widget.viewModel.baseGamesInCollection,
                  baseGamesTotal: widget.viewModel.baseGamesInCollectionTotal,
                  hasExpansions: widget.viewModel.anyExpansionsInCollection,
                  expansionsMap: widget.viewModel.expansionsInCollectionMap,
                  selectedTab: widget.viewModel.selectedTab,
                  topTabController: _topTabController,
                  analyticsService: widget.analyticsService,
                  rateAndReviewService: widget.rateAndReviewService,
                  screenshotGenerator: _screenshotGenerator,
                );
              },
            );
        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    widget.viewModel.loadBoardGames();
  }

  @override
  void dispose() {
    _topTabController.dispose();
    _screenshotGeneratorReacitonDisposer();
    super.dispose();
  }

  Future<void> _shareScreenshot(BuildContext context, File screenshotFile) async {
    final messenger = ScaffoldMessenger.of(context);
    final shareResult = await Share.shareXFiles(
      [
        XFile(screenshotFile.path, mimeType: 'image/png'),
      ],
      sharePositionOrigin: context.iPadsShareRectangle,
    );

    Fimber.i('Screenshot sharing finished with status ${shareResult.status}');

    switch (shareResult.status) {
      case ShareResultStatus.success:
      case ShareResultStatus.unavailable:
        if (!mounted) {
          break;
        }

        messenger.showSnackBar(
          const SnackBar(
            margin: Dimensions.snackbarMargin,
            behavior: SnackBarBehavior.floating,
            content: Text(AppText.collectionsPageShareCollectionSuccessMessage),
            backgroundColor: AppColors.greenColor,
          ),
        );

        break;
      case ShareResultStatus.dismissed:
        // MK Don't do anything, user cancelled/dismissed
        break;
    }
  }
}

class _Collection extends StatelessWidget {
  const _Collection({
    required this.viewModel,
    required this.isCollectionEmpty,
    required this.hasBaseGames,
    required this.baseGames,
    required this.baseGamesTotal,
    required this.hasExpansions,
    required this.expansionsMap,
    required this.selectedTab,
    required this.topTabController,
    required this.analyticsService,
    required this.rateAndReviewService,
    required this.screenshotGenerator,
  });

  final CollectionsViewModel viewModel;
  final bool isCollectionEmpty;
  final bool hasBaseGames;
  final List<BoardGameDetails> baseGames;
  final int baseGamesTotal;
  final bool hasExpansions;
  final Map<Tuple2<String, String>, List<BoardGameDetails>> expansionsMap;
  final GamesTab selectedTab;
  final TabController topTabController;
  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;
  final ScreenshotGenerator screenshotGenerator;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _AppBar(
          viewModel: viewModel,
          topTabController: topTabController,
          analyticsService: analyticsService,
          rateAndReviewService: rateAndReviewService,
        ),
        if (isCollectionEmpty)
          Observer(
            builder: (_) {
              return _EmptyCollection(
                selectedTab: selectedTab,
                userName: viewModel.userName,
              );
            },
          ),
        if (!isCollectionEmpty) ...[
          if (hasBaseGames) ...[
            SliverPersistentHeader(
              delegate: BgcSliverTitleHeaderDelegate.action(
                primaryTitle: sprintf(
                  AppText.gamesPageBaseGamesSliverSectionTitleFormat,
                  [baseGamesTotal],
                ),
                action: _ShareCollectionIconButton(
                  screenshotGenerator: screenshotGenerator,
                  boardGames: [
                    ...baseGames,
                    ...expansionsMap.values.expand((expansion) => expansion)
                  ],
                ),
              ),
            ),
            _Grid(boardGamesDetails: baseGames, analyticsService: analyticsService),
          ],
          if (hasExpansions) ...[
            for (final expansionsMapEntry in expansionsMap.entries) ...[
              SliverPersistentHeader(
                delegate: BgcSliverTitleHeaderDelegate.title(
                  primaryTitle: sprintf(
                    AppText.gamesPageExpansionsSliverSectionTitleFormat,
                    [expansionsMapEntry.key.item2, expansionsMapEntry.value.length],
                  ),
                ),
              ),
              _Grid(
                boardGamesDetails: expansionsMapEntry.value,
                analyticsService: analyticsService,
              ),
            ]
          ]
        ],
        const SliverPadding(padding: EdgeInsets.all(8.0)),
      ],
    );
  }
}

class _ShareCollectionIconButton extends StatelessWidget {
  const _ShareCollectionIconButton({
    required this.screenshotGenerator,
    required this.boardGames,
  });

  final ScreenshotGenerator screenshotGenerator;
  final List<BoardGameDetails> boardGames;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: () async => screenshotGenerator.generateCollectionScreenshot(boardGames),
    );
  }
}

class _AppBar extends StatefulWidget {
  const _AppBar({
    required this.viewModel,
    required this.topTabController,
    required this.analyticsService,
    required this.rateAndReviewService,
  });

  final CollectionsViewModel viewModel;
  final TabController topTabController;
  final AnalyticsService analyticsService;
  final RateAndReviewService rateAndReviewService;

  @override
  _AppBarState createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> {
  @override
  Widget build(BuildContext context) => SliverAppBar(
        pinned: true,
        floating: true,
        forceElevated: true,
        elevation: Dimensions.defaultElevation,
        titleSpacing: Dimensions.standardSpacing,
        foregroundColor: AppColors.accentColor,
        title: const Text(
          AppText.collectionsPageTitle,
          style: TextStyle(color: AppColors.whiteColor),
        ),
        actions: <Widget>[
          Observer(
            builder: (_) {
              return IconButton(
                icon: widget.viewModel.anyFiltersApplied
                    ? const Icon(Icons.filter_alt_rounded, color: AppColors.accentColor)
                    : const Icon(Icons.filter_alt_outlined, color: AppColors.accentColor),
                onPressed: widget.viewModel.anyBoardGames
                    ? () async {
                        await _openFiltersPanel(context);
                        await widget.analyticsService.logEvent(name: Analytics.filterCollection);
                        await widget.rateAndReviewService.increaseNumberOfSignificantActions();
                      }
                    : null,
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(74),
          child: Observer(builder: (_) {
            return TabBar(
              onTap: (int index) => widget.viewModel.selectedTab = index.toCollectionsTab(),
              controller: widget.topTabController,
              tabAlignment: TabAlignment.fill,
              tabs: <Widget>[
                AppBarBottomTab(
                  'Owned',
                  Icons.grid_on,
                  isSelected: widget.viewModel.selectedTab == GamesTab.owned,
                ),
                AppBarBottomTab(
                  'Friends',
                  Icons.group,
                  isSelected: widget.viewModel.selectedTab == GamesTab.friends,
                ),
                AppBarBottomTab(
                  'Wishlist',
                  Icons.card_giftcard,
                  isSelected: widget.viewModel.selectedTab == GamesTab.wishlist,
                ),
              ],
              indicatorColor: AppColors.accentColor,
            );
          }),
        ),
      );

  Future<void> _openFiltersPanel(BuildContext context) async {
    await showModalBottomSheet<Widget>(
      backgroundColor: AppColors.primaryColor,
      elevation: Dimensions.defaultElevation,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppStyles.defaultBottomSheetCornerRadius),
          topRight: Radius.circular(AppStyles.defaultBottomSheetCornerRadius),
        ),
      ),
      context: context,
      builder: (context) {
        return IntrinsicHeight(
          child: CollectionsFilterPanel(viewModel: widget.viewModel),
        );
      },
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    required this.boardGamesDetails,
    required this.analyticsService,
  });

  final List<BoardGameDetails> boardGamesDetails;
  final AnalyticsService analyticsService;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      sliver: SliverGrid.extent(
        crossAxisSpacing: Dimensions.standardSpacing,
        mainAxisSpacing: Dimensions.standardSpacing,
        maxCrossAxisExtent: Dimensions.boardGameItemCollectionImageWidth,
        children: [
          for (final boardGameDetails in boardGamesDetails)
            BoardGameTile(
              id: boardGameDetails.id,
              name: boardGameDetails.name,
              imageUrl: boardGameDetails.thumbnailUrl ?? '',
              rank: boardGameDetails.rank,
              elevation: AppStyles.defaultElevation,
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  PlaythroughsPage.pageRoute,
                  arguments: PlaythroughsPageArguments(
                    boardGameDetails: boardGameDetails,
                    boardGameImageHeroId: boardGameDetails.id,
                  ),
                );
              },
              heroTag: AnimationTags.boardGameHeroTag,
            )
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverAppBar(pinned: true, floating: true, foregroundColor: AppColors.accentColor),
        SliverPadding(
          padding: EdgeInsets.all(Dimensions.doubleStandardSpacing),
          sliver: SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: Dimensions.emptyPageTitleTopSpacing),
                Center(
                  child: Text(
                    'Your games collection is empty',
                    style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
                  ),
                ),
                SizedBox(height: Dimensions.doubleStandardSpacing),
                Icon(
                  Icons.sentiment_dissatisfied_sharp,
                  size: Dimensions.emptyPageTitleIconSize,
                  color: AppColors.primaryColor,
                ),
                SizedBox(height: Dimensions.doubleStandardSpacing),
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Nothing to worry about though! ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'Follow the below instructions to fill up this screen with board games.\n\n',
                      ),
                      TextSpan(text: 'Use the '),
                      TextSpan(text: 'search', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text:
                            ' icon in the bottom right corner to look up any title and start adding them to your collections.\n',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: Dimensions.mediumFontSize),
                ),
                BggCommunityMemberText(),
                _ImportDataFromBggSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ImportDataFromBggSection extends StatefulWidget {
  const _ImportDataFromBggSection();

  @override
  State<_ImportDataFromBggSection> createState() => _ImportDataFromBggSectionState();
}

class _ImportDataFromBggSectionState extends State<_ImportDataFromBggSection> {
  late TextEditingController bggUserNameController;

  bool? triggerImport;

  @override
  void initState() {
    super.initState();
    bggUserNameController = TextEditingController();
  }

  @override
  void dispose() {
    bggUserNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BggCommunityMemberUserNameTextField(
          controller: bggUserNameController,
          onSubmit: () => setState(() {
            triggerImport = true;
          }),
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        Align(
          alignment: Alignment.centerRight,
          child: ImportCollectionsButton(
            usernameCallback: () => bggUserNameController.text,
            triggerImport: triggerImport ?? false,
          ),
        ),
      ],
    );
  }
}

class _EmptyCollection extends StatelessWidget {
  const _EmptyCollection({
    required this.selectedTab,
    required this.userName,
  });

  final GamesTab selectedTab;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.doubleStandardSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Observer(
              builder: (_) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "It looks like you don't have any board games in your ",
                          ),
                          TextSpan(
                            text: selectedTab.toCollectionType().toHumandReadableText(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' collection yet.'),
                          if (selectedTab == GamesTab.wishlist && (userName.isNotNullOrBlank)) ...[
                            const TextSpan(text: "\n\nIf you want to see board games from BGG's  "),
                            const TextSpan(
                              text: 'Wishlist ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: 'or '),
                            const TextSpan(
                              text: 'Want to Buy ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: 'collections then tap the below  '),
                            const TextSpan(
                              text: '${AppText.importCollectionsButtonText} ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: 'button.'),
                          ]
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    if (selectedTab == GamesTab.wishlist && (userName.isNotNullOrBlank)) ...[
                      const SizedBox(height: Dimensions.doubleStandardSpacing),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ImportCollectionsButton(usernameCallback: () => userName!),
                      ),
                    ]
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
