// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_search_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LiveSearchState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Place> searchResult) loaded,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Place> searchResult)? loaded,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function()? noData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Place> searchResult)? loaded,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LiveSearchStateLoaded value) loaded,
    required TResult Function(LiveSearchStateLoading value) loading,
    required TResult Function(LiveSearchStateError value) error,
    required TResult Function(LiveSearchStateNoData value) noData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LiveSearchStateLoaded value)? loaded,
    TResult? Function(LiveSearchStateLoading value)? loading,
    TResult? Function(LiveSearchStateError value)? error,
    TResult? Function(LiveSearchStateNoData value)? noData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LiveSearchStateLoaded value)? loaded,
    TResult Function(LiveSearchStateLoading value)? loading,
    TResult Function(LiveSearchStateError value)? error,
    TResult Function(LiveSearchStateNoData value)? noData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiveSearchStateCopyWith<$Res> {
  factory $LiveSearchStateCopyWith(
          LiveSearchState value, $Res Function(LiveSearchState) then) =
      _$LiveSearchStateCopyWithImpl<$Res, LiveSearchState>;
}

/// @nodoc
class _$LiveSearchStateCopyWithImpl<$Res, $Val extends LiveSearchState>
    implements $LiveSearchStateCopyWith<$Res> {
  _$LiveSearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LiveSearchStateLoadedCopyWith<$Res> {
  factory _$$LiveSearchStateLoadedCopyWith(_$LiveSearchStateLoaded value,
          $Res Function(_$LiveSearchStateLoaded) then) =
      __$$LiveSearchStateLoadedCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Place> searchResult});
}

/// @nodoc
class __$$LiveSearchStateLoadedCopyWithImpl<$Res>
    extends _$LiveSearchStateCopyWithImpl<$Res, _$LiveSearchStateLoaded>
    implements _$$LiveSearchStateLoadedCopyWith<$Res> {
  __$$LiveSearchStateLoadedCopyWithImpl(_$LiveSearchStateLoaded _value,
      $Res Function(_$LiveSearchStateLoaded) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchResult = null,
  }) {
    return _then(_$LiveSearchStateLoaded(
      searchResult: null == searchResult
          ? _value._searchResult
          : searchResult // ignore: cast_nullable_to_non_nullable
              as List<Place>,
    ));
  }
}

/// @nodoc

class _$LiveSearchStateLoaded implements LiveSearchStateLoaded {
  const _$LiveSearchStateLoaded({required final List<Place> searchResult})
      : _searchResult = searchResult;

