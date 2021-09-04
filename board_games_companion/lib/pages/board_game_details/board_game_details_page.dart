// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/enums/collection_type.dart';
import '../../common/routes.dart';
import '../../common/styles.dart';
import '../../models/hive/board_game_details.dart';
import '../../services/preferences_service.dart';
import '../../stores/board_game_details_in_collection_store.dart';
import '../../stores/board_game_details_store.dart';
import '../../stores/board_games_store.dart';
import '../../utilities/launcher_helper.dart';
import '../../widgets/board_games/board_game_image.dart';
import '../../widgets/board_games/board_game_rating_hexagon.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/page_container_widget.dart';
import '../../widgets/common/ripple_effect.dart';
import '../../widgets/common/shadow_box.dart';
import '../base_page_state.dart';
import '../playthroughs/playthroughs_page.dart';
import 'board_game_details_expansions.dart';

class BoardGamesDetailsPage extends StatefulWidget {
  const BoardGamesDetailsPage({
    Key key,
    @required this.boardGameDetailsStore,
    @required this.boardGameId,
    @required this.boardGameName,
    @required this.navigatingFromType,
    @required this.preferencesService,
  }) : super(key: key);

  final String boardGameId;
  final String boardGameName;
  final BoardGameDetailsStore boardGameDetailsStore;
  final Type navigatingFromType;
  final PreferencesService preferencesService;

  @override
  _BoardGamesDetailsPageState createState() => _BoardGamesDetailsPageState();
}

