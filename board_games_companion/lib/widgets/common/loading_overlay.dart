import 'package:basics/string_basics.dart';
import 'package:board_games_companion/common/app_theme.dart';
import 'package:board_games_companion/common/dimensions.dart';
import 'package:board_games_companion/widgets/common/loading_indicator_widget.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    required this.child,
    this.title,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Container(
          color: AppTheme.blackColor.withOpacity(0.7),
          // TODO Add fade-in & out animation
          child: Column(
            children: [
              const Expanded(child: SizedBox.shrink()),
              const LoadingIndicator(),
              if (title?.isNotBlank ?? false) ...[
                const Padding(padding: EdgeInsets.only(top: Dimensions.doubleStandardSpacing)),
                Text(
                  title!,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ),
      ],
    );
  }
}
