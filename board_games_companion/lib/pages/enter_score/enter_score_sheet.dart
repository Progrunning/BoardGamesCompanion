import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../widgets/common/bottom_sheet_handle.dart';
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
          // (gesture navigation bar, home indicator) is ours to keep the last keypad row clear of.
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
                  score: viewModel.previewScore,
                ),
              ),
              Observer(
                builder: (_) => _ScoreEquation(equation: viewModel.scoreEquation),
              ),
              const SizedBox(height: Dimensions.standardSpacing),
              _InstantScoreRow(onScoreChange: viewModel.addInstantScore),
              const SizedBox(height: Dimensions.standardSpacing),
              Observer(
                builder: (_) => _Keypad(
                  canUndo: viewModel.canUndo,
                  canConfirm: viewModel.hasScoreChanged,
                  onDigit: viewModel.appendDigit,
                  onBackspace: viewModel.backspace,
                  onSubtract: viewModel.commitSubtract,
                  onAdd: viewModel.commitAdd,
                  onUndo: viewModel.undo,
                  onConfirm: () => Navigator.pop(context),
                ),
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
  });

  final String? playerName;
  final double score;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(text: playerName ?? ''),
          const TextSpan(text: AppText.enterScoreSheetPlayerScoredText),
          TextSpan(
            text: score.toStringAsFixed(0),
            style: AppTheme.theme.textTheme.displayLarge!.copyWith(
              fontSize: Dimensions.doubleExtraLargeFontSize,
              color: AppColors.accentColor,
            ),
          ),
        ],
      ),
      style: AppTheme.theme.textTheme.displayLarge,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ScoreEquation extends StatelessWidget {
  const _ScoreEquation({
    required this.equation,
  });

  /// Holds the gap between the header and the keypad open while the equation is still empty, so
  /// the keys do not shift under the thumb once the first key is pressed.
  static const double _minHeight = 20;

  final String equation;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _minHeight),
      child: Text(
        equation,
        style: AppTheme.theme.textTheme.bodyLarge,
        textAlign: TextAlign.center,
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
    return _KeyRow(
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

/// A row of keys that share the sheet's width evenly, separated by the same gap that separates
/// the rows. The keys stretch rather than the gaps, so the pad fills the sheet instead of
/// leaving margins either side.
class _KeyRow extends StatelessWidget {
  const _KeyRow({required this.children});

  static const double spacing = Dimensions.standardSpacing;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: spacing),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.canUndo,
    required this.canConfirm,
    required this.onDigit,
    required this.onBackspace,
    required this.onSubtract,
    required this.onAdd,
    required this.onUndo,
    required this.onConfirm,
  });

  /// Holds the column open so the keys below line up under the digits above.
  static const Widget _emptyKey = SizedBox(height: _Key.size);

  final bool canUndo;
  final bool canConfirm;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;
  final VoidCallback onUndo;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final rows = <List<Widget>>[
      [_digitKey('1'), _digitKey('2'), _digitKey('3'), _emptyKey],
      [
        _digitKey('4'),
        _digitKey('5'),
        _digitKey('6'),
        _commitKey(ScoreOperator.subtract.symbol, onSubtract),
      ],
      [
        _digitKey('7'),
        _digitKey('8'),
        _digitKey('9'),
        _commitKey(ScoreOperator.add.symbol, onAdd),
      ],
      [_undoKey, _digitKey('0'), _backspaceKey, _confirmKey],
    ];

    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: _KeyRow.spacing),
          _KeyRow(children: rows[i]),
        ],
      ],
    );
  }

  Widget _digitKey(String digit) {
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
          color: canUndo ? AppColors.defaultTextColor : AppColors.disabledIconIconColor,
          size: Dimensions.defaultButtonIconSize,
          semanticLabel: AppText.enterScoreSheetUndoButtonText,
        ),
      );

  Widget get _confirmKey => _Key(
        backgroundColor: AppColors.greenColor,
        onTap: canConfirm ? onConfirm : null,
        child: Icon(
          Icons.done,
          color: canConfirm ? AppColors.defaultTextColor : AppColors.disabledIconIconColor,
          size: Dimensions.defaultButtonIconSize,
          semanticLabel: AppText.enterScoreSheetConfirmButtonText,
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

  /// Height only - a key takes its width from the row, which splits the sheet between them.
  static const double size = 56;

  final VoidCallback? onTap;
  final Widget child;
  final Color backgroundColor;
  final Color splashColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: ElevatedContainer(
        // A disabled key fades rather than turning grey, so it still reads as the same key.
        backgroundColor: onTap == null
            ? backgroundColor.withAlpha(AppStyles.opacity40Percent)
            : backgroundColor,
        // The shadow would show through the faded surface, so it goes with the fade.
        elevation: onTap == null ? 0 : AppStyles.defaultElevation,
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
