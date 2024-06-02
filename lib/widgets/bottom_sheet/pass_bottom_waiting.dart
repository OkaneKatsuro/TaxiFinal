import 'package:cars/models/car_order.dart';

import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/buttons/button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../bloc/car_order_bloc/car_order_bloc.dart';
import '../../bloc/route_from_to/route_from_to.dart';
import '../../res/odder_functions.dart';
import '../buttons/button1.dart';
import 'forms/pass_plan_form.dart';
import 'pass_bottom_planed.dart';

class PassBottomWaiting extends StatefulWidget {
  const PassBottomWaiting({super.key});

  @override
  State<PassBottomWaiting> createState() => _PassBottomWaitingState();
}

class _PassBottomWaitingState extends State<PassBottomWaiting> {
  bool isPlaned = false;
  bool isWaitng = false;
  @override
  Widget build(BuildContext context) {
    return !isPlaned
        ? Container(
            color: Colors.white,
            height: 362,
            width: double.infinity,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    CircularProgressIndicator(),
                    SizedBox(height: 50),
                    Text('Ожидаем подтверждение от водителя'),
                    SizedBox(height: 80),
                    InkWell(
                      onTap: () async {
                        //Начать выполненение
                        setState(() {
                          isWaitng = true;
                        });
                        context.read<CarOrderBloc>().currentOrder.comment =
                            'Отменено пассажиром';
                        await finishOrder(
                            carOrder:
                                context.read<CarOrderBloc>().currentOrder);

                        context.read<CarOrderBloc>().add(CarOrderEvent.stop());
                        Get.offAll(() => PassHomePage());
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: isWaitng
                            ? Button2(
                                title: 'Отменить',
                                isWaiting: isWaitng,
                              )
                            : Button1(
                                title: 'Отменить',
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container(
            color: Colors.white,
            height: 362,
            width: double.infinity,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Column(children: [
                  SizedBox(height: 60),
                  const Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.green,
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('Поездка успешно забронирована', style: h17w500Black),
                  SizedBox(height: 10),
                  Text('Поездка успешно забронирована', style: h14w500Black),
                ]),
              ),
            ));
  }
}
