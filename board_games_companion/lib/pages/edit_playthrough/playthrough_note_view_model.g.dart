// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playthrough_note_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaythroughNoteViewModel on _PlaythroughNoteViewModel, Store {
  late final _$noteAtom =
      Atom(name: '_PlaythroughNoteViewModel.note', context: context);

  @override
  String? get note {
    _$noteAtom.reportRead();
    return super.note;
  }

  @override
  set note(String? value) {
    _$noteAtom.reportWrite(value, super.note, () {
      super.note = value;
    });
  }

  late final _$addNoteAsyncAction =
      AsyncAction('_PlaythroughNoteViewModel.addNote', context: context);

  @override
  Future<void> addNote(String value) {
    return _$addNoteAsyncAction.run(() => super.addNote(value));
  }

  late final _$_PlaythroughNoteViewModelActionController =
      ActionController(name: '_PlaythroughNoteViewModel', context: context);

  @override
  void setNote(String value) {
    final _$actionInfo = _$_PlaythroughNoteViewModelActionController
        .startAction(name: '_PlaythroughNoteViewModel.setNote');
    try {
      return super.setNote(value);
    } finally {
      _$_PlaythroughNoteViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPlaythrough(Playthrough value) {
    final _$actionInfo = _$_PlaythroughNoteViewModelActionController
        .startAction(name: '_PlaythroughNoteViewModel.setPlaythrough');
    try {
      return super.setPlaythrough(value);
    } finally {
      _$_PlaythroughNoteViewModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
note: ${note}
    ''';
  }
}