  final List<Place> _searchResult;
  @override
  List<Place> get searchResult {
    if (_searchResult is EqualUnmodifiableListView) return _searchResult;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchResult);
  }

  @override
  String toString() {
    return 'LiveSearchState.loaded(searchResult: $searchResult)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LiveSearchStateLoaded &&
            const DeepCollectionEquality()
                .equals(other._searchResult, _searchResult));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_searchResult));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LiveSearchStateLoadedCopyWith<_$LiveSearchStateLoaded> get copyWith =>
      __$$LiveSearchStateLoadedCopyWithImpl<_$LiveSearchStateLoaded>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Place> searchResult) loaded,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return loaded(searchResult);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Place> searchResult)? loaded,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function()? noData,
  }) {
    return loaded?.call(searchResult);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Place> searchResult)? loaded,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(searchResult);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LiveSearchStateLoaded value) loaded,
    required TResult Function(LiveSearchStateLoading value) loading,
    required TResult Function(LiveSearchStateError value) error,
    required TResult Function(LiveSearchStateNoData value) noData,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LiveSearchStateLoaded value)? loaded,
    TResult? Function(LiveSearchStateLoading value)? loading,
    TResult? Function(LiveSearchStateError value)? error,
    TResult? Function(LiveSearchStateNoData value)? noData,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LiveSearchStateLoaded value)? loaded,
    TResult Function(LiveSearchStateLoading value)? loading,
    TResult Function(LiveSearchStateError value)? error,
    TResult Function(LiveSearchStateNoData value)? noData,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class LiveSearchStateLoaded implements LiveSearchState {
  const factory LiveSearchStateLoaded(
      {required final List<Place> searchResult}) = _$LiveSearchStateLoaded;

  List<Place> get searchResult;
  @JsonKey(ignore: true)
  _$$LiveSearchStateLoadedCopyWith<_$LiveSearchStateLoaded> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LiveSearchStateLoadingCopyWith<$Res> {
  factory _$$LiveSearchStateLoadingCopyWith(_$LiveSearchStateLoading value,
          $Res Function(_$LiveSearchStateLoading) then) =
      __$$LiveSearchStateLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LiveSearchStateLoadingCopyWithImpl<$Res>
    extends _$LiveSearchStateCopyWithImpl<$Res, _$LiveSearchStateLoading>
    implements _$$LiveSearchStateLoadingCopyWith<$Res> {
  __$$LiveSearchStateLoadingCopyWithImpl(_$LiveSearchStateLoading _value,
      $Res Function(_$LiveSearchStateLoading) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LiveSearchStateLoading implements LiveSearchStateLoading {
  const _$LiveSearchStateLoading();

  @override
  String toString() {
    return 'LiveSearchState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LiveSearchStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Place> searchResult) loaded,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Place> searchResult)? loaded,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function()? noData,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Place> searchResult)? loaded,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LiveSearchStateLoaded value) loaded,
    required TResult Function(LiveSearchStateLoading value) loading,
    required TResult Function(LiveSearchStateError value) error,
    required TResult Function(LiveSearchStateNoData value) noData,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LiveSearchStateLoaded value)? loaded,
    TResult? Function(LiveSearchStateLoading value)? loading,
    TResult? Function(LiveSearchStateError value)? error,
    TResult? Function(LiveSearchStateNoData value)? noData,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LiveSearchStateLoaded value)? loaded,
    TResult Function(LiveSearchStateLoading value)? loading,
    TResult Function(LiveSearchStateError value)? error,
    TResult Function(LiveSearchStateNoData value)? noData,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class LiveSearchStateLoading implements LiveSearchState {
  const factory LiveSearchStateLoading() = _$LiveSearchStateLoading;
}

/// @nodoc
abstract class _$$LiveSearchStateErrorCopyWith<$Res> {
  factory _$$LiveSearchStateErrorCopyWith(_$LiveSearchStateError value,
          $Res Function(_$LiveSearchStateError) then) =
      __$$LiveSearchStateErrorCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LiveSearchStateErrorCopyWithImpl<$Res>
    extends _$LiveSearchStateCopyWithImpl<$Res, _$LiveSearchStateError>
    implements _$$LiveSearchStateErrorCopyWith<$Res> {
  __$$LiveSearchStateErrorCopyWithImpl(_$LiveSearchStateError _value,
      $Res Function(_$LiveSearchStateError) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LiveSearchStateError implements LiveSearchStateError {
  const _$LiveSearchStateError();

  @override
  String toString() {
    return 'LiveSearchState.error()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LiveSearchStateError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Place> searchResult) loaded,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return error();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Place> searchResult)? loaded,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function()? noData,
  }) {
    return error?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Place> searchResult)? loaded,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
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
    required TResult Function(LiveSearchStateLoaded value) loaded,
    required TResult Function(LiveSearchStateLoading value) loading,
    required TResult Function(LiveSearchStateError value) error,
    required TResult Function(LiveSearchStateNoData value) noData,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LiveSearchStateLoaded value)? loaded,
    TResult? Function(LiveSearchStateLoading value)? loading,
    TResult? Function(LiveSearchStateError value)? error,
    TResult? Function(LiveSearchStateNoData value)? noData,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LiveSearchStateLoaded value)? loaded,
    TResult Function(LiveSearchStateLoading value)? loading,
    TResult Function(LiveSearchStateError value)? error,
    TResult Function(LiveSearchStateNoData value)? noData,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class LiveSearchStateError implements LiveSearchState {
  const factory LiveSearchStateError() = _$LiveSearchStateError;
}

/// @nodoc
abstract class _$$LiveSearchStateNoDataCopyWith<$Res> {
  factory _$$LiveSearchStateNoDataCopyWith(_$LiveSearchStateNoData value,
          $Res Function(_$LiveSearchStateNoData) then) =
      __$$LiveSearchStateNoDataCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LiveSearchStateNoDataCopyWithImpl<$Res>
    extends _$LiveSearchStateCopyWithImpl<$Res, _$LiveSearchStateNoData>
    implements _$$LiveSearchStateNoDataCopyWith<$Res> {
  __$$LiveSearchStateNoDataCopyWithImpl(_$LiveSearchStateNoData _value,
      $Res Function(_$LiveSearchStateNoData) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LiveSearchStateNoData implements LiveSearchStateNoData {
  const _$LiveSearchStateNoData();

  @override
  String toString() {
    return 'LiveSearchState.noData()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LiveSearchStateNoData);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Place> searchResult) loaded,
    required TResult Function() loading,
    required TResult Function() error,
    required TResult Function() noData,
  }) {
    return noData();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Place> searchResult)? loaded,
    TResult? Function()? loading,
    TResult? Function()? error,
    TResult? Function()? noData,
  }) {
    return noData?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Place> searchResult)? loaded,
    TResult Function()? loading,
    TResult Function()? error,
    TResult Function()? noData,
    required TResult orElse(),
  }) {
    if (noData != null) {
      return noData();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LiveSearchStateLoaded value) loaded,
    required TResult Function(LiveSearchStateLoading value) loading,
    required TResult Function(LiveSearchStateError value) error,
    required TResult Function(LiveSearchStateNoData value) noData,
  }) {
    return noData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LiveSearchStateLoaded value)? loaded,
    TResult? Function(LiveSearchStateLoading value)? loading,
    TResult? Function(LiveSearchStateError value)? error,
    TResult? Function(LiveSearchStateNoData value)? noData,
  }) {
    return noData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LiveSearchStateLoaded value)? loaded,
    TResult Function(LiveSearchStateLoading value)? loading,
    TResult Function(LiveSearchStateError value)? error,
    TResult Function(LiveSearchStateNoData value)? noData,
    required TResult orElse(),
  }) {
    if (noData != null) {
      return noData(this);
    }
    return orElse();
  }
}

