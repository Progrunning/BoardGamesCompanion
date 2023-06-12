import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../models/api/search/board_game_search_dto.dart';
import 'environment_service.dart';

@singleton
class BoardGamesSearchService {
  BoardGamesSearchService(this._environmentService);

  final EnvironmentService _environmentService;

  Future<List<BoardGameSearchResultDto>> search(String? searchPhrase) async {
    if (searchPhrase?.isEmpty ?? true) {
      return [];
    }

    final url = '${_environmentService.searchBoardGamesApiBaseUrl}/api/search?query=$searchPhrase';
    // TODO Add caching
    // TODO Handle errors
    // TODO Add retry policy https://stackoverflow.com/a/65585101/510627?
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Ocp-Apim-Subscription-Key': _environmentService.searchBoardGamesApiSubscriptionKey,
      },
    );

    final boardGamesMap = jsonDecode(response.body) as List<dynamic>;
    return boardGamesMap
        .map<BoardGameSearchResultDto>(
            (dynamic json) => BoardGameSearchResultDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
