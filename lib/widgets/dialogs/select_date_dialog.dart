import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/button2.dart';
import '../buttons/button3.dart';

void selectDateDialog(Widget child, Function cancel, BuildContext context) {
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
              Container(
                color: Colors.white,
                height: 270,
                child: child,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    child: InkWell(
                      onTap: () {
                        cancel();
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Button3(title: 'Отмена'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 120,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Button2(title: 'Выбрать'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
