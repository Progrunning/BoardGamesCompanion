// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthrough_note_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughNoteViewModel on _PlaythroughNoteViewModel, Store {
  Computed<bool>? _$isNoteEmptyComputed;

  @override
  bool get isNoteEmpty =>
      (_$isNoteEmptyComputed ??= Computed<bool>(() => super.isNoteEmpty,
              name: '_PlaythroughNoteViewModel.isNoteEmpty'))
          .value;
  Computed<PlaythroughNotePageVisualState>? _$visualStateComputed;

  @override
  PlaythroughNotePageVisualState get visualState => (_$visualStateComputed ??=
          Computed<PlaythroughNotePageVisualState>(() => super.visualState,
              name: '_PlaythroughNoteViewModel.visualState'))
      .value;

  late final _$noteAtom =
      Atom(name: '_PlaythroughNoteViewModel.note', context: context);

  @override
  PlaythroughNote? get note {
    _$noteAtom.reportRead();
    return super.note;
  }

  @override
  set note(PlaythroughNote? value) {
    _$noteAtom.reportWrite(value, super.note, () {
      super.note = value;
    });
  }

  late final _$_PlaythroughNoteViewModelActionController =
      ActionController(name: '_PlaythroughNoteViewModel', context: context);

  @override
  void setNote(PlaythroughNote? playthroughNote) {
    final _$actionInfo = _$_PlaythroughNoteViewModelActionController
        .startAction(name: '_PlaythroughNoteViewModel.setNote');
    try {
      return super.setNote(playthroughNote);
    } finally {
      _$_PlaythroughNoteViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateNote(String text) {
    final _$actionInfo = _$_PlaythroughNoteViewModelActionController
        .startAction(name: '_PlaythroughNoteViewModel.updateNote');
    try {
      return super.updateNote(text);
    } finally {
      _$_PlaythroughNoteViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
note: ${note},
isNoteEmpty: ${isNoteEmpty},
visualState: ${visualState}
    ''';
  }
}
