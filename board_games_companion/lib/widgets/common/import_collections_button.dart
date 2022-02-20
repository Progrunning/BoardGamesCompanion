import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';

import '../../mixins/import_collection.dart';
import 'default_icon.dart';
import 'elevated_icon_button.dart';

class ImportCollectionsButton extends StatefulWidget {
  const ImportCollectionsButton({
    required String bggUserName,
    bool? triggerImport,
    Key? key,
  })  : _bggUserName = bggUserName,
        _triggerImport = triggerImport,
        super(key: key);

  final String _bggUserName;
  final bool? _triggerImport;

  @override
  _ImportCollectionsButtonState createState() => _ImportCollectionsButtonState();
}

class _ImportCollectionsButtonState extends State<ImportCollectionsButton>
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
    return _AnimatedButton(
      sizeAnimationController: _sizeAnimationController,
      fadeInAnimationController: _fadeInAnimationController,
      onPressed: () => _import(context),
    );
  }

  Future<void> _import(BuildContext context) async {
    _fadeInAnimationController.forward();
    _sizeAnimationController.reverse();

    await importCollections(context, widget._bggUserName);

    if (mounted) {
      _sizeAnimationController.forward();
      _fadeInAnimationController.reverse();
    }
  }
}

class _AnimatedButton extends AnimatedWidget {
  const _AnimatedButton({
    Key? key,
    required AnimationController sizeAnimationController,
    required AnimationController fadeInAnimationController,
    required VoidCallback onPressed,
  })  : _sizeAnimationController = sizeAnimationController,
        _fadeInAnimationController = fadeInAnimationController,
        _onPressed = onPressed,
        super(
          key: key,
          listenable: sizeAnimationController,
        );

  final AnimationController _sizeAnimationController;
  final AnimationController _fadeInAnimationController;

  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.scale(
          scale: _sizeAnimationController.value,
          child: ElevatedIconButton(
            title: AppText.importCollectionsButtonText,
            icon: const DefaultIcon(Icons.download),
            onPressed: _onPressed,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: FadeTransition(
              opacity: _fadeInAnimationController,
              child: const CircularProgressIndicator(color: AppTheme.accentColor),
            ),
          ),
        ),
      ],
    );
  }
}
