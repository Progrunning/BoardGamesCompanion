import 'dart:math';

import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../models/bgg/bgg_plays_import_raport.dart';
import '../../models/import_result.dart';
import '../../utilities/launcher_helper.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/text/item_property_title_widget.dart';
import '../../widgets/elevated_container.dart';

class BggPlaysImportReportDialog extends StatelessWidget {
  const BggPlaysImportReportDialog({
    required this.username,
    required this.boardGameId,
    required this.report,
    Key? key,
  }) : super(key: key);

  final BggPlaysImportRaport report;
  final String username;
  final String boardGameId;

  static const double _minWidth = 340;
  static const double _maxWidth = 380;

  static const double _minHeight = 400;
  static const double _maxHeight = 500;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final bggPlaysImportReportDialogWidth =
        max(_minWidth, min(width - 2 * Dimensions.doubleStandardSpacing, _maxWidth));
    final bggPlaysImportReportDialogHeight =
        max(_minHeight, min(height - 2 * Dimensions.doubleStandardSpacing, _maxHeight));

    return Material(
      color: Colors.transparent,
      child: Center(
        child: SizedBox(
          width: bggPlaysImportReportDialogWidth,
          child: ElevatedContainer(
            backgroundColor: AppColors.primaryColorLight,
            elevation: AppStyles.defaultElevation,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppText.importPlaysReportImportReportTitle,
                    style: AppTheme.theme.textTheme.displayMedium,
                  ),
                  const SizedBox(height: Dimensions.doubleStandardSpacing),
                  LimitedBox(
                    maxHeight: bggPlaysImportReportDialogHeight,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ItemPropertyTitle(
                              AppText.importPlaysReportImportedPlaysSectionTitle),
                          _ImportedPlays(report: report),
                          if (report.createdPlayers.isNotEmpty) ...[
                            const SizedBox(height: Dimensions.standardSpacing),
                            const ItemPropertyTitle(
                                AppText.importPlaysReportImportedPlayersSectionTitle),
                            const SizedBox(height: Dimensions.halfStandardSpacing),
                            _ImportedPlayers(players: report.createdPlayers),
                          ],
                          if (report.errors.isNotEmpty) ...[
                            const SizedBox(height: Dimensions.standardSpacing),
                            const ItemPropertyTitle(
                              AppText.importPlaysReportImportErrorsSectionTitle,
                            ),
                            const SizedBox(height: Dimensions.halfStandardSpacing),
                            Column(
                              children: [
                                for (var error in report.errors) Text(error.description!),
                              ],
                            )
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.doubleStandardSpacing),
                  _ActionButtons(
                    onSend: report.errors.isNotEmpty ? () => _sendReportViaEmail(context) : null,
                    onOk: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendReportViaEmail(BuildContext context) async {
    final errorsFormatted =
        '[$username|$boardGameId] ${report.errors.map((ImportError importError) => importError.description).join(', ')}';
    await LauncherHelper.launchUri(
      context,
      'mailto:${Constants.feedbackEmailAddress}?subject=${Uri.encodeComponent('BGG Import Report')}&body=${Uri.encodeComponent(errorsFormatted)}',
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
          const TextSpan(text: 'Imported '),
          TextSpan(
            text: '${report.percentageOfImportedGames.toStringAsFixed(0)}%',
            style: AppTheme.titleTextStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: ' of plays (${report.playsImported} / ${report.playsToImportTotal})'),
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
              backgroundColor: AppColors.primaryColor.withAlpha(
                AppStyles.opacity80Percent,
              ),
              label: Text(
                player,
                style: const TextStyle(color: AppColors.defaultTextColor),
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
            color: AppColors.blueColor,
            onPressed: onSend,
          ),
        const Expanded(child: SizedBox.shrink()),
        ElevatedIconButton(
          title: AppText.importPlaysOkButtonText,
          icon: const Icon(Icons.done),
          color: AppColors.accentColor,
          onPressed: onOk,
        ),
      ],
    );
  }
}
