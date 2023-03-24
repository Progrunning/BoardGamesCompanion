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
import 'package:sliver_tools/sliver_tools.dart';

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
              primaryTitle: AppText.playthroughsGameSettingsGameModeSectionTitle,
            ),
          ),
          Observer(builder: (_) {
            return _GameModeSection(
              gameMode: viewModel.gameMode,
              onGameModeChanged: (GameMode? gameMode) => _handleGameModeChanged(gameMode),
            );
          }),
          SliverPersistentHeader(
            delegate: BgcSliverHeaderDelegate(
              primaryTitle: AppText.playthroughsGameSettingsWinConditionSectionTitle,
            ),
          ),
          Observer(builder: (_) {
            return viewModel.gameModeSettings.when(
              score: (gameWinCondition, averageScorePrecision) => MultiSliver(
                children: [
                  _ScoreGameModeWinConditions(
                    gameWinCondition: gameWinCondition,
                    onChanged: (GameWinCondition? winningCondition) =>
                        _handleWinConditionChanged(winningCondition),
                  ),
                  SliverPersistentHeader(
                    delegate: BgcSliverHeaderDelegate(
                      primaryTitle: AppText.editPlaythroughPageScoreSectionTitle,
                    ),
                  ),
                  Observer(
                    builder: (_) {
                      return _ScoreSection(
                        averageScorePrecision: averageScorePrecision,
                        onPrecisionChanged: (precision) =>
                            viewModel.updateAverageScorePrecision(precision),
                      );
                    },
                  ),
                ],
              ),
              noScore: (gameWinCondition) => MultiSliver(
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
                    groupValue: gameWinCondition,
                    onChanged: (GameWinCondition? winningCondition) =>
                        _handleWinConditionChanged(winningCondition),
                  ),
                ],
              ),
            );
          }),
        ],
      );

  Future<void> _handleWinConditionChanged(GameWinCondition? winningCondition) async {
    if (winningCondition == null) {
      return;
    }

    await viewModel.updateWinCondition(winningCondition);
  }

  Future<void> _handleGameModeChanged(GameMode? gameMode) async {
    if (gameMode == null || gameMode == viewModel.gameMode) {
      return;
    }

    await viewModel.updateGameMode(gameMode);
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
    required this.gameMode,
    required this.onGameModeChanged,
    Key? key,
  }) : super(key: key);

  final GameMode gameMode;
  final Function(GameMode?) onGameModeChanged;

  @override
  State<_GameModeSection> createState() => _GameModeSectionState();
}

class _GameModeSectionState extends State<_GameModeSection> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: Dimensions.doubleStandardSpacing,
          top: Dimensions.standardSpacing,
          right: Dimensions.standardSpacing,
          bottom: Dimensions.standardSpacing,
        ),
        child: DropdownButton<GameMode>(
          iconEnabledColor: AppColors.accentColor,
          iconSize: 42,
          value: widget.gameMode,
          underline: const SizedBox.shrink(),
          isExpanded: true,
          items: [
            DropdownMenuItem<GameMode>(
              value: GameMode.Score,
              child: Text(
                AppText.playthroughsGameSettingsGameModeScore,
                style: AppTheme.theme.textTheme.bodyText1!,
              ),
            ),
            DropdownMenuItem<GameMode>(
              value: GameMode.NoScore,
              child: Text(
                AppText.playthroughsGameSettingsGameModeNoScore,
                style: AppTheme.theme.textTheme.bodyText1!,
              ),
            ),
          ],
          onChanged: (GameMode? value) => widget.onGameModeChanged(value),
        ),
      ),
    );
  }
}

class _ScoreGameModeWinConditions extends StatefulWidget {
  const _ScoreGameModeWinConditions({
    required this.gameWinCondition,
    required this.onChanged,
  });
  final GameWinCondition? gameWinCondition;
  final Function(GameWinCondition?) onChanged;

  @override
  State<_ScoreGameModeWinConditions> createState() => _ScoreGameModeWinConditionsState();
}

class _ScoreGameModeWinConditionsState extends State<_ScoreGameModeWinConditions> {
  late GameWinCondition? _gameWinCondition = widget.gameWinCondition;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          RadioListTile<GameWinCondition>(
            contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
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
                widget.onChanged(_gameWinCondition);
              });
            },
          ),
          RadioListTile<GameWinCondition>(
            contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
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
                widget.onChanged(_gameWinCondition);
              });
            },
          ),
        ],
      );
}
