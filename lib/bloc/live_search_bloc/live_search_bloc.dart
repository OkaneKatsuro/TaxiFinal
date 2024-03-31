import 'package:cars/models/place.dart';
import 'package:cars/repository/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'live_search_state.dart';
part 'live_search_event.dart';

part 'live_search_bloc.freezed.dart';

class LiveSearchBloc extends Bloc<LiveSearchEvent, LiveSearchState> {
  final Repository repo;

  LiveSearchBloc({
    required this.repo,
  }) : super(LiveSearchState.noData()) {
    on<LiveSearchEventFetch>((event, emit) async {
      emit(const LiveSearchState.loading());
      var res = await repo.search(text: event.text);

      emit(LiveSearchState.loaded(searchResult: res));
    });
  }

  // @override
  // TestState? fromJson(Map<String, dynamic> json) => TestState.fromJson(json);

  // @override
  // Map<String, dynamic>? toJson(TestState state) => state.toJson();
}
