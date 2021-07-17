import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../common/routes.dart';
import '../../common/styles.dart';
import '../../models/hive/board_game_details.dart';
import '../../stores/board_game_details_in_collection_store.dart';
import '../../stores/board_game_details_store.dart';
import '../../stores/board_games_store.dart';
import '../../utilities/launcher_helper.dart';
import '../../widgets/board_games/board_game_detail_floating_actions_widget.dart';
import '../../widgets/board_games/board_game_image.dart';
import '../../widgets/board_games/board_game_rating_hexagon.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/page_container_widget.dart';
import '../../widgets/common/shadow_box_widget.dart';
import '../base_page_state.dart';
import '../board_game_playthroughs.dart';
import 'board_game_details_expansions.dart';

class BoardGamesDetailsPage extends StatefulWidget {
  final String boardGameId;
  final String boardGameName;
  final BoardGameDetailsStore boardGameDetailsStore;
  final Type navigatingFromType;

  const BoardGamesDetailsPage({
    Key key,
    @required boardGameDetailsStore,
    @required boardGameId,
    @required boardGameName,
    @required navigatingFromType,
  })  : boardGameDetailsStore = boardGameDetailsStore,
        boardGameId = boardGameId,
        boardGameName = boardGameName,
        navigatingFromType = navigatingFromType,
        super(key: key);

  @override
  _BoardGamesDetailsPageState createState() => _BoardGamesDetailsPageState();
}

