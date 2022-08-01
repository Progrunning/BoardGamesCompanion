// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_game_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoardGameDetailsAdapter extends TypeAdapter<BoardGameDetails> {
  @override
  final int typeId = 0;

  @override
  BoardGameDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoardGameDetails(
      id: fields[0] as String,
      name: fields[1] as String,
    )
      ..categories = (fields[7] as List?)?.cast<BoardGameCategory>()
      ..publishers = (fields[16] as List).cast<BoardGamePublisher>()
      ..artists = (fields[17] as List).cast<BoardGameArtist>()
      ..desingers = (fields[18] as List).cast<BoardGameDesigner>()
      ..ranks = (fields[20] as List).cast<BoardGameRank>()
      ..expansions = (fields[22] as List).cast<BoardGamesExpansion>()
      ..settings = fields[28] as BoardGameSettings?
      ..imageUrl = fields[5] as String?
      ..description = fields[6] as String?
      ..rating = fields[8] as double?
      ..votes = fields[9] as int?
      ..minPlayers = fields[10] as int?
      ..minPlaytime = fields[11] as int?
      ..maxPlayers = fields[12] as int?
      ..maxPlaytime = fields[13] as int?
      ..minAge = fields[14] as int?
      ..avgWeight = fields[15] as num?
      ..commentsNumber = fields[19] as int?
      ..lastModified = fields[21] as DateTime?
      ..isExpansion = fields[23] as bool?
      ..isOwned = fields[24] as bool?
      ..isOnWishlist = fields[25] as bool?
      ..isFriends = fields[26] as bool?
      ..isBggSynced = fields[27] as bool?
      ..thumbnailUrl = fields[2] as String?
      ..rank = fields[3] as int?
      ..yearPublished = fields[4] as int?;
  }

  @override
  void write(BinaryWriter writer, BoardGameDetails obj) {
    writer
      ..writeByte(29)
      ..writeByte(7)
      ..write(obj.categories)
      ..writeByte(16)
      ..write(obj.publishers)
      ..writeByte(17)
      ..write(obj.artists)
      ..writeByte(18)
      ..write(obj.desingers)
      ..writeByte(20)
      ..write(obj.ranks)
      ..writeByte(22)
      ..write(obj.expansions)
      ..writeByte(28)
      ..write(obj.settings)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.rating)
      ..writeByte(9)
      ..write(obj.votes)
      ..writeByte(10)
      ..write(obj.minPlayers)
      ..writeByte(11)
      ..write(obj.minPlaytime)
      ..writeByte(12)
      ..write(obj.maxPlayers)
      ..writeByte(13)
      ..write(obj.maxPlaytime)
      ..writeByte(14)
      ..write(obj.minAge)
      ..writeByte(15)
      ..write(obj.avgWeight)
      ..writeByte(19)
      ..write(obj.commentsNumber)
      ..writeByte(21)
      ..write(obj.lastModified)
      ..writeByte(23)
      ..write(obj.isExpansion)
      ..writeByte(24)
      ..write(obj.isOwned)
      ..writeByte(25)
      ..write(obj.isOnWishlist)
      ..writeByte(26)
      ..write(obj.isFriends)
      ..writeByte(27)
      ..write(obj.isBggSynced)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.thumbnailUrl)
      ..writeByte(3)
      ..write(obj.rank)
      ..writeByte(4)
      ..write(obj.yearPublished);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardGameDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BoardGameDetails on _BoardGameDetails, Store {
  Computed<double?>? _$ratingComputed;

  @override
  double? get rating =>
      (_$ratingComputed ??= Computed<double?>(() => super.rating,
              name: '_BoardGameDetails.rating'))
          .value;
  Computed<int?>? _$votesComputed;

  @override
  int? get votes => (_$votesComputed ??=
          Computed<int?>(() => super.votes, name: '_BoardGameDetails.votes'))
      .value;
  Computed<num?>? _$avgWeightComputed;

  @override
  num? get avgWeight =>
      (_$avgWeightComputed ??= Computed<num?>(() => super.avgWeight,
              name: '_BoardGameDetails.avgWeight'))
          .value;
  Computed<int?>? _$commentsNumberComputed;

  @override
  int? get commentsNumber =>
      (_$commentsNumberComputed ??= Computed<int?>(() => super.commentsNumber,
              name: '_BoardGameDetails.commentsNumber'))
          .value;
  Computed<bool?>? _$isBggSyncedComputed;

  @override
  bool? get isBggSynced =>
      (_$isBggSyncedComputed ??= Computed<bool?>(() => super.isBggSynced,
              name: '_BoardGameDetails.isBggSynced'))
          .value;
  Computed<bool>? _$hasIncompleteDetailsComputed;

  @override
  bool get hasIncompleteDetails => (_$hasIncompleteDetailsComputed ??=
          Computed<bool>(() => super.hasIncompleteDetails,
              name: '_BoardGameDetails.hasIncompleteDetails'))
      .value;

  late final _$_ratingAtom =
      Atom(name: '_BoardGameDetails._rating', context: context);

  @override
  double? get _rating {
    _$_ratingAtom.reportRead();
    return super._rating;
  }

  @override
  set _rating(double? value) {
    _$_ratingAtom.reportWrite(value, super._rating, () {
      super._rating = value;
    });
  }

  late final _$_votesAtom =
      Atom(name: '_BoardGameDetails._votes', context: context);

  @override
  int? get _votes {
    _$_votesAtom.reportRead();
    return super._votes;
  }

  @override
  set _votes(int? value) {
    _$_votesAtom.reportWrite(value, super._votes, () {
      super._votes = value;
    });
  }

  late final _$_avgWeightAtom =
      Atom(name: '_BoardGameDetails._avgWeight', context: context);

  @override
  num? get _avgWeight {
    _$_avgWeightAtom.reportRead();
    return super._avgWeight;
  }

  @override
  set _avgWeight(num? value) {
    _$_avgWeightAtom.reportWrite(value, super._avgWeight, () {
      super._avgWeight = value;
    });
  }

  late final _$_commentsNumberAtom =
      Atom(name: '_BoardGameDetails._commentsNumber', context: context);

  @override
  int? get _commentsNumber {
    _$_commentsNumberAtom.reportRead();
    return super._commentsNumber;
  }

  @override
  set _commentsNumber(int? value) {
    _$_commentsNumberAtom.reportWrite(value, super._commentsNumber, () {
      super._commentsNumber = value;
    });
  }

  late final _$expansionsAtom =
      Atom(name: '_BoardGameDetails.expansions', context: context);

  @override
  List<BoardGamesExpansion> get expansions {
    _$expansionsAtom.reportRead();
    return super.expansions;
  }

  @override
  set expansions(List<BoardGamesExpansion> value) {
    _$expansionsAtom.reportWrite(value, super.expansions, () {
      super.expansions = value;
    });
  }

  late final _$_isBggSyncedAtom =
      Atom(name: '_BoardGameDetails._isBggSynced', context: context);

  @override
  bool? get _isBggSynced {
    _$_isBggSyncedAtom.reportRead();
    return super._isBggSynced;
  }

  @override
  set _isBggSynced(bool? value) {
    _$_isBggSyncedAtom.reportWrite(value, super._isBggSynced, () {
      super._isBggSynced = value;
    });
  }

  @override
  String toString() {
    return '''
expansions: ${expansions},
rating: ${rating},
votes: ${votes},
avgWeight: ${avgWeight},
commentsNumber: ${commentsNumber},
isBggSynced: ${isBggSynced},
hasIncompleteDetails: ${hasIncompleteDetails}
    ''';
  }
}
