import 'dart:math';

import 'package:board_games_companion/pages/enter_score/enter_score_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../../extensions/double_extensions.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/icon_and_text_button.dart';
import '../../widgets/rounded_container.dart';

class EnterScoreDialog extends StatelessWidget {
  const EnterScoreDialog({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final EnterScoreViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EnterScoreViewModel>.value(
      value: viewModel,
      builder: (_, __) {
        // TODO Work out a better padding because on very large screens this won't look good
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.trippleStandardSpacing),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColorLight,
                boxShadow: const [AppTheme.defaultBoxShadow],
                borderRadius: BorderRadius.circular(Styles.defaultCornerRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.doubleStandardSpacing,
                  vertical: Dimensions.standardSpacing,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: Dimensions.doubleStandardSpacing),
                    _CircularNumberPicker(
                      strokeWidth: 50,
                      thumbSize: 50,
                      onEnded: (int partialScore) {
                        viewModel.updateScore(partialScore);
                      },
                    ),
                    const SizedBox(height: Dimensions.doubleStandardSpacing),
                    Consumer<EnterScoreViewModel>(
                      builder: (_, viewModel, __) {
                        return _InstantScorePanel(
                          operation: viewModel.operation,
                          onOperationChange: (EnterScoreOperation operation) {
                            viewModel.updateOperation(operation);
                          },
                          onScoreChange: (int partialScore) async {
                            if (viewModel.operation == EnterScoreOperation.subtract) {
                              partialScore = -partialScore;
                            }

                            viewModel.updateScore(partialScore);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: Dimensions.doubleStandardSpacing),
                    _Score(playerName: viewModel.playerScore.player?.name),
                    const _ScoreHistory(),
                    const SizedBox(height: Dimensions.trippleStandardSpacing),
                    _ActionButtons(
                      onUndo: () => viewModel.undo(),
                      onDone: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ScoreHistory extends StatelessWidget {
  const _ScoreHistory({
    Key? key,
  }) : super(key: key);

  static const double _height = 20;

  @override
  Widget build(BuildContext context) {
    return Consumer<EnterScoreViewModel>(builder: (_, viewModel, __) {
      if (viewModel.partialScores.isEmpty) {
        return const SizedBox(height: _height);
      }

      return SizedBox(
        height: _height,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text('(', style: AppTheme.theme.textTheme.bodyText1),
            for (var i = 0; i < viewModel.partialScores.length; i++) ...[
              Text(
                viewModel.partialScores[i] > 0
                    ? '+${viewModel.partialScores[i]}'
                    : '${viewModel.partialScores[i]}',
                style: AppTheme.theme.textTheme.bodyText1,
              ),
              if (i != viewModel.partialScores.length - 1) ...[
                Text(', ', style: AppTheme.theme.textTheme.bodyText1),
              ]
            ],
            Text(')', style: AppTheme.theme.textTheme.bodyText1),
          ],
        ),
      );
    });
  }
}

class _Score extends StatelessWidget {
  const _Score({
    required this.playerName,
    Key? key,
  }) : super(key: key);

  final String? playerName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          sprintf(AppText.editPlaythroughPlayerScoredFormat, [playerName]),
          style: AppTheme.theme.textTheme.headline1!.copyWith(fontWeight: FontWeight.normal),
        ),
        Consumer<EnterScoreViewModel>(
          builder: (_, viewModel, __) {
            return Text(
              ' ${viewModel.score} ',
              style: AppTheme.theme.textTheme.headline1!.copyWith(
                fontSize: Dimensions.doubleExtraLargeFontSize,
                color: AppTheme.accentColor,
              ),
            );
          },
        ),
        Text(
          AppText.editPlaythroughScorePoints,
          style: AppTheme.theme.textTheme.headline1!.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}

class _InstantScorePanel extends StatelessWidget {
  const _InstantScorePanel({
    required this.operation,
    required this.onOperationChange,
    required this.onScoreChange,
    Key? key,
  }) : super(key: key);

  final EnterScoreOperation operation;
  final ValueChanged<EnterScoreOperation> onOperationChange;
  final ValueChanged<int> onScoreChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoundedContainer(
          backgroundColor: AppTheme.primaryColor,
          child: Column(
            children: [
              _InstantScoreOperationTile(
                operation: EnterScoreOperation.add,
                isActive: operation == EnterScoreOperation.add,
                symbol: '+',
                onOperationChange: onOperationChange,
              ),
              _InstantScoreOperationTile(
                operation: EnterScoreOperation.subtract,
                isActive: operation == EnterScoreOperation.subtract,
                symbol: '-',
                onOperationChange: onOperationChange,
              ),
            ],
          ),
        ),
        const SizedBox(width: Dimensions.doubleStandardSpacing),
        _InstantScoreTile(text: '1', onTap: () => onScoreChange(1)),
        const Expanded(child: SizedBox.shrink()),
        _InstantScoreTile(text: '5', onTap: () => onScoreChange(5)),
        const Expanded(child: SizedBox.shrink()),
        _InstantScoreTile(text: '10', onTap: () => onScoreChange(10)),
        const Expanded(child: SizedBox.shrink()),
        _InstantScoreTile(text: '50', onTap: () => onScoreChange(50)),
      ],
    );
  }
}

class _InstantScoreOperationTile extends StatelessWidget {
  const _InstantScoreOperationTile({
    Key? key,
    required this.operation,
    required this.isActive,
    required this.symbol,
    required this.onOperationChange,
  }) : super(key: key);

  final bool isActive;
  final String symbol;
  final EnterScoreOperation operation;
  final ValueChanged<EnterScoreOperation> onOperationChange;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      width: 44,
      height: 44,
      backgroundColor: isActive ? AppTheme.accentColor : Colors.transparent,
      splashColor: isActive ? null : AppTheme.accentColor,
      onTap: () => onOperationChange(operation),
      child: Center(
          child: Text(
        symbol,
        style: AppTheme.theme.textTheme.headline1,
      )),
    );
  }
}

class _InstantScoreTile extends StatelessWidget {
  const _InstantScoreTile({
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      addShadow: true,
      onTap: onTap,
      width: 52,
      height: 52,
      child: Center(
        child: Text(
          text,
          style: AppTheme.theme.textTheme.headline3!,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onUndo,
    required this.onDone,
    Key? key,
  }) : super(key: key);

  final VoidCallback onUndo;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer<EnterScoreViewModel>(builder: (_, viewModel, __) {
          return IconAndElevatedButton(
            title: AppText.enterScoreDialogUndoButtonText,
            icon: const DefaultIcon(Icons.undo),
            color: AppTheme.blueColor,
            onPressed: viewModel.canUndo ? onUndo : null,
          );
        }),
        const Expanded(child: SizedBox.shrink()),
        IconAndElevatedButton(
          title: AppText.enterScoreDialogDoneButtonText,
          icon: const DefaultIcon(Icons.done),
          color: AppTheme.accentColor,
          onPressed: onDone,
        ),
      ],
    );
  }
}

