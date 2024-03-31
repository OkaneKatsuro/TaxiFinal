import 'dart:async';

import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/user.dart';
import 'package:cars/pages/register_page.dart';
import 'package:cars/pages/sign_in_page.dart';
import 'package:cars/res/firebase_utils.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/buttons/button2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../models/role.dart';
import '../buttons/button1.dart';

// ignore: must_be_immutable
class SignInForm extends StatefulWidget {
  SignInForm({
    super.key,
    required this.role,
  });
  Role role;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  var phoneController = TextEditingController(text: '+7');

  final phoneMaskFormatter = MaskTextInputFormatter(mask: '+7 (###) ### ## ##');

  bool checkResult = true;
  bool isWaiting = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text('Введите свой номер телефона', style: h15w500Black),
        const SizedBox(height: 15),
        SizedBox(
          height: 44,
          child: TextFormField(
            onChanged: (value) {
              setState(() {
                checkResult = true;
              });
            },
            keyboardType: TextInputType.number,
            controller: phoneController,
            inputFormatters: [phoneMaskFormatter],
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
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          checkResult
              ? 'Мы пришлем код на указанный номер'
              : 'Номер не найден, введите другой номер',
          style: TextStyle(
              color:
                  checkResult ? null : const Color.fromARGB(255, 189, 36, 25)),
        ),
        const SizedBox(height: 60),
        InkWell(
          onTap: () async {
            setState(() {
              isWaiting = true;
            });
            //проверяем в базе номер firebase  (phonebook)
            var res = await checkPhone(
                phoneStr: phoneController.text, role: widget.role);

            checkResult = res;

            if (checkResult) {
              Get.offAll(
                SignInPage(
                  role: widget.role,
                  isSignIn: false,
                  phone: phoneController.text,
                ),
              );
            } else {
              setState(() {
                isWaiting = false;
              });
            }
          },
          child: isWaiting
              ? Center(child: CircularProgressIndicator())
              : Button2(title: 'Отправить код'),
        ),
      ],
    );
  }
}
