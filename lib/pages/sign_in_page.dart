import 'package:cars/widgets/sign_in/confirm_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/role.dart';
import '../models/user.dart';
import '../widgets/maps/models/location_service.dart';
import '../widgets/sign_in/pass_driver_tab.dart';
import '../widgets/sign_in/sign_in_form.dart';

class SignInPage extends StatefulWidget {
  SignInPage({
    super.key,
    required this.isSignIn,
    this.phone = '',
    this.role = Role.pass,
  });
  bool isSignIn;
  String phone;
  Role role;
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    () async {
      print('->');
      var docs = await FirebaseFirestore.instance.collection('phonebook').get();
      docs.docs.forEach((doc) {
        print(doc.data());
      });
    }();
    LocationService().requestPermission();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 350),
            child: Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    SvgPicture.asset(
                      'asstes/logo.svg',
                      width: 100,
                    ),
                    const SizedBox(height: 20),
                    if (widget.isSignIn)
                      Container(
                        alignment: Alignment.center,
                        child: PassDriverTab(
                          role: widget.role,
                          change: (Role value) => setState(() {
                            widget.role = value;
                          }),
                        ),
                      ),
                    const SizedBox(height: 20),
                    widget.isSignIn
                        ? SignInForm(role: widget.role)
                        : ConfirmForm(role: widget.role, phone: widget.phone),
                    const SizedBox(height: 80),
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
