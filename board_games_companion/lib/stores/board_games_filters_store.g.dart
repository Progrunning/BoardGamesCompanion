// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_games_filters_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BoardGamesFiltersStore on _BoardGamesFiltersStore, Store {
  Computed<double?>? _$filterByRatingComputed;

  @override
  double? get filterByRating => (_$filterByRatingComputed ??= Computed<double?>(
          () => super.filterByRating,
          name: '_BoardGamesFiltersStore.filterByRating'))
      .value;
  Computed<int?>? _$numberOfPlayersComputed;

  @override
  int? get numberOfPlayers =>
      (_$numberOfPlayersComputed ??= Computed<int?>(() => super.numberOfPlayers,
              name: '_BoardGamesFiltersStore.numberOfPlayers'))
          .value;
  Computed<bool>? _$anyFiltersAppliedComputed;

  @override
  bool get anyFiltersApplied => (_$anyFiltersAppliedComputed ??= Computed<bool>(
          () => super.anyFiltersApplied,
          name: '_BoardGamesFiltersStore.anyFiltersApplied'))
      .value;

  late final _$_collectionFiltersAtom = Atom(
      name: '_BoardGamesFiltersStore._collectionFilters', context: context);

  @override
  CollectionFilters? get _collectionFilters {
    _$_collectionFiltersAtom.reportRead();
    return super._collectionFilters;
  }

  @override
  set _collectionFilters(CollectionFilters? value) {
    _$_collectionFiltersAtom.reportWrite(value, super._collectionFilters, () {
      super._collectionFilters = value;
    });
  }

  late final _$sortByOptionsAtom =
      Atom(name: '_BoardGamesFiltersStore.sortByOptions', context: context);

  @override
  ObservableList<SortBy> get sortByOptions {
    _$sortByOptionsAtom.reportRead();
    return super.sortByOptions;
  }

  @override
  set sortByOptions(ObservableList<SortBy> value) {
    _$sortByOptionsAtom.reportWrite(value, super.sortByOptions, () {
      super.sortByOptions = value;
    });
  }

  late final _$loadFilterPreferencesAsyncAction = AsyncAction(
      '_BoardGamesFiltersStore.loadFilterPreferences',
      context: context);

  @override
  Future<void> loadFilterPreferences() {
    return _$loadFilterPreferencesAsyncAction
        .run(() => super.loadFilterPreferences());
  }

  late final _$clearFiltersAsyncAction =
      AsyncAction('_BoardGamesFiltersStore.clearFilters', context: context);

  @override
  Future<void> clearFilters() {
    return _$clearFiltersAsyncAction.run(() => super.clearFilters());
  }

  late final _$updateSortBySelectionAsyncAction = AsyncAction(
      '_BoardGamesFiltersStore.updateSortBySelection',
      context: context);

  @override
  Future<void> updateSortBySelection(SortBy sortBy) {
    return _$updateSortBySelectionAsyncAction
        .run(() => super.updateSortBySelection(sortBy));
  }

  late final _$updateFilterByRatingAsyncAction = AsyncAction(
      '_BoardGamesFiltersStore.updateFilterByRating',
      context: context);

  @override
  Future<void> updateFilterByRating(double? filterByRating) {
    return _$updateFilterByRatingAsyncAction
        .run(() => super.updateFilterByRating(filterByRating));
  }

  late final _$changeNumberOfPlayersAsyncAction = AsyncAction(
      '_BoardGamesFiltersStore.changeNumberOfPlayers',
      context: context);

  @override
  Future<void> changeNumberOfPlayers(int? numberOfPlayers) {
    return _$changeNumberOfPlayersAsyncAction
        .run(() => super.changeNumberOfPlayers(numberOfPlayers));
  }

  late final _$updateNumberOfPlayersFilterAsyncAction = AsyncAction(
      '_BoardGamesFiltersStore.updateNumberOfPlayersFilter',
      context: context);

  @override
  Future<void> updateNumberOfPlayersFilter() {
    return _$updateNumberOfPlayersFilterAsyncAction
        .run(() => super.updateNumberOfPlayersFilter());
  }

  @override
  String toString() {
    return '''
sortByOptions: ${sortByOptions},
filterByRating: ${filterByRating},
numberOfPlayers: ${numberOfPlayers},
anyFiltersApplied: ${anyFiltersApplied}
    ''';
  }
}
