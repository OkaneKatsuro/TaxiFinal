import 'dart:math';

import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/car_order.dart';

import 'package:cars/widgets/maps/res/functions.dart';
import 'package:cars/widgets/sign_in/confirm_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'notification_services.dart';

Future<CarOrder?> orderNow(BuildContext context) async {
  var date = context.read<CarOrderBloc>().currentOrder.startDate == null
      ? DateTime.now()
      : context.read<CarOrderBloc>().currentOrder.startDate!;
  var id = DateTime.now().millisecondsSinceEpoch.toString();
  var back = await getBackTime(context);
  if (context.read<CarOrderBloc>().currentOrder.arriveTime == null) {
    await getRouteToPass(context);
  }

  context.read<CarOrderBloc>().currentOrder.endDate = date
      .add(Duration(
          seconds: context.read<CarOrderBloc>().currentOrder.lengthSec!))
      .add(Duration(
          seconds: context.read<CarOrderBloc>().currentOrder.arriveTime!))
      .add(Duration(seconds: back));

  context.read<CarOrderBloc>().currentOrder.passName =
      context.read<CarOrderBloc>().user.getUser()!.fname +
          ' ' +
          context.read<CarOrderBloc>().user.getUser()!.lname;

  context.read<CarOrderBloc>().currentOrder.id = id;
  context.read<CarOrderBloc>().currentOrder.passId =
      context.read<CarOrderBloc>().user.getUser()!.id;


  var order = context.read<CarOrderBloc>().currentOrder;

  //проверка занята ли машина в наше время во всех заказах
  var otherOrder = await checkOrdersBeforePlane(order);

  if (otherOrder == null) {
    if (context.read<CarOrderBloc>().currentOrder.startDate == null) {
      context.read<CarOrderBloc>().currentOrder.startDate = date;
      context.read<CarOrderBloc>().currentOrder.status = CarOrderStatus.waiting;
    } else {
      context.read<CarOrderBloc>().currentOrder.status = CarOrderStatus.planed;
    }

    await FirebaseFirestore.instance
        .collection('orders')
        .doc(id)
        .set(context.read<CarOrderBloc>().currentOrder.toJson());
    var passName = context.read<CarOrderBloc>().user.getUser()!.name;
    var passFName = context.read<CarOrderBloc>().user.getUser()!.fname;

    return null;
  } else {
    return CarOrder.fromJson(otherOrder);
  }
}

orderConfirm(BuildContext context) async {
  var id = context.read<RouteFromToCubit>().get().id;

  context.read<RouteFromToCubit>().setDriverName(
      context.read<UserCubit>().getUser()!.fname +
          ' ' +
          context.read<UserCubit>().getUser()!.lname);
  var order = context.read<RouteFromToCubit>().get();
  order.driverId = context.read<UserCubit>().getUser()!.id;
  await FirebaseFirestore.instance.collection('orders').doc(id).set(order.toJson());
  await sendNotificationToPassStartOrder(orderId: id);
}

Future<Map<String, dynamic>?> getFirstWaitingOrder() async {
  var orders = await FirebaseFirestore.instance.collection('orders').get();
  var order = orders.docs
      .firstWhereOrNull((element) => element.data()['status'] == 'waiting');
  return order?.data();
}

Future<Map<String, dynamic>?> getFirstActiveOrder() async {
  var orders = await FirebaseFirestore.instance.collection('orders').get();
  var order = orders.docs
      .firstWhereOrNull((element) => element.data()['status'] == 'active');
  return order?.data();
}

Future<Map<String, dynamic>?> finishOrder({
  required CarOrder carOrder,
}) async {
  var orders = await FirebaseFirestore.instance.collection('orders').get();
  var order = orders.docs
      .firstWhereOrNull((element) => element.data()['status'] == 'active');

  //из имеющегося заказа создаем историю
  await FirebaseFirestore.instance
      .collection('history')
      .doc(carOrder.passId)
      .collection('history')
      .doc(carOrder.id)
      .set(carOrder.toJson());

  try {
    print('save as driver');
    await FirebaseFirestore.instance
        .collection('history')
        .doc(carOrder.driverId)
        .collection('history')
        .doc(carOrder.id)
        .set(carOrder.toJson());
    print('save as driver');
  } catch (e) {
    print(carOrder.driverId);
  }
  //удаляем документ.
  await FirebaseFirestore.instance
      .collection('orders')
      .doc(carOrder.id)
      .delete();

  return order?.data();
}

Future<Map<String, dynamic>?> getActiveOrderById(String id) async {
  var orders = await FirebaseFirestore.instance.collection('orders').get();
  var order = orders.docs
      .firstWhereOrNull((element) => element.data()['status'] == 'active');

  if (order != null && order.id == id) {
    return order.data();
  }
  return null;
}

Future<Map<String, dynamic>?> getActiveOrderByPassId(String passId) async {
  try {
    var orders = await FirebaseFirestore.instance.collection('orders').get();
    var order = orders.docs
        .firstWhereOrNull((element) => element.data()['status'] == 'active');

    if (order != null && order['passId'] == passId) {
      return order.data();
    }
  } catch (e) {}
  return null;
}

Future<Map<String, dynamic>?> getWaingOrderByPassId(String passId) async {
  try {
    var orders = await FirebaseFirestore.instance.collection('orders').get();
    var order = orders.docs
        .firstWhereOrNull((element) => element.data()['status'] == 'waiting');

    if (order != null && order['passId'] == passId) {
      return order.data();
    }
  } catch (e) {}
  return null;
}

Future<Map<String, dynamic>?> getOrderByOrderId(String id) async {
  try {
    var order =
        await FirebaseFirestore.instance.collection('orders').doc(id).get();
    return order.data();
  } catch (e) {}
  return null;
}

Future<Map<String, dynamic>?> checkOrdersBeforePlane(CarOrder order) async {
  try {
    var orders = await FirebaseFirestore.instance.collection('orders').get();
    int startTime = order.startDate!.millisecondsSinceEpoch;
    int endTime = order.endDate!.millisecondsSinceEpoch;

    var otherOrder = orders.docs.firstWhereOrNull((element) {
      var tmpOrder = CarOrder.fromJson(element.data());
      int orderEndDate = tmpOrder.endDate!.millisecondsSinceEpoch;
      int orderStartDate = tmpOrder.startDate!.millisecondsSinceEpoch;
      // print('$startTime < ${element['startDate']}');
      // print('$startTime < ${element['startDate']}');
      return !((startTime < orderStartDate && endTime < orderStartDate) ||
          (startTime > orderEndDate && endTime > orderEndDate));
    });
    return otherOrder?.data();
  } catch (e) {
    return null;
  }
}

Future<void> deleteOrderById(String id) async {

  print(id);
  await FirebaseFirestore.instance.collection('orders').doc(id).delete();

  return;
}

Future<void> startOrderById(String id, BuildContext context) async {
  print(id);
  var order =
      await FirebaseFirestore.instance.collection('orders').doc(id).get();
  var json = order.data();
  json!['status'] = 'waiting';
  json!['driverId'] = context.read<UserCubit>().getUser()!.id;
  json!['driverName'] = context.read<UserCubit>().getUser()!.fname +
      ' ' +
      context.read<UserCubit>().getUser()!.lname;

  var tmpOrder = CarOrder.fromJson(json);
  await FirebaseFirestore.instance.collection('orders').doc(id).set(json);

  return;
}
