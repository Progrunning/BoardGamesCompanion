import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums/game_winning_condition.dart';
import 'package:board_games_companion/pages/playthroughs/playthroughs_game_settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../injectable.dart';
import '../../widgets/common/slivers/bgc_sliver_header_delegate.dart';
import '../../widgets/elevated_container.dart';

class PlaythroughsGameSettingsPage extends StatefulWidget {
  const PlaythroughsGameSettingsPage({Key? key}) : super(key: key);

  @override
  State<PlaythroughsGameSettingsPage> createState() => _PlaythroughsGameSettingsPageState();
}

class _PlaythroughsGameSettingsPageState extends State<PlaythroughsGameSettingsPage> {
  late PlaythroughsGameSettingsViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = getIt<PlaythroughsGameSettingsViewModel>();
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: BgcSliverHeaderDelegate(
              primaryTitle: AppText.playthroughsGameSettingsWinningConditionSectionTitle,
            ),
          ),
          _WinningConditionSection(
            winningCondition: viewModel.winningCondition,
            onChange: (GameWinningCondition? winningCondition) =>
                _winningConditionChanged(winningCondition),
          ),
          SliverPersistentHeader(
            delegate: BgcSliverHeaderDelegate(
              primaryTitle: AppText.editPlaythroughPageScoreSectionTitle,
            ),
          ),
          Observer(
            builder: (_) {
              return _ScoreSection(
                averageScorePrecision: viewModel.averageScorePrecision,
                onPrecisionChanged: (precision) => viewModel.updateAverageScorePrecision(precision),
              );
            },
          ),
        ],
      );

  Future<void> _winningConditionChanged(GameWinningCondition? winningCondition) async {
    if (winningCondition == null) {
      return;
    }

    await viewModel.updateWinningCondition(winningCondition);
  }
}

class _ScoreSection extends StatelessWidget {
  const _ScoreSection({
    required this.averageScorePrecision,
    required this.onPrecisionChanged,
  });

  final int averageScorePrecision;
  final Function(int) onPrecisionChanged;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    AppText.editPlaythroughPageScoreSectionAverageScorePrecisionText,
                    style: AppTheme.defaultTextFieldStyle,
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  ElevatedContainer(
                    backgroundColor: AppColors.primaryColor,
                    elevation: AppStyles.defaultElevation,
                    child: Row(
                      children: [
                        _AverageScorePrecisionTile(
                          precision: 0,
                          isActive: averageScorePrecision == 0,
                          onSelected: (precision) => onPrecisionChanged(precision),
                          text: 'None',
                        ),
                        _AverageScorePrecisionTile(
                          precision: 1,
                          isActive: averageScorePrecision == 1,
                          onSelected: (precision) => onPrecisionChanged(precision),
                          text: '.0',
                        ),
                        _AverageScorePrecisionTile(
                          precision: 2,
                          isActive: averageScorePrecision == 2,
                          onSelected: (precision) => onPrecisionChanged(precision),
                          text: '.00',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class _AverageScorePrecisionTile extends StatelessWidget {
  const _AverageScorePrecisionTile({
    required this.text,
    required this.isActive,
    required this.precision,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final bool isActive;
  final String text;
  final int precision;
  final Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 40,
      child: ElevatedContainer(
        backgroundColor: isActive ? AppColors.accentColor : Colors.transparent,
        splashColor: isActive ? AppColors.primaryColor : AppColors.accentColor,
        onTap: () => onSelected(precision),
        child: Center(
          child: Text(text, style: AppTheme.theme.textTheme.headline3),
        ),
      ),
    );
  }
}

class _WinningConditionSection extends StatefulWidget {
  const _WinningConditionSection({
    required this.winningCondition,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  final GameWinningCondition winningCondition;
  final Function(GameWinningCondition?) onChange;

  @override
  State<_WinningConditionSection> createState() => _WinningConditionSectionState();
}

class _WinningConditionSectionState extends State<_WinningConditionSection> {
  late GameWinningCondition? _gameWinningCondition = widget.winningCondition;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RadioListTile<GameWinningCondition>(
            contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
            activeColor: AppColors.accentColor,
            title: const Text(
              AppText.playthroughsGameSettingsWinningConditionHighestScore,
              style: AppTheme.defaultTextFieldStyle,
            ),
            secondary: Icon(Icons.arrow_upward,
                color: _gameWinningCondition == GameWinningCondition.HighestScore
                    ? AppColors.activeWinningConditionIcon
                    : AppColors.inactiveBottomTabColor),
            value: GameWinningCondition.HighestScore,
            groupValue: _gameWinningCondition,
            onChanged: (GameWinningCondition? value) {
              setState(() {
                _gameWinningCondition = value;
                widget.onChange(_gameWinningCondition);
              });
            },
          ),
          RadioListTile<GameWinningCondition>(
            contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
            activeColor: AppColors.accentColor,
            title: const Text(
              AppText.playthroughsGameSettingsWinningConditionLowestScore,
              style: AppTheme.defaultTextFieldStyle,
            ),
            secondary: Icon(Icons.arrow_downward,
                color: _gameWinningCondition == GameWinningCondition.LowestScore
                    ? AppColors.activeWinningConditionIcon
                    : AppColors.inactiveBottomTabColor),
            value: GameWinningCondition.LowestScore,
            groupValue: _gameWinningCondition,
            onChanged: (GameWinningCondition? value) {
              setState(() {
                _gameWinningCondition = value;
                widget.onChange(_gameWinningCondition);
              });
            },
          ),
        ],
      ),
    );
  }
}
