// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_game_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BoardGameDetails {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;

  /// This property holds a URL to a web image or a locally saved file in case a board game [isCreatedByUser]
  @HiveField(2)
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  @HiveField(3)
  int? get rank => throw _privateConstructorUsedError;
  @HiveField(4)
  int? get yearPublished => throw _privateConstructorUsedError;

  /// This property holds a URL to a web image or a locally saved file in case a board game [isCreatedByUser]
  @HiveField(5)
  String? get imageUrl => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get description => throw _privateConstructorUsedError;
  @HiveField(7)
  List<BoardGameCategory>? get categories => throw _privateConstructorUsedError;
  @HiveField(8)
  double? get rating => throw _privateConstructorUsedError;
  @HiveField(9)
  int? get votes => throw _privateConstructorUsedError;
  @HiveField(10)
  int? get minPlayers => throw _privateConstructorUsedError;
  @HiveField(11)
  int? get minPlaytime => throw _privateConstructorUsedError;
  @HiveField(12)
  int? get maxPlayers => throw _privateConstructorUsedError;
  @HiveField(13)
  int? get maxPlaytime => throw _privateConstructorUsedError;
  @HiveField(14)
  int? get minAge => throw _privateConstructorUsedError;
  @HiveField(15)
  num? get avgWeight => throw _privateConstructorUsedError;
  @HiveField(16)
  List<BoardGamePublisher> get publishers => throw _privateConstructorUsedError;
  @HiveField(17)
  List<BoardGameArtist> get artists => throw _privateConstructorUsedError;
  @HiveField(18)
  List<BoardGameDesigner> get desingers => throw _privateConstructorUsedError;
  @HiveField(19)
  int? get commentsNumber => throw _privateConstructorUsedError;
  @HiveField(20)
  List<BoardGameRank> get ranks => throw _privateConstructorUsedError;
  @HiveField(21)
  DateTime? get lastModified => throw _privateConstructorUsedError;
  @HiveField(22)
  List<BoardGameExpansion> get expansions => throw _privateConstructorUsedError;
  @HiveField(23)
  bool? get isExpansion => throw _privateConstructorUsedError;
  @HiveField(24)
  bool? get isOwned => throw _privateConstructorUsedError;
  @HiveField(25)
  bool? get isOnWishlist => throw _privateConstructorUsedError;
  @HiveField(26)
  bool? get isFriends => throw _privateConstructorUsedError;
  @HiveField(27)
  bool? get isBggSynced => throw _privateConstructorUsedError;
  @HiveField(28)
  BoardGameSettings? get settings => throw _privateConstructorUsedError;
  @HiveField(29, defaultValue: false)
  bool get isCreatedByUser => throw _privateConstructorUsedError;
  @HiveField(30, defaultValue: <BoardGamePrices>[])
  List<BoardGamePrices> get prices => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BoardGameDetailsCopyWith<BoardGameDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardGameDetailsCopyWith<$Res> {
  factory $BoardGameDetailsCopyWith(
          BoardGameDetails value, $Res Function(BoardGameDetails) then) =
      _$BoardGameDetailsCopyWithImpl<$Res, BoardGameDetails>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String? thumbnailUrl,
      @HiveField(3) int? rank,
      @HiveField(4) int? yearPublished,
      @HiveField(5) String? imageUrl,
      @HiveField(6) String? description,
      @HiveField(7) List<BoardGameCategory>? categories,
      @HiveField(8) double? rating,
      @HiveField(9) int? votes,
      @HiveField(10) int? minPlayers,
      @HiveField(11) int? minPlaytime,
      @HiveField(12) int? maxPlayers,
      @HiveField(13) int? maxPlaytime,
      @HiveField(14) int? minAge,
      @HiveField(15) num? avgWeight,
      @HiveField(16) List<BoardGamePublisher> publishers,
      @HiveField(17) List<BoardGameArtist> artists,
      @HiveField(18) List<BoardGameDesigner> desingers,
      @HiveField(19) int? commentsNumber,
      @HiveField(20) List<BoardGameRank> ranks,
      @HiveField(21) DateTime? lastModified,
      @HiveField(22) List<BoardGameExpansion> expansions,
      @HiveField(23) bool? isExpansion,
      @HiveField(24) bool? isOwned,
      @HiveField(25) bool? isOnWishlist,
      @HiveField(26) bool? isFriends,
      @HiveField(27) bool? isBggSynced,
      @HiveField(28) BoardGameSettings? settings,
      @HiveField(29, defaultValue: false) bool isCreatedByUser,
      @HiveField(30, defaultValue: <BoardGamePrices>[])
      List<BoardGamePrices> prices});

  $BoardGameSettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class _$BoardGameDetailsCopyWithImpl<$Res, $Val extends BoardGameDetails>
    implements $BoardGameDetailsCopyWith<$Res> {
  _$BoardGameDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? thumbnailUrl = freezed,
    Object? rank = freezed,
    Object? yearPublished = freezed,
    Object? imageUrl = freezed,
    Object? description = freezed,
    Object? categories = freezed,
    Object? rating = freezed,
    Object? votes = freezed,
    Object? minPlayers = freezed,
    Object? minPlaytime = freezed,
    Object? maxPlayers = freezed,
    Object? maxPlaytime = freezed,
    Object? minAge = freezed,
    Object? avgWeight = freezed,
    Object? publishers = null,
    Object? artists = null,
    Object? desingers = null,
    Object? commentsNumber = freezed,
    Object? ranks = null,
    Object? lastModified = freezed,
    Object? expansions = null,
    Object? isExpansion = freezed,
    Object? isOwned = freezed,
    Object? isOnWishlist = freezed,
    Object? isFriends = freezed,
    Object? isBggSynced = freezed,
    Object? settings = freezed,
    Object? isCreatedByUser = null,
    Object? prices = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      rank: freezed == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int?,
      yearPublished: freezed == yearPublished
          ? _value.yearPublished
          : yearPublished // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<BoardGameCategory>?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      votes: freezed == votes
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as int?,
      minPlayers: freezed == minPlayers
          ? _value.minPlayers
          : minPlayers // ignore: cast_nullable_to_non_nullable
              as int?,
      minPlaytime: freezed == minPlaytime
          ? _value.minPlaytime
          : minPlaytime // ignore: cast_nullable_to_non_nullable
              as int?,
      maxPlayers: freezed == maxPlayers
          ? _value.maxPlayers
          : maxPlayers // ignore: cast_nullable_to_non_nullable
              as int?,
      maxPlaytime: freezed == maxPlaytime
          ? _value.maxPlaytime
          : maxPlaytime // ignore: cast_nullable_to_non_nullable
              as int?,
      minAge: freezed == minAge
          ? _value.minAge
          : minAge // ignore: cast_nullable_to_non_nullable
              as int?,
      avgWeight: freezed == avgWeight
          ? _value.avgWeight
          : avgWeight // ignore: cast_nullable_to_non_nullable
              as num?,
      publishers: null == publishers
          ? _value.publishers
          : publishers // ignore: cast_nullable_to_non_nullable
              as List<BoardGamePublisher>,
      artists: null == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<BoardGameArtist>,
      desingers: null == desingers
          ? _value.desingers
          : desingers // ignore: cast_nullable_to_non_nullable
              as List<BoardGameDesigner>,
      commentsNumber: freezed == commentsNumber
          ? _value.commentsNumber
          : commentsNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      ranks: null == ranks
          ? _value.ranks
          : ranks // ignore: cast_nullable_to_non_nullable
              as List<BoardGameRank>,
      lastModified: freezed == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expansions: null == expansions
          ? _value.expansions
          : expansions // ignore: cast_nullable_to_non_nullable
              as List<BoardGameExpansion>,
      isExpansion: freezed == isExpansion
          ? _value.isExpansion
          : isExpansion // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOwned: freezed == isOwned
          ? _value.isOwned
          : isOwned // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOnWishlist: freezed == isOnWishlist
          ? _value.isOnWishlist
          : isOnWishlist // ignore: cast_nullable_to_non_nullable
              as bool?,
      isFriends: freezed == isFriends
          ? _value.isFriends
          : isFriends // ignore: cast_nullable_to_non_nullable
              as bool?,
      isBggSynced: freezed == isBggSynced
          ? _value.isBggSynced
          : isBggSynced // ignore: cast_nullable_to_non_nullable
              as bool?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as BoardGameSettings?,
      isCreatedByUser: null == isCreatedByUser
          ? _value.isCreatedByUser
          : isCreatedByUser // ignore: cast_nullable_to_non_nullable
              as bool,
      prices: null == prices
          ? _value.prices
          : prices // ignore: cast_nullable_to_non_nullable
              as List<BoardGamePrices>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BoardGameSettingsCopyWith<$Res>? get settings {
    if (_value.settings == null) {
      return null;
    }

    return $BoardGameSettingsCopyWith<$Res>(_value.settings!, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BoardGameDetailsImplCopyWith<$Res>
    implements $BoardGameDetailsCopyWith<$Res> {
  factory _$$BoardGameDetailsImplCopyWith(_$BoardGameDetailsImpl value,
          $Res Function(_$BoardGameDetailsImpl) then) =
      __$$BoardGameDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String? thumbnailUrl,
      @HiveField(3) int? rank,
      @HiveField(4) int? yearPublished,
      @HiveField(5) String? imageUrl,
      @HiveField(6) String? description,
      @HiveField(7) List<BoardGameCategory>? categories,
      @HiveField(8) double? rating,
      @HiveField(9) int? votes,
      @HiveField(10) int? minPlayers,
      @HiveField(11) int? minPlaytime,
      @HiveField(12) int? maxPlayers,
      @HiveField(13) int? maxPlaytime,
      @HiveField(14) int? minAge,
      @HiveField(15) num? avgWeight,
      @HiveField(16) List<BoardGamePublisher> publishers,
      @HiveField(17) List<BoardGameArtist> artists,
      @HiveField(18) List<BoardGameDesigner> desingers,
      @HiveField(19) int? commentsNumber,
      @HiveField(20) List<BoardGameRank> ranks,
      @HiveField(21) DateTime? lastModified,
      @HiveField(22) List<BoardGameExpansion> expansions,
      @HiveField(23) bool? isExpansion,
      @HiveField(24) bool? isOwned,
      @HiveField(25) bool? isOnWishlist,
      @HiveField(26) bool? isFriends,
      @HiveField(27) bool? isBggSynced,
      @HiveField(28) BoardGameSettings? settings,
      @HiveField(29, defaultValue: false) bool isCreatedByUser,
      @HiveField(30, defaultValue: <BoardGamePrices>[])
      List<BoardGamePrices> prices});

  @override
  $BoardGameSettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class __$$BoardGameDetailsImplCopyWithImpl<$Res>
    extends _$BoardGameDetailsCopyWithImpl<$Res, _$BoardGameDetailsImpl>
    implements _$$BoardGameDetailsImplCopyWith<$Res> {
  __$$BoardGameDetailsImplCopyWithImpl(_$BoardGameDetailsImpl _value,
      $Res Function(_$BoardGameDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? thumbnailUrl = freezed,
    Object? rank = freezed,
    Object? yearPublished = freezed,
    Object? imageUrl = freezed,
    Object? description = freezed,
    Object? categories = freezed,
    Object? rating = freezed,
    Object? votes = freezed,
    Object? minPlayers = freezed,
    Object? minPlaytime = freezed,
    Object? maxPlayers = freezed,
    Object? maxPlaytime = freezed,
    Object? minAge = freezed,
    Object? avgWeight = freezed,
    Object? publishers = null,
    Object? artists = null,
    Object? desingers = null,
    Object? commentsNumber = freezed,
    Object? ranks = null,
    Object? lastModified = freezed,
    Object? expansions = null,
    Object? isExpansion = freezed,
    Object? isOwned = freezed,
    Object? isOnWishlist = freezed,
    Object? isFriends = freezed,
    Object? isBggSynced = freezed,
    Object? settings = freezed,
    Object? isCreatedByUser = null,
    Object? prices = null,
  }) {
    return _then(_$BoardGameDetailsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      rank: freezed == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int?,
      yearPublished: freezed == yearPublished
          ? _value.yearPublished
          : yearPublished // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<BoardGameCategory>?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      votes: freezed == votes
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as int?,
      minPlayers: freezed == minPlayers
          ? _value.minPlayers
          : minPlayers // ignore: cast_nullable_to_non_nullable
              as int?,
      minPlaytime: freezed == minPlaytime
          ? _value.minPlaytime
          : minPlaytime // ignore: cast_nullable_to_non_nullable
              as int?,
      maxPlayers: freezed == maxPlayers
          ? _value.maxPlayers
          : maxPlayers // ignore: cast_nullable_to_non_nullable
              as int?,
      maxPlaytime: freezed == maxPlaytime
          ? _value.maxPlaytime
          : maxPlaytime // ignore: cast_nullable_to_non_nullable
              as int?,
      minAge: freezed == minAge
          ? _value.minAge
          : minAge // ignore: cast_nullable_to_non_nullable
              as int?,
      avgWeight: freezed == avgWeight
          ? _value.avgWeight
          : avgWeight // ignore: cast_nullable_to_non_nullable
              as num?,
      publishers: null == publishers
          ? _value._publishers
          : publishers // ignore: cast_nullable_to_non_nullable
              as List<BoardGamePublisher>,
      artists: null == artists
          ? _value._artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<BoardGameArtist>,
      desingers: null == desingers
          ? _value._desingers
          : desingers // ignore: cast_nullable_to_non_nullable
              as List<BoardGameDesigner>,
      commentsNumber: freezed == commentsNumber
          ? _value.commentsNumber
          : commentsNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      ranks: null == ranks
          ? _value._ranks
          : ranks // ignore: cast_nullable_to_non_nullable
              as List<BoardGameRank>,
      lastModified: freezed == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expansions: null == expansions
          ? _value._expansions
          : expansions // ignore: cast_nullable_to_non_nullable
              as List<BoardGameExpansion>,
      isExpansion: freezed == isExpansion
          ? _value.isExpansion
          : isExpansion // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOwned: freezed == isOwned
          ? _value.isOwned
          : isOwned // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOnWishlist: freezed == isOnWishlist
          ? _value.isOnWishlist
          : isOnWishlist // ignore: cast_nullable_to_non_nullable
              as bool?,
      isFriends: freezed == isFriends
          ? _value.isFriends
          : isFriends // ignore: cast_nullable_to_non_nullable
              as bool?,
      isBggSynced: freezed == isBggSynced
          ? _value.isBggSynced
          : isBggSynced // ignore: cast_nullable_to_non_nullable
              as bool?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as BoardGameSettings?,
      isCreatedByUser: null == isCreatedByUser
          ? _value.isCreatedByUser
          : isCreatedByUser // ignore: cast_nullable_to_non_nullable
              as bool,
      prices: null == prices
          ? _value._prices
          : prices // ignore: cast_nullable_to_non_nullable
              as List<BoardGamePrices>,
    ));
  }
}

/// @nodoc

@HiveType(
    typeId: HiveBoxes.boardGamesDetailsTypeId,
    adapterName: 'BoardGameDetailsAdapter')
class _$BoardGameDetailsImpl extends _BoardGameDetails {
  const _$BoardGameDetailsImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) this.thumbnailUrl,
      @HiveField(3) this.rank,
      @HiveField(4) this.yearPublished,
      @HiveField(5) this.imageUrl,
      @HiveField(6) this.description,
      @HiveField(7)
      final List<BoardGameCategory>? categories = const <BoardGameCategory>[],
      @HiveField(8) this.rating,
      @HiveField(9) this.votes,
      @HiveField(10) this.minPlayers,
      @HiveField(11) this.minPlaytime,
      @HiveField(12) this.maxPlayers,
      @HiveField(13) this.maxPlaytime,
      @HiveField(14) this.minAge,
      @HiveField(15) this.avgWeight,
      @HiveField(16)
      final List<BoardGamePublisher> publishers = const <BoardGamePublisher>[],
      @HiveField(17)
      final List<BoardGameArtist> artists = const <BoardGameArtist>[],
      @HiveField(18)
      final List<BoardGameDesigner> desingers = const <BoardGameDesigner>[],
      @HiveField(19) this.commentsNumber,
      @HiveField(20) final List<BoardGameRank> ranks = const <BoardGameRank>[],
      @HiveField(21) this.lastModified,
      @HiveField(22)
      final List<BoardGameExpansion> expansions = const <BoardGameExpansion>[],
      @HiveField(23) this.isExpansion,
      @HiveField(24) this.isOwned,
      @HiveField(25) this.isOnWishlist,
      @HiveField(26) this.isFriends,
      @HiveField(27) this.isBggSynced,
      @HiveField(28) this.settings,
      @HiveField(29, defaultValue: false) this.isCreatedByUser = false,
      @HiveField(30, defaultValue: <BoardGamePrices>[])
      final List<BoardGamePrices> prices = const <BoardGamePrices>[]})
      : _categories = categories,
        _publishers = publishers,
        _artists = artists,
        _desingers = desingers,
        _ranks = ranks,
        _expansions = expansions,
        _prices = prices,
        super._();

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;

  /// This property holds a URL to a web image or a locally saved file in case a board game [isCreatedByUser]
  @override
  @HiveField(2)
  final String? thumbnailUrl;
  @override
  @HiveField(3)
  final int? rank;
  @override
  @HiveField(4)
  final int? yearPublished;

  /// This property holds a URL to a web image or a locally saved file in case a board game [isCreatedByUser]
  @override
  @HiveField(5)
  final String? imageUrl;
  @override
  @HiveField(6)
  final String? description;
  final List<BoardGameCategory>? _categories;
  @override
  @JsonKey()
  @HiveField(7)
  List<BoardGameCategory>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @HiveField(8)
  final double? rating;
  @override
  @HiveField(9)
  final int? votes;
  @override
  @HiveField(10)
  final int? minPlayers;
  @override
  @HiveField(11)
  final int? minPlaytime;
  @override
  @HiveField(12)
  final int? maxPlayers;
  @override
  @HiveField(13)
  final int? maxPlaytime;
  @override
  @HiveField(14)
  final int? minAge;
  @override
  @HiveField(15)
  final num? avgWeight;
  final List<BoardGamePublisher> _publishers;
  @override
  @JsonKey()
  @HiveField(16)
  List<BoardGamePublisher> get publishers {
    if (_publishers is EqualUnmodifiableListView) return _publishers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_publishers);
  }

  final List<BoardGameArtist> _artists;
  @override
  @JsonKey()
  @HiveField(17)
  List<BoardGameArtist> get artists {
    if (_artists is EqualUnmodifiableListView) return _artists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artists);
  }

  final List<BoardGameDesigner> _desingers;
  @override
  @JsonKey()
  @HiveField(18)
  List<BoardGameDesigner> get desingers {
    if (_desingers is EqualUnmodifiableListView) return _desingers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_desingers);
  }

  @override
  @HiveField(19)
  final int? commentsNumber;
  final List<BoardGameRank> _ranks;
  @override
  @JsonKey()
  @HiveField(20)
  List<BoardGameRank> get ranks {
    if (_ranks is EqualUnmodifiableListView) return _ranks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ranks);
  }

  @override
  @HiveField(21)
  final DateTime? lastModified;
  final List<BoardGameExpansion> _expansions;
  @override
  @JsonKey()
  @HiveField(22)
  List<BoardGameExpansion> get expansions {
    if (_expansions is EqualUnmodifiableListView) return _expansions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expansions);
  }

  @override
  @HiveField(23)
  final bool? isExpansion;
  @override
  @HiveField(24)
  final bool? isOwned;
  @override
  @HiveField(25)
  final bool? isOnWishlist;
  @override
  @HiveField(26)
  final bool? isFriends;
  @override
  @HiveField(27)
  final bool? isBggSynced;
  @override
  @HiveField(28)
  final BoardGameSettings? settings;
  @override
  @JsonKey()
  @HiveField(29, defaultValue: false)
  final bool isCreatedByUser;
  final List<BoardGamePrices> _prices;
  @override
  @JsonKey()
  @HiveField(30, defaultValue: <BoardGamePrices>[])
  List<BoardGamePrices> get prices {
    if (_prices is EqualUnmodifiableListView) return _prices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prices);
  }

  @override
  String toString() {
    return 'BoardGameDetails(id: $id, name: $name, thumbnailUrl: $thumbnailUrl, rank: $rank, yearPublished: $yearPublished, imageUrl: $imageUrl, description: $description, categories: $categories, rating: $rating, votes: $votes, minPlayers: $minPlayers, minPlaytime: $minPlaytime, maxPlayers: $maxPlayers, maxPlaytime: $maxPlaytime, minAge: $minAge, avgWeight: $avgWeight, publishers: $publishers, artists: $artists, desingers: $desingers, commentsNumber: $commentsNumber, ranks: $ranks, lastModified: $lastModified, expansions: $expansions, isExpansion: $isExpansion, isOwned: $isOwned, isOnWishlist: $isOnWishlist, isFriends: $isFriends, isBggSynced: $isBggSynced, settings: $settings, isCreatedByUser: $isCreatedByUser, prices: $prices)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardGameDetailsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.yearPublished, yearPublished) ||
                other.yearPublished == yearPublished) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.votes, votes) || other.votes == votes) &&
            (identical(other.minPlayers, minPlayers) ||
                other.minPlayers == minPlayers) &&
            (identical(other.minPlaytime, minPlaytime) ||
                other.minPlaytime == minPlaytime) &&
            (identical(other.maxPlayers, maxPlayers) ||
                other.maxPlayers == maxPlayers) &&
            (identical(other.maxPlaytime, maxPlaytime) ||
                other.maxPlaytime == maxPlaytime) &&
            (identical(other.minAge, minAge) || other.minAge == minAge) &&
            (identical(other.avgWeight, avgWeight) ||
                other.avgWeight == avgWeight) &&
            const DeepCollectionEquality()
                .equals(other._publishers, _publishers) &&
            const DeepCollectionEquality().equals(other._artists, _artists) &&
            const DeepCollectionEquality()
                .equals(other._desingers, _desingers) &&
            (identical(other.commentsNumber, commentsNumber) ||
                other.commentsNumber == commentsNumber) &&
            const DeepCollectionEquality().equals(other._ranks, _ranks) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified) &&
            const DeepCollectionEquality()
                .equals(other._expansions, _expansions) &&
            (identical(other.isExpansion, isExpansion) ||
                other.isExpansion == isExpansion) &&
            (identical(other.isOwned, isOwned) || other.isOwned == isOwned) &&
            (identical(other.isOnWishlist, isOnWishlist) ||
                other.isOnWishlist == isOnWishlist) &&
            (identical(other.isFriends, isFriends) ||
                other.isFriends == isFriends) &&
            (identical(other.isBggSynced, isBggSynced) ||
                other.isBggSynced == isBggSynced) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.isCreatedByUser, isCreatedByUser) ||
                other.isCreatedByUser == isCreatedByUser) &&
            const DeepCollectionEquality().equals(other._prices, _prices));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        thumbnailUrl,
        rank,
        yearPublished,
        imageUrl,
        description,
        const DeepCollectionEquality().hash(_categories),
        rating,
        votes,
        minPlayers,
        minPlaytime,
        maxPlayers,
        maxPlaytime,
        minAge,
        avgWeight,
        const DeepCollectionEquality().hash(_publishers),
        const DeepCollectionEquality().hash(_artists),
        const DeepCollectionEquality().hash(_desingers),
        commentsNumber,
        const DeepCollectionEquality().hash(_ranks),
        lastModified,
        const DeepCollectionEquality().hash(_expansions),
        isExpansion,
        isOwned,
        isOnWishlist,
        isFriends,
        isBggSynced,
        settings,
        isCreatedByUser,
        const DeepCollectionEquality().hash(_prices)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardGameDetailsImplCopyWith<_$BoardGameDetailsImpl> get copyWith =>
      __$$BoardGameDetailsImplCopyWithImpl<_$BoardGameDetailsImpl>(
          this, _$identity);
}

