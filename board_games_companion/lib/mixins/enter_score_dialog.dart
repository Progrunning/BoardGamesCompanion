import 'dart:async';

import 'package:board_games_companion/pages/enter_score/enter_score_view_model.dart';
import 'package:flutter/material.dart';

import '../pages/enter_score/enter_score_dialog.dart';

mixin EnterScoreDialogMixin {
  Future<void> showEnterScoreDialog(BuildContext context, EnterScoreViewModel viewModel) async {
    await showGeneralDialog<void>(
      context: context,
      pageBuilder: (_, __, ___) {
        return EnterScoreDialog(viewModel: viewModel);
      },
    );
  }
}
