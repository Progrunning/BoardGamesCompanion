import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/animation_tags.dart';
import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../models/hive/board_game_details.dart';
import '../../models/navigation/board_game_details_page_arguments.dart';
import '../../models/navigation/playthroughs_page_arguments.dart';
import '../../widgets/board_games/board_game_tile.dart';
import '../../widgets/common/board_game/board_game_property.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/rating_hexagon.dart';
import '../../widgets/elevated_container.dart';
import '../board_game_details/board_game_details_page.dart';
import '../playthroughs/playthroughs_page.dart';

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  _Header(
                    selectedBoardGame: widget.selectedBoardGame,
                    confettiController: _confettiController,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: dialogWidth,
                      height: Dimensions.gameSpinnerSelectedGameImageHeight,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.info),
                          onPressed: () => _navigateToBoardGameDetails(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.doubleStandardSpacing),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                child: _Body(selectedBoardGame: widget.selectedBoardGame),
              ),
              const SizedBox(height: Dimensions.doubleStandardSpacing),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                child: _Footer(
                  onPlayPressed: () => _navigateToBoardGamePlaythrough(context),
                  onSpinAgainPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: Dimensions.standardSpacing),
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

class _Header extends StatelessWidget {
  const _Header({
    required this.selectedBoardGame,
    required this.confettiController,
  });

  final ConfettiController confettiController;
  final BoardGameDetails selectedBoardGame;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: Dimensions.gameSpinnerSelectedGameImageHeight,
        child: Stack(
          children: [
            BoardGameTile(
              id: '${AnimationTags.gameSpinnerBoardGameHeroTag}${selectedBoardGame.id}',
              imageUrl: selectedBoardGame.imageUrl ?? '',
              name: selectedBoardGame.name,
              nameFontSize: Dimensions.largeFontSize,
              elevation: AppStyles.defaultElevation,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppStyles.defaultCornerRadius),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: confettiController,
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
      );
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
    required this.selectedBoardGame,
  }) : super(key: key);

  static const double _gameStatIconSize = 24;
  static const double _gamePropertyIconSize = 28;

  final BoardGameDetails selectedBoardGame;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BoardGameProperty(
          icon: const Icon(Icons.people, size: _gameStatIconSize),
          iconWidth: _gamePropertyIconSize,
          propertyName: selectedBoardGame.playersFormatted,
          fontSize: Dimensions.mediumFontSize,
        ),
        const SizedBox(height: Dimensions.standardSpacing),
        BoardGameProperty(
          icon: const Icon(Icons.hourglass_bottom, size: _gameStatIconSize),
          iconWidth: _gamePropertyIconSize,
          propertyName: selectedBoardGame.playtimeFormatted,
          fontSize: Dimensions.mediumFontSize,
        ),
        if (selectedBoardGame.avgWeight != null) ...[
          const SizedBox(height: Dimensions.standardSpacing),
          BoardGameProperty(
            icon: const FaIcon(FontAwesomeIcons.scaleUnbalanced, size: _gameStatIconSize),
            iconWidth: _gamePropertyIconSize,
            propertyName: sprintf(
              AppText.gamesPageSearchResultComplexityGameStatFormat,
              [selectedBoardGame.avgWeight!.toStringAsFixed(2)],
            ),
            fontSize: Dimensions.mediumFontSize,
          ),
        ],
        if (selectedBoardGame.rating != null) ...[
          const SizedBox(height: Dimensions.standardSpacing),
          BoardGameProperty(
            icon: const RatingHexagon(width: _gameStatIconSize, height: _gameStatIconSize),
            iconWidth: _gamePropertyIconSize,
            propertyName: selectedBoardGame.rating!
                .toStringAsFixed(Constants.boardGameRatingNumberOfDecimalPlaces),
            fontSize: Dimensions.mediumFontSize,
          ),
        ]
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.onPlayPressed,
    required this.onSpinAgainPressed,
  });

  final VoidCallback onPlayPressed;
  final VoidCallback onSpinAgainPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedIconButton(
          title: AppText.playsPageGameSpinnerSelectedGameSpinAgainButtonText,
          icon: const FaIcon(FontAwesomeIcons.arrowsSpin),
          color: AppColors.blueColor,
          onPressed: () => onSpinAgainPressed(),
        ),
        const Expanded(child: SizedBox.shrink()),
        ElevatedIconButton(
          title: AppText.playsPageGameSpinnerSelectedGamePlayButtonText,
          icon: const FaIcon(FontAwesomeIcons.dice),
          color: AppColors.accentColor,
          onPressed: () => onPlayPressed(),
        ),
      ],
    );
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
