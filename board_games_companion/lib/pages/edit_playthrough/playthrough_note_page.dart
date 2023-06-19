import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/app_colors.dart';
import '../../common/app_text.dart';
import '../../common/app_theme.dart';
import '../../common/dimensions.dart';
import '../../widgets/common/default_icon.dart';
import '../../widgets/common/elevated_icon_button.dart';
import '../../widgets/common/page_container.dart';
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
    widget.viewModel.visualState.maybeWhen(
      edit: (note) => _controller.text = note.text,
      orElse: () {},
    );
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
      body: SafeArea(
        child: PageContainer(
          child: Column(
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
                  onChanged: (note) async => _updateNote(note),
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
              Padding(
                padding: const EdgeInsets.all(Dimensions.standardSpacing),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Observer(
                    builder: (_) {
                      return ElevatedIconButton(
                        title: widget.viewModel.isNewNote
                            ? AppText.playthroughNotePageAddNoteButtonText
                            : AppText.playthroughNotePageUpdateNoteButtonText,
                        icon: const DefaultIcon(Icons.save),
                        color: AppColors.accentColor,
                        onPressed: widget.viewModel.isNoteEmpty ? null : () async => _saveNote(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveNote() async {
    final navigatorState = Navigator.of(context);
    widget.viewModel.updateNote(_controller.text);
    navigatorState.pop(widget.viewModel.note);
  }

  void _updateNote(String note) => widget.viewModel.updateNote(note);
}
