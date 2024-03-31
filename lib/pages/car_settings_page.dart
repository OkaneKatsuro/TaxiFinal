import 'dart:async';

import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/models/car.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../res/styles.dart';

class CarSettingsPage extends StatefulWidget {
  CarSettingsPage({
    super.key,
  });

  @override
  State<CarSettingsPage> createState() => _CarSettingsPageState();
}

class _CarSettingsPageState extends State<CarSettingsPage> {
  var comment = TextEditingController();

  @override
  void initState() {
    comment = TextEditingController(
        text: context.read<RouteFromToCubit>().get().comment ?? '');
    super.initState();
    timer = Timer(Duration(seconds: 2), () {
      setState(() {
        car1 = car;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Timer? timer;
  var car1 = car;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              //color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                    'Состояние машины',
                    style: h17w500Black,
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            SizedBox(height: 15),
            MyDivider(),
            // SizedBox(height: 10),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'asstes/camry.png',
                        scale: 4,
                      ),
                      // Text(
                      //   'Toyota camry',
                      //   style: h17w400Black,
                      // ),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 40),
                      Container(
                        height: 120,
                        width: double.infinity,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 209, 209, 209)
                                        .withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: Text(
                                      'Зажигание',
                                      style: h14w400Black,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Divider(),
                                  Expanded(child: SizedBox()),
                                  Container(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'asstes/zag.png',
                                          color: blue,
                                          width: 35,
                                          scale: 10,
                                        ),
                                        Text(
                                          car1.zajiganie,
                                          style: TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 110,
                              height: 110,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 208, 207, 207)
                                        .withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: Text(
                                      'Пробег',
                                      style: h14w400Black,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Divider(),
                                  Expanded(child: SizedBox()),
                                  Container(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.speed,
                                          color: blue,
                                          size: 35,
                                        ),
                                        Text(
                                          car1.probeg,
                                          style: TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 110,
                              height: 110,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 189, 189, 189)
                                            .withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: Text(
                                      'Температура в салоне',
                                      style: h14w400Black,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Divider(),
                                  Expanded(child: SizedBox()),
                                  Container(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.thermostat,
                                          color: blue,
                                          size: 35,
                                        ),
                                        Text(
                                          car1.temp,
                                          style: TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 120,
                        width: double.infinity,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 189, 189, 189)
                                            .withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: Text(
                                      'Уровень топлива',
                                      style: h14w400Black,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Divider(),
                                  Expanded(child: SizedBox()),
                                  Container(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.local_gas_station,
                                          color: blue,
                                          size: 35,
                                        ),
                                        Text(
                                          car1.toplevo,
                                          style: TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 110,
                              height: 110,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 189, 189, 189)
                                            .withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: Text(
                                      'Моточасы',
                                      style: h14w400Black,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Divider(),
                                  Expanded(child: SizedBox()),
                                  Container(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.timer_sharp,
                                          color: blue,
                                          size: 35,
                                        ),
                                        Text(
                                          car1.moto,
                                          style: TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 110,
                              height: 110,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 189, 189, 189)
                                            .withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: Text(
                                      'Время стоянки',
                                      style: h14w400Black,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Divider(),
                                  Expanded(child: SizedBox()),
                                  Container(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.timer_sharp,
                                          color: blue,
                                          size: 35,
                                        ),
                                        Text(
                                          '',
                                          style: TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Transform.scale(
                            //   scale: 0.8,
                            //   child: Container(
                            //     width: 110,
                            //     height: 110,
                            //     padding: EdgeInsets.all(10),
                            //     //  margin: EdgeInsets.all(5),
                            //     decoration: BoxDecoration(
                            //       color: whiteGrey,
                            //       borderRadius: BorderRadius.circular(20),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.5),
                            //           spreadRadius: 2,
                            //           blurRadius: 2,
                            //           offset: Offset(
                            //               0, 3), // changes position of shadow
                            //         ),
                            //       ],
                            //     ),
                            //     child: Column(
                            //       children: [
                            //         Container(
                            //           height: 30,
                            //           child: Text(
                            //             'Давление в шинах',
                            //             style: h13w400Black,
                            //             textAlign: TextAlign.center,
                            //           ),
                            //         ),
                            //         Divider(),
                            //         Expanded(child: SizedBox()),
                            //         Container(
                            //           height: 40,
                            //           child: Row(
                            //             children: [
                            //               Image.asset(
                            //                 'asstes/wheel.png',
                            //                 color: blue,
                            //                 scale: 9,
                            //               ),
                            //               Text(
                            //                 ' 96%',
                            //                 style: TextStyle(fontSize: 25),
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
