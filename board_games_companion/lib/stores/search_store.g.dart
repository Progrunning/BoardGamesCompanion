// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SearchStore on _SearchStore, Store {
  late final _$searchHistoryAtom =
      Atom(name: '_SearchStore.searchHistory', context: context);

  @override
  ObservableList<SearchHistoryEntry> get searchHistory {
    _$searchHistoryAtom.reportRead();
    return super.searchHistory;
  }

  @override
  set searchHistory(ObservableList<SearchHistoryEntry> value) {
    _$searchHistoryAtom.reportWrite(value, super.searchHistory, () {
      super.searchHistory = value;
    });
  }

  late final _$loadSearchHistoryAsyncAction =
      AsyncAction('_SearchStore.loadSearchHistory', context: context);

  @override
  Future<void> loadSearchHistory() {
    return _$loadSearchHistoryAsyncAction.run(() => super.loadSearchHistory());
  }

  late final _$addOrUpdateEntryAsyncAction =
      AsyncAction('_SearchStore.addOrUpdateEntry', context: context);

  @override
  Future<void> addOrUpdateEntry(SearchHistoryEntry searchHistoryEntry) {
    return _$addOrUpdateEntryAsyncAction
        .run(() => super.addOrUpdateEntry(searchHistoryEntry));
  }

  @override
  String toString() {
    return '''
searchHistory: ${searchHistory}
    ''';
  }
}