class _CircularNumberPicker extends StatefulWidget {
  const _CircularNumberPicker({
    Key? key,
    this.onChanged,
    this.onEnded,
    this.size = const Size(280, 280),
    this.strokeWidth = 30,
    this.thumbSize = 30,
    this.highestNumberInSingleSpin = 12,
  }) : super(key: key);

  /// Called during a drag when the user is selecting a color.
  ///
  /// This callback called with latest color that user selected.
  final ValueChanged<int>? onChanged;

  /// Called when drag ended.
  ///
  /// This callback called with latest color that user selected.
  final ValueChanged<int>? onEnded;

  /// The size of widget.
  /// Draggable area is thumb widget is included to the size,
  /// so circle is smaller than the size.
  ///
  /// Default value is 280 x 280.
  final Size size;

  /// The width of circle border.
  ///
  /// Default value is 2.
  final double strokeWidth;

  /// The size of thumb for circle picker.
  ///
  /// Default value is 32.
  final double thumbSize;

  final int highestNumberInSingleSpin;

  @override
  _CircularNumberPickerState createState() => _CircularNumberPickerState();
}

class _CircularNumberPickerState extends State<_CircularNumberPicker>
    with TickerProviderStateMixin {
  static const int _fullCricleDegrees = 360;

  double _numberOpacity = 0.0;

  late double _angle;
  late int _number;
  late final double _degreesPerNumber;

  @override
  void initState() {
    super.initState();
    _angle = 0;
    _number = 0;

    assert(widget.highestNumberInSingleSpin > 0);
    _degreesPerNumber = _fullCricleDegrees / widget.highestNumberInSingleSpin;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: Stack(
        children: <Widget>[
          _NumberPicker(
            angle: _angle,
            size: widget.size,
            strokeWidth: widget.strokeWidth,
            thumbSize: widget.thumbSize,
            onEnded: () => _handleEndedPicking(),
            onChanged: (double angle, int multiplier) => _handleNumberChange(angle, multiplier),
          ),
          Positioned.fill(
            child: Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _numberOpacity,
                onEnd: () => _resetPickedNumber(),
                child: Text(
                  _number > 0 ? '+$_number' : '$_number',
                  style: AppTheme.theme.textTheme.headline1?.copyWith(fontSize: 56),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetPickedNumber() {
    if (_angle == 0) {
      _number = 0;
    }
  }

  void _handleNumberChange(double angle, int multiplier) {
    setState(() {
      _angle = angle;
      _numberOpacity = 1;
      _number =
          ((angle / _degreesPerNumber).floor() + 1) + widget.highestNumberInSingleSpin * multiplier;
      if (multiplier < 0) {
        _number--;
      }

      widget.onChanged?.call(_number);
    });
  }

  void _handleEndedPicking() {
    widget.onEnded?.call(_number);
    setState(() {
      _angle = 0;
      _numberOpacity = 0;
      widget.onChanged?.call(0);
    });
  }
}

class _NumberPicker extends StatefulWidget {
  const _NumberPicker({
    Key? key,
    required this.angle,
    required this.onChanged,
    required this.onEnded,
    required this.size,
    required this.strokeWidth,
    required this.thumbSize,
  }) : super(key: key);

  final double angle;

  final void Function(double, int) onChanged;

  final VoidCallback onEnded;

  final Size size;

  final double strokeWidth;

  final double thumbSize;

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<_NumberPicker> with TickerProviderStateMixin {
  late bool _isInit;
  late int _fullCirclesCount;
  late bool _isApproachingFromRight;
  late bool _isApproachingFromLeft;

  @override
  void initState() {
    super.initState();
    _isInit = true;
    _fullCirclesCount = 0;
    _isApproachingFromLeft = false;
    _isApproachingFromRight = false;
  }

  @override
  Widget build(BuildContext context) {
    final minSize = min(widget.size.width, widget.size.height);
    final offset = _CircleTween(
      minSize / 2 - widget.thumbSize / 2,
    ).lerp(widget.angle * pi / 180);

    return GestureDetector(
      onPanDown: _onDown,
      onHorizontalDragStart: _onStart,
      onHorizontalDragUpdate: _onUpdate,
      onHorizontalDragEnd: _onEnd,
      onVerticalDragStart: _onStart,
      onVerticalDragUpdate: _onUpdate,
      onVerticalDragEnd: _onEnd,
      child: SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: CustomPaint(painter: _CirclePickerPainter(widget.strokeWidth)),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: _Thumb(size: widget.thumbSize, color: AppTheme.accentColor),
            ),
          ],
        ),
      ),
    );
  }

  void _onDown(DragDownDetails details) {
    _updatePosition(details.localPosition);
  }

  void _onStart(DragStartDetails details) {
    _updatePosition(details.localPosition);
  }

  void _onUpdate(DragUpdateDetails details) {
    _updatePosition(details.localPosition);
  }

  void _onEnd(DragEndDetails details) {
    _reset();
    widget.onEnded();
  }

  void _updatePosition(Offset position) {
    final double radians = atan2(
      position.dy - widget.size.height / 2,
      position.dx - widget.size.width / 2,
    );
    final double angle = radians % (2 * pi) * 180 / pi;

    if (_isApproachingFromRight && angle.isBetween(0, 90)) {
      _fullCirclesCount++;
      _isApproachingFromRight = false;
    }
    if (_isApproachingFromLeft && angle.isBetween(270, 360)) {
      _fullCirclesCount--;
      _isApproachingFromLeft = false;
    }

    if (_isInit && angle.isBetween(270, 360)) {
      _fullCirclesCount--;
    }

    if (angle.isBetween(90, 270)) {
      _isApproachingFromRight = false;
      _isApproachingFromLeft = false;
    }
    if (!_isApproachingFromRight && angle.isBetween(270, 360)) {
      _isApproachingFromRight = true;
      _isApproachingFromLeft = false;
    }
    if (!_isApproachingFromLeft && angle.isBetween(0, 90)) {
      _isApproachingFromRight = false;
      _isApproachingFromLeft = true;
    }

    widget.onChanged(angle, _fullCirclesCount);

    if (_isInit) {
      _isInit = false;
    }
  }

  void _reset() {
    _isInit = true;
    _fullCirclesCount = 0;
    _isApproachingFromLeft = false;
    _isApproachingFromRight = false;
  }
}

class _CircleTween extends Tween<Offset> {
  _CircleTween(this.radius)
      : super(
          begin: _radiansToOffset(0, radius),
          end: _radiansToOffset(2 * pi, radius),
        );

  final double radius;

  @override
  Offset lerp(double t) => _radiansToOffset(t, radius);

  static Offset _radiansToOffset(double radians, double radius) {
    return Offset(
      radius + radius * cos(radians),
      radius + radius * sin(radians),
    );
  }
}

class _CirclePickerPainter extends CustomPainter {
  const _CirclePickerPainter(this.strokeWidth);

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radio = (min(size.width, size.height) / 2) - strokeWidth / 2;

    canvas.drawCircle(
      center,
      radio,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = AppTheme.primaryColor.withOpacity(0.3),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    Key? key,
    required this.size,
    required this.color,
  }) : super(key: key);

  final double size;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
