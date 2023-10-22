import 'dart:async';

import 'package:flutter/material.dart';

import '../pages/enter_score/enter_score_dialog.dart';
import '../pages/enter_score/enter_score_view_model.dart';

mixin EnterScoreDialogMixin {
  Future<void> showEnterScoreDialog(BuildContext context, EnterScoreViewModel viewModel) async {
    await showGeneralDialog<void>(
      context: context,
      routeSettings: const RouteSettings(name: EnterScoreDialog.pageRoute),
      pageBuilder: (_, __, ___) {
        return EnterScoreDialog(viewModel: viewModel);
      },
    );
  }
}
