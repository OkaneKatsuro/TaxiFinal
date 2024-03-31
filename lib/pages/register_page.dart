import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/role.dart';
import 'package:cars/models/user.dart';
import 'package:cars/pages/driver_home_page.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/res/firebase_utils.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/buttons/button2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({
    super.key,
    required this.userNameData,
    required this.phone,
    required this.role,
  });
  List<String> userNameData;
  String phone;
  Role role;
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fName = TextEditingController();
  final _lName = TextEditingController();
  final _sName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var validator = (value) =>
      value != null && value.isNotEmpty ? null : 'Поле не должно быть пустым';

  @override
  void initState() {
    // TODO: implement initState
    _fName.text = widget.userNameData[0];
    _lName.text = widget.userNameData[1];
    _sName.text = widget.userNameData[2];
    print(widget.userNameData);
    super.initState();
  }

  bool isWait = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text('Регистрация', style: h24w500Black),
                    const SizedBox(height: 45),
                    TextFormField(
                      enabled: !isWait,
                      keyboardType: TextInputType.name,
                      validator: validator,
                      controller: _lName,
                      cursorColor: blue,
                      decoration: InputDecoration(
                        label: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Фамилия:'),
                            Text(
                              '*',
                              style: TextStyle(color: blue, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                    TextFormField(
                      enabled: !isWait,
                      keyboardType: TextInputType.name,
                      validator: validator,
                      controller: _fName,
                      decoration: InputDecoration(
                        label: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Имя:'),
                            Text(
                              '*',
                              style: TextStyle(color: blue, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                    TextFormField(
                      enabled: !isWait,
                      keyboardType: TextInputType.name,
                      controller: _sName,
                      decoration: const InputDecoration(
                        label: Text('Отчество'),
                      ),
                    ),
                    // const Expanded(child: SizedBox()),
                    const SizedBox(height: 45),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          isWait = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          print('ok');
                          var uid = FirebaseAuth.instance.currentUser!.uid;
                          String jsonStr = '';
                          try {
                            var doc = await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .get();
                            jsonStr = await doc.data()!['addr_json'] as String;
                          } catch (e) {
                            print(e);
                          }
                          try {
                            await saveUserToFireBase(
                              uid: uid,
                              fname: _fName.text,
                              lname: _lName.text,
                              sname: _sName.text,
                              phone: widget.phone,
                              ispass: widget.role == Role.pass,
                              addrJson: jsonStr,
                            );
                            var user = await CarUser.loadFromFirebase();
                            context.read<UserCubit>().set(user);

                            Future.delayed(Duration.zero, () {
                              print(widget.role);
                              widget.role == Role.driver
                                  ? Get.to(() => DriverHomePage())
                                  : Get.to(() => PassHomePage());
                            });
                          } catch (e) {}
                          setState(() {
                            isWait = false;
                          });
                        }
                      },
                      child: isWait
                          ? Center(child: CircularProgressIndicator())
                          : Button2(title: 'Войти'),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
