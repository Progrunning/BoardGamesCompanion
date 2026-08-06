import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/app_colors.dart';
import '../../common/app_styles.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/dimensions.dart';
import '../../services/purchase_service.dart';
import '../../utilities/launcher_helper.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/generic_error_message_widget.dart';
import '../../widgets/common/loading_indicator_widget.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/page_container.dart';
import '../../widgets/common/supporter_badge.dart';
import 'app_icon_picker_section.dart';
import 'app_icon_picker_view_model.dart';
import 'tip_purchase_visual_state.dart';
import 'tip_view_model.dart';

class TipPage extends StatefulWidget {
  const TipPage({
    required this.viewModel,
    required this.appIconPickerViewModel,
    super.key,
  });

  final TipViewModel viewModel;
  final AppIconPickerViewModel appIconPickerViewModel;

  static const String pageRoute = '/tip';

  @override
  TipPageState createState() => TipPageState();
}

class TipPageState extends State<TipPage> {
  late final ReactionDisposer _purchaseVisualStateReactionDisposer;

  @override
  void initState() {
    super.initState();

    widget.viewModel.trackTipScreenViewed();
    unawaited(widget.viewModel.loadTipTiers());

    _purchaseVisualStateReactionDisposer = reaction<TipPurchaseVisualState>(
      (_) => widget.viewModel.purchaseVisualState,
      _onPurchaseVisualStateChanged,
    );
  }

  @override
  void dispose() {
    _purchaseVisualStateReactionDisposer();
    super.dispose();
  }

  void _onPurchaseVisualStateChanged(TipPurchaseVisualState purchaseVisualState) {
    purchaseVisualState.when(
      idle: () {},
      purchasing: () {},
      pending: () {},
      completed: _showThankYouDialog,
      failed: _showPurchaseFailedSnackbar,
    );
  }

  Future<void> _showThankYouDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppText.tipScreenThankYouDialogTitle),
        content: const Text(AppText.tipScreenThankYouDialogMessage),
        elevation: Dimensions.defaultElevation,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              AppText.ok,
              style: TextStyle(color: AppColors.accentColor),
            ),
          ),
        ],
      ),
    );

    widget.viewModel.dismissPurchaseResult();
  }

  void _showPurchaseFailedSnackbar() {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: Dimensions.snackbarMargin,
          content: const Text(AppText.tipScreenPurchaseErrorMessage),
          action: SnackBarAction(
            label: AppText.tipScreenRetryButtonText,
            onPressed: () {
              widget.viewModel.dismissPurchaseResult();
              widget.viewModel.retryLastPurchase();
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppText.tipScreenTitle,
          style: AppTheme.titleTextStyle,
        ),
      ),
      body: SafeArea(
        child: PageContainer(
          child: Observer(
            builder: (_) {
              final Widget body = widget.viewModel.visualState.when(
                loading: () => const _Loading(),
                loaded: () => _TipScreenContent(
                  viewModel: widget.viewModel,
                  appIconPickerViewModel: widget.appIconPickerViewModel,
                ),
                failedLoading: () => _LoadingFailed(onRetry: widget.viewModel.loadTipTiers),
              );

              if (widget.viewModel.purchaseVisualState ==
                  const TipPurchaseVisualState.purchasing()) {
                return LoadingOverlay(
                  title: AppText.tipScreenPurchasingMessage,
                  child: body,
                );
              }

              return body;
            },
          ),
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: LoadingIndicator());
  }
}

class _LoadingFailed extends StatelessWidget {
  const _LoadingFailed({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const GenericErrorMessage(),
          const SizedBox(height: Dimensions.standardSpacing),
          Text(
            AppText.tipScreenLoadingErrorMessage,
            textAlign: TextAlign.center,
            style: AppTheme.theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: Dimensions.standardSpacing),
          Align(
            alignment: Alignment.center,
            child: ElevatedIconButton(
              icon: const Icon(Icons.refresh),
              title: AppText.tipScreenRetryButtonText,
              onPressed: onRetry,
            ),
          ),
        ],
      ),
    );
  }
}

