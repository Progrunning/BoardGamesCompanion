// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_icon_picker_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppIconPickerViewModel on _AppIconPickerViewModel, Store {
  Computed<bool>? _$isSupporterComputed;

  @override
  bool get isSupporter =>
      (_$isSupporterComputed ??= Computed<bool>(() => super.isSupporter,
              name: '_AppIconPickerViewModel.isSupporter'))
          .value;

  late final _$availableIconIdsAtom =
      Atom(name: '_AppIconPickerViewModel.availableIconIds', context: context);

  @override
  ObservableList<String> get availableIconIds {
    _$availableIconIdsAtom.reportRead();
    return super.availableIconIds;
  }

  @override
  set availableIconIds(ObservableList<String> value) {
    _$availableIconIdsAtom.reportWrite(value, super.availableIconIds, () {
      super.availableIconIds = value;
    });
  }

  late final _$currentIconIdAtom =
      Atom(name: '_AppIconPickerViewModel.currentIconId', context: context);

  @override
  String? get currentIconId {
    _$currentIconIdAtom.reportRead();
    return super.currentIconId;
  }

  @override
  set currentIconId(String? value) {
    _$currentIconIdAtom.reportWrite(value, super.currentIconId, () {
      super.currentIconId = value;
    });
  }

  late final _$isApplyingIconAtom =
      Atom(name: '_AppIconPickerViewModel.isApplyingIcon', context: context);

  @override
  bool get isApplyingIcon {
    _$isApplyingIconAtom.reportRead();
    return super.isApplyingIcon;
  }

  @override
  set isApplyingIcon(bool value) {
    _$isApplyingIconAtom.reportWrite(value, super.isApplyingIcon, () {
      super.isApplyingIcon = value;
    });
  }

  late final _$loadAvailableIconsAsyncAction = AsyncAction(
      '_AppIconPickerViewModel.loadAvailableIcons',
      context: context);

  @override
  Future<void> loadAvailableIcons() {
    return _$loadAvailableIconsAsyncAction
        .run(() => super.loadAvailableIcons());
  }

  late final _$selectIconAsyncAction =
      AsyncAction('_AppIconPickerViewModel.selectIcon', context: context);

  @override
  Future<void> selectIcon(String iconId) {
    return _$selectIconAsyncAction.run(() => super.selectIcon(iconId));
  }

  @override
  String toString() {
    return '''
availableIconIds: ${availableIconIds},
currentIconId: ${currentIconId},
isApplyingIcon: ${isApplyingIcon},
isSupporter: ${isSupporter}
    ''';
  }
}
