import 'dart:math';

import 'package:flutter/material.dart';

import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../models/bgg/bgg_plays_import_raport.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/rounded_container.dart';

class BggPlaysImportReportDialog extends StatelessWidget {
  const BggPlaysImportReportDialog({
    required this.report,
    Key? key,
  }) : super(key: key);

  final BggPlaysImportRaport report;

  static const double _minWidth = 340;
  static const double _maxWidth = 380;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bggPlaysImportReportDialogWidth =
        max(_minWidth, min(width - 2 * Dimensions.doubleStandardSpacing, _maxWidth));

    return Center(
      child: RoundedContainer(
        width: bggPlaysImportReportDialogWidth,
        backgroundColor: AppTheme.primaryColorLight,
        addShadow: true,
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
              // TODO Add UI to show report information
              _ActionButtons(
                onSend: () {
                  // TODO Handle
                },
                onOk: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onSend,
    required this.onOk,
    Key? key,
  }) : super(key: key);

  final VoidCallback onSend;
  final VoidCallback onOk;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedIconButton(
          title: AppText.importPlaysSendReportViaEmailButtonText,
          icon: const Icon(Icons.email),
          color: AppTheme.blueColor,
          onPressed: onSend,
        ),
        const Expanded(child: SizedBox.shrink()),
        ElevatedIconButton(
          title: AppText.importPlaysOkButtonText,
          icon: const Icon(Icons.done),
          color: AppTheme.accentColor,
          onPressed: onOk,
        ),
      ],
    );
  }
}
