import 'package:cars/widgets/dialogs/change_route_dialog/change_route_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../res/styles.dart';
import '../../buttons/button2.dart';
import '../../buttons/button3.dart';
import '../../other/my_divider.dart';

void changeRouteDialog(Function cancel, BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      height: 390,
      padding: const EdgeInsets.only(top: 20.0),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Text('Маршрут', style: h17w500Black),
              SizedBox(height: 15),
              MyDivider(),
              ChangeRouteForm(),
            ],
          ),
        ),
      ),
    ),
  );
}
