import 'dart:async';

import 'package:board_games_companion/models/hive/board_game_category.dart';
import 'package:board_games_companion/widgets/common/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
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
import '../../widgets/common/board_game/board_game_property.dart';
import '../../widgets/common/board_game/collection_flags.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/loading_indicator_widget.dart';
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
    Key? key,
    required this.viewModel,
    required this.navigatingFromType,
    required this.preferencesService,
  }) : super(key: key);

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
            child: CustomScrollView(
              slivers: <Widget>[
                Observer(
                  builder: (_) {
                    return _Header(
                      boardGameImageHeroId: widget.viewModel.imageHeroId,
                      boardGameName: widget.viewModel.name,
                      boardGameImageUrl: widget.viewModel.imageUrl,
                    );
                  },
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(
                    bottom: Dimensions.halfFloatingActionButtonBottomSpacing,
                  ),
                  sliver: Observer(builder: (_) {
                    return _Body(
                      viewModel: widget.viewModel,
                      futureStatus: widget.viewModel.futureLoadBoardGameDetails?.status ??
                          FutureStatus.pending,
                      preferencesService: widget.preferencesService,
                    );
                  }),
                ),
              ],
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

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required String boardGameImageHeroId,
    required String boardGameName,
    required String? boardGameImageUrl,
  })  : _boardGameImageHeroId = boardGameImageHeroId,
        _boardGameName = boardGameName,
        _boardGameImageUrl = boardGameImageUrl,
        super(key: key);

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
    Key? key,
    required this.viewModel,
    required this.futureStatus,
    required this.preferencesService,
  }) : super(key: key);

  final BoardGameDetailsViewModel viewModel;
  final FutureStatus futureStatus;
  final PreferencesService preferencesService;

  static const _spacingBetweenSecions = Dimensions.doubleStandardSpacing;
  static const _halfSpacingBetweenSecions = Dimensions.standardSpacing;
  static const _sectionTopSpacing = Dimensions.standardSpacing;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (_) {
        switch (futureStatus) {
          case FutureStatus.pending:
            return const SliverFillRemaining(child: LoadingIndicator());

          case FutureStatus.rejected:
            return SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(Dimensions.standardSpacing),
                      child: Center(
                        child: Text(
                          '''
We couldn't retrieve any board games. Check your Internet connectivity and try again.''',
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.standardSpacing),
                    ElevatedIconButton(
                        title: 'Refresh',
                        icon: const DefaultIcon(Icons.refresh),
                        onPressed: () => viewModel.loadBoardGameDetails()),
                  ],
                ),
              ),
            );

          case FutureStatus.fulfilled:
            return SliverPadding(
              padding: const EdgeInsets.only(bottom: Dimensions.standardSpacing),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed(
                  <Widget>[
                    SectionHeader.titles(
                      primaryTitle: AppText.boardGameDetailsPaboutGeneralTitle,
                      secondaryTitle: AppText.boardGameDetailsPaboutCollectionsTitle,
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
                      SectionHeader.title(title: AppText.boardGameDetailsPaboutLinksTitle),
                      _Links(boardGameDetailsStore: viewModel),
                      const SizedBox(height: _halfSpacingBetweenSecions),
                      SectionHeader.title(title: AppText.boardGameDetailsPaboutCreditsTitle),
                      const SizedBox(height: _sectionTopSpacing),
                      _Credits(boardGameDetails: viewModel.boardGame),
                      const SizedBox(height: _halfSpacingBetweenSecions),
                      SectionHeader.title(
                        title: AppText.boardGameDetailsPaboutCategoriesTitle,
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
                        title: AppText.boardGameDetailsPaboutDescriptionTitle,
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
      },
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
          for (var category in categories)
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
    Key? key,
    required BoardGameDetailsViewModel boardGameDetailsStore,
  })  : _boardGameDetailsStore = boardGameDetailsStore,
        super(key: key);

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
        // TODO Wait until Board Game Oracle owner responds
        // const SizedBox(
        //   width: Dimensions.doubleStandardSpacing,
        // ),
        // Stack(
        //   children: [
        //     if (isPricingInCountrySupported)
        //       const SizedBox.shrink()
        //     else
        //       Positioned(
        //         top: Dimensions.standardSpacing,
        //         right: Dimensions.standardSpacing,
        //         child: Image.asset(
        //           'assets/flags/${Constants.UsaCountryCode.toLowerCase()}.png',
        //           width: 16,
        //           height: 12,
        //         ),
        //       ),
        //     _Link(
        //       title: isPricingInCountrySupported ? 'Prices' : '${Constants.UsaCountryCode} Prices',
        //       icon: Icons.attach_money,
        //       boardGameDetailsStore: _boardGameDetailsStore,
        //       onPressed: () async {
        //         await LauncherHelper.launchUri(
        //           context,
        //           _boardGameDetailsStore.boardGameDetails.boardGameOraclePriceUrl,
        //         );
        //       },
        //     ),
        //   ],
        // ),
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
    Key? key,
  }) : super(key: key);

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
    Key? key,
  }) : super(key: key);

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
    Key? key,
  }) : super(key: key);

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
    Key? key,
    required this.viewModel,
  }) : super(key: key);

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
                    propertyName: '${viewModel.boardGame.rankFormatted}',
                    fontSize: Dimensions.mediumFontSize,
                  ),
                  const SizedBox(height: Dimensions.halfStandardSpacing),
                  BoardGameProperty(
                    icon: const Icon(Icons.how_to_vote, size: _iconSize),
                    iconWidth: _iconSize,
                    propertyName: '${viewModel.boardGame.votesFormatted} ratings',
                    fontSize: Dimensions.mediumFontSize,
                  ),
                  const SizedBox(height: Dimensions.halfStandardSpacing),
                  BoardGameProperty(
                    icon: const Icon(Icons.comment, size: _iconSize),
                    iconWidth: _iconSize,
                    propertyName: '${viewModel.boardGame.commentsNumberFormatted} comments',
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
    Key? key,
  }) : super(key: key);

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
    Key? key,
  }) : super(key: key);

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
            if (avgWeight != null)
              Expanded(
                child: _InfoPanel(
                  icon: const FaIcon(FontAwesomeIcons.scaleUnbalanced),
                  title: '${avgWeight!.toStringAsFixed(2)} / 5',
                ),
              ),
            if (avgWeight == null) const Spacer()
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
    Key? key,
  }) : super(key: key);

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
