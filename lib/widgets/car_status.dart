import 'dart:async';

import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/models/car.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/maps/models/app_lat_long.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/route_from_to/route_from_to.dart';
import 'package:cars/models/car_order.dart';

import 'maps/res/functions.dart';

class CarStatus extends StatefulWidget {
  CarStatus({
    super.key,
  });

  @override
  State<CarStatus> createState() => _CarStatusState();
}

class _CarStatusState extends State<CarStatus> with WidgetsBindingObserver {
  String? ariveTime;
  Timer? timer;
  AppLatLong oldPos = AppLatLong(lat: car.lat, long: car.long);
  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 30), (timer) {
      () async {
        if (!(oldPos.lat == car.lat && oldPos.long == car.long)) {
          print('new route');
          try {
            var tmp = await getRouteToPass(context);
            setState(() {
              ariveTime = tmp;
              oldPos.lat = car.lat;
              oldPos.long = car.long;
            });
          } catch (e) {
            print(e);
          }
        }
      }();
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    () async {
      setState(() {
        ariveTime = null;
      });
      await Future.delayed(Duration(seconds: 5));
      try {
        var tmp = await getRouteToPass(context);
        setState(() {
          ariveTime = tmp;
        });
      } catch (e) {
        print(e);
      }
    }();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('this');
    () async {
      setState(() {
        ariveTime = null;
      });
      await Future.delayed(Duration(seconds: 5));
      try {
        var tmp = await getRouteToPass(context);
        setState(() {
          ariveTime = tmp;
        });
      } catch (e) {
        print(e);
      }
    }();
  }

  @override
  void didUpdateWidget(covariant CarStatus oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // () async {
    //   await Future.delayed(Duration(seconds: 5));
    //   try {
    //     var tmp = await getRouteToPass(context);
    //     setState(() {
    //       ariveTime = tmp;
    //     });
    //   } catch (e) {
    //     print(e);
    //   }
    // }();
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          context.watch<CarOrderBloc>().currentOrder.status ==
                  CarOrderStatus.active
              ? 'Идет выполнение вашего заказа'
              : context.read<CarOrderBloc>().carStatusStr,
          style: h17w500Black.copyWith(
              color: context.watch<CarOrderBloc>().currentOrder.status ==
                          CarOrderStatus.active ||
                      context.watch<CarOrderBloc>().carStatusStr !=
                          'Машина свободна'
                  ? null
                  : const Color.fromARGB(255, 25, 157, 30)),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2),
        if (context.watch<CarOrderBloc>().carStatusStr == 'Машина свободна')
          Text(
            context.watch<CarOrderBloc>().currentOrder.status ==
                        CarOrderStatus.waiting ||
                    context.watch<CarOrderBloc>().currentOrder.status ==
                            CarOrderStatus.empty &&
                        ariveTime != null
                ? 'время ожидания: $ariveTime'
                : '',
            style: h14w500Black.copyWith(
                color: context.read<CarOrderBloc>().currentOrder.status ==
                        CarOrderStatus.active
                    ? null
                    : const Color.fromARGB(255, 25, 157, 30)),
          ),
      ],
    );
  }
}
