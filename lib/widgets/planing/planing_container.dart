import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/car_order.dart';
import 'package:cars/models/place.dart';
import 'package:cars/models/role.dart';
import 'package:cars/models/route_from_to.dart';
import 'package:cars/pages/driver_home_page.dart';
import 'package:cars/pages/plan_page.dart';
import 'package:cars/res/odder_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../res/styles.dart';

class PlaningContainer extends StatefulWidget {
  PlaningContainer({
    super.key,
    required this.route,
    required this.startDate,
    required this.endDate,
    required this.name,
    this.isHistory = false,
    this.orderId,
    this.comment = '',
  });
  DateTime startDate;
  DateTime endDate;
  List<Place> route;
  String name;
  bool isHistory;
  String? orderId;
  String comment;

  @override
  State<PlaningContainer> createState() => _PlaningContainerState();
}

class _PlaningContainerState extends State<PlaningContainer> {
  bool isWaiting = false;
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    DateTime checkedTime = widget.startDate;
    DateTime currentTime = DateTime.now();
    String date = '';
    if ((currentTime.year == checkedTime.year) &&
        (currentTime.month == checkedTime.month) &&
        (currentTime.day == checkedTime.day)) {
      date = 'Сегодня  (' +
          DateFormat('hh:mm, dd MMM').format(widget.startDate) +
          ' - ' +
          DateFormat('hh:mm, dd MMM').format(widget.endDate) +
          ')';
    } else if ((currentTime.year == checkedTime.year) &&
        (currentTime.month == checkedTime.month)) {
      if ((currentTime.day - checkedTime.day) == 1) {
      } else if ((currentTime.day - checkedTime.day) == -1) {
        date = 'Завтра  (' +
            DateFormat('hh:mm, dd MMM').format(widget.startDate) +
            ' - ' +
            DateFormat('hh:mm, dd MMM').format(widget.endDate) +
            ')';
      } else {}
    }
    String routeStr = '';
    routeStr = widget.route.first.name ?? widget.route.first.description!;
    for (var i = 1; i < widget.route.length; i++) {
      routeStr += '→' + widget.route[i].name ?? widget.route[i].description!;
    }
    return InkWell(
      onTap: () {
        if (context.read<UserCubit>().getUser()!.role == Role.driver) {
          if (context.read<RouteFromToCubit>().get().status ==
              CarOrderStatus.active) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                titleTextStyle: h14w500Black,
                contentTextStyle: h12w400BlackWithOpacity,
                title: const Text('Выполнение заказа не возможно'),
                content: const Text('Сначала завершите текущую поездку'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                titleTextStyle: h14w500Black,
                contentTextStyle: h12w400BlackWithOpacity,
                title: const Text('Приступить к заказу'),
                content: const Text(
                    'Приступить к выполнению запланированного заказа?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Отмена'),
                    child: const Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await startOrderById(widget.orderId!, context);
                      //await orderConfirm(context);
                      // Get.offAll(() => DriverHomePage());
                      Navigator.pop(context, 'Да');
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Приступить'),
                  ),
                ],
              ),
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 196, 195, 195).withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding:
                  EdgeInsets.only(top: 15, left: 10, right: 15, bottom: 10),
              child: isWaiting
                  ? Container(
                      height: 100,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('        дата: ',
                                          style: h13w500Black),
                                      Text(
                                          '${date != '' ? date : '${DateFormat('hh:mm, dd MMM').format(widget.startDate)} - ${DateFormat('hh:mm, dd MMM').format(widget.endDate)}'}',
                                          style: h13w400Black),
                                    ],
                                  ),
                                ),
                                if (widget.name != '') SizedBox(height: 8),
                                if (widget.name != '')
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                            context
                                                        .read<UserCubit>()
                                                        .getUser()!
                                                        .role ==
                                                    Role.pass
                                                ? 'водитель: '
                                                : 'пассажир: ',
                                            style: h13w500Black),
                                        Text(widget.name, style: h13w400Black),
                                      ],
                                    ),
                                  ),
                                SizedBox(height: 8),
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('маршрут:  ', style: h13w500Black),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        child:
                                            Text(routeStr, style: h13w400Black),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                if (widget.comment != '')
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('комментарий:  ',
                                            style: h13w500Black),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              250,
                                          height: isOpen ? null : 20,
                                          child: Text(widget.comment,
                                              style: h13w400Black),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            if (!widget.isHistory &&
                context.read<UserCubit>().getUser()!.role == Role.pass)
              Positioned(
                  right: 10,
                  bottom: 8,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            isWaiting = true;
                          });
                          await deleteOrderById(widget.orderId!);
                          setState(() {
                            isWaiting = true;
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PlanPage()));
                        },
                        child: Icon(
                          Icons.delete,
                          color: black,
                          size: isWaiting ? 0 : 20,
                        ),
                      ),
                    ],
                  )),
            if (widget.comment != '')
              Positioned(
                  //  right: 30,
                  bottom: 0,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            isOpen = !isOpen;
                          });
                        },
                        child: isOpen
                            ? Icon(
                                Icons.arrow_drop_up_outlined,
                                color: black,
                                size: 35,
                              )
                            : Icon(
                                Icons.arrow_drop_down_outlined,
                                color: black,
                                size: 35,
                              ),
                      ),
                    ],
                  )),
          ],
        ),
      ),
    );
  }
}