abstract class LiveSearchStateNoData implements LiveSearchState {
  const factory LiveSearchStateNoData() = _$LiveSearchStateNoData;
}

/// @nodoc
mixin _$LiveSearchEvent {
  String get text => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text) fetch,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String text)? fetch,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text)? fetch,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LiveSearchEventFetch value) fetch,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LiveSearchEventFetch value)? fetch,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LiveSearchEventFetch value)? fetch,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LiveSearchEventCopyWith<LiveSearchEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiveSearchEventCopyWith<$Res> {
  factory $LiveSearchEventCopyWith(
          LiveSearchEvent value, $Res Function(LiveSearchEvent) then) =
      _$LiveSearchEventCopyWithImpl<$Res, LiveSearchEvent>;
  @useResult
  $Res call({String text});
}

/// @nodoc
class _$LiveSearchEventCopyWithImpl<$Res, $Val extends LiveSearchEvent>
    implements $LiveSearchEventCopyWith<$Res> {
  _$LiveSearchEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LiveSearchEventFetchCopyWith<$Res>
    implements $LiveSearchEventCopyWith<$Res> {
  factory _$$LiveSearchEventFetchCopyWith(_$LiveSearchEventFetch value,
          $Res Function(_$LiveSearchEventFetch) then) =
      __$$LiveSearchEventFetchCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text});
}

/// @nodoc
class __$$LiveSearchEventFetchCopyWithImpl<$Res>
    extends _$LiveSearchEventCopyWithImpl<$Res, _$LiveSearchEventFetch>
    implements _$$LiveSearchEventFetchCopyWith<$Res> {
  __$$LiveSearchEventFetchCopyWithImpl(_$LiveSearchEventFetch _value,
      $Res Function(_$LiveSearchEventFetch) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
  }) {
    return _then(_$LiveSearchEventFetch(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LiveSearchEventFetch implements LiveSearchEventFetch {
  const _$LiveSearchEventFetch({required this.text});

  @override
  final String text;

  @override
  String toString() {
    return 'LiveSearchEvent.fetch(text: $text)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LiveSearchEventFetch &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LiveSearchEventFetchCopyWith<_$LiveSearchEventFetch> get copyWith =>
      __$$LiveSearchEventFetchCopyWithImpl<_$LiveSearchEventFetch>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String text) fetch,
  }) {
    return fetch(text);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String text)? fetch,
  }) {
    return fetch?.call(text);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String text)? fetch,
    required TResult orElse(),
  }) {
    if (fetch != null) {
      return fetch(text);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LiveSearchEventFetch value) fetch,
  }) {
    return fetch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LiveSearchEventFetch value)? fetch,
  }) {
    return fetch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LiveSearchEventFetch value)? fetch,
    required TResult orElse(),
  }) {
    if (fetch != null) {
      return fetch(this);
    }
    return orElse();
  }
}

abstract class LiveSearchEventFetch implements LiveSearchEvent {
  const factory LiveSearchEventFetch({required final String text}) =
      _$LiveSearchEventFetch;

  @override
  String get text;
  @override
  @JsonKey(ignore: true)
  _$$LiveSearchEventFetchCopyWith<_$LiveSearchEventFetch> get copyWith =>
      throw _privateConstructorUsedError;
}
