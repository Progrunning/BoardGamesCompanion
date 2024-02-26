import 'dart:async';

import 'package:board_games_companion/models/hive/board_game_category.dart';
import 'package:board_games_companion/widgets/common/rating_hexagon.dart';
import 'package:board_games_companion/widgets/common/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../injectable.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/navigation/create_board_game_page_arguments.dart';
import '../../models/results/board_game_creation_result.dart';
import '../../services/preferences_service.dart';
import '../../stores/board_games_store.dart';
import '../../utilities/launcher_helper.dart';
import '../../widgets/board_games/bgc_flexible_space_bar.dart';
import '../../widgets/board_games/board_game_rating_hexagon.dart';
import '../../widgets/common/bgc_shimmer.dart';
import '../../widgets/common/board_game/board_game_property.dart';
import '../../widgets/common/board_game/collection_flags.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/common/ripple_effect.dart';
import '../../widgets/elevated_container.dart';
import '../base_page_state.dart';
import '../create_board_game/create_board_game_page.dart';
import '../home/home_page.dart';
import '../playthroughs/playthroughs_page.dart';
import 'board_game_details_expansions.dart';
import 'board_game_details_view_model.dart';

class BoardGamesDetailsPage extends StatefulWidget {
  const BoardGamesDetailsPage({
    super.key,
    required this.viewModel,
    required this.navigatingFromType,
    required this.preferencesService,
  });

  final BoardGameDetailsViewModel viewModel;
  final Type navigatingFromType;
  final PreferencesService preferencesService;

  static const String pageRoute = '/boardGameDetails';

  @override
  BoardGamesDetailsPageState createState() => BoardGamesDetailsPageState();
}

