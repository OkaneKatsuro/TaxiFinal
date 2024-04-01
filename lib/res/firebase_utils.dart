import 'dart:convert';

import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/car_order.dart';
import '../models/message.dart';
import '../models/role.dart';

Future<bool> checkPhone({required String phoneStr, required Role role}) async {
  String phone = phoneStr.replaceAll(RegExp(r'[() ]'), '');

  var found = false;
  var docs = await FirebaseFirestore.instance.collection('phonebook').get();
  docs.docs.forEach((doc) {
    if (doc.data()['phone'] == phone &&
        (doc.data()['is_pass'] == (role == Role.pass) ||
            !doc.data()['is_pass'] == !(role == Role.pass))) {
      found = true;
      print(' found');
    } else {
      print('not found');
    }
  });
  return found;
}

Future<List<String>> getUserNameData(
    {required String phoneStr, required Role role}) async {
  String phone = phoneStr.replaceAll(RegExp(r'[() ]'), '');

  var docs = await FirebaseFirestore.instance.collection('phonebook').get();
  List<String> list = ['', '', ''];

  docs.docs.forEach(
    (doc) {
      if (doc.data()['phone'] == phone &&
          (doc.data()['is_pass'] == (role == Role.pass) ||
              !doc.data()['is_pass'] == !(role == Role.driver))) {
        var el = doc.data();
        if (el.containsKey('f_name')) list[0] = el['f_name'];
        if (el.containsKey('l_name')) list[1] = el['l_name'];
        if (el.containsKey('s_name')) list[2] = el['s_name'];
      }
    },
  );
  print(list);
  return list;
}

Future<void> saveUserToFireBase({
  required String uid,
  required String fname,
  required String lname,
  required String sname,
  required String phone,
  required bool ispass,
  String addrJson = '',
}) async {
  var docs = await FirebaseFirestore.instance.collection('users');
  String phone1 = phone.replaceAll(RegExp(r'[() ]'), '');
  var check = await docs.doc(uid).get();
  if (check.exists) {
    print('update');
    await docs.doc(uid).update({
      'f_name': fname,
      'l_name': lname,
      's_name': sname,
      'phone': phone1,
      'is_pass': ispass,
      'addr_json': addrJson,
    });
    var check = await docs.doc(uid).get();
    print('after update');
    print(check['addr_json']);
  } else {
    print('set');
    await docs.doc(uid).set({
      'f_name': fname,
      'l_name': lname,
      's_name': sname,
      'phone': phone1,
      'is_pass': ispass,
    });
  }
  return;
}

Future<String> loadAddrListFromFireBase({required String uid}) async {
  var docs = await FirebaseFirestore.instance.collection('users');
  var doc = await docs.doc(uid).get();
  var json = doc.data()!['addr_json'];
  return json;
}

Future<String> getCarStatus() async {
  try {
    var orders = await FirebaseFirestore.instance.collection('orders').get();
    var order = orders.docs
        .firstWhereOrNull((element) => element['status'] == 'active')
        ?.data();
    if (order != null) {
      var carOrder = CarOrder.fromJson(order);
      return 'Машина занята\n до ${DateFormat('hh:mm, dd MMM').format(carOrder.endDate!)} (${carOrder.passName})';
    }
  } catch (e) {}
  return 'Машина свободна';
}

Future<List<CarOrder>?> getHistory(BuildContext context) async {
  try {
    var orders = await FirebaseFirestore.instance
        .collection('history')
        .doc(context.read<UserCubit>().getUser()!.id)
        .collection('history')
        .orderBy('id', descending: false)
        .limit(100)
        .get();

    List<CarOrder> list = [];

    orders.docs.reversed
        .forEach((element) => list.add(CarOrder.fromJson(element.data())));

    return list;
  } catch (e) {}
  return null;
}

Future<List<CarOrder>?> getPlanList(BuildContext context) async {
  try {
    var orders = await FirebaseFirestore.instance.collection('orders').get();

    List<CarOrder> list = [];
    var id = context.read<UserCubit>().getUser()!.id;
    var role = context.read<UserCubit>().getUser()!.role;
    if (role == Role.driver) {
      orders.docs.forEach((element) {
        var data = element.data();
        if (data['status'] != 'active') {
          list.add(CarOrder.fromJson(data));
        }
      });
    } else {
      orders.docs.forEach((element) {
        var data = element.data();
        if (data['passId'] == id && data['status'] != 'active') {
          list.add(CarOrder.fromJson(data));
        }
      });
    }

    return list;
  } catch (e) {}
  return null;
}

Future<Map<String, String>> getCallMap(BuildContext context) async {
  try {
    var role = context.read<UserCubit>().getUser()!.role;
    var users = await FirebaseFirestore.instance.collection('users').get();

    Map<String, String> map = {};

    if (role == Role.driver) {
      users.docs.forEach((element) {
        var data = element.data();
        if (data['is_pass'] == true) {
          map.addAll({'${data['f_name']} ${data['l_name']}': data['phone']});
        }
      });
      return map;
    } else {
      users.docs.forEach((element) {
        var data = element.data();
        if (data['is_pass'] == false) {
          map.addAll({'${data['f_name']} ${data['l_name']}': data['phone']});
        }
      });
      return map;
    }
  } catch (e) {}
  return {};
}

Future<Map<String, String>?> getUserList(Role role) async {
  try {
    var users = await FirebaseFirestore.instance.collection('users').get();
    Map<String, String> map = {};
    users.docs.forEach((element) {
      var data = element.data();
      if (role == Role.driver) {
        if (data['is_pass'] == true) {
          map.addAll({'${element.id}': '${data['f_name']} ${data['l_name']}'});
        }
      } else {
        if (data['is_pass'] == false) {
          map.addAll({'${element.id}': '${data['f_name']} ${data['l_name']}'});
        }
      }
    });
    return map;
  } catch (e) {}
  return null;
}

Future<bool> sendMessage({
  required String passId,
  required String driverId,
  required Message message,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc('$passId-$driverId')
        .collection('messages')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      DateTime.now().millisecondsSinceEpoch.toString(): message.toJson()
    });
    return true;
  } catch (e) {}
  return false;
}

Future<List<Message>?> getMessages({
  required String passId,
  required String driverId,
}) async {
  try {
    List<Message> list = [];
    var ts = await FirebaseFirestore.instance
        .collection('chats')
        .doc('$passId-$driverId')
        .collection('messages')
        .snapshots();
    ts.forEach((element) {
      var li = element.docs.toList().sublist(element.docs.toList().length - 5);
      li.forEach((element1) {
        print(element1.data());
        list.add(Message.fromJson(element1.data().values.first));
      });
    });

    // var mess = await FirebaseFirestore.instance
    //     .collection('chats')
    //     .doc('$passId-$driverId')
    //     .collection('messages')
    //     .limit(10)
    //     .get();
    // mess.docs.forEach((element) {
    //   print(element.data().values.first['message']);
    //   list.add(Message.fromJson(element.data().values.first));
    // });

    print(list);
    return list;
  } catch (e) {}
  return null;
}

Future<Message?> getLastMessage({
  required String docId,
}) async {
  print('--->');
  try {
    var ts = await FirebaseFirestore.instance
        .collection('chats')
        .doc(docId)
        .collection('messages')
        .snapshots();
    Message? m;

    return await ts.first.then((value) {
      print(value.docs.last.data().values.first);
      return Message.fromJson(value.docs.last.data().values.first);
    });
  } catch (e) {
    print(e);
  }
  return null;
}
