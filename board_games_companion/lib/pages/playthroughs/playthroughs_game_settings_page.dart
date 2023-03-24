import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/common/enums/game_classification.dart';
import 'package:board_games_companion/common/enums/game_family.dart';
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
              primaryTitle: AppText.playthroughsGameSettingsGameClassificationSectionTitle,
            ),
          ),
          Observer(builder: (_) {
            return _GameClassificationSection(
              gameClassification: viewModel.gameClassification,
              onGameClassificationChanged: (GameClassification? gameClassification) =>
                  _handleGameClassificationChange(gameClassification),
            );
          }),
          SliverPersistentHeader(
            delegate: BgcSliverHeaderDelegate(
              primaryTitle: AppText.playthroughsGameSettingsGameFamilySectionTitle,
            ),
          ),
          Observer(builder: (_) {
            return viewModel.gameClassificationSettings.when(
              score: (gameFamily, averageScorePrecision) => MultiSliver(
                children: [
                  _ScoreGameFamilySection(
                    gameFamily: gameFamily,
                    onChanged: (GameFamily? selectedGameFamily) =>
                        _handleGameFamilyChange(selectedGameFamily),
                  ),
                  SliverPersistentHeader(
                    delegate: BgcSliverHeaderDelegate(
                      primaryTitle: AppText.playthroughsGameSettingsScoreDetailsSectionTitle,
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
              noScore: (gameFamily) => MultiSliver(
                children: [
                  RadioListTile<GameFamily>(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
                    activeColor: AppColors.accentColor,
                    title: const Text(
                      AppText.playthroughsGameSettingsGameFamilyCoop,
                      style: AppTheme.defaultTextFieldStyle,
                    ),
                    value: GameFamily.Cooperative,
                    groupValue: gameFamily,
                    onChanged: (GameFamily? selectedGameFamily) =>
                        _handleGameFamilyChange(selectedGameFamily),
                  ),
                ],
              ),
            );
          }),
        ],
      );

  Future<void> _handleGameFamilyChange(GameFamily? gameFamily) async {
    if (gameFamily == null) {
      return;
    }

    await viewModel.updateGameFamily(gameFamily);
  }

  Future<void> _handleGameClassificationChange(GameClassification? gameClassification) async {
    if (gameClassification == null || gameClassification == viewModel.gameClassification) {
      return;
    }

    await viewModel.updateGameClassification(gameClassification);
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

class _GameClassificationSection extends StatefulWidget {
  const _GameClassificationSection({
    required this.gameClassification,
    required this.onGameClassificationChanged,
    Key? key,
  }) : super(key: key);

  final GameClassification gameClassification;
  final Function(GameClassification?) onGameClassificationChanged;

  @override
  State<_GameClassificationSection> createState() => _GameClassificationSectionState();
}

class _GameClassificationSectionState extends State<_GameClassificationSection> {
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
        child: DropdownButton<GameClassification>(
          iconEnabledColor: AppColors.accentColor,
          iconSize: 42,
          value: widget.gameClassification,
          underline: const SizedBox.shrink(),
          isExpanded: true,
          items: [
            DropdownMenuItem<GameClassification>(
              value: GameClassification.Score,
              child: Text(
                AppText.playthroughsGameSettingsGameClassificationScore,
                style: AppTheme.theme.textTheme.bodyText1!,
              ),
            ),
            DropdownMenuItem<GameClassification>(
              value: GameClassification.NoScore,
              child: Text(
                AppText.playthroughsGameSettingsGameClssificationNoScore,
                style: AppTheme.theme.textTheme.bodyText1!,
              ),
            ),
          ],
          onChanged: (GameClassification? value) => widget.onGameClassificationChanged(value),
        ),
      ),
    );
  }
}

class _ScoreGameFamilySection extends StatefulWidget {
  const _ScoreGameFamilySection({
    required this.gameFamily,
    required this.onChanged,
  });
  final GameFamily? gameFamily;
  final Function(GameFamily?) onChanged;

  @override
  State<_ScoreGameFamilySection> createState() => _ScoreGameFamilySectionState();
}

class _ScoreGameFamilySectionState extends State<_ScoreGameFamilySection> {
  late GameFamily? _gameFamily = widget.gameFamily;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          RadioListTile<GameFamily>(
            contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
            activeColor: AppColors.accentColor,
            title: const Text(
              AppText.playthroughsGameSettingsGameFamilyHighestScore,
              style: AppTheme.defaultTextFieldStyle,
            ),
            value: GameFamily.HighestScore,
            groupValue: _gameFamily,
            onChanged: (GameFamily? value) {
              setState(() {
                _gameFamily = value;
                widget.onChanged(_gameFamily);
              });
            },
          ),
          RadioListTile<GameFamily>(
            contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
            activeColor: AppColors.accentColor,
            title: const Text(
              AppText.playthroughsGameSettingsGameFamilyLowestScore,
              style: AppTheme.defaultTextFieldStyle,
            ),
            value: GameFamily.LowestScore,
            groupValue: _gameFamily,
            onChanged: (GameFamily? value) {
              setState(() {
                _gameFamily = value;
                widget.onChanged(_gameFamily);
              });
            },
          ),
        ],
      );
}
