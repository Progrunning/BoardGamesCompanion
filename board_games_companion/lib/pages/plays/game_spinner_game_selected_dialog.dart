import 'dart:async';
import 'dart:math';

import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/models/navigation/board_game_details_page_arguments.dart';
import 'package:board_games_companion/pages/board_game_details/board_game_details_page.dart';
import 'package:board_games_companion/pages/playthroughs/playthroughs_page.dart';
import 'package:board_games_companion/widgets/board_games/board_game_tile.dart';
import 'package:board_games_companion/widgets/common/board_game/board_game_property.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/animation_tags.dart';
import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../models/navigation/playthroughs_page_arguments.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/rating_hexagon.dart';
import '../../widgets/elevated_container.dart';

class GameSpinnerGameSelectedDialog extends StatefulWidget {
  const GameSpinnerGameSelectedDialog({
    required this.selectedBoardGame,
    super.key,
  });

  final BoardGameDetails selectedBoardGame;

  @override
  State<GameSpinnerGameSelectedDialog> createState() => _GameSpinnerGameSelectedDialogState();
}

class _GameSpinnerGameSelectedDialogState extends State<GameSpinnerGameSelectedDialog> {
  static const double _minWidth = 340;
  static const double _maxWidth = 380;
  static const double _gameStatIconSize = 24;
  static const double _gamePropertyIconSize = 28;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _confettiController.play(),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dialogWidth =
        max(_minWidth, min(width - 2 * Dimensions.doubleStandardSpacing, _maxWidth));

    return Center(
      child: SizedBox(
        width: dialogWidth,
        child: ElevatedContainer(
          backgroundColor: AppColors.primaryColorLight,
          elevation: AppStyles.defaultElevation,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dimensions.gameSpinnerSelectedGameImageHeight,
                    child: Stack(
                      children: [
                        BoardGameTile(
                          id: '${AnimationTags.gameSpinnerBoardGameHeroTag}${widget.selectedBoardGame.id}',
                          imageUrl: widget.selectedBoardGame.imageUrl ?? '',
                          name: widget.selectedBoardGame.name,
                          nameFontSize: Dimensions.largeFontSize,
                          elevation: AppStyles.defaultElevation,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppStyles.defaultCornerRadius),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ConfettiWidget(
                            confettiController: _confettiController,
                            blastDirectionality: BlastDirectionality.explosive,
                            colors: const [
                              AppColors.accentColor,
                              AppColors.primaryColor,
                              AppColors.primaryColorLight,
                              ...AppColors.chartColorPallete,
                            ],
                            emissionFrequency: 0.03,
                            createParticlePath: drawStar,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.doubleStandardSpacing),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                    child: Column(
                      children: [
                        BoardGameProperty(
                          icon: const Icon(Icons.people, size: _gameStatIconSize),
                          iconWidth: _gamePropertyIconSize,
                          propertyName: widget.selectedBoardGame.playersFormatted,
                          fontSize: Dimensions.mediumFontSize,
                        ),
                        const SizedBox(height: Dimensions.standardSpacing),
                        BoardGameProperty(
                          icon: const Icon(Icons.hourglass_bottom, size: _gameStatIconSize),
                          iconWidth: _gamePropertyIconSize,
                          propertyName: widget.selectedBoardGame.playtimeFormatted,
                          fontSize: Dimensions.mediumFontSize,
                        ),
                        if (widget.selectedBoardGame.avgWeight != null) ...[
                          const SizedBox(height: Dimensions.standardSpacing),
                          BoardGameProperty(
                            icon: const FaIcon(FontAwesomeIcons.scaleUnbalanced,
                                size: _gameStatIconSize),
                            iconWidth: _gamePropertyIconSize,
                            propertyName: sprintf(
                              AppText.gamesPageSearchResultComplexityGameStatFormat,
                              [widget.selectedBoardGame.avgWeight!.toStringAsFixed(2)],
                            ),
                            fontSize: Dimensions.mediumFontSize,
                          ),
                        ],
                        if (widget.selectedBoardGame.rating != null) ...[
                          const SizedBox(height: Dimensions.standardSpacing),
                          BoardGameProperty(
                            icon: const RatingHexagon(
                                width: _gameStatIconSize, height: _gameStatIconSize),
                            iconWidth: _gamePropertyIconSize,
                            propertyName: widget.selectedBoardGame.rating!
                                .toStringAsFixed(Constants.boardGameRatingNumberOfDecimalPlaces),
                            fontSize: Dimensions.mediumFontSize,
                          ),
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.doubleStandardSpacing),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                    child: Row(
                      children: [
                        ElevatedIconButton(
                          title: AppText.playsPageGameSpinnerSelectedGameSpinAgainButtonText,
                          icon: const FaIcon(FontAwesomeIcons.arrowsSpin),
                          color: AppColors.blueColor,
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(child: SizedBox.shrink()),
                        ElevatedIconButton(
                          title: AppText.playsPageGameSpinnerSelectedGamePlayButtonText,
                          icon: const FaIcon(FontAwesomeIcons.dice),
                          color: AppColors.accentColor,
                          onPressed: () => _navigateToBoardGamePlaythrough(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.standardSpacing),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: AppTheme.defaultBorderRadius,
                  child: IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () => _navigateToBoardGameDetails(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToBoardGameDetails(BuildContext context) {
    unawaited(Navigator.pushNamed(
      context,
      BoardGamesDetailsPage.pageRoute,
      arguments: BoardGameDetailsPageArguments(
        boardGameId: widget.selectedBoardGame.id,
        boardGameName: widget.selectedBoardGame.name,
        navigatingFromType: GameSpinnerGameSelectedDialog,
        boardGameImageHeroId:
            '${AnimationTags.gameSpinnerBoardGameHeroTag}${widget.selectedBoardGame.id}',
      ),
    ));
  }

  void _navigateToBoardGamePlaythrough(BuildContext context) {
    unawaited(Navigator.pushNamed(
      context,
      PlaythroughsPage.pageRoute,
      arguments: PlaythroughsPageArguments(
        boardGameDetails: widget.selectedBoardGame,
        boardGameImageHeroId:
            '${AnimationTags.gameSpinnerBoardGameHeroTag}${widget.selectedBoardGame.id}',
      ),
    ));
  }
}

Path drawStar(Size size) {
  // Method to convert degree to radians
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
    path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep));
  }
  path.close();
  return path;
}
