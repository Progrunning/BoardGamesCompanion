import 'package:board_games_companion/common/enums/game_classification.dart';
import 'package:board_games_companion/models/collection_import_result.dart';
import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/models/hive/board_game_prices.dart';
import 'package:board_games_companion/models/hive/board_game_settings.dart';
import 'package:board_games_companion/services/board_games_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/board_games_geek_service_mock.dart';
import '../mocks/hive_box_mock.dart';
import '../mocks/hive_interface_mock.dart';

void main() {
  const sampleBoardGameDetails = BoardGameDetails(id: '1', name: 'Scythe');

  const String mockUsername = 'JohnCena';

  late MockBoardGamesGeekService mockBoardGamesGeekService;
  late MockHiveInterface mockHiveInterface;
  late MockBox<BoardGameDetails> mockBox;

  late final BoardGamesService boardGamesService;

  setUp(() {
    mockBoardGamesGeekService = MockBoardGamesGeekService();
    mockBox = MockBox<BoardGameDetails>();
    when(() => mockBox.put(any<dynamic>(), any())).thenAnswer((_) => Future.value());
    mockHiveInterface = MockHiveInterface();
    when(() => mockHiveInterface.isBoxOpen(any())).thenAnswer((_) => false);
    when(() => mockHiveInterface.openBox<BoardGameDetails>(any())).thenAnswer((_) async => mockBox);
    boardGamesService = BoardGamesService(mockHiveInterface, mockBoardGamesGeekService);
  });

  setUpAll(() {
    // MK Required fallback of a dummy objects when mocktail needs to return a model of such type
    registerFallbackValue(sampleBoardGameDetails);
  });

  tearDown(() {
    reset(mockBoardGamesGeekService);
    reset(mockBox);
    reset(mockHiveInterface);
  });

  group('GIVEN import collection', () {
    test(
        'WHEN an imported game is already in collection '
        'THEN its existing details should not be erased ', () async {
      const importedBoardGameWithoutDetails = sampleBoardGameDetails;
      final existingBoardGame = importedBoardGameWithoutDetails.copyWith(
        prices: [
          const BoardGamePrices(
            region: '',
            websiteUrl: '',
            lowest: 10,
          ),
        ],
        settings: const BoardGameSettings(gameClassification: GameClassification.NoScore),
      );

      when(() => mockBoardGamesGeekService.importCollections(mockUsername)).thenAnswer(
        (_) async => CollectionImportResult()
          ..isSuccess = true
          ..data = [importedBoardGameWithoutDetails],
      );
      when(() => mockBox.values).thenReturn([existingBoardGame]);

      final importedCollections = await boardGamesService.importCollections(mockUsername);

      expect(importedCollections.isSuccess, isTrue);
      expect(importedCollections.errors, isNull);
      expect(importedCollections.data, [importedBoardGameWithoutDetails]);

      verify(() => mockBox.put(importedBoardGameWithoutDetails.id, existingBoardGame)).called(1);
    });
  });
}
