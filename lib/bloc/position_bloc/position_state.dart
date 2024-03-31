part of 'position_bloc.dart';

@freezed
class PositionState with _$PositionState {
  const factory PositionState.carLoading() = PositionStateCarLoading;
  const factory PositionState.geoLoading() = PositionStateGeoLoading;
  const factory PositionState.carLoaded() = PositionStateCarLoaded;
  const factory PositionState.geoLoaded() = PositionStateGeoLoaded;
  const factory PositionState.allLoaded() = PositionStateAllLoaded;
  const factory PositionState.allLoading() = PositionStateAllLoading;
}
