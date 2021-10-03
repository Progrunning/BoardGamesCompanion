import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/board_game_expansion.dart';
import '../../services/preferences_service.dart';
import '../../stores/board_game_details_store.dart';
import '../../utilities/navigator_helper.dart';
import '../../widgets/common/expansions_banner_widget.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import 'board_game_details_page.dart';

class BoardGameDetailsExpansions extends StatefulWidget {
  const BoardGameDetailsExpansions({
    Key? key,
    required this.boardGameDetailsStore,
    required this.spacingBetweenSecions,
    required this.preferencesService,
  }) : super(key: key);

  final BoardGameDetailsStore boardGameDetailsStore;
  final double spacingBetweenSecions;
  final PreferencesService? preferencesService;

  @override
  _BoardGameDetailsExpansionsState createState() => _BoardGameDetailsExpansionsState();
}

class _BoardGameDetailsExpansionsState extends State<BoardGameDetailsExpansions> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: widget.spacingBetweenSecions,
        ),
        Material(
          color: Colors.transparent,
          child: Theme(
            data: AppTheme.theme.copyWith(
              unselectedWidgetColor: AppTheme.accentColor,
            ),
            child: FutureBuilder<bool>(
              future: widget.preferencesService!.getExpansionsPanelExpandedState(),
              builder: (_, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return _Expansions(
                      boardGameDetailsStore: widget.boardGameDetailsStore,
                      preferencesService: widget.preferencesService!,
                      initiallyExpanded: snapshot.data as bool?,
                    );
                  }
                }

                return const Center(child: LoadingIndicator());
              },
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
    required this.boardGameDetailsStore,
    required this.preferencesService,
    required this.initiallyExpanded,
  }) : super(key: key);

  final BoardGameDetailsStore boardGameDetailsStore;
  final PreferencesService preferencesService;
  final bool? initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'Expansions (${boardGameDetailsStore.boardGameDetails!.expansions.length})',
        style: const TextStyle(
          fontSize: Dimensions.standardFontSize,
        ),
      ),
      subtitle: Text(
        boardGameDetailsStore.boardGameDetails!.expansionsOwned == 0
            ? "You don't own any expansions"
            : 'You own ${boardGameDetailsStore.boardGameDetails!.expansionsOwned} expansion(s)',
        style: const TextStyle(
          color: AppTheme.defaultTextColor,
          fontSize: Dimensions.smallFontSize,
        ),
      ),
      tilePadding: const EdgeInsets.symmetric(
        horizontal: Dimensions.standardSpacing,
      ),
      initiallyExpanded: initiallyExpanded!,
      onExpansionChanged: (bool isExpanded) async {
        await preferencesService.setExpansionsPanelExpandedState(isExpanded);
      },
      children: [
        ...List.generate(
          boardGameDetailsStore.boardGameDetails!.expansions.length,
          (index) {
            final expansion = boardGameDetailsStore.boardGameDetails!.expansions[index];

            return ChangeNotifierProvider<BoardGamesExpansion>.value(
              value: expansion,
              child: Consumer<BoardGamesExpansion>(
                builder: (_, store, __) {
                  return _Expansion(
                    boardGamesExpansion: expansion,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Expansion extends StatelessWidget {
  const _Expansion({
    Key? key,
    required BoardGamesExpansion boardGamesExpansion,
  })  : _boardGameExpansion = boardGamesExpansion,
        super(key: key);

  final BoardGamesExpansion _boardGameExpansion;

  @override
  Widget build(BuildContext context) {
    Widget expansionItemWidget = InkWell(
      splashColor: AppTheme.accentColor,
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
            const Icon(
              Icons.navigate_next,
              color: AppTheme.accentColor,
            ),
          ],
        ),
      ),
      onTap: () async {
        await NavigatorHelper.navigateToBoardGameDetails(
          context,
          _boardGameExpansion.id,
          _boardGameExpansion.name,
          BoardGamesDetailsPage,
        );
      },
    );

    if (_boardGameExpansion.isInCollection ?? false) {
      expansionItemWidget = ClipRect(
        child: CustomPaint(
          foregroundPainter: ExpanionsBannerPainter(
            location: BannerLocation.topStart,
            color: AppTheme.accentColor,
            message: 'own',
          ),
          child: expansionItemWidget,
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: expansionItemWidget,
    );
  }
}
