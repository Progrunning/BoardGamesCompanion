import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../mixins/import_collection.dart';
import 'default_icon.dart';
import 'elevated_icon_button.dart';

class ImportCollectionsButton extends StatefulWidget {
  const ImportCollectionsButton({
    required String Function() usernameCallback,
    bool? triggerImport,
    super.key,
  })  : _usernameCallback = usernameCallback,
        _triggerImport = triggerImport;

  final String Function() _usernameCallback;
  final bool? _triggerImport;

  @override
  ImportCollectionsButtonState createState() => ImportCollectionsButtonState();
}

class ImportCollectionsButtonState extends State<ImportCollectionsButton>
    with TickerProviderStateMixin, ImportCollection {
  late AnimationController _fadeInAnimationController;
  late AnimationController _sizeAnimationController;

  @override
  void initState() {
    super.initState();

    _fadeInAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 500),
    );
    _sizeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      value: 1,
    );
  }

  @override
  void didUpdateWidget(covariant ImportCollectionsButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget._triggerImport ?? false) {
      _import(context);
    }
  }

  @override
  void dispose() {
    _fadeInAnimationController.dispose();
    _sizeAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      text: AppText.importCollectionsButtonText,
      icon: const DefaultIcon(Icons.download),
      sizeAnimationController: _sizeAnimationController,
      fadeInAnimationController: _fadeInAnimationController,
      onPressed: () => _import(context),
    );
  }

  Future<void> _import(BuildContext context) async {
    await importCollections(context, widget._usernameCallback());

    if (mounted) {
      _sizeAnimationController.forward();
      _fadeInAnimationController.reverse();
    }
  }
}

class AnimatedButton extends AnimatedWidget {
  const AnimatedButton({
    required String text,
    required Widget icon,
    required AnimationController sizeAnimationController,
    required AnimationController fadeInAnimationController,
    required Future<void> Function() onPressed,
    super.key,
  })  : _text = text,
        _icon = icon,
        _sizeAnimationController = sizeAnimationController,
        _fadeInAnimationController = fadeInAnimationController,
        _onPressed = onPressed,
        super(
          listenable: sizeAnimationController,
        );

  final String _text;
  final Widget _icon;
  final AnimationController _sizeAnimationController;
  final AnimationController _fadeInAnimationController;

  final Future<void> Function() _onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.scale(
          scale: _sizeAnimationController.value,
          child: ElevatedIconButton(
            title: _text,
            icon: _icon,
            onPressed: () async {
              _fadeInAnimationController.forward();
              _sizeAnimationController.reverse();

              await _onPressed();
            },
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: FadeTransition(
              opacity: _fadeInAnimationController,
              child: const CircularProgressIndicator(color: AppColors.accentColor),
            ),
          ),
        ),
      ],
    );
  }
}
