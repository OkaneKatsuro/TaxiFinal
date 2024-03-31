import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../res/styles.dart';
import '../buttons/button1.dart';
import '../buttons/button2.dart';

class PlaningDialogBox extends StatelessWidget {
  const PlaningDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 50,
                      child: WheelChooser(
                          isInfinite: true,
                          onValueChanged: (s) => print(s),
                          datas: List.generate(24, (index) => index)),
                    ),
                    Text(
                      '  :  ',
                      style: TextStyle(fontSize: 24),
                    ),
                    Container(
                      height: 200,
                      width: 50,
                      child: WheelChooser(
                          isInfinite: true,
                          onValueChanged: (s) => print(s),
                          datas: List.generate(59, (index) => index)),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1,
                          width: 50,
                          color: grey,
                        ),
                        SizedBox(width: 30),
                        Container(
                          height: 1,
                          width: 50,
                          color: grey,
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1,
                          width: 50,
                          color: grey,
                        ),
                        SizedBox(width: 30),
                        Container(
                          height: 1,
                          width: 50,
                          color: grey,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Future<void> showPlainDialog(context) async {
  return showDialog<void>(
    useRootNavigator: true,

    useSafeArea: false,
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        titlePadding: EdgeInsets.all(0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '              Отложить выполнение заказа  ',
              style: h14w500Black,
            ),
            const Expanded(child: SizedBox()),
            IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              icon: const Icon(
                Icons.close,
                size: 18,
              ),
            ),
          ],
        ),
        content: const SingleChildScrollView(
          child: PlaningDialogBox(),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Center(
              child: Container(
                alignment: Alignment.center,
                width: 170,
                child: Button2(title: 'Готово'),
              ),
            ),
          )
        ],
      );
    },
  );
}
