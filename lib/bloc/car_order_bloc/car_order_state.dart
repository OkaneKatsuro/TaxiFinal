part of 'car_order_bloc.dart';

@freezed
class CarOrderState with _$CarOrderState {
  const factory CarOrderState.loading() = CarOrderStateLoading;
  const factory CarOrderState.error() = CarOrderStateError;
  const factory CarOrderState.active() = CarOrderStateActive;
  const factory CarOrderState.confirmed() = CarOrderStateConfirmed;
  const factory CarOrderState.perenos() = CarOrderStatePerenos;
  const factory CarOrderState.finishedOrCanceled() =
      CarOrderStateFinishedOrCanceled;
  const factory CarOrderState.waitingForConfirmation() =
      CarOrderStateWaitingForConfirmation;

  const factory CarOrderState.done() = CarOrderStateDone;
  const factory CarOrderState.planAnother() = CarOrderStatePlanAnother;
  // factory CarOrderState.fromJson(Map<String, dynamic> json) =>
  //     _$CarOrderStateFromJson(json);
}
