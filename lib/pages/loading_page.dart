import 'dart:convert';

import 'package:cars/bloc/position_bloc/position_bloc.dart';
import 'package:cars/models/user.dart';
import 'package:cars/res/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../bloc/user/user_cubit.dart';
import '../models/car.dart';
import '../models/place.dart';
import '../models/role.dart';
import 'driver_home_page.dart';
import 'pass_home_page.dart';
import 'sign_in_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  CarUser? user;
  bool authDone = false;
  @override
  Widget build(BuildContext context) {
    //SignInPage(isSignIn: true),

    Future.delayed(const Duration(seconds: 2), () async {
      //проверка авторизован ли пользователь и если то проверить ли он в базе
      //если нет то разлогинивание
      await updateCarLocation();
      context.read<PositionBloc>().add(PositionEvent.startService());
      // await Future.delayed(const Duration(seconds: 7));
      var carUser = context.read<UserCubit>().getUser();
      bool res = carUser != null
          ? await checkPhone(phoneStr: carUser.phone, role: carUser.role)
          : false;
      if (!res) {
        try {
          await context.read<UserCubit>().clear();
          await FirebaseAuth.instance.signOut();
        } catch (e) {}
        Get.off(SignInPage(isSignIn: true));
      } else {
        Get.off(() => carUser.role == Role.pass && res
            ? const PassHomePage()
            : carUser.role == Role.driver && res
                ? const DriverHomePage()
                : SignInPage(isSignIn: true));
      }
    });
    return Scaffold(
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
