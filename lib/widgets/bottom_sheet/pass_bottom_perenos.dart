import 'package:cars/models/car_order.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../bloc/car_order_bloc/car_order_bloc.dart';
import '../../bloc/route_from_to/route_from_to.dart';
import 'forms/pass_plan_form.dart';
import 'pass_bottom_planed.dart';

class PassBottomPerenos extends StatefulWidget {
  const PassBottomPerenos({super.key});

  @override
  State<PassBottomPerenos> createState() => _PassBottomPerenosState();
}

class _PassBottomPerenosState extends State<PassBottomPerenos> {
  @override
  void initState() {
    super.initState();
    //осуществит проверку брони и выдать соответсвующий статус

    // Future.delayed(Duration(seconds: 4), () {
    //   //чистим заказ и в главную форму
    //   context
    //       .read<RouteFromToCubit>()
    //       .set(CarOrder(status: CarOrderStatus.waiting));
    //   context.read<CarOrderBloc>().add(CarOrderEvent.routeLoading());
    //   Future.delayed(
    //       Duration(seconds: 0), () => Get.offAll(() => PassHomePage()));
    // });
  }

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
            child: Column(children: [
              SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: whiteGrey2,
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.calendar_today_outlined,
                      color: whiteGrey2,
                      size: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Водитель отложил ваш заказ', style: h17w500Black),
              Text('машина прибудет в указанное время', style: h14w500Black),
              SizedBox(height: 20),
              Text(
                  DateFormat('hh:mm, dd MMM').format(
                      context.read<CarOrderBloc>().currentOrder.startDate!),
                  style: h17w500Black.copyWith(
                    fontSize: 25,
                  )),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: () {
                    context.read<CarOrderBloc>().currentOrder =
                        CarOrder(status: CarOrderStatus.empty);
                    context.read<CarOrderBloc>().add(CarOrderEvent.stop());
                    Future.delayed(Duration(seconds: 0),
                        () => Get.offAll(() => PassHomePage()));
                  },
                  child: Button1(title: 'Закрыть'),
                ),
              )
            ]),
          ),
        ));
  }
}
