import 'dart:convert';

import 'package:cars/models/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'car_order.dart';
import 'role.dart';

class CarUser {
  Role role;
  String id;
  String name;
  String fname;
  String lname;
  String sname;
  String phone;
  String oneId;
  List<Map<String, Place>>? addressList;
  List<CarOrder>? orders;

  CarUser({
    required this.oneId,
    required this.role,
    required this.id,
    required this.name,
    required this.fname,
    required this.lname,
    required this.sname,
    required this.phone,
    this.addressList,
  });
  //сериализация и десериализация

  //из фаербейз
  //loadFromFirebase

  static Future<CarUser?> loadFromFirebase() async {
    var uid = await FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid != '') {
      var docs = await FirebaseFirestore.instance.collection('users');
      var data = await docs.doc(uid).get();
      var id = uid;
      var oneId = data['oneId'];
      var name = data['f_name'] + ' ' + data['l_name'];
      var phone = data['phone'];
      var role = data['is_pass'] == true ? Role.pass : Role.driver;

      List<Map<String, Place>> list = [];
      try {
        String addressList = data['addr_json'];

        Map<String, dynamic> jsonAddr = jsonDecode(addressList);
        jsonAddr.forEach((key, value) {
          list.add({key: Place.fromJson(value)});
        });
      } catch (e) {
        print(e);
      }

      return CarUser(
          oneId: oneId,
          role: role,
          id: id,
          name: name,
          phone: phone,
          fname: data['f_name'],
          lname: data['l_name'],
          sname: data['s_name'],
          addressList: list);
    } else {
      print('not authorized');
      return null;
    }
  }
  //saveToFirebase
}
