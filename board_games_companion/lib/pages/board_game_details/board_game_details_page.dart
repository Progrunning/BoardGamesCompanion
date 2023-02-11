import 'dart:async';

import 'package:board_games_companion/models/navigation/create_board_game_page_arguments.dart';
import 'package:board_games_companion/pages/create_board_game/create_board_game_page.dart';
import 'package:board_games_companion/widgets/elevated_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../injectable.dart';
import '../../models/hive/board_game_details.dart';
import '../../services/preferences_service.dart';
import '../../stores/board_games_store.dart';
import '../../utilities/launcher_helper.dart';
import '../../widgets/board_games/bgc_flexible_space_bar.dart';
import '../../widgets/board_games/board_game_rating_hexagon.dart';
import '../../widgets/common/board_game/collection_flags.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/common/ripple_effect.dart';
import '../base_page_state.dart';
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
    unawaited(
      Navigator.pushNamed(
        context,
        CreateBoardGamePage.pageRoute,
        arguments: CreateBoardGamePageArguments(
          boardGameId: widget.viewModel.id,
          boardGameName: widget.viewModel.name,
        ),
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
                    const SizedBox(
                      height: Dimensions.standardSpacing,
                    ),
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
              padding: const EdgeInsets.symmetric(vertical: Dimensions.standardSpacing),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed(
                  <Widget>[
                    const _BodySectionHeader(title: 'Stats', secondaryTitle: 'Collections'),
                    _StatsAndCollections(viewModel: viewModel),
                    const SizedBox(height: _spacingBetweenSecions),
                    const _BodySectionHeader(title: 'General'),
                    _FirstRowGeneralInfoPanels(boardGameDetails: viewModel.boardGame),
                    const SizedBox(height: _spacingBetweenSecions),
                    _SecondRowGeneralInfoPanels(boardGameDetails: viewModel.boardGame),
                    const SizedBox(height: _spacingBetweenSecions),
                    if (!viewModel.isCreatedByUser) ...[
                      const _BodySectionHeader(title: 'Links'),
                      _Links(boardGameDetailsStore: viewModel),
                      const SizedBox(height: _halfSpacingBetweenSecions),
                      const _BodySectionHeader(title: 'Credits'),
                      _Credits(boardGameDetails: viewModel.boardGame),
                      const SizedBox(height: _halfSpacingBetweenSecions),
                      const _BodySectionHeader(title: 'Categories'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: Dimensions.standardSpacing,
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            for (var category in viewModel.boardGame.categories!)
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
                      ),
                      if (viewModel.isMainGame && viewModel.hasExpansions)
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
                      const SizedBox(height: _spacingBetweenSecions),
                      const _BodySectionHeader(title: 'Description'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                        child: Text(
                          viewModel.unescapedDescription,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: Dimensions.mediumFontSize),
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

class _BodySectionHeader extends StatelessWidget {
  const _BodySectionHeader({
    required this.title,
    this.secondaryTitle,
    Key? key,
  }) : super(key: key);

  final String title;
  final String? secondaryTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTheme.sectionHeaderTextStyle),
              if (secondaryTitle?.isEmpty ?? true)
                const SizedBox.shrink()
              else ...[
                const Expanded(child: SizedBox.shrink()),
                Text(secondaryTitle!, style: AppTheme.sectionHeaderTextStyle),
              ]
            ],
          ),
          const SizedBox(height: Dimensions.halfStandardSpacing),
        ],
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
            detail: boardGameDetails?.desingers.map((d) => d.name).join(', '),
          ),
          const SizedBox(height: _spacingBetweenCredits),
          _CreditsItem(
            title: 'Artist:',
            detail: boardGameDetails?.artists.map((d) => d.name).join(', '),
          ),
          const SizedBox(height: _spacingBetweenCredits),
          _CreditsItem(
            title: 'Publisher:',
            detail: boardGameDetails?.publishers.map((d) => d.name).join(', '),
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
            style: AppTheme.titleTextStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: ' '),
          TextSpan(text: detail),
        ],
      ),
    );
  }
}

class _StatsAndCollections extends StatelessWidget {
  const _StatsAndCollections({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final BoardGameDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(child: BoardGameRatingHexagon(rating: viewModel.boardGame.rating)),
          const SizedBox(width: Dimensions.standardSpacing),
          if (viewModel.isCreatedByUser) const Spacer(),
          if (!viewModel.isCreatedByUser)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _DetailsNumbersItem(
                    title: 'Rank',
                    detail: viewModel.boardGame.rankFormatted,
                  ),
                  const SizedBox(height: Dimensions.halfStandardSpacing),
                  _DetailsNumbersItem(
                    title: 'Ratings',
                    detail: '${viewModel.boardGame.votes}',
                    format: true,
                  ),
                  const SizedBox(height: Dimensions.halfStandardSpacing),
                  _DetailsNumbersItem(
                    title: 'Comments',
                    detail: '${viewModel.boardGame.commentsNumber}',
                    format: true,
                  ),
                  const SizedBox(height: Dimensions.halfStandardSpacing),
                  _DetailsNumbersItem(
                    title: 'Published',
                    detail: '${viewModel.boardGame.yearPublished}',
                  ),
                ],
              ),
            ),
          Observer(
            builder: (_) {
              return CollectionFlags(
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
    required this.boardGameDetails,
    Key? key,
  }) : super(key: key);

  final BoardGameDetails? boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(child: _InfoPanel(title: boardGameDetails!.playersFormatted)),
            const SizedBox(width: Dimensions.standardSpacing),
            Flexible(
              child: _InfoPanel(
                title: boardGameDetails!.playtimeFormatted,
                subtitle: 'Playing Time',
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
    required this.boardGameDetails,
    Key? key,
  }) : super(key: key);

  final BoardGameDetails? boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: _InfoPanel(
                title: 'Age: ${boardGameDetails!.minAge}+',
              ),
            ),
            const SizedBox(width: Dimensions.standardSpacing),
            Flexible(
              child: _InfoPanel(
                title: 'Weight: ${boardGameDetails!.avgWeight?.toStringAsFixed(2)} / 5',
                subtitle: 'Complexity Rating',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.title,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      elevation: AppStyles.defaultElevation,
      backgroundColor: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.halfStandardSpacing),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTheme.titleTextStyle,
              ),
              if (subtitle?.isNotEmpty ?? false)
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: AppTheme.subTitleTextStyle,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsNumbersItem extends StatelessWidget {
  const _DetailsNumbersItem({
    Key? key,
    required String title,
    required String? detail,
    bool format = false,
  })  : _title = title,
        _detail = detail,
        _format = format,
        super(key: key);

  final String _title;
  final String? _detail;
  final bool _format;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$_title: ',
          ),
          TextSpan(
            text: _formatNumber(),
            style: AppTheme.titleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String? _formatNumber() {
    if (_detail?.isEmpty ?? true) {
      return '';
    }

    final number = num.tryParse(_detail!);
    if (number == null) {
      return _detail;
    }

    if (!_format || number < 1000) {
      return number.toString();
    }

    final numberOfThousands = number / 1000;
    return '${numberOfThousands.round()}k';
  }
}
