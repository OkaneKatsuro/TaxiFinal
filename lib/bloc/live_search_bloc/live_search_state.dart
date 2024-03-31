part of 'live_search_bloc.dart';

@freezed
class LiveSearchState with _$LiveSearchState {
  const factory LiveSearchState.loaded({required List<Place> searchResult}) =
      LiveSearchStateLoaded;
  const factory LiveSearchState.loading() = LiveSearchStateLoading;
  const factory LiveSearchState.error() = LiveSearchStateError;
  const factory LiveSearchState.noData() = LiveSearchStateNoData;

  // factory LiveSearchState.fromJson(Map<String, dynamic> json) =>
  //     _$LiveSearchStateFromJson(json);
}