class _BoardGamesDetailsPageState extends BasePageState<BoardGamesDetailsPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppTheme.primaryColor,
    ));

    return WillPopScope(
      onWillPop: () async {
        return _handleOnWillPop(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: PageContainer(
            child: CustomScrollView(
              slivers: <Widget>[
                _Header(
                  boardGameDetailsStore: widget.boardGameDetailsStore,
                  boardGameName: widget.boardGameName,
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(
                    bottom: Dimensions.halfFloatingActionButtonBottomSpacing,
                  ),
                  sliver: _Body(
                    boardGameId: widget.boardGameId,
                    boardGameName: widget.boardGameName,
                    boardGameDetailsStore: widget.boardGameDetailsStore,
                    preferencesService: widget.preferencesService,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _handleOnWillPop(BuildContext context) async {
    final boardGamesStore = Provider.of<BoardGamesStore>(
      context,
      listen: false,
    );
    final boardGameDetailsInCollectionStore = BoardGameDetailsInCollectionStore(
      boardGamesStore,
      widget.boardGameDetailsStore?.boardGameDetails,
    );

    if (!boardGameDetailsInCollectionStore.isInCollection &&
        widget.navigatingFromType == PlaythroughsPage) {
      Navigator.popUntil(context, ModalRoute.withName(Routes.home));
      return false;
    }

    return true;
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key key,
    @required BoardGameDetailsStore boardGameDetailsStore,
    @required String boardGameName,
  })  : _boardGameDetailsStore = boardGameDetailsStore,
        _boardGameName = boardGameName,
        super(key: key);

  final String _boardGameName;
  final BoardGameDetailsStore _boardGameDetailsStore;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      expandedHeight: Constants.BoardGameDetailsImageHeight,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withAlpha(Styles.opacity70Percent),
            borderRadius: const BorderRadius.all(
              Radius.circular(Styles.defaultCornerRadius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              Dimensions.halfStandardSpacing,
            ),
            child: Text(
              _boardGameName ?? '',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppTheme.defaultTextColor,
                fontSize: Dimensions.largeFontSize,
              ),
            ),
          ),
        ),
        background: ChangeNotifierProvider<BoardGameDetailsStore>.value(
          value: _boardGameDetailsStore,
          child: Consumer<BoardGameDetailsStore>(
            builder: (_, store, __) {
              // TODO Add shadow to the image
              return BoardGameImage(
                _boardGameDetailsStore.boardGameDetails,
                minImageHeight: Constants.BoardGameDetailsImageHeight,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key key,
    @required this.boardGameId,
    @required this.boardGameName,
    @required this.boardGameDetailsStore,
    @required this.preferencesService,
  }) : super(key: key);

  final String boardGameId;
  final String boardGameName;
  final BoardGameDetailsStore boardGameDetailsStore;
  final PreferencesService preferencesService;

  static const _spacingBetweenSecions = Dimensions.doubleStandardSpacing;
  static const _halfSpacingBetweenSecions = Dimensions.standardSpacing;

  @override
  Widget build(BuildContext context) {
    final htmlUnescape = HtmlUnescape();
    return FutureBuilder(
      future: boardGameDetailsStore.loadBoardGameDetails(boardGameId),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(
                    Dimensions.doubleStandardSpacing,
                  ),
                  child: Text(
                    '''
Sorry, we couldn't retrieve $boardGameName's details. Check your Internet connectivity and try again. If the problem persists, please contact support at feedback@progrunning.net''',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            );
          }

          return ChangeNotifierProvider<BoardGameDetailsStore>.value(
            value: boardGameDetailsStore,
            child: Consumer<BoardGameDetailsStore>(
              builder: (_, store, __) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.standardSpacing,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed(
                      <Widget>[
                        const _BodySectionHeader(
                          title: 'Stats',
                          secondaryTitle: 'Collections',
                        ),
                        _StatsAndCollections(
                          boardGameDetailsStore: boardGameDetailsStore,
                        ),
                        const SizedBox(
                          height: _spacingBetweenSecions,
                        ),
                        const _BodySectionHeader(
                          title: 'General',
                        ),
                        _FirstRowGeneralInfoPanels(
                          boardGameDetails: boardGameDetailsStore.boardGameDetails,
                        ),
                        const SizedBox(
                          height: _spacingBetweenSecions,
                        ),
                        _SecondRowGeneralInfoPanels(
                          boardGameDetails: boardGameDetailsStore.boardGameDetails,
                        ),
                        const SizedBox(
                          height: _spacingBetweenSecions,
                        ),
                        const _BodySectionHeader(
                          title: 'Links',
                        ),
                        _Links(
                          boardGameDetailsStore: boardGameDetailsStore,
                        ),
                        const SizedBox(
                          height: _halfSpacingBetweenSecions,
                        ),
                        const _BodySectionHeader(
                          title: 'Credits',
                        ),
                        _Credits(
                          boardGameDetails: boardGameDetailsStore.boardGameDetails,
                        ),
                        const SizedBox(
                          height: _halfSpacingBetweenSecions,
                        ),
                        const _BodySectionHeader(
                          title: 'Categories',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.standardSpacing,
                          ),
                          child: Wrap(
                            direction: Axis.horizontal,
                            spacing: Dimensions.standardSpacing,
                            alignment: WrapAlignment.spaceEvenly,
                            children: boardGameDetailsStore.boardGameDetails.categories
                                .map<Widget>((category) {
                              return Chip(
                                padding: const EdgeInsets.all(
                                  Dimensions.standardSpacing,
                                ),
                                backgroundColor: AppTheme.primaryColor.withAlpha(
                                  Styles.opacity80Percent,
                                ),
                                label: Text(
                                  category.name,
                                  style: const TextStyle(
                                    color: AppTheme.defaultTextColor,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        if (!store.boardGameDetails.isExpansion &&
                            store.boardGameDetails.expansions.isNotEmpty)
                          BoardGameDetailsExpansions(
                            boardGameDetailsStore: store,
                            spacingBetweenSecions: _spacingBetweenSecions,
                            preferencesService: preferencesService,
                          ),
                        const SizedBox(
                          height: _spacingBetweenSecions,
                        ),
                        const _BodySectionHeader(
                          title: 'Description',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.standardSpacing,
                          ),
                          child: Text(
                            htmlUnescape.convert(store.boardGameDetails.description),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(fontSize: Dimensions.mediumFontSize),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
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
                  IconAndTextButton(
                    title: 'Refresh',
                    icon: const DefaultIcon(
                      Icons.refresh,
                    ),
                    onPressed: () => _refreshBoardGameDetails(
                      boardGameId,
                      boardGameDetailsStore,
                    ),
                  )
                ],
              ),
            ),
          );
        }

        return const SliverFillRemaining(
          child: LoadingIndicator(),
        );
      },
    );
  }

  Future<void> _refreshBoardGameDetails(
    String boardGameDetailsId,
    BoardGameDetailsStore boardGameDetailsStore,
  ) async {
    await boardGameDetailsStore.loadBoardGameDetails(boardGameDetailsId);
  }
}

class _Links extends StatelessWidget {
  const _Links({
    Key key,
    @required BoardGameDetailsStore boardGameDetailsStore,
  })  : _boardGameDetailsStore = boardGameDetailsStore,
        super(key: key);

  final BoardGameDetailsStore _boardGameDetailsStore;

  @override
  Widget build(BuildContext context) {
    // final bool isPricingInCountrySupported =
    //     Constants.BoardGameOracleSupportedCultureNames.contains(
    //         Platform.localeName.replaceFirst('_', '-'));

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
                _boardGameDetailsStore.boardGameDetails.bggOverviewUrl,
              );
            }),
        const SizedBox(
          width: Dimensions.doubleStandardSpacing,
        ),
        _Link(
          title: 'Videos',
          icon: Icons.videocam,
          boardGameDetailsStore: _boardGameDetailsStore,
          onPressed: () async {
            await LauncherHelper.launchUri(
              context,
              _boardGameDetailsStore.boardGameDetails.bggHotVideosUrl,
            );
          },
        ),
        const SizedBox(
          width: Dimensions.doubleStandardSpacing,
        ),
        _Link(
          title: 'Forums',
          icon: Icons.forum,
          boardGameDetailsStore: _boardGameDetailsStore,
          onPressed: () async {
            await LauncherHelper.launchUri(
              context,
              _boardGameDetailsStore.boardGameDetails.bggHotForumUrl,
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
    @required this.title,
    @required this.icon,
    @required this.boardGameDetailsStore,
    @required this.onPressed,
    Key key,
  }) : super(key: key);

  final BoardGameDetailsStore boardGameDetailsStore;
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RippleEffect(
      onTap: () async {
        onPressed?.call();
        await boardGameDetailsStore.captureLinkAnalytics(title);
      },
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.standardSpacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppTheme.accentColor,
              size: Dimensions.boardGameDetailsLinkIconSize,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: Dimensions.smallFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BodySectionHeader extends StatelessWidget {
  const _BodySectionHeader({
    @required this.title,
    this.secondaryTitle,
    Key key,
  }) : super(key: key);

  final String title;
  final String secondaryTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.standardSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.sectionHeaderTextStyle,
              ),
              if (secondaryTitle?.isEmpty ?? true)
                const SizedBox.shrink()
              else ...[
                const Expanded(
                  child: SizedBox.shrink(),
                ),
                Text(
                  secondaryTitle,
                  style: AppTheme.sectionHeaderTextStyle,
                ),
              ]
            ],
          ),
          const SizedBox(
            height: Dimensions.halfStandardSpacing,
          ),
        ],
      ),
    );
  }
}

class _Credits extends StatelessWidget {
  const _Credits({
    @required this.boardGameDetails,
    Key key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;

  static const _spacingBetweenCredits = Dimensions.standardSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.standardSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _CreditsItem(
            title: 'Designer:',
            detail: boardGameDetails?.desingers?.map((d) => d.name)?.join(', '),
          ),
          const SizedBox(
            height: _spacingBetweenCredits,
          ),
          _CreditsItem(
            title: 'Artist:',
            detail: boardGameDetails?.artists?.map((d) => d.name)?.join(', '),
          ),
          const SizedBox(
            height: _spacingBetweenCredits,
          ),
          _CreditsItem(
            title: 'Publisher:',
            detail: boardGameDetails?.publishers?.map((d) => d.name)?.join(', '),
          ),
        ],
      ),
    );
  }
}

class _CreditsItem extends StatelessWidget {
  const _CreditsItem({
    @required this.title,
    @required this.detail,
    Key key,
  }) : super(key: key);

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title ?? '',
            style: AppTheme.titleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: detail ?? '',
          ),
        ],
      ),
    );
  }
}

