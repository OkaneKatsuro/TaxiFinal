import 'package:cars/bloc/app_bottom_form/app_bottom_form.dart';
import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/pages/change_route_page.dart';
import 'package:cars/pages/driver_home_page.dart';
import 'package:cars/res/odder_functions.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/res/utils.dart';

import 'package:cars/widgets/buttons/button2.dart';
import 'package:cars/widgets/dialogs/change_route_dialog/change_route_dialog.dart';
import 'package:cars/widgets/dialogs/planed_bad.dart';
import 'package:cars/widgets/dialogs/planing_dialog_box.dart';

import 'package:cars/widgets/other/blue_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

import '../../../models/car_order.dart';
import '../../../pages/comment_page.dart';
import '../../../pages/search_page.dart';

import '../../buttons/button3.dart';
import '../../dialogs/comment_dialog.dart';
import '../../dialogs/select_date_dialog.dart';
import '../../maps/order_form/address_input_filed_v2.dart';

class DriverOrderForm extends StatefulWidget {
  DriverOrderForm({super.key});

  @override
  State<DriverOrderForm> createState() => _DriverOrderFormState();
}

class _DriverOrderFormState extends State<DriverOrderForm> {
  @override
  void initState() {
    super.initState();
  }

  String from = '';
  String to = '';
  String comment = '';
  DateTime? planDate;
  String routeLength = '';
  bool isWaiting = false;
  @override
  Widget build(BuildContext context) {
    from = context.watch<RouteFromToCubit>().get().from?.name ?? '';
    var route = context.watch<RouteFromToCubit>().get().route;
    if (route != null) {
      if (route.length == 1) {
        to = context.watch<RouteFromToCubit>().get().route?.last.name ?? '';
      } else if (route.length > 1) {
        to =
            '(остановок: ${context.watch<RouteFromToCubit>().get().route!.length - 1}) → ${context.watch<RouteFromToCubit>().get().route!.last.name}';
      }
    }
    context.watch<CarOrderBloc>().state.when(
        done: () {},
        loading: () {
          var len = context.read<RouteFromToCubit>().get().lengthSec;
          if (len != null &&
              (context.read<RouteFromToCubit>().get().route != null &&
                  context.read<RouteFromToCubit>().get().route!.isNotEmpty)) {
            format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

            final d1 = Duration(seconds: len);

            routeLength = 'Время поездки: ' + format(d1);
            context.read<RouteFromToCubit>().setLenth(len);
            (context.read<RouteFromToCubit>().get().startDate);
          } else {
            routeLength = '';
            context.read<RouteFromToCubit>().setLenth(null);
          }
        },
        error: () {},
        active: () {},
        confirmed: () {},
        waitingForConfirmation: () {},
        perenos: () {},
        finishedOrCanceled: () {},
        planAnother: () {});

    comment = context.read<RouteFromToCubit>().get().comment ?? '';

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white,
      child: Column(
        children: [
          if (routeLength != '')
            Container(
              // width: 190,
              // padding: EdgeInsets.all(4),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                //  color: whiteGrey3,
              ),
              child: Text(
                routeLength,
                style: h12w400BlackWithOpacity,
              ),
            ),
          InkWell(
            onTap: () {
              changeRouteDialog(
                () => () {},
                context,
              );
            },
            child: from == ''
                ? AddressInputFieldV2(
                    isActive: false,
                    change: () {},
                    hintText: 'Откуда?',
                    icon: const Icon(Icons.search),
                  )
                : AddressInputFieldV2(
                    showFrom: true,
                    isActive: false,
                    change: () {},
                    hintText: from,
                    icon: const BluePoint(),
                  ),
          ),
          SizedBox(height: 10),
          Stack(
            children: [
              InkWell(
                onTap: () {
                  changeRouteDialog(
                    () => () {},
                    context,
                  );
                },
                child: to == ''
                    ? AddressInputFieldV2(
                        isActive: false,
                        change: () {},
                        hintText: 'Куда?',
                        icon: const Icon(Icons.search),
                      )
                    : AddressInputFieldV2(
                        showWhere: true,
                        isActive: false,
                        change: () {},
                        hintText: to,
                        icon: const BluePoint(),
                      ),
              ),
            ],
          ),
          SizedBox(height: 8),

          Stack(
            children: [
              InkWell(
                onTap: () async {
                  selectDateDialog(
                    CupertinoDatePicker(
                      showDayOfWeek: false,
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (DateTime value) {
                        setState(() {
                          planDate = value;
                        });
                      },
                    ),
                    () => setState(() {
                      planDate = null;
                    }),
                    context,
                  );

                  if (planDate != null) {
                    // ignore: use_build_context_synchronously
                  } else {
                    setState(() {
                      planDate = null;
                    });
                  }
                },
                child: planDate == null
                    ? AddressInputFieldV2(
                        isActive: false,
                        change: () {},
                        hintText: 'Сейчас',
                        icon: const Icon(Icons.calendar_month),
                      )
                    : Stack(children: [
                        AddressInputFieldV2(
                          showWhere: true,
                          isActive: false,
                          change: () {},
                          hintText:
                              DateFormat('Отложить заказ до: dd.MM.yyyy  hh:mm')
                                  .format(planDate!),
                          icon: const BluePoint(),
                        ),
                        Positioned(
                          right: 0,
                          top: 20,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                planDate = null;
                              });
                            },
                            child: Icon(
                              Icons.clear,
                              size: 18,
                            ),
                          ),
                        )
                      ]),
              ),
            ],
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              // Get.to(CommentPage(
              //   setComment: (val) => setState(() {
              //     comment = val;
              //   }),
              // ));
              commentDialog(
                  CommentPage(
                    setComment: (val) => setState(() {
                      context.read<CarOrderBloc>().currentOrder.comment = val;
                    }),
                    isPass: false,
                  ),
                  () {},
                  context);
            },
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0.1),
              ),
              child: Row(
                children: [
                  SizedBox(width: 15),
                  Icon(
                    Icons.message_outlined,
                    color: black.withOpacity(0.7),
                  ),
                  SizedBox(width: 15),
                  Text(comment != '' ? comment : 'Комментарий водителю',
                      style: h13w400Black)
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              //Начать выполненение
              print(planDate);
              setState(() {
                isWaiting = true;
              });
              if (planDate != null) {
                () async {
                  var checkedOrder = context.read<RouteFromToCubit>().get();
                  checkedOrder.startDate = planDate;
                  checkedOrder.endDate = planDate!
                      .add(Duration(seconds: checkedOrder.lengthSec!))
                      .add(Duration(seconds: checkedOrder.arriveTime!));
                  print(checkedOrder.startDate);
                  var res = await checkOrdersBeforePlane(checkedOrder);
                  print(res);
                  if (res == null) {
                    context
                        .read<RouteFromToCubit>()
                        .setStatus(CarOrderStatus.planed);
                    context.read<RouteFromToCubit>().setStartDate(planDate!);
                    context.read<RouteFromToCubit>().setEndDate(planDate!.add(
                        Duration(
                            seconds: context
                                .read<RouteFromToCubit>()
                                .get()
                                .lengthSec!)));
                    orderConfirm(context);
                    context
                        .read<RouteFromToCubit>()
                        .set(CarOrder(status: CarOrderStatus.waiting));

                    Get.offAll(() => DriverHomePage());
                  } else {
                    planedBad(
                      context,
                      () {
                        Navigator.of(context).pop();
                      },
                      CarOrder.fromJson(res),
                    );
                    //  showBadOrderMessage(context, CarOrder.fromJson(res));
                    // showBadOrderMessage(context, CarOrder.fromJson(res));
                    print(res);
                  }
                }();
              } else {
                context
                    .read<RouteFromToCubit>()
                    .setStatus(CarOrderStatus.active);
                orderConfirm(context);
              }
              setState(() {
                isWaiting = false;
              });
              //отложить
            },
            child: isWaiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Button2(
                    title: planDate == null
                        ? 'Начать выполнение заказа'
                        : 'Отложить выполение заказа',
                  ),
          ),

          SizedBox(height: 20),

          //SizedBox(height: 10),
        ],
      ),
    );
  }
}
