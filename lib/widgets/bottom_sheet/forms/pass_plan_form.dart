import 'dart:async';

import 'package:cars/bloc/app_bottom_form/app_bottom_form.dart';
import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/pages/change_route_page.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/res/odder_functions.dart';
import 'package:cars/res/styles.dart';

import 'package:cars/widgets/buttons/button2.dart';
import 'package:cars/widgets/dialogs/change_route_dialog.dart';
import 'package:cars/widgets/dialogs/comment_dialog.dart';
import 'package:cars/widgets/dialogs/planed_ok.dart';
import 'package:cars/widgets/dialogs/planing_dialog_box.dart';
import 'package:cars/widgets/dialogs/select_date_dialog.dart';

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
import '../../../res/utils.dart';
import '../../buttons/button1.dart';
import '../../buttons/button3.dart';
import '../../dialogs/planed_bad.dart';
import '../../dialogs/select_route_dialog.dart';
import '../../maps/order_form/address_input_filed_v2.dart';

class PassPlanForm extends StatefulWidget {
  PassPlanForm({super.key, required this.order});
  CarOrder order;
  @override
  State<PassPlanForm> createState() => _PassPlanFormState();
}

class _PassPlanFormState extends State<PassPlanForm> {
  @override
  void initState() {
    var timer = Timer.periodic(Duration(seconds: 1), (timer) {
      try {
        var len = context.read<CarOrderBloc>().currentOrder.lengthSec;
        print('len=$len');
        if (len != null &&
            (context.read<CarOrderBloc>().currentOrder.route != null &&
                context.read<CarOrderBloc>().currentOrder.route!.isNotEmpty)) {
          format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
          final d1 = Duration(seconds: len);
          setState(() {
            routeLength = 'Время поездки: ' + format(d1);
          });

          context.read<CarOrderBloc>().currentOrder.lengthSec = len;
          setState(() {});
        } else {
          routeLength = '';
          context.read<CarOrderBloc>().currentOrder.lengthSec = null;
        }
      } catch (e) {}
    });
    super.initState();
  }

  String from = '';
  String to = '';
  String comment = '';
  DateTime? planDate;
  String routeLength = '';
  bool isWaiting = false;
  var fromController = TextEditingController();
  var routeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var order = context.watch<CarOrderBloc>().currentOrder;

    from = order.from?.name ?? '';
    print('from=${order.from?.name}');
    var route = order.route;

    if (route != null) {
      if (route.length == 1) {
        to = context.read<CarOrderBloc>().currentOrder.route?.last.name ?? '';
      } else if (route.length > 1) {
        to = '(остановок: ${route.length - 1}) → ${route.last.name}';
      }
    }

    comment = order.comment ?? '';

