import 'dart:math';

import 'package:flutter/material.dart';

import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../common/styles.dart';
import '../../models/bgg/bgg_plays_import_raport.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
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

    return Material(
      color: Colors.transparent,
      child: Center(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const ItemPropertyTitle(AppText.importPlaysReportImportedPlaysSectionTitle),
                _ImportedPlays(report: report),
                const SizedBox(height: Dimensions.halfStandardSpacing),
                if (report.createdPlayers.isNotEmpty) ...[
                  const SizedBox(height: Dimensions.standardSpacing),
                  const ItemPropertyTitle(AppText.importPlaysReportImportedPlayersSectionTitle),
                  const SizedBox(height: Dimensions.halfStandardSpacing),
                  _ImportedPlayers(players: report.createdPlayers),
                ],
                if (report.errors.isNotEmpty) ...[
                  const SizedBox(height: Dimensions.standardSpacing),
                  const ItemPropertyTitle(AppText.importPlaysReportImportErrorsSectionTitle),
                  const SizedBox(height: Dimensions.halfStandardSpacing),
                  Column(
                    children: [for (var error in report.errors) Text(error.description!)],
                  )
                ],
                const SizedBox(height: Dimensions.doubleStandardSpacing),
                _ActionButtons(
                  onSend: report.errors.isNotEmpty
                      ? () {
                          // TODO Handle
                        }
                      : null,
                  onOk: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImportedPlays extends StatelessWidget {
  const _ImportedPlays({
    Key? key,
    required this.report,
  }) : super(key: key);

  final BggPlaysImportRaport report;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Imported ',
          ),
          TextSpan(
            text: '${report.percentageOfImportedGames.toStringAsFixed(0)}%',
            style: AppTheme.titleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' of plays (${report.playsImported} / ${report.playsToImportTotal})',
          ),
        ],
      ),
    );
  }
}

class _ImportedPlayers extends StatelessWidget {
  const _ImportedPlayers({
    required this.players,
    Key? key,
  }) : super(key: key);

  final List<String> players;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.standardSpacing),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: Dimensions.standardSpacing,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          for (var player in players)
            Chip(
              padding: const EdgeInsets.all(Dimensions.standardSpacing),
              backgroundColor: AppTheme.primaryColor.withAlpha(
                Styles.opacity80Percent,
              ),
              label: Text(
                player,
                style: const TextStyle(color: AppTheme.defaultTextColor),
              ),
            ),
        ],
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

  final VoidCallback? onSend;
  final VoidCallback onOk;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onSend != null)
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
