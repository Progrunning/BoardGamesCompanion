import 'package:board_games_companion/common/app_text.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:flutter/material.dart';

import '../../mixins/import_collection.dart';
import 'default_icon.dart';
import 'elevated_icon_button.dart';

class ImportCollectionsButton extends StatefulWidget {
  const ImportCollectionsButton({
    required String Function() usernameCallback,
    Key? key,
  })  : _usernameCallback = usernameCallback,
        super(key: key);

  final String Function() _usernameCallback;

  @override
  _ImportCollectionsButtonState createState() => _ImportCollectionsButtonState();
}

class _ImportCollectionsButtonState extends State<ImportCollectionsButton>
    with TickerProviderStateMixin {
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
  Widget build(BuildContext context) {
    return _AnimatedButton(
      sizeAnimationController: _sizeAnimationController,
      fadeInAnimationController: _fadeInAnimationController,
      usernameCallback: widget._usernameCallback,
      parentMounted: mounted,
    );
  }

  @override
  void dispose() {
    _fadeInAnimationController.dispose();
    _sizeAnimationController.dispose();

    super.dispose();
  }
}

class _AnimatedButton extends AnimatedWidget with ImportCollection {
  const _AnimatedButton({
    Key? key,
    required AnimationController sizeAnimationController,
    required AnimationController fadeInAnimationController,
    required this.usernameCallback,
    required this.parentMounted,
  })  : _sizeAnimationController = sizeAnimationController,
        _fadeInAnimationController = fadeInAnimationController,
        super(
          key: key,
          listenable: sizeAnimationController,
        );

  final AnimationController _sizeAnimationController;
  final AnimationController _fadeInAnimationController;

  final String Function() usernameCallback;
  final bool parentMounted;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.scale(
          scale: _sizeAnimationController.value,
          child: ElevatedIconButton(
            title: AppText.importCollectionsButtonText,
            icon: const DefaultIcon(Icons.download),
            onPressed: () async {
              _fadeInAnimationController.forward();
              _sizeAnimationController.reverse();

              await importCollections(context, usernameCallback());

              if (parentMounted) {
                _sizeAnimationController.forward();
                _fadeInAnimationController.reverse();
              }
            },
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