class BoardGamesDetailsPageState extends BasePageState<BoardGamesDetailsPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadBoardGameDetails();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
    ));

    return WillPopScope(
      onWillPop: () async => _handleOnWillPop(context),
      child: Scaffold(
        body: SafeArea(
          child: PageContainer(
            child: Observer(
              builder: (_) {
                return widget.viewModel.visualState.when(
                  loading: () => const _LoadingShimmer(key: Key('loadingShimmer')),
                  detailsLoaded: (_) => _BoardGameDetails(
                    preferencesService: widget.preferencesService,
                    viewModel: widget.viewModel,
                  ),
                  loadingFailed: () => _Error(
                    onRefresh: () => widget.viewModel.loadBoardGameDetails(),
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: widget.viewModel.isCreatedByUser
            ? FloatingActionButton(
                child: const Icon(Icons.edit),
                onPressed: () => _navigateToCreateBoardGamePage(),
              )
            : null,
      ),
    );
  }

  Future<bool> _handleOnWillPop(BuildContext context) async {
    final boardGamesStore = getIt<BoardGamesStore>();
    if (!boardGamesStore.allBoardGamesInCollectionsMap.containsKey(widget.viewModel.boardGame.id) &&
        widget.navigatingFromType == PlaythroughsPage) {
      Navigator.popUntil(context, ModalRoute.withName(HomePage.pageRoute));
      return false;
    }

    return true;
  }

  Future<void> _navigateToCreateBoardGamePage() async {
    final gameCreationResult = await Navigator.pushNamed<GameCreationResult>(
      context,
      CreateBoardGamePage.pageRoute,
      arguments: CreateBoardGamePageArguments(
        boardGameId: widget.viewModel.id,
        boardGameName: widget.viewModel.name,
      ),
    );

    gameCreationResult?.maybeWhen(
      removingFromCollectionsSucceeded: (boardGameName) => _showGameDeletedSnackbar(boardGameName),
      orElse: () {},
    );
  }

  Future<void> _showGameDeletedSnackbar(String boardGameName) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: Dimensions.snackbarMargin,
        content: Text(sprintf(AppText.createNewGameDeleteSucceededTextFormat, [boardGameName])),
      ),
    );
  }
}

class _BoardGameDetails extends StatelessWidget {
  const _BoardGameDetails({required this.viewModel, required this.preferencesService});

  final BoardGameDetailsViewModel viewModel;
  final PreferencesService preferencesService;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        Observer(
          builder: (_) {
            return _Header(
              boardGameImageHeroId: viewModel.imageHeroId,
              boardGameName: viewModel.name,
              boardGameImageUrl: viewModel.imageUrl,
            );
          },
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            bottom: Dimensions.halfFloatingActionButtonBottomSpacing,
          ),
          sliver: Observer(builder: (_) {
            return _Body(
              viewModel: viewModel,
              preferencesService: preferencesService,
            );
          }),
        ),
      ],
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({
    required this.onRefresh,
  });

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(),
        SliverPadding(
          padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
          sliver: SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: Dimensions.emptyPageTitleTopSpacing),
                const Center(
                  child: Text(
                    'Sorry, we ran into a problem',
                    style: TextStyle(fontSize: Dimensions.extraLargeFontSize),
                  ),
                ),
                const SizedBox(height: Dimensions.doubleStandardSpacing),
                const Icon(
                  Icons.error,
                  size: Dimensions.emptyPageTitleIconSize,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: Dimensions.doubleStandardSpacing),
                const Text(
                  "We couldn't retrieve details of the board game at this time. "
                  ' Please check your internet connectivity and try again or report the issue '
                  ' by sending an email to feedback@progrunning.net if the problem persists',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: Dimensions.mediumFontSize),
                ),
                const SizedBox(height: Dimensions.standardSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedIconButton(
                      title: 'Refresh',
                      icon: const DefaultIcon(Icons.refresh),
                      onPressed: () => onRefresh(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required String boardGameImageHeroId,
    required String boardGameName,
    required String? boardGameImageUrl,
  })  : _boardGameImageHeroId = boardGameImageHeroId,
        _boardGameName = boardGameName,
        _boardGameImageUrl = boardGameImageUrl;

  final String _boardGameName;
  final String _boardGameImageHeroId;
  final String? _boardGameImageUrl;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      expandedHeight: Constants.boardGameDetailsImageHeight,
      flexibleSpace: BgcFlexibleSpaceBar(
        id: _boardGameImageHeroId,
        boardGameName: _boardGameName,
        boardGameImageUrl: _boardGameImageUrl,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.viewModel,
    required this.preferencesService,
  });

  final BoardGameDetailsViewModel viewModel;
  final PreferencesService preferencesService;

  static const _spacingBetweenSecions = Dimensions.doubleStandardSpacing;
  static const _halfSpacingBetweenSecions = Dimensions.standardSpacing;
  static const _sectionTopSpacing = Dimensions.standardSpacing;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: Dimensions.standardSpacing),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed(
          <Widget>[
            SectionHeader.titles(
              primaryTitle: AppText.boardGameDetailsPageGeneralTitle,
              secondaryTitle: AppText.boardGameDetailsPageCollectionsTitle,
            ),
            const SizedBox(height: _sectionTopSpacing),
            _GeneralAndCollections(viewModel: viewModel),
            const SizedBox(height: _spacingBetweenSecions),
            Observer(
              builder: (_) {
                if (viewModel.boardGame.hasGeneralInfoDefined) {
                  return _General(
                    playersFormatted: viewModel.boardGame.playersFormatted,
                    playtimeFormatted: viewModel.boardGame.playtimeFormatted,
                    minAge: viewModel.boardGame.minAge,
                    avgWeight: viewModel.boardGame.avgWeight,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: _halfSpacingBetweenSecions),
            if (!viewModel.isCreatedByUser) ...[
              SectionHeader.title(title: AppText.boardGameDetailsPagetLinksTitle),
              _Links(boardGameDetailsStore: viewModel),
              const SizedBox(height: _halfSpacingBetweenSecions),
              SectionHeader.title(title: AppText.boardGameDetailsPageCreditsTitle),
              const SizedBox(height: _sectionTopSpacing),
              _Credits(boardGameDetails: viewModel.boardGame),
              const SizedBox(height: _halfSpacingBetweenSecions),
              SectionHeader.title(
                title: AppText.boardGameDetailsPageCategoriesTitle,
              ),
              _Categories(categories: viewModel.boardGame.categories!),
              if (viewModel.isMainGame && viewModel.hasExpansions) ...[
                Observer(
                  builder: (_) {
                    return BoardGameDetailsExpansions(
                      expansions: viewModel.expansions,
                      ownedExpansionsById: viewModel.expansionsOwnedById,
                      totalExpansionsOwned: viewModel.totalExpansionsOwned,
                      spacingBetweenSecions: _spacingBetweenSecions,
                      preferencesService: preferencesService,
                    );
                  },
                ),
                const SizedBox(height: _halfSpacingBetweenSecions),
              ],
              SectionHeader.title(
                title: AppText.boardGameDetailsPageDescriptionTitle,
              ),
              const SizedBox(height: _sectionTopSpacing),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                child: Text(
                  viewModel.unescapedDescription,
                  textAlign: TextAlign.justify,
                  style: AppTheme.theme.textTheme.bodyMedium,
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories({
    required this.categories,
  });

  final List<BoardGameCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: Dimensions.standardSpacing,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          for (final category in categories)
            Chip(
              padding: const EdgeInsets.all(Dimensions.standardSpacing),
              backgroundColor: AppColors.primaryColor.withAlpha(
                AppStyles.opacity80Percent,
              ),
              label: Text(
                category.name,
                style: const TextStyle(color: AppColors.defaultTextColor),
              ),
            )
        ],
      ),
    );
  }
}

class _General extends StatelessWidget {
  const _General({
    required this.playersFormatted,
    required this.playtimeFormatted,
    required this.minAge,
    required this.avgWeight,
  });

  final String playersFormatted;
  final String playtimeFormatted;
  final int? minAge;
  final num? avgWeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FirstRowGeneralInfoPanels(
          playersFormatted: playersFormatted,
          playtimeFormatted: playtimeFormatted,
        ),
        if (minAge != null || avgWeight != null) ...[
          const SizedBox(height: Dimensions.standardSpacing),
          _SecondRowGeneralInfoPanels(
            minAge: minAge,
            avgWeight: avgWeight,
          ),
        ],
      ],
    );
  }
}