/// The main "loaded" content of the tip screen — the intro copy, the
/// already-tipped/pending banners, the tier list, and the restore-purchases
/// action. Laid out as a single scrollable column of sections so a future
/// supporter badge or "Join our Discord" button (out of scope here) can be
/// added as another section without restructuring this widget.
class _TipScreenContent extends StatelessWidget {
  const _TipScreenContent({required this.viewModel, required this.appIconPickerViewModel});

  final TipViewModel viewModel;
  final AppIconPickerViewModel appIconPickerViewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimensions.doubleStandardSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            AppText.tipScreenIntro,
            style: AppTheme.theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: Dimensions.standardSpacing),
          Text(
            AppText.tipScreenWhatItFunds,
            style: AppTheme.theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: Dimensions.standardSpacing),
          Text(
            AppText.tipScreenThankYouBlurb,
            style: AppTheme.theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: Dimensions.doubleStandardSpacing),
          if (viewModel.isSupporter) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: SupporterBadge(),
            ),
            const SizedBox(height: Dimensions.standardSpacing),
          ],
          if (viewModel.isSupporter) ...[
            const _Banner(text: AppText.tipScreenAlreadySupporterBanner),
            const SizedBox(height: Dimensions.standardSpacing),
          ] else if (viewModel.supporterStatus == SupporterStatus.pending) ...[
            const _Banner(text: AppText.tipScreenPendingBanner),
            const SizedBox(height: Dimensions.standardSpacing),
          ],
          if (viewModel.hasAnyTipTiers)
            for (final tipTier in viewModel.tipTiers!) ...[
              _TipTierTile(
                tipTier: tipTier,
                onTap: () => viewModel.purchase(tipTier),
              ),
              const SizedBox(height: Dimensions.standardSpacing),
            ]
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.doubleStandardSpacing),
              child: Text(
                AppText.tipScreenNoTiersAvailable,
                textAlign: TextAlign.center,
                style: AppTheme.theme.textTheme.bodyMedium,
              ),
            ),
          const SizedBox(height: Dimensions.standardSpacing),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: viewModel.restorePurchases,
              child: const Text(
                AppText.tipScreenRestorePurchasesButtonText,
                style: TextStyle(color: AppColors.accentColor),
              ),
            ),
          ),
          if (viewModel.canJoinDiscord) ...[
            const SizedBox(height: Dimensions.standardSpacing),
            const _JoinDiscordSection(),
          ],
          if (viewModel.isSupporter) ...[
            const SizedBox(height: Dimensions.doubleStandardSpacing),
            AppIconPickerSection(viewModel: appIconPickerViewModel),
          ],
        ],
      ),
    );
  }
}

/// The community perk revealed once a user is a Supporter — an action that
/// opens the unlisted supporters' Discord invite. The invite URL ships in
/// [Constants.supportersDiscordInviteUrl] (app config, not fetched from any
/// backend) so it can be rotated via an ordinary app release if it leaks.
class _JoinDiscordSection extends StatelessWidget {
  const _JoinDiscordSection();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedIconButton(
        icon: const Icon(Icons.forum),
        title: AppText.tipScreenJoinDiscordButtonText,
        onPressed: () => LauncherHelper.launchUri(
          context,
          Constants.supportersDiscordInviteUrl,
          launchMode: LaunchMode.externalApplication,
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.standardSpacing),
      decoration: BoxDecoration(
        color: AppColors.accentColor.withValues(alpha: .15),
        borderRadius: AppTheme.defaultBorderRadius,
        border: Border.all(color: AppColors.accentColor),
      ),
      child: Text(
        text,
        style: AppTheme.theme.textTheme.bodyMedium,
      ),
    );
  }
}

class _TipTierTile extends StatelessWidget {
  const _TipTierTile({
    required this.tipTier,
    required this.onTap,
  });

  final TipTier tipTier;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryColorLight,
      borderRadius: AppTheme.defaultBorderRadius,
      elevation: AppStyles.defaultElevation,
      child: InkWell(
        borderRadius: AppTheme.defaultBorderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.standardSpacing),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      tipTier.title,
                      style: AppTheme.sectionHeaderTextStyle,
                    ),
                    const SizedBox(height: Dimensions.halfStandardSpacing),
                    Text(
                      tipTier.description,
                      style: AppTheme.theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Dimensions.standardSpacing),
              Text(
                tipTier.priceString,
                style: AppTheme.theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
