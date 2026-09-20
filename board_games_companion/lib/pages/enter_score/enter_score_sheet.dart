import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../widgets/common/bottom_sheet_handle.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/elevated_container.dart';
import 'enter_score_view_model.dart';

class EnterScoreSheet extends StatelessWidget {
  const EnterScoreSheet({
    required this.viewModel,
    super.key,
  });

  static const String pageRoute = '/enterScoreSheet';

  final EnterScoreViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppStyles.defaultBottomSheetCornerRadius),
        topRight: Radius.circular(AppStyles.defaultBottomSheetCornerRadius),
      ),
      // Nothing scrolls at normal sizes. This is an escape hatch for short screens and large
      // font scales, where a keypad plus a header can outgrow the viewport.
      child: SingleChildScrollView(
        child: Padding(
          // showModalBottomSheet's useSafeArea only guards the top, so the bottom intrusion
          // (gesture navigation bar, home indicator) is ours to keep the Done button clear of.
          padding: const EdgeInsets.all(Dimensions.standardSpacing).copyWith(
            bottom: Dimensions.standardSpacing + MediaQuery.viewPaddingOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const BottomSheetHandle(),
              const SizedBox(height: Dimensions.standardSpacing),
              Observer(
                builder: (_) => _Header(
                  playerName: viewModel.playerName,
                  score: viewModel.score,
                  scoreEntry: viewModel.scoreEntry,
                ),
              ),
              Observer(
                builder: (_) => _ScoreHistory(partialScores: viewModel.partialScores),
              ),
              const SizedBox(height: Dimensions.standardSpacing),
              _InstantScoreRow(onScoreChange: viewModel.addInstantScore),
              const SizedBox(height: Dimensions.standardSpacing),
              Observer(
                builder: (_) => _Keypad(
                  canUndo: viewModel.canUndo,
                  onDigit: viewModel.appendDigit,
                  onBackspace: viewModel.backspace,
                  onSubtract: viewModel.commitSubtract,
                  onAdd: viewModel.commitAdd,
                  onUndo: viewModel.undo,
                ),
              ),
              const SizedBox(height: Dimensions.standardSpacing),
              ElevatedIconButton(
                title: AppText.enterScoreSheetDoneButtonText,
                icon: const Icon(Icons.done),
                color: AppColors.accentColor,
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: Dimensions.standardSpacing),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.playerName,
    required this.score,
    required this.scoreEntry,
  });

  final String? playerName;
  final double score;
  final String scoreEntry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          playerName ?? '',
          style: AppTheme.theme.textTheme.displayLarge,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          score.toStringAsFixed(0),
          style: AppTheme.theme.textTheme.displayLarge!.copyWith(
            fontSize: Dimensions.doubleExtraLargeFontSize,
            color: AppColors.accentColor,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          scoreEntry.isEmpty ? AppText.enterScoreSheetEmptyScoreEntry : scoreEntry,
          style: AppTheme.theme.textTheme.displaySmall!.copyWith(
            color: scoreEntry.isEmpty ? AppColors.secondaryTextColor : AppColors.defaultTextColor,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ScoreHistory extends StatelessWidget {
  const _ScoreHistory({
    required this.partialScores,
  });

  static const double _minHeight = 20;

  final List<double> partialScores;

  @override
  Widget build(BuildContext context) {
    if (partialScores.isEmpty) {
      return const SizedBox(height: _minHeight);
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _minHeight),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text('(', style: AppTheme.theme.textTheme.bodyLarge),
          for (var i = 0; i < partialScores.length; i++) ...[
            Text(
              partialScores[i] > 0
                  ? '+${partialScores[i].toStringAsFixed(0)}'
                  : partialScores[i].toStringAsFixed(0),
              style: AppTheme.theme.textTheme.bodyLarge,
            ),
            if (i != partialScores.length - 1) ...[
              Text(', ', style: AppTheme.theme.textTheme.bodyLarge),
            ]
          ],
          Text(')', style: AppTheme.theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _InstantScoreRow extends StatelessWidget {
  const _InstantScoreRow({
    required this.onScoreChange,
  });

  static const List<double> _instantScores = [1, 5, 10, 50];

  final ValueChanged<double> onScoreChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final instantScore in _instantScores)
          _Key(
            backgroundColor: AppColors.accentColor,
            splashColor: AppColors.primaryColor,
            onTap: () => onScoreChange(instantScore),
            child: Text(
              '+${instantScore.toStringAsFixed(0)}',
              style: AppTheme.theme.textTheme.displaySmall,
            ),
          ),
      ],
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.canUndo,
    required this.onDigit,
    required this.onBackspace,
    required this.onSubtract,
    required this.onAdd,
    required this.onUndo,
  });

  static const double _spacing = Dimensions.standardSpacing;

  final bool canUndo;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;
  final VoidCallback onUndo;

  @override
  Widget build(BuildContext context) {
    final rows = <({List<String> digits, Widget action})>[
      (digits: ['1', '2', '3'], action: _backspaceKey),
      (digits: ['4', '5', '6'], action: _commitKey('−', onSubtract)),
      (digits: ['7', '8', '9'], action: _commitKey('+', onAdd)),
      (digits: ['', '0', ''], action: _undoKey),
    ];

    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: _spacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final digit in rows[i].digits) _digitKey(digit),
              rows[i].action,
            ],
          ),
        ],
      ],
    );
  }

  Widget _digitKey(String digit) {
    if (digit.isEmpty) {
      return const SizedBox(width: _Key.size, height: _Key.size);
    }

    return _Key(
      onTap: () => onDigit(digit),
      child: Text(digit, style: AppTheme.theme.textTheme.displayLarge),
    );
  }

  Widget get _backspaceKey => _Key(
        onTap: onBackspace,
        child: const Icon(
          Icons.backspace_outlined,
          color: AppColors.defaultTextColor,
          size: Dimensions.defaultButtonIconSize,
          semanticLabel: AppText.enterScoreSheetBackspaceButtonText,
        ),
      );

  Widget _commitKey(String symbol, VoidCallback onTap) => _Key(
        backgroundColor: AppColors.accentColor,
        splashColor: AppColors.primaryColor,
        onTap: onTap,
        child: Text(symbol, style: AppTheme.theme.textTheme.displayLarge),
      );

  Widget get _undoKey => _Key(
        backgroundColor: AppColors.blueColor,
        onTap: canUndo ? onUndo : null,
        child: Icon(
          Icons.undo,
          color: canUndo ? AppColors.defaultTextColor : AppColors.secondaryTextColor,
          size: Dimensions.defaultButtonIconSize,
          semanticLabel: AppText.enterScoreSheetUndoButtonText,
        ),
      );
}

class _Key extends StatelessWidget {
  const _Key({
    required this.onTap,
    required this.child,
    this.backgroundColor = AppColors.primaryColorLight,
    this.splashColor = AppColors.accentColor,
  });

  static const double size = 56;

  final VoidCallback? onTap;
  final Widget child;
  final Color backgroundColor;
  final Color splashColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedContainer(
        backgroundColor: onTap == null
            ? AppColors.disabledFloatinActionButtonColor
            : backgroundColor,
        elevation: AppStyles.defaultElevation,
        splashColor: splashColor,
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.quarterStandardSpacing),
            child: FittedBox(child: child),
          ),
        ),
      ),
    );
  }
}