    return Form(
      key: formKey,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  order.status == CarOrderStatus.planed
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              context
                                  .read<CarOrderBloc>()
                                  .add(CarOrderEvent.initPassenger());
                              Get.offAll(PassHomePage());
                            },
                            child: Icon(Icons.arrow_back),
                          ),
                        )
                      : SizedBox(),
                  routeLength != ''
                      ? Text(
                          routeLength,
                          style: h12w400BlackWithOpacity,
                        )
                      : SizedBox(),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                selectRouteDialog(
                    SearchPage(
                      setAddress: () {
                        setState(() {});
                      },
                      isFrom: true,
                    ),
                    () {},
                    context);
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
                    if (route != null && route.length > 1) {
                      changeRouteDialog(ChangeRoutePage(), () {
                        Get.offAll(PassHomePage());
                      }, context);

                      //  Get.off(() => ChangeRoutePage());
                    } else {
                      selectRouteDialog(
                          SearchPage(
                            setAddress: () {
                              setState(() {});
                            },
                            isFrom: false,
                            isChange: true,
                          ),
                          () {},
                          context);
                    }
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
                if (route != null)
                  Positioned(
                    right: 0,
                    top: 15,
                    child: InkWell(
                      onTap: () {
                        selectRouteDialog(
                            SearchPage(
                              setAddress: () {
                                setState(() {});
                              },
                              isFrom: false,
                              isChange: false,
                            ),
                            () {},
                            context);
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),

            Stack(
              children: [
                InkWell(
                  onTap: () async {
                    _showDialog(
                      CupertinoDatePicker(
                        showDayOfWeek: false,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (DateTime value) {
                          setState(() {
                            context
                                .read<CarOrderBloc>()
                                .currentOrder
                                .startDate = value;
                            planDate = context
                                .read<CarOrderBloc>()
                                .currentOrder
                                .startDate;
                          });
                          print(value);
                        },
                      ),
                      () => setState(() {
                        context.read<CarOrderBloc>().currentOrder.startDate =
                            null;
                      }),
                    );
                  },
                  child: context.read<CarOrderBloc>().currentOrder.startDate ==
                          null
                      ? AddressInputFieldV2(
                          validateDate: true,
                          isActive: false,
                          change: () {},
                          hintText: context
                                          .read<CarOrderBloc>()
                                          .currentOrder
                                          .startDate ==
                                      CarOrderStatus.planed ||
                                  order.isCarFree == false
                              ? 'Выберите дату'
                              : 'Сейчас',
                          icon: const Icon(Icons.calendar_month),
                        )
                      : Stack(children: [
                          AddressInputFieldV2(
                            showWhere: true,
                            isActive: false,
                            change: () {},
                            hintText: DateFormat('dd.MM.yyyy  hh:mm').format(
                                planDate != null ? planDate! : DateTime.now()),
                            icon: const BluePoint(),
                          ),
                          Positioned(
                            right: 0,
                            top: 20,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  context
                                      .read<CarOrderBloc>()
                                      .currentOrder
                                      .startDate = null;
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
                commentDialog(
                    CommentPage(
                      setComment: (val) => setState(() {
                        context.read<CarOrderBloc>().currentOrder.comment = val;
                      }),
                    ),
                    () {},
                    context);
                // Get.to(CommentPage(
                //   setComment: (val) => setState(() {
                //     context.read<CarOrderBloc>().currentOrder.comment = val;
                //   }),
                // ));
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
              onTap: () async {
                setState(() {
                  isWaiting = true;
                  print(isWaiting);
                });

                formKey.currentState?.validate();
                //проверка валидации введенных данных
                var order = context.read<CarOrderBloc>().currentOrder;

                if (order.status == CarOrderStatus.empty &&
                    order.from != null &&
                    order.route != null &&
                    order.isCarFree == true &&
                    order.startDate == null) {
                  var res = await orderNow(context);

                  if (res == null) {
                    context.read<CarOrderBloc>().add(CarOrderEvent.start());
                  } else {
                    planedBad(
                      context,
                      () {
                        Navigator.of(context).pop();
                      },
                      res,
                    );
                  }
                } else if (order.startDate != null) {
                  var res = await orderNow(context);
                  if (res == null) {
                    planedOk(context, () {
                      context.read<CarOrderBloc>().add(CarOrderEvent.stop());
                      Get.offAll(() => PassHomePage());
                    });
                  } else {
                    planedBad(
                      context,
                      () {
                        Navigator.of(context).pop();
                      },
                      res,
                    );
                  }
                }
                setState(() {
                  isWaiting = false;
                  print(isWaiting);
                });

                // ========  if (context.read<RouteFromToCubit>().get().status ==
                //       CarOrderStatus.active) {
                //     //до проверка
                //   }
                //   orderNow(context);
                //   context.read<CarOrderBloc>().add(CarOrderEvent.start());
              },
              child: Button2(
                isWaiting: isWaiting,
                title: context.watch<CarOrderBloc>().currentOrder.startDate !=
                            null ||
                        context.watch<CarOrderBloc>().currentOrder.isCarFree ==
                            false
                    ? 'Запланировать поездку'
                    : 'Заказать машину',
              ),
            ),

            SizedBox(height: 20),

            //SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showDialog(Widget child, Function cancel) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.down,
        onDismissed: (_) {
          Navigator.of(context).pop();
          cancel();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          height: 390,
          padding: const EdgeInsets.only(top: 20.0),
          // The bottom margin is provided to align the popup above the system
          // navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.

          // Use a SafeArea widget to avoid system overlaps.
          child: Scaffold(
            body: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: 270,
                    child: child,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        child: InkWell(
                          onTap: () {
                            cancel();
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Button3(title: 'Отмена'),
                        ),
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        width: 120,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Button2(title: 'Выбрать'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
