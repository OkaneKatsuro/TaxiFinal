import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/place.dart';
import 'package:cars/repository/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/car_order.dart';
import '../../res/firebase_utils.dart';
import '../../res/odder_functions.dart';

part 'car_order_state.dart';
part 'car_order_event.dart';

part 'car_order_bloc.freezed.dart';

class CarOrderBloc extends Bloc<CarOrderEvent, CarOrderState> {
  final Repository repo;
  CarOrder currentOrder = CarOrder(status: CarOrderStatus.empty);
  CarOrder tmpOrder = CarOrder(status: CarOrderStatus.empty);
  UserCubit user;

  String carStatusStr = '';

  CarOrderBloc({
    required this.repo,
    required this.user,
  }) : super(CarOrderState.done()) {
    on<CarOrderEventStart>((event, emit) async {
      emit(const CarOrderState.waitingForConfirmation());
    });
    on<CarOrderEventPlanAnother>((event, emit) async {
      tmpOrder = currentOrder;
      currentOrder = CarOrder(status: CarOrderStatus.planed);
      emit(const CarOrderState.planAnother());
    });

    on<CarOrderEventStop>((event, emit) async {
      currentOrder = CarOrder(status: CarOrderStatus.empty);
      emit(const CarOrderState.done());
    });

    on<CarOrderEventRouteLoading>((event, emit) async {
      // emit(const CarOrderState.loading());
      print('loading=>>>');
      var st = state;
      emit(const CarOrderState.error());
      await Future.delayed(Duration(milliseconds: 1500));
      emit(state);
    });

    on<CarOrderEventPerenosZakaza>((event, emit) async {
      emit(const CarOrderState.perenos());
    });

    on<CarOrderEventBadDate>((event, emit) async {
      var stat = state;
      emit(const CarOrderState.error());
      await Future.delayed(Duration(milliseconds: 1500));
      emit(stat);
    });

    on<CarOrderEventInitPassenger>((event, emit) async {
      try {
        var tmpCarStatus = await getCarStatus();
        carStatusStr = tmpCarStatus;

        if (tmpCarStatus == 'Машина свободна') {
          currentOrder.isCarFree = true;
        } else {
          currentOrder.isCarFree = false;
        }
        print('Обновление заказа');

        var activeOrder = await getActiveOrderByPassId(user.getUser()!.id);

        var waitingOrder = await getWaingOrderByPassId(user.getUser()!.id);

        var orderById = await getOrderByOrderId(currentOrder.id ?? '');

        print(
            ' currentOrder.status = ${currentOrder.status}    activeOrder=$activeOrder  waitingOrder=$waitingOrder  orderById=$orderById ');
        //если в фаербейз ордер статус Waiting
        if (activeOrder == null &&
            waitingOrder == null &&
            orderById == null &&
            currentOrder.status == CarOrderStatus.active) {
          print('заказ отменен или завершен');
          currentOrder = CarOrder(status: CarOrderStatus.empty);
          emit(const CarOrderState.finishedOrCanceled());
          await Future.delayed(Duration(seconds: 1));
          emit(const CarOrderState.done());
        } else if (activeOrder == null &&
            waitingOrder != null &&
            CarOrder.fromJson(waitingOrder).status == CarOrderStatus.waiting) {
          currentOrder = CarOrder.fromJson(waitingOrder);
          emit(const CarOrderState.waitingForConfirmation());
        } else if (currentOrder.status == CarOrderStatus.waiting &&
            orderById != null &&
            orderById['status'] == 'planed') {
          print('водетель изменил время выполнения');
          currentOrder = CarOrder.fromJson(orderById);
          emit(CarOrderState.perenos());
        } else if (activeOrder != null) {
          print('идет выполнение нашего заказа');
          currentOrder = CarOrder.fromJson(activeOrder);
          emit(CarOrderState.done());
        }
      } catch (e) {
        emit(CarOrderState.done());
      }
      // //бронировние при выполняющемся заказе
      // if (currentOrder.status != CarOrderStatus.planed && activeOrder != null) {
      //   print('бронировние при выполняющемся заказе');
      //   // context.read<RouteFromToCubit>().set(CarOrder.fromJson(order));
      //   // context.read<CarOrderBloc>().add(CarOrderEvent.stop());
      // }
    });
  }

  // @override
  // TestState? fromJson(Map<String, dynamic> json) => TestState.fromJson(json);

  // @override
  // Map<String, dynamic>? toJson(TestState state) => state.toJson();
}
