import 'dart:math';

import 'package:board_games_companion/extensions/playthroughs_extensions.dart';

import '../common/constants.dart';
import '../common/enums/collection_type.dart';
import '../common/enums/order_by.dart';
import '../common/enums/sort_by_option.dart';
import '../extensions/date_time_extensions.dart';
import '../extensions/double_extensions.dart';
import '../extensions/int_extensions.dart';
import '../extensions/string_extensions.dart';
import '../models/hive/board_game_details.dart';
import '../models/hive/playthrough.dart';
import '../models/sort_by.dart';

extension BoardGameDetailsExtensions on BoardGameDetails {
  BoardGameDetails toggleCollection(CollectionType collectionType) {
    late BoardGameDetails updatedBoardGame;
    switch (collectionType) {
      case CollectionType.owned:
        updatedBoardGame = copyWith(isOwned: !(isOwned ?? false));
        if (updatedBoardGame.isOwned ?? false) {
          updatedBoardGame = updatedBoardGame.copyWith(isOnWishlist: false);
        }
        break;
      case CollectionType.friends:
        updatedBoardGame = copyWith(isFriends: !(isFriends ?? false));
        break;
      case CollectionType.wishlist:
        updatedBoardGame = copyWith(
          isOnWishlist: !(isOnWishlist ?? false),
          isOwned: false,
        );
        break;
    }

    return updatedBoardGame;
  }
}

extension BoardGameDetailsCollectionExtensions on Iterable<BoardGameDetails> {
  Iterable<BoardGameDetails> inCollection(CollectionType collectionType) {
    switch (collectionType) {
      case CollectionType.owned:
        return where((boardGame) => boardGame.isOwned ?? false);
      case CollectionType.friends:
        return where((boardGame) => boardGame.isFriends ?? false);
      case CollectionType.wishlist:
        return where((boardGame) => boardGame.isOnWishlist ?? false);
    }
  }
}

extension BoardGameDetailsListExtensions on List<BoardGameDetails> {
  void sortByMostRecentPlays(List<Playthrough> finishedPlaythroughs, OrderBy orderBy) {
    final mostRecentGamePlaysIndexes = <String, int>{};
    var index = 1;
    for (final playthrough in finishedPlaythroughs.sortedByStartDate) {
      if (mostRecentGamePlaysIndexes.containsKey(playthrough.boardGameId)) {
        continue;
      }

      mostRecentGamePlaysIndexes[playthrough.boardGameId] = index++;
    }

    sort((boardGame, otherBoardGame) {
      if (orderBy == OrderBy.Ascending) {
        final buffer = boardGame;
        boardGame = otherBoardGame;
        otherBoardGame = buffer;
      }

      final boardGameIndex = mostRecentGamePlaysIndexes[boardGame.id];
      final otherBoardGameIndex = mostRecentGamePlaysIndexes[otherBoardGame.id];

      if (boardGameIndex == null && otherBoardGameIndex != null) {
        return Constants.moveBelow;
      }

      if (boardGameIndex != null && otherBoardGameIndex == null) {
        return Constants.moveAbove;
      }

      if (boardGameIndex == null && otherBoardGameIndex == null) {
        return Constants.leaveAsIs;
      }

      return boardGameIndex!.compareTo(otherBoardGameIndex!);
    });
  }

  void sortBy(SortBy? sortBy) {
    if (sortBy == null) {
      return;
    }

    sort(
      (boardGame, otherBoardGame) {
        if (sortBy.orderBy == OrderBy.Descending) {
          final buffer = boardGame;
          boardGame = otherBoardGame;
          otherBoardGame = buffer;
        }

        switch (sortBy.sortByOption) {
          case SortByOption.Name:
            return boardGame.name.safeCompareTo(otherBoardGame.name);
          case SortByOption.YearPublished:
            return boardGame.yearPublished.safeCompareTo(otherBoardGame.yearPublished);
          case SortByOption.LastUpdated:
            return boardGame.lastModified.safeCompareTo(otherBoardGame.lastModified);
          case SortByOption.Rank:
            return boardGame.rank.safeCompareTo(otherBoardGame.rank);
          case SortByOption.NumberOfPlayers:
            if (sortBy.orderBy == OrderBy.Descending) {
              return otherBoardGame.maxPlayers.safeCompareTo(boardGame.maxPlayers);
            }

            return boardGame.minPlayers.safeCompareTo(otherBoardGame.maxPlayers);
          case SortByOption.Playtime:
            return boardGame.maxPlaytime.safeCompareTo(otherBoardGame.maxPlaytime);
          case SortByOption.Rating:
            return otherBoardGame.rating.safeCompareTo(boardGame.rating);
          default:
            return boardGame.lastModified.safeCompareTo(otherBoardGame.lastModified);
        }
      },
    );
  }

  int get maxNumberOfPlayers => min(
        where((boardGameDetails) => boardGameDetails.maxPlayers != null)
            .map((boardGameDetails) => boardGameDetails.maxPlayers!)
            .reduce(max),
        Constants.maxNumberOfPlayers,
      );

  int get minNumberOfPlayers => max(
        where((boardGameDetails) => boardGameDetails.minPlayers != null)
            .map((boardGameDetails) => boardGameDetails.minPlayers!)
            .reduce(min),
        Constants.minNumberOfPlayers,
      );
}
