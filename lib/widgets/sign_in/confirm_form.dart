import 'dart:async';

import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/user.dart';
import 'package:cars/pages/register_page.dart';
import 'package:cars/pages/sign_in_page.dart';
import 'package:cars/res/firebase_utils.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/buttons/button2.dart';
import 'package:cars/widgets/sign_in/sign_in_form.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../models/role.dart';
import '../buttons/button1.dart';

class ConfirmForm extends StatefulWidget {
  ConfirmForm({
    super.key,
    required this.role,
    required this.phone,
  });
  Role role;
  String phone;
  @override
  State<ConfirmForm> createState() => _ConfirmFormState();
}

class _ConfirmFormState extends State<ConfirmForm> {
  var phoneController = TextEditingController(text: '');
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), ((timer) {
      setState(() {
        i++;
      });
    }));
    () async {
      await auth.verifyPhoneNumber(
        phoneNumber: widget.phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          if (kDebugMode) {
            print('verificationCompleted');
          }
          await auth.signInWithCredential(credential);
          if (kDebugMode) {
            print('Auth complete');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e);
        },
        codeSent: (String verificationId, int? resendToken) async {
          // if (kDebugMode) {
          //   print('codeSent');
          // }
          setState(() {
            verifId = verificationId;
          });
          String smsCode = '111111';
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);

          await auth.signInWithCredential(credential);

          if (auth.currentUser == null) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Пользователь с таким телефоном не найден'),
            ));
          } else {
            phoneController.text = '111111';
            setState(() {
              phoneController.text = '111111';
            });
            await Future.delayed(Duration(seconds: 1));
            // Future.delayed(Duration.zero, () => Get.to(RegisterPage()));

            print('Auth complete');
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 120),
      );
    }();
    super.initState();
  }

  String verifId = '';
  int i = 1;
  final key = GlobalKey<FormState>();
  bool isWaiting = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Введите код из смс, отправленный \nна номер ${widget.phone}',
            style: h15w500Black,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                alignment: Alignment.center,
                child: Form(
                  key: key,
                  child: TextFormField(
                    enabled: !isWaiting,
                    validator: (value) {
                      if (auth.currentUser == null) {
                        return 'Неверный код';
                      }
                      return null;
                    },
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    cursorColor: blue,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: blue,
                          width: 1.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 194, 37, 26),
                          width: 1.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 194, 37, 26),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          if (120 - i > 0)
            Text(
              'Отправить код повторно можно через ${120 - i}',
              style: h13w400Black,
            ),
          const SizedBox(height: 40),
          InkWell(
            onTap: () async {
              setState(() {
                isWaiting = true;
              });
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verifId, smsCode: phoneController.text);
              try {
                await auth.signOut();
                await auth.signInWithCredential(credential);
              } catch (e) {}

              if (auth.currentUser == null) {
                // ignore: use_build_context_synchronously
                key.currentState!.validate();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Неверный проверочный код'),
                ));
                setState(() {
                  isWaiting = false;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Успешный вход'),
                ));
                var data = await getUserNameData(
                    phoneStr: widget.phone, role: widget.role);
                Future.delayed(
                    Duration.zero,
                    () => Get.to(RegisterPage(
                          userNameData: data,
                          phone: widget.phone,
                          role: widget.role,
                        )));
              }
            },
            child: 120 - i > 0
                ? isWaiting
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Button2(title: 'Подтвердить')
                : Button1(title: 'Подтвердить'),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: 120 - i > 0
                ? () {
                    print(i);
                  }
                : () async {
                    Get.offAll(() => SignInPage(isSignIn: true));
                  },
            child: 120 - i > 0
                ? Button1(title: 'Отправить повторно')
                : Button2(title: 'Отправить повторно'),
          ),
        ],
      ),
    );
  }
}
