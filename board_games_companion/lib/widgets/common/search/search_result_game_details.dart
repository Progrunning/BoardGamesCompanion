import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprintf/sprintf.dart';

import '../../../common/app_text.dart';
import '../../../common/app_theme.dart';
import '../../../common/constants.dart';
import '../../../common/dimensions.dart';
import '../../../models/hive/board_game_details.dart';
import '../board_game/board_game_property.dart';
import '../rating_hexagon.dart';

class SearchResultGameDetails extends StatelessWidget {
  const SearchResultGameDetails({
    super.key,
    required this.boardGame,
  });

  final BoardGameDetails boardGame;

  static const double _gamePropertyIconSize = 20;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          boardGame.name,
          style: AppTheme.theme.textTheme.bodyLarge,
        ),
        if (boardGame.minPlayers != null) ...[
          const SizedBox(height: Dimensions.standardSpacing),
          BoardGameProperty(
            icon: const Icon(Icons.people, size: Dimensions.smallButtonIconSize),
            iconWidth: _gamePropertyIconSize,
            propertyName: boardGame.playersFormatted,
          ),
        ],
        if (boardGame.minPlaytime != null && boardGame.minPlaytime != 0) ...[
          const SizedBox(height: Dimensions.standardSpacing),
          BoardGameProperty(
            icon: const Icon(Icons.hourglass_bottom, size: Dimensions.smallButtonIconSize),
            iconWidth: _gamePropertyIconSize,
            propertyName: boardGame.playtimeFormatted,
          ),
        ],
        if (boardGame.avgWeight != null && boardGame.avgWeight != 0) ...[
          const SizedBox(height: Dimensions.standardSpacing),
          BoardGameProperty(
            icon: const FaIcon(FontAwesomeIcons.scaleUnbalanced,
                size: Dimensions.smallButtonIconSize),
            iconWidth: _gamePropertyIconSize,
            propertyName: sprintf(
              AppText.gamesPageSearchResultComplexityGameStatFormat,
              [boardGame.avgWeight!.toStringAsFixed(2)],
            ),
          ),
        ],
        if (boardGame.rating != null) ...[
          const SizedBox(height: Dimensions.standardSpacing),
          BoardGameProperty(
            icon: const RatingHexagon(
                width: Dimensions.smallButtonIconSize, height: Dimensions.smallButtonIconSize),
            iconWidth: _gamePropertyIconSize,
            propertyName:
                boardGame.rating!.toStringAsFixed(Constants.boardGameRatingNumberOfDecimalPlaces),
          ),
        ],
        if (boardGame.yearPublished != null && boardGame.yearPublished != 0) ...[
          const SizedBox(height: Dimensions.standardSpacing),
          BoardGameProperty(
            icon: const Icon(Icons.event, size: Dimensions.smallButtonIconSize),
            iconWidth: _gamePropertyIconSize,
            propertyName: '${boardGame.yearPublished}',
          ),
        ]
      ],
    );
  }
}
