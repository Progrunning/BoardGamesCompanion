// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'games_screenshot_generator.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GamesScreenshotGenerator on _GamesScreenshotGenerator, Store {
  late final _$gamesScreenshotGeneratorStateAtom = Atom(
      name: '_GamesScreenshotGenerator.gamesScreenshotGeneratorState',
      context: context);

  @override
  GamesScreenshotGeneratorState get gamesScreenshotGeneratorState {
    _$gamesScreenshotGeneratorStateAtom.reportRead();
    return super.gamesScreenshotGeneratorState;
  }

  @override
  set gamesScreenshotGeneratorState(GamesScreenshotGeneratorState value) {
    _$gamesScreenshotGeneratorStateAtom
        .reportWrite(value, super.gamesScreenshotGeneratorState, () {
      super.gamesScreenshotGeneratorState = value;
    });
  }

  late final _$generateScreenshotAsyncAction = AsyncAction(
      '_GamesScreenshotGenerator.generateScreenshot',
      context: context);

  @override
  Future<void> generateScreenshot(List<BoardGameDetails> boardGames,
      [int numberOfColumns = 5]) {
    return _$generateScreenshotAsyncAction
        .run(() => super.generateScreenshot(boardGames, numberOfColumns));
  }

  @override
  String toString() {
    return '''
gamesScreenshotGeneratorState: ${gamesScreenshotGeneratorState}
    ''';
  }
}
