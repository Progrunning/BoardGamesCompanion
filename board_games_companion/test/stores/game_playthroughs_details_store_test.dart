import 'package:board_games_companion/models/hive/board_game_details.dart';
import 'package:board_games_companion/models/hive/player.dart';
import 'package:board_games_companion/models/hive/playthrough.dart';
import 'package:board_games_companion/models/hive/score.dart';
import 'package:board_games_companion/models/hive/score_game_results.dart';
import 'package:board_games_companion/models/player_score.dart';
import 'package:board_games_companion/models/playthroughs/playthrough_details.dart';
import 'package:board_games_companion/stores/game_playthroughs_details_store.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' show ObservableList, ObservableMap;
import 'package:mocktail/mocktail.dart';

import '../mocks/board_games_store_mock.dart';
import '../mocks/players_store_mock.dart';
import '../mocks/playthroughs_store_mock.dart';
import '../mocks/scores_store_mock.dart';

class _FakeScore extends Fake implements Score {}

class _FakePlaythrough extends Fake implements Playthrough {}

void main() {
  final mockPlaythroughsStore = MockPlaythroughsStore();
  final mockScoresStore = MockScoresStore();
  final mockPlayersStore = MockPlayersStore();
  final mockBoardGamesStore = MockBoardGamesStore();

  // The board game the store is scoped to. It is deliberately DIFFERENT from the
  // playthrough's board game id below so that the `playthroughs` computed (used by
  // loadPlaythroughsDetails at the end of updatePlaythrough) filters down to empty
  // and stays a safe no-op, while the raw list still contains the original.
  const String scopedBoardGameId = 'scoped-bg';
  const String playthroughBoardGameId = 'bg1';
  const String playthroughId = 'p1';

  Playthrough buildOriginalPlaythrough({required List<String> scoreIds}) => Playthrough(
        id: playthroughId,
        boardGameId: playthroughBoardGameId,
        playerIds: const ['pl1'],
        scoreIds: scoreIds,
        startDate: clock.now(),
      );

  late GamePlaythroughsDetailsStore store;

  setUpAll(() {
    registerFallbackValue(_FakeScore());
    registerFallbackValue(_FakePlaythrough());
  });

  setUp(() {
    when(() => mockBoardGamesStore.allBoardGamesMap).thenReturn(
      ObservableMap.of(
        {scopedBoardGameId: const BoardGameDetails(id: scopedBoardGameId, name: 'Scoped')},
      ),
    );
    when(() => mockPlaythroughsStore.updatePlaythrough(any())).thenAnswer((_) async => true);
    when(() => mockScoresStore.addOrUpdateScore(any())).thenAnswer((_) async => true);
    when(() => mockScoresStore.deleteScore(any())).thenAnswer((_) async {});

    store = GamePlaythroughsDetailsStore(
      mockPlaythroughsStore,
      mockScoresStore,
      mockPlayersStore,
      mockBoardGamesStore,
    );
    store.setBoardGameId(scopedBoardGameId);
  });

  tearDown(() {
    reset(mockPlaythroughsStore);
    reset(mockScoresStore);
    reset(mockPlayersStore);
    reset(mockBoardGamesStore);
  });

  // SUSPECT A: the persistence loop iterates originalPlaythrough.scoreIds only, so a
  // score whose id is not already in the original set is never written.
  // NOTE: latent store bug — not reachable from the edit-playthrough page (no add-score
  // affordance there), so it is not the #72 symptom, but is fixed as part of #72's scope.
  test(
      'GIVEN a playthrough gains a new player score '
      'WHEN the playthrough is updated '
      'THEN the newly added score is persisted too', () async {
    final original = buildOriginalPlaythrough(scoreIds: const ['s1']);
    when(() => mockPlaythroughsStore.playthroughs)
        .thenReturn(ObservableList.of([original]));

    final details = PlaythroughDetails(
      playthrough: original,
      playerScores: [
        const PlayerScore(
          player: Player(id: 'pl1'),
          score: Score(
            id: 's1',
            playerId: 'pl1',
            boardGameId: playthroughBoardGameId,
            scoreGameResult: ScoreGameResult(points: 10),
          ),
        ),
        const PlayerScore(
          player: Player(id: 'pl2'),
          score: Score(
            id: 's2',
            playerId: 'pl2',
            boardGameId: playthroughBoardGameId,
            scoreGameResult: ScoreGameResult(points: 8),
          ),
        ),
      ],
    );

    await store.updatePlaythrough(details);

    final persistedScoreIds = verify(() => mockScoresStore.addOrUpdateScore(captureAny()))
        .captured
        .cast<Score>()
        .map((score) => score.id)
        .toList();
    expect(persistedScoreIds, containsAll(<String>['s1', 's2']));
  });

  // SUSPECT E: scores are matched by `score.id == scoreId`. A score that has not yet been
  // assigned a persisted id (empty id) fails to match its original id and is treated as a
  // deletion instead of being saved. (Score.id is non-nullable, so the reachable variant
  // of the original "null id" suspect is the empty/unassigned id.)
  // NOTE: same root cause / reachability caveat as Suspect A.
  test(
      'GIVEN an edited score has not been assigned a persisted id yet '
      'WHEN the playthrough is updated '
      'THEN the edited score is still persisted (not silently dropped)', () async {
    final original = buildOriginalPlaythrough(scoreIds: const ['s1']);
    when(() => mockPlaythroughsStore.playthroughs)
        .thenReturn(ObservableList.of([original]));

    final details = PlaythroughDetails(
      playthrough: original,
      playerScores: [
        const PlayerScore(
          player: Player(id: 'pl1'),
          score: Score(
            id: '',
            playerId: 'pl1',
            boardGameId: playthroughBoardGameId,
            scoreGameResult: ScoreGameResult(points: 12),
          ),
        ),
      ],
    );

    await store.updatePlaythrough(details);

    final persistedScores = verify(() => mockScoresStore.addOrUpdateScore(captureAny()))
        .captured
        .cast<Score>();
    expect(persistedScores.any((score) => score.score == 12), isTrue);
  });
}
