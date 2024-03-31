part of 'position_bloc.dart';

@freezed
class PositionEvent with _$PositionEvent {
  const factory PositionEvent.startService() = PositionEventStartService;
  const factory PositionEvent.stopService() = PositionEventStopService;
}
