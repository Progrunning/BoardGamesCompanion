import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums/game_mode.dart';
import 'package:board_games_companion/common/enums/game_win_condition.dart';
import 'package:board_games_companion/extensions/average_score_precision_extensions.dart';
import 'package:board_games_companion/pages/playthroughs/playthroughs_game_settings_view_model.dart';
import 'package:board_games_companion/widgets/common/filtering/filter_toggle_buttons_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/app_colors.dart';
import '../../injectable.dart';
import '../../widgets/common/filtering/filter_toggle_button.dart';
import '../../widgets/common/slivers/bgc_sliver_header_delegate.dart';
import 'average_score_precision.dart';

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
              primaryTitle: AppText.playthroughsGameSettingsWinConditionSectionTitle,
            ),
          ),
          _GameModeSection(
            winCondition: viewModel.winCondition,
            gameMode: viewModel.gameMode,
            onChange: (GameWinCondition? winningCondition) =>
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

  Future<void> _winningConditionChanged(GameWinCondition? winningCondition) async {
    if (winningCondition == null) {
      return;
    }

    await viewModel.updateWinCondition(winningCondition);
  }
}

class _ScoreSection extends StatelessWidget {
  const _ScoreSection({
    required this.averageScorePrecision,
    required this.onPrecisionChanged,
  });

  static const int numberOfPrecisionOptions = 3;
  static const double precisionContainerHeight = 40;
  static const double precisionContainerWidth = numberOfPrecisionOptions * 52;

  final AverageScorePrecision averageScorePrecision;
  final Function(AverageScorePrecision) onPrecisionChanged;

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
                  const Spacer(),
                  FilterToggleButtonsContainer(
                    height: precisionContainerHeight,
                    width: precisionContainerWidth,
                    child: Row(
                      children: [
                        _AverageScorePrecisionTile.precision(
                          isSelected: averageScorePrecision == const AverageScorePrecision.none(),
                          onSelected: (precision) => onPrecisionChanged(precision),
                          averageScorePrecision: const AverageScorePrecision.none(),
                        ),
                        _AverageScorePrecisionTile.precision(
                          isSelected: averageScorePrecision ==
                              const AverageScorePrecision.value(precision: 1),
                          onSelected: (precision) => onPrecisionChanged(precision),
                          averageScorePrecision: const AverageScorePrecision.value(precision: 1),
                        ),
                        _AverageScorePrecisionTile.precision(
                          isSelected: averageScorePrecision ==
                              const AverageScorePrecision.value(precision: 2),
                          onSelected: (precision) => onPrecisionChanged(precision),
                          averageScorePrecision: const AverageScorePrecision.value(precision: 2),
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

class _AverageScorePrecisionTile extends FilterToggleButton<AverageScorePrecision> {
  _AverageScorePrecisionTile.precision({
    required bool isSelected,
    required AverageScorePrecision averageScorePrecision,
    required Function(AverageScorePrecision) onSelected,
  }) : super(
          value: averageScorePrecision,
          isSelected: isSelected,
          onTapped: (_) => onSelected(averageScorePrecision),
          child: Center(
            child: Text(
              averageScorePrecision.toFormattedText(),
              style: AppTheme.theme.textTheme.headline3,
            ),
          ),
        );
}

class _GameModeSection extends StatefulWidget {
  const _GameModeSection({
    required this.winCondition,
    required this.gameMode,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  final GameWinCondition winCondition;
  final GameMode gameMode;
  final Function(GameWinCondition?) onChange;

  @override
  State<_GameModeSection> createState() => _GameModeSectionState();
}

class _GameModeSectionState extends State<_GameModeSection> {
  late GameWinCondition? _gameWinCondition = widget.winCondition;
  late GameMode? _gameMode = widget.gameMode;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RadioListTile<GameMode>(
            contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
            activeColor: AppColors.accentColor,
            title: const Text(
              AppText.playthroughsGameSettingsGameModeScore,
              style: AppTheme.defaultTextFieldStyle,
            ),
            value: GameMode.Score,
            groupValue: _gameMode,
            onChanged: (GameMode? value) {
              setState(() {
                _gameMode = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: Dimensions.doubleStandardSpacing),
            child: Column(
              children: [
                RadioListTile<GameWinCondition>(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                  activeColor: AppColors.accentColor,
                  title: const Text(
                    AppText.playthroughsGameSettingsWinConditionCoop,
                    style: AppTheme.defaultTextFieldStyle,
                  ),
                  value: GameWinCondition.Coop,
                  groupValue: _gameWinCondition,
                  onChanged: (GameWinCondition? value) {
                    setState(() {
                      _gameWinCondition = value;
                      widget.onChange(_gameWinCondition);
                    });
                  },
                ),
              ],
            ),
          ),
          RadioListTile<GameMode>(
            contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
            activeColor: AppColors.accentColor,
            title: const Text(
              AppText.playthroughsGameSettingsGameModeNoScore,
              style: AppTheme.defaultTextFieldStyle,
            ),
            value: GameMode.NoScore,
            groupValue: _gameMode,
            onChanged: (GameMode? value) {
              setState(() {
                _gameMode = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: Dimensions.doubleStandardSpacing),
            child: Column(
              children: [
                RadioListTile<GameWinCondition>(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                  activeColor: AppColors.accentColor,
                  title: const Text(
                    AppText.playthroughsGameSettingsWinningConditionHighestScore,
                    style: AppTheme.defaultTextFieldStyle,
                  ),
                  value: GameWinCondition.HighestScore,
                  groupValue: _gameWinCondition,
                  onChanged: (GameWinCondition? value) {
                    setState(() {
                      _gameWinCondition = value;
                      widget.onChange(_gameWinCondition);
                    });
                  },
                ),
                RadioListTile<GameWinCondition>(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                  activeColor: AppColors.accentColor,
                  title: const Text(
                    AppText.playthroughsGameSettingsWinningConditionLowestScore,
                    style: AppTheme.defaultTextFieldStyle,
                  ),
                  value: GameWinCondition.LowestScore,
                  groupValue: _gameWinCondition,
                  onChanged: (GameWinCondition? value) {
                    setState(() {
                      _gameWinCondition = value;
                      widget.onChange(_gameWinCondition);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
