part of 'car_order_bloc.dart';

@freezed
class CarOrderEvent with _$CarOrderEvent {
  const factory CarOrderEvent.start() = CarOrderEventStart;
  const factory CarOrderEvent.stop() = CarOrderEventStop;
  const factory CarOrderEvent.routeLoading() = CarOrderEventRouteLoading;
  const factory CarOrderEvent.perenosZakaza() = CarOrderEventPerenosZakaza;
  const factory CarOrderEvent.badDate() = CarOrderEventBadDate;
  const factory CarOrderEvent.initPassenger() = CarOrderEventInitPassenger;
  const factory CarOrderEvent.planAnother() = CarOrderEventPlanAnother;
}
