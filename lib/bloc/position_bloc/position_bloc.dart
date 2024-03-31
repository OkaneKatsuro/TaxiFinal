import 'package:cars/models/car.dart';
import 'package:cars/repository/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'position_state.dart';
part 'position_event.dart';

part 'position_bloc.freezed.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  final Repository repo;
  bool isActive = false;
  PositionBloc({
    required this.repo,
  }) : super(PositionState.allLoading()) {
    on<PositionEventStartService>((event, emit) async {
      isActive = true;
      while (isActive) {
        print('Get Car position');
        emit(PositionState.carLoading());
        await updateCarLocation();
        emit(PositionState.carLoaded());
        await Future.delayed(Duration(seconds: 5));
      }
    });
    // on<CarOrderEventStop>((event, emit) async {
    //   // emit(const CarOrderState.loading());

    //   emit(const CarOrderState.confirmed());
    // });
    // on<CarOrderEventRouteLoading>((event, emit) async {
    //   // emit(const CarOrderState.loading());
    //   print('loading=>>>');
    //   emit(const CarOrderState.error());
    //   emit(const CarOrderState.loading());
    // });
    // on<CarOrderEventPerenosZakaza>((event, emit) async {
    //   emit(const CarOrderState.perenos());
    // });
  }

  // @override
  // TestState? fromJson(Map<String, dynamic> json) => TestState.fromJson(json);

  // @override
  // Map<String, dynamic>? toJson(TestState state) => state.toJson();
}
