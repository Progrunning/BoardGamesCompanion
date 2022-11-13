// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:sprintf/sprintf.dart';

import '../../common/app_text.dart';
import '../../common/constants.dart';
import '../../common/hive_boxes.dart';
import 'board_game_artist.dart';
import 'board_game_category.dart';
import 'board_game_designer.dart';
import 'board_game_expansion.dart';
import 'board_game_publisher.dart';
import 'board_game_rank.dart';
import 'board_game_settings.dart';

part 'board_game_details.freezed.dart';
part 'board_game_details.g.dart';

@freezed
class BoardGameDetails with _$BoardGameDetails {
  @HiveType(typeId: HiveBoxes.boardGamesDetailsTypeId, adapterName: 'BoardGameDetailsAdapter')
  const factory BoardGameDetails({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) String? thumbnailUrl,
    @HiveField(3) int? rank,
    @HiveField(4) int? yearPublished,
    @HiveField(5) String? imageUrl,
    @HiveField(6) String? description,
    @Default(<BoardGameCategory>[]) @HiveField(7) List<BoardGameCategory>? categories,
    @HiveField(8) double? rating,
    @HiveField(9) int? votes,
    @HiveField(10) int? minPlayers,
    @HiveField(11) int? minPlaytime,
    @HiveField(12) int? maxPlayers,
    @HiveField(13) int? maxPlaytime,
    @HiveField(14) int? minAge,
    @HiveField(15) num? avgWeight,
    @Default(<BoardGamePublisher>[]) @HiveField(16) List<BoardGamePublisher> publishers,
    @Default(<BoardGameArtist>[]) @HiveField(17) List<BoardGameArtist> artists,
    @Default(<BoardGameDesigner>[]) @HiveField(18) List<BoardGameDesigner> desingers,
    @HiveField(19) int? commentsNumber,
    @Default(<BoardGameRank>[]) @HiveField(20) List<BoardGameRank> ranks,
    @HiveField(21) DateTime? lastModified,
    @Default(<BoardGameExpansion>[]) @HiveField(22) List<BoardGameExpansion> expansions,
    @HiveField(23) bool? isExpansion,
    @HiveField(24) bool? isOwned,
    @HiveField(25) bool? isOnWishlist,
    @HiveField(26) bool? isFriends,
    @HiveField(27) bool? isBggSynced,
    @HiveField(28) BoardGameSettings? settings,
  }) = _BoardGameDetails;

  const BoardGameDetails._();

  RegExp get onlyLettersOrNumbersRegex => RegExp(r'[a-zA-Z0-9\-]+');
  static const Set<String> bggNotUsedUrlEncodedNameParts = {
    'the',
    'of',
    'for',
    'a',
    'with',
    'on',
    'at',
    'by',
    'to',
    'from',
    'into',
    'but',
    'off',
    'up',
  };

  bool get isMainGame => !(isExpansion ?? false);

  String get playtimeFormatted {
    var playtimeRange = '';
    if (minPlaytime == maxPlaytime) {
      if (minPlaytime == 0) {
        return '-';
      } else {
        playtimeRange = '$minPlaytime';
      }
    } else {
      if (maxPlaytime == 0) {
        playtimeRange = '$minPlaytime';
      } else {
        playtimeRange = '$minPlaytime - $maxPlaytime';
      }
    }

    return sprintf(AppText.gamePlaytimeFormat, [playtimeRange]);
  }

  String get playersFormatted {
    if (minPlayers == maxPlayers || maxPlayers == null) {
      if (minPlayers == 1) {
        return sprintf(AppText.gamePlayersSingularFormat, [minPlayers]);
      }

      return sprintf(AppText.gamePlayersPluralFormat, [minPlayers]);
    }

    return sprintf(AppText.gamePlayersRangeFormat, [minPlayers, maxPlayers]);
  }

  String? get rankFormatted {
    if (rank != null) {
      return rank.toString();
    } else if (ranks.isNotEmpty) {
      final overallRank = ranks.first.rank;
      return overallRank?.toString() ?? 'Not Ranked';
    }

    return null;
  }

  bool get hasIncompleteDetails =>
      (isBggSynced ?? false) &&
      (avgWeight == null || rating == null || commentsNumber == null || votes == null);

  String get bggOverviewUrl => '$_baseBggBoardGameUrl/$id/$_bggUrlEncodedName';

  String get bggHotVideosUrl => '$bggOverviewUrl/videos/all?sort=hot';

  String get bggHotForumUrl => '$bggOverviewUrl/forums/0?sort=hot';

  String get boardGameOraclePriceUrl {
    final String currentCulture = Platform.localeName.replaceFirst('_', '-');
    if (!Constants.boardGameOracleSupportedCultureNames.contains(currentCulture) ||
        currentCulture == Constants.boardGameOracleUsaCultureName) {
      return '${Constants.boardGameOracleBaseUrl}boardgame/price/$_boardGameOracleUrlEncodedName';
    }

    return '${Constants.boardGameOracleBaseUrl}$currentCulture/boardgame/price/$_boardGameOracleUrlEncodedName';
  }

  String get _baseBggBoardGameUrl => '${Constants.boardGameGeekBaseUrl}boardgame';

  String get _bggUrlEncodedName {
    final List<String> spaceSeparatedNameParts = name.toLowerCase().split(' ');
    return spaceSeparatedNameParts.where((part) {
      final String trimmedAndLoweredPart = part.trim();
      return !bggNotUsedUrlEncodedNameParts.contains(trimmedAndLoweredPart);
    }).map((part) {
      final String trimmedAndLoweredPart = part.trim();
      final String? regexMatch = onlyLettersOrNumbersRegex.stringMatch(trimmedAndLoweredPart);
      return regexMatch;
    }).join('-');
  }

  String get _boardGameOracleUrlEncodedName {
    final List<String> spaceSeparatedNameParts = name.toLowerCase().split(' ');
    return spaceSeparatedNameParts.map((part) {
      final String trimmedAndLoweredPart = part.trim();
      final String? regexMatch = onlyLettersOrNumbersRegex.stringMatch(trimmedAndLoweredPart);
      return regexMatch;
    }).join('-');
  }
}
