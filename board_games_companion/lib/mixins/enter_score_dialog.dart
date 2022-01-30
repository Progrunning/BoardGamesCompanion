import 'dart:async';
import 'dart:math';

import 'package:board_games_companion/common/app_text.dart';
import 'package:flutter/material.dart';

import '../common/app_theme.dart';
import '../common/dimensions.dart';
import '../common/styles.dart';
import '../extensions/double_extensions.dart';
import '../widgets/common/default_icon.dart';
import '../widgets/common/icon_and_text_button.dart';
import '../widgets/rounded_container.dart';

mixin EnterScoreDialogMixin {
  Future<int?> showEnterScoreDialog(BuildContext context) async {
    return showGeneralDialog<int>(
      barrierDismissible: true,
      barrierLabel: 'dismiss',
      context: context,
      pageBuilder: (_, __, ___) {
        return const EnterScoreDialog();
      },
    );
  }
}

class EnterScoreDialog extends StatelessWidget {
  const EnterScoreDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const _Header(),
              const SizedBox(height: Dimensions.doubleStandardSpacing),
              const _CircularNumberPicker(strokeWidth: 50, thumbSize: 50),
              const SizedBox(height: Dimensions.doubleStandardSpacing),
              const _InstantScorePanel(),
              const SizedBox(height: Dimensions.trippleStandardSpacing),
              _ActionButtons(
                onUndo: () {},
                onSave: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          'Miko',
          style: AppTheme.theme.textTheme.headline1!,
        ),
        const SizedBox(width: Dimensions.standardSpacing),
        Text(
          '80',
          style: AppTheme.theme.textTheme.headline1!.copyWith(
            fontSize: Dimensions.doubleExtraLargeFontSize,
          ),
        ),
      ],
    );
  }
}

class _InstantScorePanel extends StatelessWidget {
  const _InstantScorePanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoundedContainer(
          backgroundColor: AppTheme.primaryColor,
          addShadow: true,
          child: Column(
            children: [
              RoundedContainer(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.doubleStandardSpacing,
                    vertical: Dimensions.standardSpacing,
                  ),
                  child: Text('+'),
                ),
              ),
              RoundedContainer(
                onTap: () {},
                backgroundColor: Colors.transparent,
                splashColor: AppTheme.accentColor,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.doubleStandardSpacing,
                    vertical: Dimensions.standardSpacing,
                  ),
                  child: Text('-'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: Dimensions.doubleStandardSpacing),
        _InstantScoreTile(text: '1', onTap: () {}),
        const Expanded(child: SizedBox.shrink()),
        _InstantScoreTile(text: '5', onTap: () {}),
        const Expanded(child: SizedBox.shrink()),
        _InstantScoreTile(text: '10', onTap: () {}),
        const Expanded(child: SizedBox.shrink()),
        _InstantScoreTile(text: '50', onTap: () {}),
      ],
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
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.doubleStandardSpacing,
          vertical: Dimensions.standardSpacing,
        ),
        child: Text(
          text,
          style: AppTheme.theme.textTheme.bodyText1!,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onUndo,
    required this.onSave,
    Key? key,
  }) : super(key: key);

  final VoidCallback onUndo;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconAndTextButton(
          title: AppText.enterScoreDialogUndoButtonText,
          icon: const DefaultIcon(Icons.undo),
          color: AppTheme.blueColor,
          onPressed: onUndo,
        ),
        const Expanded(child: SizedBox.shrink()),
        IconAndTextButton(
          title: AppText.enterScoreDialogSaveButtonText,
          icon: const DefaultIcon(
            Icons.save,
          ),
          color: AppTheme.accentColor,
          onPressed: onSave,
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
            child: Text(
              _number > 0 ? '+$_number' : '$_number',
              style: AppTheme.theme.textTheme.headline1?.copyWith(fontSize: 60),
            ),
          )),
        ],
      ),
    );
  }

  void _handleNumberChange(double angle, int multiplier) {
    setState(() {
      _angle = angle;
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
      _number = 0;
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
      onPanCancel: _onCancel,
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

  void _onCancel() {
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
