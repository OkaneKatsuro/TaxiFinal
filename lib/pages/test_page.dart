import 'package:cars/res/styles.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:flutter/material.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: Center(
          child: Container(
            height: 360,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        '          Отложить выполнение заказа',
                        style: h13w400Black,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.close,
                        size: 15,
                      ),
                    ),
                  ],
                ),
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
                Container(
                  width: 170,
                  child: Button1(title: 'Готово'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
