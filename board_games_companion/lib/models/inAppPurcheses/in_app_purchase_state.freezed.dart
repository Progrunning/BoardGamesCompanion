// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'in_app_purchase_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$InAppPurchasesState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<ProductDetails> productDetails)
        loadedProducts,
    required TResult Function() unavailable,
    required TResult Function() error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<ProductDetails> productDetails)? loadedProducts,
    TResult Function()? unavailable,
    TResult Function()? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ProductDetails> productDetails)? loadedProducts,
    TResult Function()? unavailable,
    TResult Function()? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_loadedProducts value) loadedProducts,
    required TResult Function(_unavailable value) unavailable,
    required TResult Function(_error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_loadedProducts value)? loadedProducts,
    TResult Function(_unavailable value)? unavailable,
    TResult Function(_error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_loadedProducts value)? loadedProducts,
    TResult Function(_unavailable value)? unavailable,
    TResult Function(_error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InAppPurchasesStateCopyWith<$Res> {
  factory $InAppPurchasesStateCopyWith(
          InAppPurchasesState value, $Res Function(InAppPurchasesState) then) =
      _$InAppPurchasesStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$InAppPurchasesStateCopyWithImpl<$Res>
    implements $InAppPurchasesStateCopyWith<$Res> {
  _$InAppPurchasesStateCopyWithImpl(this._value, this._then);

  final InAppPurchasesState _value;
  // ignore: unused_field
  final $Res Function(InAppPurchasesState) _then;
}

/// @nodoc
abstract class _$$_loadedProductsCopyWith<$Res> {
  factory _$$_loadedProductsCopyWith(
          _$_loadedProducts value, $Res Function(_$_loadedProducts) then) =
      __$$_loadedProductsCopyWithImpl<$Res>;
  $Res call({List<ProductDetails> productDetails});
}

/// @nodoc
class __$$_loadedProductsCopyWithImpl<$Res>
    extends _$InAppPurchasesStateCopyWithImpl<$Res>
    implements _$$_loadedProductsCopyWith<$Res> {
  __$$_loadedProductsCopyWithImpl(
      _$_loadedProducts _value, $Res Function(_$_loadedProducts) _then)
      : super(_value, (v) => _then(v as _$_loadedProducts));

  @override
  _$_loadedProducts get _value => super._value as _$_loadedProducts;

  @override
  $Res call({
    Object? productDetails = freezed,
  }) {
    return _then(_$_loadedProducts(
      productDetails == freezed
          ? _value._productDetails
          : productDetails // ignore: cast_nullable_to_non_nullable
              as List<ProductDetails>,
    ));
  }
}

/// @nodoc

class _$_loadedProducts implements _loadedProducts {
  const _$_loadedProducts(final List<ProductDetails> productDetails)
      : _productDetails = productDetails;

  final List<ProductDetails> _productDetails;
  @override
  List<ProductDetails> get productDetails {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productDetails);
  }

  @override
  String toString() {
    return 'InAppPurchasesState.loadedProducts(productDetails: $productDetails)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_loadedProducts &&
            const DeepCollectionEquality()
                .equals(other._productDetails, _productDetails));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_productDetails));

  @JsonKey(ignore: true)
  @override
  _$$_loadedProductsCopyWith<_$_loadedProducts> get copyWith =>
      __$$_loadedProductsCopyWithImpl<_$_loadedProducts>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<ProductDetails> productDetails)
        loadedProducts,
    required TResult Function() unavailable,
    required TResult Function() error,
  }) {
    return loadedProducts(productDetails);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<ProductDetails> productDetails)? loadedProducts,
    TResult Function()? unavailable,
    TResult Function()? error,
  }) {
    return loadedProducts?.call(productDetails);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ProductDetails> productDetails)? loadedProducts,
    TResult Function()? unavailable,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (loadedProducts != null) {
      return loadedProducts(productDetails);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_loadedProducts value) loadedProducts,
    required TResult Function(_unavailable value) unavailable,
    required TResult Function(_error value) error,
  }) {
    return loadedProducts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_loadedProducts value)? loadedProducts,
    TResult Function(_unavailable value)? unavailable,
    TResult Function(_error value)? error,
  }) {
    return loadedProducts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_loadedProducts value)? loadedProducts,
    TResult Function(_unavailable value)? unavailable,
    TResult Function(_error value)? error,
    required TResult orElse(),
  }) {
    if (loadedProducts != null) {
      return loadedProducts(this);
    }
    return orElse();
  }
}

