import 'package:injectable/injectable.dart';

import '../models/api/search/board_game_search_dto.dart';

@singleton
class BoardGameSearchService {
  static const String _baseBoardGamesSearchApiUrl = 'https://www.boardgamegeek.com/xmlapi2';

  Future<List<BoardGameSearchDto>> search(String? searchPhrase) async {
    // TODO Implement
    return List.empty();
  }
}
