part of 'live_search_bloc.dart';

@freezed
class LiveSearchEvent with _$LiveSearchEvent {
  const factory LiveSearchEvent.fetch({required String text}) =
      LiveSearchEventFetch;
}