abstract class _BoardGameDetails extends BoardGameDetails {
  const factory _BoardGameDetails(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) final String? thumbnailUrl,
      @HiveField(3) final int? rank,
      @HiveField(4) final int? yearPublished,
      @HiveField(5) final String? imageUrl,
      @HiveField(6) final String? description,
      @HiveField(7) final List<BoardGameCategory>? categories,
      @HiveField(8) final double? rating,
      @HiveField(9) final int? votes,
      @HiveField(10) final int? minPlayers,
      @HiveField(11) final int? minPlaytime,
      @HiveField(12) final int? maxPlayers,
      @HiveField(13) final int? maxPlaytime,
      @HiveField(14) final int? minAge,
      @HiveField(15) final num? avgWeight,
      @HiveField(16) final List<BoardGamePublisher> publishers,
      @HiveField(17) final List<BoardGameArtist> artists,
      @HiveField(18) final List<BoardGameDesigner> desingers,
      @HiveField(19) final int? commentsNumber,
      @HiveField(20) final List<BoardGameRank> ranks,
      @HiveField(21) final DateTime? lastModified,
      @HiveField(22) final List<BoardGameExpansion> expansions,
      @HiveField(23) final bool? isExpansion,
      @HiveField(24) final bool? isOwned,
      @HiveField(25) final bool? isOnWishlist,
      @HiveField(26) final bool? isFriends,
      @HiveField(27) final bool? isBggSynced,
      @HiveField(28) final BoardGameSettings? settings,
      @HiveField(29, defaultValue: false) final bool isCreatedByUser,
      @HiveField(30, defaultValue: <BoardGamePrices>[])
      final List<BoardGamePrices> prices}) = _$BoardGameDetailsImpl;
  const _BoardGameDetails._() : super._();

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override

  /// This property holds a URL to a web image or a locally saved file in case a board game [isCreatedByUser]
  @HiveField(2)
  String? get thumbnailUrl;
  @override
  @HiveField(3)
  int? get rank;
  @override
  @HiveField(4)
  int? get yearPublished;
  @override

  /// This property holds a URL to a web image or a locally saved file in case a board game [isCreatedByUser]
  @HiveField(5)
  String? get imageUrl;
  @override
  @HiveField(6)
  String? get description;
  @override
  @HiveField(7)
  List<BoardGameCategory>? get categories;
  @override
  @HiveField(8)
  double? get rating;
  @override
  @HiveField(9)
  int? get votes;
  @override
  @HiveField(10)
  int? get minPlayers;
  @override
  @HiveField(11)
  int? get minPlaytime;
  @override
  @HiveField(12)
  int? get maxPlayers;
  @override
  @HiveField(13)
  int? get maxPlaytime;
  @override
  @HiveField(14)
  int? get minAge;
  @override
  @HiveField(15)
  num? get avgWeight;
  @override
  @HiveField(16)
  List<BoardGamePublisher> get publishers;
  @override
  @HiveField(17)
  List<BoardGameArtist> get artists;
  @override
  @HiveField(18)
  List<BoardGameDesigner> get desingers;
  @override
  @HiveField(19)
  int? get commentsNumber;
  @override
  @HiveField(20)
  List<BoardGameRank> get ranks;
  @override
  @HiveField(21)
  DateTime? get lastModified;
  @override
  @HiveField(22)
  List<BoardGameExpansion> get expansions;
  @override
  @HiveField(23)
  bool? get isExpansion;
  @override
  @HiveField(24)
  bool? get isOwned;
  @override
  @HiveField(25)
  bool? get isOnWishlist;
  @override
  @HiveField(26)
  bool? get isFriends;
  @override
  @HiveField(27)
  bool? get isBggSynced;
  @override
  @HiveField(28)
  BoardGameSettings? get settings;
  @override
  @HiveField(29, defaultValue: false)
  bool get isCreatedByUser;
  @override
  @HiveField(30, defaultValue: <BoardGamePrices>[])
  List<BoardGamePrices> get prices;
  @override
  @JsonKey(ignore: true)
  _$$BoardGameDetailsImplCopyWith<_$BoardGameDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
