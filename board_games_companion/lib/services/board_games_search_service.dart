import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:injectable/injectable.dart';

import '../models/api/search/board_game_search_dto.dart';
import 'environment_service.dart';

@singleton
class BoardGamesSearchService {
  BoardGamesSearchService(this._environmentService) {
    _httpClient = RetryClient(http.Client());
  }

  final EnvironmentService _environmentService;

  /// An arbitrary number of seconds to wait until a request should timeout
  final Duration _searchTimeout = const Duration(seconds: 10);

  late RetryClient _httpClient;

  Future<List<BoardGameSearchResultDto>> search(String? searchPhrase) async {
    if (searchPhrase?.isEmpty ?? true) {
      return [];
    }

    final url = '${_environmentService.searchBoardGamesApiBaseUrl}/api/search?query=$searchPhrase';
    final response = await _httpClient.get(
      Uri.parse(url),
      headers: <String, String>{
        'Ocp-Apim-Subscription-Key': _environmentService.searchBoardGamesApiSubscriptionKey,
      },
    ).timeout(_searchTimeout);

    final boardGamesMap = jsonDecode(response.body) as List<dynamic>;
    return boardGamesMap
        .map<BoardGameSearchResultDto>(
            (dynamic json) => BoardGameSearchResultDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
