
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';

import '../../bloc/route_from_to/route_from_to.dart';
import '../../pages/driver_home_page.dart';
import '../../res/notification_services.dart';
import '../../res/odder_functions.dart';
import '../../res/styles.dart';
import '../buttons/button2.dart';
import 'forms/pass_plan_form.dart';

class PassBottomActive extends StatefulWidget {
  const PassBottomActive({super.key});

  @override
  State<PassBottomActive> createState() => _PassBottomActiveState();
}

class _PassBottomActiveState extends State<PassBottomActive> {
  bool isWaiting = false;
  @override
  Widget build(BuildContext context) {
    return Container(
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
              SizedBox(height: 90),
              InkWell(
                onTap: () async {
                  context.read<CarOrderBloc>().add(CarOrderEvent.planAnother());

                },
                child: Button2(
                  title: 'Запланировать новую поездку',
                ),
              ),
              SizedBox(height: 40),
              InkWell(
                onTap: () async {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      titleTextStyle: h14w500Black,
                      contentTextStyle: h12w400BlackWithOpacity,
                      title: const Text('Отмена поездки'),
                      content: const Text('Отменить текущую поездку?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Отмена'),
                          child: const Text('Назад'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Начать выполнение
                            Navigator.pop(context, 'OK');
                            setState(() {
                              isWaiting = true;
                            });
                            context.read<CarOrderBloc>().currentOrder.comment = 'Отменено пассажиром';
                            var driverid = context.read<CarOrderBloc>().currentOrder.driverId;

                            // Завершаем заказ
                            await finishOrder(
                              carOrder: context.read<CarOrderBloc>().currentOrder,
                            );

                            // Отправляем уведомление водителю после завершения заказа
                            await sendNotificationToDriverCancel(driverId: driverid);

                            // Останавливаем обработку заказа и переходим на домашнюю страницу пассажира
                            context.read<CarOrderBloc>().add(CarOrderEvent.stop());
                            Get.offAll(() => PassHomePage());
                          },
                          child: const Text('Да, Отменить'),
                        ),
                      ],
                    ),
                  );
                },
                child: isWaiting
                    ? Button2(
                        title: 'Отменить текущую поездку',
                        isWaiting: isWaiting,
                      )
                    : Button1(
                        title: 'Отменить текущую поездку',
                      ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
