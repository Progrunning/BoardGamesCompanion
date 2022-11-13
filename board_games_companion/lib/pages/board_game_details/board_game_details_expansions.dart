import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/board_game_expansion.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
import '../../services/preferences_service.dart';
import 'board_game_details_page.dart';

class BoardGameDetailsExpansions extends StatefulWidget {
  const BoardGameDetailsExpansions({
    Key? key,
    required this.expansions,
    required this.totalExpansionsOwned,
    required this.spacingBetweenSecions,
    // TODO MK Pass in requier preferences data (instead of entire service) and or handle the events outside of this widget
    required this.preferencesService,
  }) : super(key: key);

  final List<BoardGameExpansion> expansions;
  final int totalExpansionsOwned;
  final double spacingBetweenSecions;
  final PreferencesService? preferencesService;

  @override
  BoardGameDetailsExpansionsState createState() => BoardGameDetailsExpansionsState();
}

class BoardGameDetailsExpansionsState extends State<BoardGameDetailsExpansions> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: widget.spacingBetweenSecions),
        Material(
          color: Colors.transparent,
          child: Theme(
            data: AppTheme.theme.copyWith(unselectedWidgetColor: AppColors.accentColor),
            child: _Expansions(
              expansions: widget.expansions,
              totalExpansionsOwned: widget.totalExpansionsOwned,
              preferencesService: widget.preferencesService!,
              initiallyExpanded: widget.preferencesService!.getExpansionsPanelExpandedState(),
            ),
          ),
        ),
      ],
    );
  }
}

class _Expansions extends StatelessWidget {
  const _Expansions({
    Key? key,
    required this.expansions,
    required this.totalExpansionsOwned,
    required this.preferencesService,
    required this.initiallyExpanded,
  }) : super(key: key);

  final List<BoardGameExpansion> expansions;
  final int totalExpansionsOwned;
  final PreferencesService preferencesService;
  final bool? initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          'Expansions (${expansions.length})',
          style: const TextStyle(fontSize: Dimensions.standardFontSize),
        ),
        textColor: AppColors.accentColor,
        collapsedTextColor: AppColors.secondaryTextColor,
        iconColor: AppColors.accentColor,
        collapsedIconColor: AppColors.accentColor,
        subtitle: Text(
          totalExpansionsOwned == 0
              ? "You don't own any expansions"
              : 'You own $totalExpansionsOwned expansion(s)',
          style: const TextStyle(
            color: AppColors.defaultTextColor,
            fontSize: Dimensions.smallFontSize,
          ),
        ),
        tilePadding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
        initiallyExpanded: initiallyExpanded!,
        onExpansionChanged: (bool isExpanded) async =>
            preferencesService.setExpansionsPanelExpandedState(isExpanded),
        children: [
          for (final BoardGameExpansion expansion in expansions)
            // TODO Test if updates propertly
            _Expansion(boardGamesExpansion: expansion),
        ],
      ),
    );
  }
}

class _Expansion extends StatelessWidget {
  const _Expansion({
    Key? key,
    required BoardGameExpansion boardGamesExpansion,
  })  : _boardGameExpansion = boardGamesExpansion,
        super(key: key);

  final BoardGameExpansion _boardGameExpansion;

  @override
  Widget build(BuildContext context) {
    final Widget expansionItem = InkWell(
      splashColor: AppColors.accentColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.doubleStandardSpacing,
          horizontal: Dimensions.standardSpacing,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                _boardGameExpansion.name,
                style: AppTheme.theme.textTheme.headline3,
              ),
            ),
            const Icon(Icons.navigate_next, color: AppColors.accentColor),
          ],
        ),
      ),
      onTap: () async {
        await Navigator.pushNamed(
          context,
          BoardGamesDetailsPage.pageRoute,
          arguments: BoardGameDetailsPageArguments(
            _boardGameExpansion.id,
            _boardGameExpansion.name,
            BoardGamesDetailsPage,
          ),
        );
      },
    );

    // TODO Fix the isInCollection
    // if (_boardGameExpansion.isInCollection ?? false) {
    //   expansionItem = ClipRect(
    //     child: CustomPaint(
    //       foregroundPainter: ExpanionsBannerPainter(
    //         location: BannerLocation.topStart,
    //         color: AppColors.accentColor,
    //         message: 'own',
    //       ),
    //       child: expansionItem,
    //     ),
    //   );
    // }

    return Material(
      color: Colors.transparent,
      child: expansionItem,
    );
  }
}
