//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cars/bloc/app_bottom_form/app_bottom_form.dart';
import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/models/car.dart';
import 'package:cars/pages/change_route_page.dart';
import 'package:cars/pages/driver_home_page.dart';
import 'package:cars/res/odder_functions.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/buttons/button1.dart';

import 'package:cars/widgets/buttons/button2.dart';
import 'package:cars/widgets/dialogs/change_route_dialog/change_route_dialog.dart';
import 'package:cars/widgets/dialogs/planing_dialog_box.dart';

import 'package:cars/widgets/other/blue_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/car_order.dart';
import '../../../pages/comment_page.dart';
import '../../../pages/search_page.dart';

import '../../../res/notification_services.dart';
import '../../buttons/button3.dart';
import '../../dialogs/select_date_dialog.dart';
import '../../maps/order_form/address_input_filed_v2.dart';

class DriverActiveForm extends StatefulWidget {
  DriverActiveForm({super.key});

  @override
  State<DriverActiveForm> createState() => _DriverActiveFormState();
}

class _DriverActiveFormState extends State<DriverActiveForm> {
  @override
  void initState() {
    super.initState();
  }

  bool isWaiting = false;
  bool isWaiting1 = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 30),
          InkWell(
            onTap: () async {
              setState(() {
                isWaiting1 = true;
              });
              //Начать выполненение
              //rtext=47.250397%2C39.656191~47.272440%2C39.709618~47.235757%2C39.703105
              var rText =
                  '${car.lat}%2C${car.long}~${context.read<RouteFromToCubit>().get().from!.lat}%2C${context.read<RouteFromToCubit>().get().from!.long}';
              context.read<RouteFromToCubit>().get().route!.forEach((element) {
                rText = rText +
                    '~' +
                    element.lat.toString() +
                    '%2C' +
                    element.long.toString();
              });
              print('----->');
              print(
                'https://yandex.ru/maps/?ll=${car.lat}%2C${car.long}&mode=routes&rtext=${rText}&rtt=auto&z=12',
              );
              // Future.delayed(
              //     Duration(seconds: 1),
              //     () => setState(() {
              //           isWaiting1 = false;
              //         }));
              await launchUrl(
                Uri.parse(
                  'https://yandex.ru/maps/?ll=${car.lat}%2C${car.long}&mode=routes&rtext=${rText}&rtt=auto&z=12',
                ),
                mode: LaunchMode.externalNonBrowserApplication,
              );
              setState(() {
                isWaiting1 = false;
              });
            },
            child: Button2(
              title: 'Открыть навигатор',
              isWaiting: isWaiting1,
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () async {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  titleTextStyle: h14w500Black,
                  contentTextStyle: h12w400BlackWithOpacity,
                  title: const Text('Завершение поездки'),
                  content: const Text('завершить текущую поездку?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Отмена'),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          isWaiting = true;
                        });
                        Navigator.pop(context, 'OK');
                        var passId = context.read<RouteFromToCubit>().get().passId;
                        await finishOrder(
                            carOrder: context.read<RouteFromToCubit>().get());


                        Get.offAll(() => DriverHomePage());
                      },
                      child: const Text('Завершить'),
                    ),
                  ],
                ),
              );
            },
            child: Button2(
              title: 'Завершить поездку',
              isWaiting: isWaiting,
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
