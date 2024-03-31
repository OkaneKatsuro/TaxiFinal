import 'dart:convert';

import 'package:cars/models/place.dart';
import 'package:cars/models/role.dart';
import 'package:cars/models/user.dart';
import 'package:cars/res/firebase_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class UserCubit extends HydratedCubit<CarUser?> {
  UserCubit() : super(null) {
    hydrate();
  }
  void set(CarUser? user) {
    emit(user);
    hydrate();
  }

  CarUser? get() => state;

  bool addAddress({required String name, required Place place}) {
    if (state!.addressList == null) {
      state!.addressList = [
        {name: place}
      ];
      emit(state);
      hydrate();
      return true;
    } else {
      var foundEl = state?.addressList!
          .firstWhereOrNull((element) => element.keys.first == name);
      if (foundEl == null) {
        state?.addressList!.add({name: place});
        emit(state);
        hydrate();
        return true;
      }
      emit(state);
      hydrate();
      return false;
    }
  }

  bool updateAddress({
    required String name,
    required Place place,
    required Map<String, Place> oldAddress,
  }) {
    // oldAddress = {name: place};
    var foundIndex =
        state?.addressList!.indexWhere((element) => element.keys.first == name);
    if (foundIndex == -1 ||
        state!.addressList![foundIndex!].keys.first == oldAddress.keys.first) {
      List<Map<String, Place>> tmp = [];
      state!.addressList!.forEach((e) {
        if (e.keys.first != oldAddress.keys.first) {
          tmp.add(e);
        } else {
          tmp.add({name: place});
        }
      });
      state!.addressList!.clear();
      state!.addressList!.addAll(tmp);
      emit(state);
      hydrate();
      return true;
    }
    emit(state);
    hydrate();
    return false;
  }

  deleteAddress({required Map<String, Place> address}) {
    var el = state!.addressList!
        .firstWhere((element) => element.keys.first == address.keys.first);
    state!.addressList!.remove(el);
    emit(state);
    hydrate();
  }

  @override
  CarUser? fromJson(Map<String, dynamic> json) {
    Role role = json['role'] == 'pass' ? Role.pass : Role.driver;
    String id = json['id'];
    String name = json['name'];
    String phone = json['phone'];
    List<Map<String, Place>> list = [];
    try {
      String addressList = json['addressList'];

      Map<String, dynamic> jsonAddr = jsonDecode(addressList);
      jsonAddr.forEach((key, value) {
        list.add({key: Place.fromJson(value)});
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    var user = CarUser(
      role: role,
      id: id,
      name: name,
      phone: phone,
      addressList: list,
      fname: json['f_name'],
      lname: json['l_name'],
      sname: json['s_name'],
    );
    return user;
  }

  @override
  Map<String, String> toJson(CarUser? state) {
    if (state != null) {
      String jsonStr = '';
      try {
        state.addressList!.forEach((element) {
          var sub = '"${element.keys.first}":${element.values.first.toJson()}';
          if (jsonStr == '') {
            jsonStr = sub;
          } else {
            jsonStr = jsonStr + ',' + sub;
          }
        });
        jsonStr = '{$jsonStr}';
      } catch (e) {
        print(e);
      }
      //firebase
      saveUserToFireBase(
        uid: state.id,
        fname: state.fname,
        lname: state.lname,
        sname: state.sname,
        phone: state.phone,
        ispass: state.role == Role.pass,
        addrJson: jsonStr,
      );

      return {
        'role': state!.role.name,
        'id': state.id,
        'name': state.name,
        'f_name': state.fname,
        'l_name': state.lname,
        's_name': state.sname,
        'phone': state.phone,
        'addressList': state.addressList != null ? jsonStr : '{}'
      };
    } else {
      return {};
    }
  }
}
