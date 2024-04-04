import 'dart:async';

import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/models/car.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/other/my_divider.dart';
import 'package:flutter/cupertino.dart';
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
    carStatUpdate();
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

        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Image.asset(
                  'asstes/camry.png', // Path to your image asset
                  scale: 4,
                ),
                Divider(),
                SizedBox(height: 27), // Adjust as needed
                 GridView.count(
                   shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                   childAspectRatio: 150 / 90,
                    children: [
                      _buildGridItem(
                        'Зажигание',
                        Icons.whatshot,
                        car1.zajiganie,
                      ),
                      _buildGridItem(
                        'Пробег',
                        Icons.speed,
                        car1.probeg,
                      ),
                      _buildGridItem(
                        'Температура в салоне',
                        Icons.thermostat,
                        car1.temp,
                      ),
                      _buildGridItem(
                        'Уровень топлива',
                        Icons.local_gas_station,
                        car1.toplevo,
                      ),
                      _buildGridItem(
                        'Моточасы',
                        Icons.timer_sharp,
                        car1.moto,
                      ),
                      _buildGridItem(
                        'Время стоянки',
                        Icons.timer_sharp,
                        car1.parkTime,
                      ),
                    ],
                  ),

              ],
            ),
          ),
        ),

          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String title, IconData iconData, String value) {
    return  Container(
        width: 150,
        height: 90,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 209, 209, 209).withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: h14w400Black,
              textAlign: TextAlign.center,
            ),
            //Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  color: blue,
                  size: 20,
                ),
                SizedBox(width: 5),
                Text(
                  value,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      );

  }




}
