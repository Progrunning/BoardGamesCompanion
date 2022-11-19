// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scores_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ScoresStore on _ScoresStore, Store {
  late final _$scoresAtom = Atom(name: '_ScoresStore.scores', context: context);

  @override
  ObservableList<Score> get scores {
    _$scoresAtom.reportRead();
    return super.scores;
  }

  @override
  set scores(ObservableList<Score> value) {
    _$scoresAtom.reportWrite(value, super.scores, () {
      super.scores = value;
    });
  }

  @override
  String toString() {
    return '''
scores: ${scores}
    ''';
  }
}