class _StatsAndCollections extends StatelessWidget {
  const _StatsAndCollections({
    Key key,
    @required this.boardGameDetailsStore,
  }) : super(key: key);

  final BoardGameDetailsStore boardGameDetailsStore;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: BoardGameRatingHexagon(
              rating: boardGameDetailsStore.boardGameDetails?.rating,
            ),
          ),
          const SizedBox(
            width: Dimensions.standardSpacing,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _DetailsNumbersItem(
                  title: 'Rank',
                  detail: boardGameDetailsStore.boardGameDetails?.rankFormatted,
                ),
                const SizedBox(height: Dimensions.halfStandardSpacing),
                _DetailsNumbersItem(
                  title: 'Ratings',
                  detail: '${boardGameDetailsStore.boardGameDetails?.votes}',
                  format: true,
                ),
                const SizedBox(height: Dimensions.halfStandardSpacing),
                _DetailsNumbersItem(
                  title: 'Comments',
                  detail: '${boardGameDetailsStore.boardGameDetails?.commentsNumber}',
                  format: true,
                ),
                const SizedBox(height: Dimensions.halfStandardSpacing),
                _DetailsNumbersItem(
                  title: 'Published',
                  detail: '${boardGameDetailsStore.boardGameDetails?.yearPublished}',
                ),
              ],
            ),
          ),
          _CollectionFlags(
            boardGameDetailsStore: boardGameDetailsStore,
          ),
        ],
      ),
    );
  }
}

