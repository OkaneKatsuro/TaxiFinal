import 'package:cars/models/car_order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

  import '../../models/place.dart';

class RouteFromToCubit extends Cubit<CarOrder> {
  RouteFromToCubit() : super(CarOrder(status: CarOrderStatus.waiting));
  void set(val) {
    emit(val);
  }

  void setBackTime(int val) {
    state.backTime = val;
    emit(state);
  }

  void setArriveTime(int val) {
    state.arriveTime = val;
    emit(state);
  }

  void setCarStatus(bool val) {
    state.isCarFree = val;
    emit(state);
  }

  void setOrderId(String val) {
    state.id = val;
    emit(state);
  }

  void setPassId(String val) {
    state.passId = val;
    emit(state);
  }

  void setFrom(Place? val) {
    state.from = val;
    emit(state);
  }

  void setPassName(val) {
    state.passName = val;
    emit(state);
  }

  setDriverName(String name) {
    state.driverName = name;
    emit(state);
  }

  setStatus(CarOrderStatus status) {
    state.status = status;
    emit(state);
  }

  setStartDate(DateTime? date) {
    state.startDate = date;
    emit(state);
  }

  setEndDate(DateTime date) {
    state.endDate = date;
    emit(state);
  }

  void setLenth(int? val) {
    state.lengthSec = val;
    emit(state);
  }

  void setTo(List<Place> val) {
    state.route = val;
    emit(state);
  }

  void removePlaceFromRoute(Place val) {
    state.route!.remove(val);
    emit(state);
  }

  void addStop(Place val) {
    if (state.route != null) {
      state.route!.add(val);
    } else {
      state.route = [val];
    }
    emit(state);
  }

  void setComment(val) {
    state.comment = val;
    emit(state);
  }

  CarOrder get() => state.obs.value;
}