class _BoardGamesDetailsPageState extends BasePageState<BoardGamesDetailsPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
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
                  padding: EdgeInsets.only(
                    bottom: Dimensions.halfFloatingActionButtonBottomSpacing,
                  ),
                  sliver: _Body(
                    boardGameId: widget.boardGameId,
                    boardGameName: widget.boardGameName,
                    boardGameDetailsStore: widget.boardGameDetailsStore,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: BoardGameDetailFloatingActions(
          boardGameDetailsStore: widget.boardGameDetailsStore,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        widget.navigatingFromType == BoardGamePlaythroughsPage) {
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
            borderRadius: BorderRadius.all(
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
              style: TextStyle(
                  color: AppTheme.defaultTextColor,
                  fontSize: Dimensions.largeFontSize),
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
    @required boardGameId,
    @required boardGameName,
    @required boardGameDetailsStore,
  })  : _boardGameId = boardGameId,
        _boardGameName = boardGameName,
        _boardGameDetailsStore = boardGameDetailsStore,
        super(key: key);

  final String _boardGameId;
  final String _boardGameName;
  final BoardGameDetailsStore _boardGameDetailsStore;

  static const _spacingBetweenSecions = Dimensions.doubleStandardSpacing;
  static const _halfSpacingBetweenSecions = Dimensions.standardSpacing;

  @override
  Widget build(BuildContext context) {
    final htmlUnescape = new HtmlUnescape();
    return FutureBuilder(
      future: _boardGameDetailsStore.loadBoardGameDetails(_boardGameId),
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
                    'Sorry, we couldn\'t retrieve $_boardGameName\'s details. Check your Internet connectivity and try again. If the problem persists, please contact support at feedback@progrunning.net',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            );
          }

          return ChangeNotifierProvider<BoardGameDetailsStore>.value(
            value: _boardGameDetailsStore,
            child: Consumer<BoardGameDetailsStore>(
              builder: (_, store, __) {
                return SliverPadding(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.standardSpacing,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed(
                      <Widget>[
                        _BodySectionHeader(
                          title: 'Stats',
                        ),
                        _Stats(
                          boardGameDetails:
                              _boardGameDetailsStore.boardGameDetails,
                        ),
                        SizedBox(
                          height: _spacingBetweenSecions,
                        ),
                        _BodySectionHeader(
                          title: 'General',
                        ),
                        _FirstRowGeneralInfoPanels(
                          boardGameDetails:
                              _boardGameDetailsStore.boardGameDetails,
                        ),
                        SizedBox(
                          height: _spacingBetweenSecions,
                        ),
                        _SecondRowGeneralInfoPanels(
                          boardGameDetails:
                              _boardGameDetailsStore.boardGameDetails,
                        ),
                        SizedBox(
                          height: _spacingBetweenSecions,
                        ),
                        _BodySectionHeader(
                          title: 'Links',
                        ),
                        _Links(
                          boardGameDetailsStore: _boardGameDetailsStore,
                        ),
                        SizedBox(
                          height: _halfSpacingBetweenSecions,
                        ),
                        _BodySectionHeader(
                          title: 'Credits',
                        ),
                        _Credits(
                          boardGameDetails:
                              _boardGameDetailsStore.boardGameDetails,
                        ),
                        SizedBox(
                          height: _halfSpacingBetweenSecions,
                        ),
                        _BodySectionHeader(
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
                            children: _boardGameDetailsStore
                                .boardGameDetails.categories
                                .map<Widget>((category) {
                              return Chip(
                                padding: EdgeInsets.all(
                                  Dimensions.standardSpacing,
                                ),
                                backgroundColor:
                                    AppTheme.primaryColor.withAlpha(
                                  Styles.opacity80Percent,
                                ),
                                label: Text(
                                  category.name,
                                  style: TextStyle(
                                    color: AppTheme.defaultTextColor,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        if (!store.boardGameDetails.isExpansion &&
                            store.boardGameDetails.expansions.length > 0)
                          BoardGameDetailsExpansions(
                            boardGameDetailsStore: store,
                            spacingBetweenSecions: _spacingBetweenSecions,
                          ),
                        SizedBox(
                          height: _spacingBetweenSecions,
                        ),
                        _BodySectionHeader(
                          title: 'Description',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.standardSpacing,
                          ),
                          child: Text(
                            htmlUnescape
                                .convert(store.boardGameDetails.description),
                            textAlign: TextAlign.justify,
                            style:
                                TextStyle(fontSize: Dimensions.mediumFontSize),
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
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.standardSpacing),
                    child: Center(
                      child: Text(
                        'We couldn\'t retrieve any board games. Check your Internet connectivity and try again.',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.standardSpacing,
                  ),
                  IconAndTextButton(
                    title: 'Refresh',
                    icon: Icons.refresh,
                    onPressed: () => _refreshBoardGameDetails(
                      _boardGameId,
                      _boardGameDetailsStore,
                    ),
                  )
                ],
              ),
            ),
          );
        }

        return SliverFillRemaining(
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
    final bool isPricingInCountrySupported =
        Constants.BoardGameOracleSupportedCultureNames.contains(
            Platform.localeName.replaceFirst('_', '-'));

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
        SizedBox(
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
        SizedBox(
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
        SizedBox(
          width: Dimensions.doubleStandardSpacing,
        ),
        Stack(
          children: [
            isPricingInCountrySupported
                ? SizedBox.shrink()
                : Positioned(
                    top: Dimensions.standardSpacing,
                    right: Dimensions.standardSpacing,
                    child: Image.asset(
                      'assets/flags/${Constants.UsaCountryCode.toLowerCase()}.png',
                      width: 16,
                      height: 12,
                    ),
                  ),
            _Link(
              title: isPricingInCountrySupported
                  ? 'Prices'
                  : '${Constants.UsaCountryCode} Prices',
              icon: Icons.attach_money,
              boardGameDetailsStore: _boardGameDetailsStore,
              onPressed: () async {
                await LauncherHelper.launchUri(
                  context,
                  _boardGameDetailsStore
                      .boardGameDetails.boardGameOraclePriceUrl,
                );
              },
            ),
          ],
        ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
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
                style: TextStyle(
                  fontSize: Dimensions.smallFontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BodySectionHeader extends StatelessWidget {
  const _BodySectionHeader({
    @required title,
    Key key,
  })  : _title = title,
        super(key: key);

  final String _title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.standardSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            _title,
            style: AppTheme.sectionHeaderTextStyle,
          ),
          SizedBox(
            height: Dimensions.halfStandardSpacing,
          ),
        ],
      ),
    );
  }
}

class _Credits extends StatelessWidget {
  const _Credits({
    @required boardGameDetails,
    Key key,
  })  : _boardGameDetails = boardGameDetails,
        super(key: key);

  final BoardGameDetails _boardGameDetails;

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
            detail:
                _boardGameDetails?.desingers?.map((d) => d.name)?.join(', '),
          ),
          SizedBox(
            height: _spacingBetweenCredits,
          ),
          _CreditsItem(
            title: 'Artist:',
            detail: _boardGameDetails?.artists?.map((d) => d.name)?.join(', '),
          ),
          SizedBox(
            height: _spacingBetweenCredits,
          ),
          Container(
            child: _CreditsItem(
              title: 'Publisher:',
              detail:
                  _boardGameDetails?.publishers?.map((d) => d.name)?.join(', '),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditsItem extends StatelessWidget {
  const _CreditsItem({
    @required title,
    @required detail,
    Key key,
  })  : _title = title,
        _detail = detail,
        super(key: key);

  final String _title;
  final String _detail;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: _title ?? '',
            style: AppTheme.titleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: _detail ?? '',
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({
    Key key,
    @required BoardGameDetails boardGameDetails,
  })  : _boardGameDetails = boardGameDetails,
        super(key: key);

  final BoardGameDetails _boardGameDetails;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: BoardGameRatingHexagon(
              rating: _boardGameDetails?.rating,
            ),
          ),
          SizedBox(
            width: Dimensions.standardSpacing,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _DetailsNumbersItem(
                  title: 'Rank',
                  detail: _boardGameDetails?.rankFormatted,
                ),
                const SizedBox(height: Dimensions.halfStandardSpacing),
                _DetailsNumbersItem(
                  title: 'Ratings',
                  detail: '${_boardGameDetails?.votes}',
                  format: true,
                ),
                const SizedBox(height: Dimensions.halfStandardSpacing),
                _DetailsNumbersItem(
                  title: 'Comments',
                  detail: '${_boardGameDetails?.commentsNumber}',
                  format: true,
                ),
                const SizedBox(height: Dimensions.halfStandardSpacing),
                _DetailsNumbersItem(
                  title: 'Published',
                  detail: '${_boardGameDetails?.yearPublished}',
                ),
              ],
            ),
          ),
          const _CollectionFlags(),
        ],
      ),
    );
  }
}

class _CollectionFlags extends StatelessWidget {
  const _CollectionFlags({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleButtons(
          splashColor: AppTheme.accentColor.withAlpha(Styles.opacity30Percent),
          fillColor: Colors.transparent,
          selectedColor: Colors.white,
          selectedBorderColor: Colors.transparent,
          borderColor: Colors.transparent,
          isSelected: [false, true],
          children: [
            _CollectionFlag(
              icon: Icons.sports_esports,
              title: 'Played',
              isSelected: false,
            ),            
            _CollectionFlag(
              icon: Icons.card_giftcard,
              title: 'Wishlist',
              isSelected: false,
            ),
          ],
          onPressed: (int index) {},
        ),
        ToggleButtons(
          splashColor: AppTheme.accentColor.withAlpha(Styles.opacity30Percent),
          fillColor: Colors.transparent,
          selectedColor: Colors.white,
          selectedBorderColor: Colors.transparent,
          borderColor: Colors.transparent,
          isSelected: [false],
          children: [
            _CollectionFlag(
              icon: Icons.grid_on,
              title: 'Collection',
              isSelected: true,
            ),
          ],
          onPressed: (int index) {},
        ),
      ],
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
            horizontal: Dimensions.standardSpacing,
            vertical: Dimensions.halfStandardSpacing
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppTheme.accentColor
                    : AppTheme.deselectedBottomTabIconColor,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: Dimensions.smallFontSize,
                  color: isSelected
                      ? AppTheme.defaultTextColor
                      : AppTheme.secondaryTextColor,
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
    @required boardGameDetails,
    Key key,
  })  : _boardGameDetails = boardGameDetails,
        super(key: key);

  final BoardGameDetails _boardGameDetails;

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
                title:
                    '${_boardGameDetails.minPlayers} - ${_boardGameDetails.maxPlayers} Players',
              ),
            ),
            SizedBox(
              width: Dimensions.standardSpacing,
            ),
            Flexible(
              child: _InfoPanel(
                title: '${_boardGameDetails.playtimeFormatted} Min',
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
    @required boardGameDetails,
    Key key,
  })  : _boardGameDetails = boardGameDetails,
        super(key: key);

  final BoardGameDetails _boardGameDetails;

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
                title: 'Age: ${_boardGameDetails.minAge}+',
              ),
            ),
            SizedBox(
              width: Dimensions.standardSpacing,
            ),
            Flexible(
              child: _InfoPanel(
                title:
                    'Weight: ${_boardGameDetails.avgWeight?.toStringAsFixed(2)} / 5',
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
    @required title,
    subtitle,
    Key key,
  })  : _title = title,
        _subtitle = subtitle,
        super(key: key);

  final String _title;
  final String _subtitle;

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
                  _title ?? '',
                  textAlign: TextAlign.center,
                  style: AppTheme.titleTextStyle,
                ),
                if (_subtitle?.isNotEmpty ?? false)
                  Text(
                    _subtitle,
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
  _DetailsNumbersItem({
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
