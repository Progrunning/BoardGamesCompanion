import 'package:board_games_companion/common/dimensions.dart';
import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import 'playthrough_note_view_model.dart';

class PlaythroughNotePage extends StatefulWidget {
  const PlaythroughNotePage({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final PlaythroughNoteViewModel viewModel;

  static const String pageRoute = '/addPlaythroughNote';

  @override
  State<PlaythroughNotePage> createState() => _PlaythroughNotePageState();
}

class _PlaythroughNotePageState extends State<PlaythroughNotePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.viewModel.note ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(AppText.playthroughNotePageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.standardSpacing),
            child: TextField(
              autofocus: true,
              controller: _controller,
              style: AppTheme.defaultTextFieldStyle.copyWith(
                fontSize: Dimensions.largeFontSize,
              ),
              maxLines: 5,
              decoration: InputDecoration(
                labelText: AppText.playthroughNoteTextBoxLabel,
                labelStyle: AppTheme.defaultTextFieldLabelStyle,
                hintText: AppText.playthroughNoteTextBoxHint,
                hintStyle: AppTheme.theme.inputDecorationTheme.hintStyle?.copyWith(
                  fontSize: Dimensions.largeFontSize,
                ),
              ),
              onSubmitted: (note) {
                // TODO Handle saving a note
              },
            ),
          ),
          const Expanded(child: SizedBox.shrink()),
          Padding(
            padding: const EdgeInsets.all(Dimensions.standardSpacing),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedIconButton(
                title: AppText.playthroughNotePageAddNoteButtonText,
                icon: const DefaultIcon(Icons.save),
                color: AppColors.accentColor,
                onPressed: () {
                  // TODO Handle saving a note
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