class _CollectionFlags extends StatelessWidget {
  const _CollectionFlags({
    @required this.boardGameDetailsStore,
    Key key,
  }) : super(key: key);

  final BoardGameDetailsStore boardGameDetailsStore;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: boardGameDetailsStore.boardGameDetails,
      child: Consumer<BoardGameDetails>(
        builder: (_, BoardGameDetails boardGameDetailsProvider, __) {
          return Column(
            children: [
              ToggleButtons(
                splashColor: AppTheme.accentColor.withAlpha(Styles.opacity30Percent),
                fillColor: Colors.transparent,
                selectedColor: Colors.white,
                selectedBorderColor: Colors.transparent,
                disabledBorderColor: Colors.transparent,
                borderColor: Colors.transparent,
                isSelected: [
                  boardGameDetailsProvider.isFriends,
                  boardGameDetailsProvider.isOnWishlist
                ],
                children: <Widget>[
                  _CollectionFlag(
                    icon: Icons.group,
                    title: 'Friends',
                    isSelected: boardGameDetailsProvider.isFriends,
                  ),
                  _CollectionFlag(
                    icon: Icons.card_giftcard,
                    title: 'Wishlist',
                    isSelected: boardGameDetailsProvider.isOnWishlist,
                  ),
                ],
                onPressed: (int index) async {
                  await boardGameDetailsStore.toggleCollection(
                    index == 0 ? CollectionType.Friends : CollectionType.Wishlist,
                  );
                },
              ),
              ToggleButtons(
                splashColor: AppTheme.accentColor.withAlpha(Styles.opacity30Percent),
                fillColor: Colors.transparent,
                selectedColor: Colors.white,
                selectedBorderColor: Colors.transparent,
                borderColor: Colors.transparent,
                isSelected: [boardGameDetailsProvider.isOwned],
                children: <Widget>[
                  _CollectionFlag(
                    icon: Icons.grid_on,
                    title: 'Owned',
                    isSelected: boardGameDetailsProvider.isOwned,
                  ),
                ],
                onPressed: (int index) async {
                  await boardGameDetailsStore.toggleCollection(CollectionType.Owned);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CollectionFlag extends StatelessWidget {
  const _CollectionFlag({
    @required this.icon,
    @required this.title,
    @required this.isSelected,
    Key key,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.standardSpacing, vertical: Dimensions.halfStandardSpacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.accentColor : AppTheme.deselectedTabIconColor,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: Dimensions.smallFontSize,
                  color: isSelected ? AppTheme.defaultTextColor : AppTheme.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FirstRowGeneralInfoPanels extends StatelessWidget {
  const _FirstRowGeneralInfoPanels({
    @required this.boardGameDetails,
    Key key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.standardSpacing,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: _InfoPanel(
                title: '${boardGameDetails.minPlayers} - ${boardGameDetails.maxPlayers} Players',
              ),
            ),
            const SizedBox(
              width: Dimensions.standardSpacing,
            ),
            Flexible(
              child: _InfoPanel(
                title: '${boardGameDetails.playtimeFormatted} Min',
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
    @required this.boardGameDetails,
    Key key,
  }) : super(key: key);

  final BoardGameDetails boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.standardSpacing,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: _InfoPanel(
                title: 'Age: ${boardGameDetails.minAge}+',
              ),
            ),
            const SizedBox(
              width: Dimensions.standardSpacing,
            ),
            Flexible(
              child: _InfoPanel(
                title: 'Weight: ${boardGameDetails.avgWeight?.toStringAsFixed(2)} / 5',
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
    @required this.title,
    this.subtitle,
    Key key,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
      child: Container(
        color: AppTheme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.halfStandardSpacing,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  title ?? '',
                  textAlign: TextAlign.center,
                  style: AppTheme.titleTextStyle,
                ),
                if (subtitle?.isNotEmpty ?? false)
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: AppTheme.subTitleTextStyle,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailsNumbersItem extends StatelessWidget {
  const _DetailsNumbersItem({
    Key key,
    @required String title,
    @required String detail,
    bool format = false,
  })  : _title = title,
        _detail = detail,
        _format = format,
        super(key: key);

  final String _title;
  final String _detail;
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

  String _formatNumber() {
    if (_detail?.isEmpty ?? true) {
      return '';
    }

    final number = num.tryParse(_detail);
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