class _Links extends StatelessWidget {
  const _Links({
    required BoardGameDetailsViewModel boardGameDetailsStore,
  }) : _boardGameDetailsStore = boardGameDetailsStore;

  final BoardGameDetailsViewModel _boardGameDetailsStore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Link(
            title: 'Overview',
            icon: Icons.info,
            boardGameDetailsStore: _boardGameDetailsStore,
            onPressed: () async {
              await LauncherHelper.launchUri(
                context,
                _boardGameDetailsStore.boardGame.bggOverviewUrl,
                launchMode: LaunchMode.externalApplication,
              );
            }),
        const SizedBox(width: Dimensions.doubleStandardSpacing),
        _Link(
          title: 'Videos',
          icon: Icons.videocam,
          boardGameDetailsStore: _boardGameDetailsStore,
          onPressed: () async {
            await LauncherHelper.launchUri(
              context,
              _boardGameDetailsStore.boardGame.bggHotVideosUrl,
              launchMode: LaunchMode.externalApplication,
            );
          },
        ),
        const SizedBox(width: Dimensions.doubleStandardSpacing),
        _Link(
          title: 'Forums',
          icon: Icons.forum,
          boardGameDetailsStore: _boardGameDetailsStore,
          onPressed: () async {
            await LauncherHelper.launchUri(
              context,
              _boardGameDetailsStore.boardGame.bggHotForumUrl,
              launchMode: LaunchMode.externalApplication,
            );
          },
        ),
      ],
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({
    required this.title,
    required this.icon,
    required this.boardGameDetailsStore,
    required this.onPressed,
  });

  final BoardGameDetailsViewModel boardGameDetailsStore;
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RippleEffect(
      onTap: () async {
        onPressed();
        await boardGameDetailsStore.captureLinkAnalytics(title);
      },
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.standardSpacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.accentColor,
              size: Dimensions.boardGameDetailsLinkIconSize,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: Dimensions.smallFontSize),
            ),
          ],
        ),
      ),
    );
  }
}

class _Credits extends StatelessWidget {
  const _Credits({
    required this.boardGameDetails,
  });

  final BoardGameDetails? boardGameDetails;

  static const _spacingBetweenCredits = Dimensions.standardSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _CreditsItem(
            title: 'Designer:',
            detail: boardGameDetails?.desingers.map((designer) => designer.name).join(', '),
          ),
          const SizedBox(height: _spacingBetweenCredits),
          _CreditsItem(
            title: 'Artist:',
            detail: boardGameDetails?.artists.map((artist) => artist.name).join(', '),
          ),
          const SizedBox(height: _spacingBetweenCredits),
          _CreditsItem(
            title: 'Publisher:',
            detail: boardGameDetails?.publishers.map((publisher) => publisher.name).join(', '),
          ),
        ],
      ),
    );
  }
}

class _CreditsItem extends StatelessWidget {
  const _CreditsItem({
    required this.title,
    required this.detail,
  });

