import 'package:flutter/material.dart';

import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/hive/no_score_game_result.dart';
import '../common/segmented_buttons/bgc_segmented_button.dart';
import '../common/segmented_buttons/bgc_segmented_buttons_container.dart';

class CooperativeGameResultSegmentedButton extends StatelessWidget {
  const CooperativeGameResultSegmentedButton({
    required this.cooperativeGameResult,
    required this.onCooperativeGameResultChanged,
    super.key,
  });

  final CooperativeGameResult? cooperativeGameResult;
  final void Function(CooperativeGameResult) onCooperativeGameResultChanged;

  @override
  Widget build(BuildContext context) {
    return BgcSegmentedButtonsContainer(
      // MK an arbitrary number based on 75px being enough to tap on the button and to show the name on the tile
      width: 150,
      height: Dimensions.defaultSegmentedButtonsContainerHeight,
      child: Row(
        children: [
          _NoScoreResultTile.result(
            text: AppText.editPlaythroughNoScoreResultWinText,
            isSelected: cooperativeGameResult == CooperativeGameResult.win,
            onSelected: (isWin) => onCooperativeGameResultChanged(CooperativeGameResult.win),
          ),
          _NoScoreResultTile.result(
            text: AppText.editPlaythroughNoScoreResultLossText,
            isSelected: cooperativeGameResult == CooperativeGameResult.loss,
            onSelected: (isLoss) => onCooperativeGameResultChanged(CooperativeGameResult.loss),
          ),
        ],
      ),
    );
  }
}

class _NoScoreResultTile extends BgcSegmentedButton<bool> {
  _NoScoreResultTile.result({
    required String text,
    required bool isSelected,
    required Function(bool) onSelected,
  }) : super(
          value: isSelected,
          isSelected: isSelected,
          onTapped: (_) => onSelected(isSelected),
          child: Center(
            child: Text(
              text,
              style: AppTheme.theme.textTheme.displaySmall,
            ),
          ),
        );
}
