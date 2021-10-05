import 'dart:math';

import 'package:flutter/material.dart';

import '../../mixins/sync_collection.dart';
import 'default_icon.dart';
import 'icon_and_text_button.dart';

class SyncButton extends StatefulWidget {
  const SyncButton({
    required String Function() usernameCallback,
    Key? key,
  })  : _usernameCallback = usernameCallback,
        super(key: key);

  final String Function() _usernameCallback;

  @override
  _SyncButtonState createState() => _SyncButtonState();
}

class _SyncButtonState extends State<SyncButton> with SyncCollection, TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconAndTextButton(
      title: 'Sync',
      icon: _SyncCollectionIcon(animationController: _animationController),
      onPressed: () async {
        _animationController.repeat();
        await syncCollection(
          context,
          widget._usernameCallback(),
        );
        if (mounted) {
          _animationController.stop();
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }
}

class _SyncCollectionIcon extends AnimatedWidget {
  const _SyncCollectionIcon({
    required this.animationController,
    Key? key,
  }) : super(
          key: key,
          listenable: animationController,
        );

  Animation<double> get _progress => listenable as Animation<double>;

  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _progress.value * 12 * pi,
      child: const DefaultIcon(Icons.sync),
    );
  }
}