  final String title;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: AppTheme.theme.textTheme.displaySmall,
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: detail,
            style: AppTheme.theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _GeneralAndCollections extends StatelessWidget {
  const _GeneralAndCollections({
    required this.viewModel,
  });

  final BoardGameDetailsViewModel viewModel;

  static const double _iconSize = 28;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Observer(
            builder: (_) {
              return Column(
                children: [
                  BoardGameRatingHexagon(rating: viewModel.boardGame.rating),
                ],
              );
            },
          ),
          const SizedBox(width: Dimensions.standardSpacing),
          if (viewModel.isCreatedByUser) const Spacer(),
          if (!viewModel.isCreatedByUser)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BoardGameProperty(
                    icon: const Icon(Icons.tag, size: _iconSize),
                    iconWidth: _iconSize,
                    propertyName: viewModel.boardGame.rankFormatted,
                    fontSize: Dimensions.mediumFontSize,
                  ),
                  const SizedBox(height: Dimensions.halfStandardSpacing),
                  BoardGameProperty(
                    icon: const Icon(Icons.how_to_vote, size: _iconSize),
                    iconWidth: _iconSize,
                    propertyName: viewModel.boardGame.votesNumberFormatted,
                    fontSize: Dimensions.mediumFontSize,
                  ),
                  const SizedBox(height: Dimensions.halfStandardSpacing),
                  BoardGameProperty(
                    icon: const Icon(Icons.comment, size: _iconSize),
                    iconWidth: _iconSize,
                    propertyName: viewModel.boardGame.commentsNumberFormatted,
                    fontSize: Dimensions.mediumFontSize,
                  ),
                  const SizedBox(height: Dimensions.halfStandardSpacing),
                  BoardGameProperty(
                    icon: const Icon(Icons.event, size: _iconSize),
                    iconWidth: _iconSize,
                    propertyName: '${viewModel.boardGame.yearPublished}',
                    fontSize: Dimensions.mediumFontSize,
                  ),
                ],
              ),
            ),
          Observer(
            builder: (_) {
              return CollectionFlags(
                isEditable: !viewModel.isCreatedByUser,
                isOwned: viewModel.boardGame.isOwned ?? false,
                isOnWishlist: viewModel.boardGame.isOnWishlist ?? false,
                isOnFriendsList: viewModel.boardGame.isFriends ?? false,
                onToggleCollection: (collection) async => viewModel.toggleCollection(collection),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FirstRowGeneralInfoPanels extends StatelessWidget {
  const _FirstRowGeneralInfoPanels({
    required this.playersFormatted,
    required this.playtimeFormatted,
  });

  final String playersFormatted;
  final String playtimeFormatted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: _InfoPanel(
                title: playersFormatted,
                icon: const Icon(Icons.people),
              ),
            ),
            const SizedBox(width: Dimensions.standardSpacing),
            Expanded(
              child: _InfoPanel(
                icon: const Icon(Icons.hourglass_bottom),
                title: playtimeFormatted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondRowGeneralInfoPanels extends StatelessWidget {
  const _SecondRowGeneralInfoPanels({
    required this.minAge,
    required this.avgWeight,
  });

  final int? minAge;
  final num? avgWeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (minAge != null)
              Expanded(
                child: _InfoPanel(
                  icon: const Icon(Icons.family_restroom),
                  title: '$minAge+',
                ),
              ),
            const SizedBox(width: Dimensions.standardSpacing),
            if (avgWeight != null && avgWeight != 0)
              Expanded(
                child: _InfoPanel(
                  icon: const FaIcon(FontAwesomeIcons.scaleUnbalanced),
                  title: '${avgWeight!.toStringAsFixed(2)} / 5',
                ),
              ),
            if (avgWeight == null || avgWeight == 0) const Spacer()
          ],
        ),
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.title,
    this.icon,
  });

  final String title;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      elevation: AppStyles.defaultElevation,
      backgroundColor: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.oneAndHalfStandardSpacing),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: Dimensions.standardSpacing)],
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTheme.titleTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer({
    super.key,
  });

  static const double _collectionsIconSize = 28;

  // Approximated value
  static const double _gamePropertiesPanelHeight = 36;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              // Image
              SizedBox(
                height: Constants.boardGameDetailsImageHeight,
                child: BgcShimmer.fill(),
              ),
              // Section header
              const _SectionHeaderShimmer(hasSecondTitle: true),
              const SizedBox(height: Dimensions.standardSpacing),
              // Game stats and collections
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BgcShimmer.custom(child: const RatingHexagon()),
                  const SizedBox(width: Dimensions.standardSpacing),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BoardGamePropertyShimmer(textWidth: 40),
                      SizedBox(height: Dimensions.standardSpacing),
                      _BoardGamePropertyShimmer(textWidth: 100),
                      SizedBox(height: Dimensions.standardSpacing),
                      _BoardGamePropertyShimmer(textWidth: 110),
                      SizedBox(height: Dimensions.standardSpacing),
                      _BoardGamePropertyShimmer(textWidth: 50),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Row(
                        children: [
                          BgcShimmer.box(width: _collectionsIconSize, height: _collectionsIconSize),
                          const SizedBox(width: Dimensions.doubleStandardSpacing),
                          BgcShimmer.box(width: _collectionsIconSize, height: _collectionsIconSize),
                        ],
                      ),
                      const SizedBox(height: Dimensions.standardSpacing),
                      BgcShimmer.box(width: _collectionsIconSize, height: _collectionsIconSize),
                    ],
                  ),
                  const SizedBox(width: Dimensions.standardSpacing),
                ],
              ),
              const SizedBox(height: Dimensions.standardSpacing),
              // Game properties
              Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: Dimensions.standardSpacing),
                      Expanded(
                        child: SizedBox(
                          height: _gamePropertiesPanelHeight,
                          child: BgcShimmer.fill(),
                        ),
                      ),
                      const SizedBox(width: Dimensions.standardSpacing),
                      Expanded(
                        child: SizedBox(
                          height: _gamePropertiesPanelHeight,
                          child: BgcShimmer.fill(),
                        ),
                      ),
                      const SizedBox(width: Dimensions.standardSpacing),
                    ],
                  ),
                  const SizedBox(height: Dimensions.standardSpacing),
                  Row(
                    children: [
                      const SizedBox(width: Dimensions.standardSpacing),
                      Expanded(
                        child: SizedBox(
                          height: _gamePropertiesPanelHeight,
                          child: BgcShimmer.fill(),
                        ),
                      ),
                      const SizedBox(width: Dimensions.standardSpacing),
                      Expanded(
                        child: SizedBox(
                          height: _gamePropertiesPanelHeight,
                          child: BgcShimmer.fill(),
                        ),
                      ),
                      const SizedBox(width: Dimensions.standardSpacing),
                    ],
                  )
                ],
              ),
              const SizedBox(height: Dimensions.standardSpacing),
              const _SectionHeaderShimmer(),
              const SizedBox(height: Dimensions.standardSpacing),
              // Dimensions.boardGameDetailsLinkIconSize
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                child: Row(
                  children: [
                    BgcShimmer.box(
                      height: Dimensions.boardGameDetailsLinkIconSize,
                      width: Dimensions.boardGameDetailsLinkIconSize,
                    ),
                    const Spacer(),
                    BgcShimmer.box(
                      height: Dimensions.boardGameDetailsLinkIconSize,
                      width: Dimensions.boardGameDetailsLinkIconSize,
                    ),
                    const Spacer(),
                    BgcShimmer.box(
                      height: Dimensions.boardGameDetailsLinkIconSize,
                      width: Dimensions.boardGameDetailsLinkIconSize,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.standardSpacing),
              const _SectionHeaderShimmer(),
              const SizedBox(height: Dimensions.standardSpacing),
              // Credits
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BgcShimmer.box(
                      height: AppTheme.subTitleTextStyle.fontSize!,
                      width: 200,
                    ),
                    const SizedBox(height: Dimensions.standardSpacing),
                    SizedBox(
                      height: AppTheme.subTitleTextStyle.fontSize!,
                      child: BgcShimmer.fill(),
                    ),
                    const SizedBox(height: Dimensions.standardSpacing),
                    SizedBox(
                      height: 120,
                      child: BgcShimmer.fill(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.standardSpacing),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeaderShimmer extends StatelessWidget {
  const _SectionHeaderShimmer({
    this.hasSecondTitle = false,
  });

  final bool hasSecondTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.sectionHeaderHeight,
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.standardSpacing),
        child: Row(
          children: [
            BgcShimmer.invertedColorsBox(
              width: 100,
              height: AppTheme.titleTextStyle.fontSize!,
            ),
            if (hasSecondTitle) ...[
              const Spacer(),
              BgcShimmer.invertedColorsBox(
                width: 100,
                height: AppTheme.titleTextStyle.fontSize!,
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _BoardGamePropertyShimmer extends StatelessWidget {
  const _BoardGamePropertyShimmer({
    required this.textWidth,
  });

  static const double _iconSize = 28;

  final double textWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BgcShimmer.box(height: _iconSize, width: _iconSize),
        const SizedBox(width: Dimensions.standardSpacing),
        BgcShimmer.box(
          width: textWidth,
          height: Dimensions.mediumFontSize,
        ),
      ],
    );
  }
}