abstract class _loadedProducts implements InAppPurchasesState {
  const factory _loadedProducts(final List<ProductDetails> productDetails) =
      _$_loadedProducts;

  List<ProductDetails> get productDetails;
  @JsonKey(ignore: true)
  _$$_loadedProductsCopyWith<_$_loadedProducts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_unavailableCopyWith<$Res> {
  factory _$$_unavailableCopyWith(
          _$_unavailable value, $Res Function(_$_unavailable) then) =
      __$$_unavailableCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_unavailableCopyWithImpl<$Res>
    extends _$InAppPurchasesStateCopyWithImpl<$Res>
    implements _$$_unavailableCopyWith<$Res> {
  __$$_unavailableCopyWithImpl(
      _$_unavailable _value, $Res Function(_$_unavailable) _then)
      : super(_value, (v) => _then(v as _$_unavailable));

  @override
  _$_unavailable get _value => super._value as _$_unavailable;
}

/// @nodoc

class _$_unavailable implements _unavailable {
  const _$_unavailable();

  @override
  String toString() {
    return 'InAppPurchasesState.unavailable()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_unavailable);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<ProductDetails> productDetails)
        loadedProducts,
    required TResult Function() unavailable,
    required TResult Function() error,
  }) {
    return unavailable();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<ProductDetails> productDetails)? loadedProducts,
    TResult Function()? unavailable,
    TResult Function()? error,
  }) {
    return unavailable?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ProductDetails> productDetails)? loadedProducts,
    TResult Function()? unavailable,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (unavailable != null) {
      return unavailable();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_loadedProducts value) loadedProducts,
    required TResult Function(_unavailable value) unavailable,
    required TResult Function(_error value) error,
  }) {
    return unavailable(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_loadedProducts value)? loadedProducts,
    TResult Function(_unavailable value)? unavailable,
    TResult Function(_error value)? error,
  }) {
    return unavailable?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_loadedProducts value)? loadedProducts,
    TResult Function(_unavailable value)? unavailable,
    TResult Function(_error value)? error,
    required TResult orElse(),
  }) {
    if (unavailable != null) {
      return unavailable(this);
    }
    return orElse();
  }
}

abstract class _unavailable implements InAppPurchasesState {
  const factory _unavailable() = _$_unavailable;
}

/// @nodoc
abstract class _$$_errorCopyWith<$Res> {
  factory _$$_errorCopyWith(_$_error value, $Res Function(_$_error) then) =
      __$$_errorCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_errorCopyWithImpl<$Res>
    extends _$InAppPurchasesStateCopyWithImpl<$Res>
    implements _$$_errorCopyWith<$Res> {
  __$$_errorCopyWithImpl(_$_error _value, $Res Function(_$_error) _then)
      : super(_value, (v) => _then(v as _$_error));

  @override
  _$_error get _value => super._value as _$_error;
}

/// @nodoc

class _$_error implements _error {
  const _$_error();

  @override
  String toString() {
    return 'InAppPurchasesState.error()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_error);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<ProductDetails> productDetails)
        loadedProducts,
    required TResult Function() unavailable,
    required TResult Function() error,
  }) {
    return error();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(List<ProductDetails> productDetails)? loadedProducts,
    TResult Function()? unavailable,
    TResult Function()? error,
  }) {
    return error?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ProductDetails> productDetails)? loadedProducts,
    TResult Function()? unavailable,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_loadedProducts value) loadedProducts,
    required TResult Function(_unavailable value) unavailable,
    required TResult Function(_error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_loadedProducts value)? loadedProducts,
    TResult Function(_unavailable value)? unavailable,
    TResult Function(_error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_loadedProducts value)? loadedProducts,
    TResult Function(_unavailable value)? unavailable,
    TResult Function(_error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _error implements InAppPurchasesState {
  const factory _error() = _$_error;
}
