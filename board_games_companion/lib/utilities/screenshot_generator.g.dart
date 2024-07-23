// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screenshot_generator.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ScreenshotGenerator on _ScreenshotGenerator, Store {
  late final _$visualStateAtom =
      Atom(name: '_ScreenshotGenerator.visualState', context: context);

  @override
  ScreenshotGeneratorVisualState get visualState {
    _$visualStateAtom.reportRead();
    return super.visualState;
  }

  @override
  set visualState(ScreenshotGeneratorVisualState value) {
    _$visualStateAtom.reportWrite(value, super.visualState, () {
      super.visualState = value;
    });
  }

  late final _$generateCollectionScreenshotAsyncAction = AsyncAction(
      '_ScreenshotGenerator.generateCollectionScreenshot',
      context: context);

  @override
  Future<void> generateCollectionScreenshot(List<BoardGameDetails> boardGames,
      [int numberOfColumns = 5]) {
    return _$generateCollectionScreenshotAsyncAction.run(
        () => super.generateCollectionScreenshot(boardGames, numberOfColumns));
  }

  @override
  String toString() {
    return '''
visualState: ${visualState}
    ''';
  }
}
