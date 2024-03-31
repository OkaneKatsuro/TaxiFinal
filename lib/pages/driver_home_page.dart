//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/models/car_order.dart';
import 'package:cars/res/odder_functions.dart';
import 'package:cars/widgets/bottom_sheet/forms/driver_active_form.dart';
import 'package:cars/widgets/bottom_sheet/forms/pass_plan_form.dart';
import 'package:cars/widgets/driving_map_container.dart';
import 'package:cars/widgets/menu/driver_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:notification_permissions/notification_permissions.dart';
import '../bloc/car_order_bloc/car_order_bloc.dart';
import '../widgets/bottom_sheet/bottom_shet_header.dart';
import '../widgets/bottom_sheet/driver_app_bottom_sheet.dart';
import '../widgets/bottom_sheet/forms/driver_order_form.dart';
import '../widgets/buttons/video_button.dart';
import '../widgets/car_status.dart';
import '../widgets/driver_car_status.dart';
import '../widgets/map_container.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  CollectionReference reference =
      FirebaseFirestore.instance.collection('orders');

  @override
  void initState() {
    // Future<PermissionStatus> permissionStatus =
    //     NotificationPermissions.requestNotificationPermissions();

    // Future.delayed(Duration(seconds: 5), () {
    //   AwesomeNotifications().createNotification(
    //     // schedule: NotificationAndroidCrontab(
    //     //     preciseSchedules: [DateTime.now().add(Duration(seconds: 10))]),
    //     content: NotificationContent(
    //       largeIcon:
    //           'https://prod-ripcut-delivery.disney-plus.net/v1/variant/disney/174C605829DEB3C79C2F6993EFA97B2ECBF21D6A152E6BB0CA00DDA987E94BAC/scale?width=1200&aspectRatio=1.78&format=jpeg',
    //       id: 10,
    //       channelKey: 'basic_channel',
    //       title: 'Simple Notification',
    //       body: 'Simple body',
    //       wakeUpScreen: true,
    //       fullScreenIntent: true,
    //       criticalAlert: true,

    //       //  category: NotificationCategory.Call,

    //       // locked: true,
    //     ),
    //     actionButtons: <NotificationActionButton>[
    //       NotificationActionButton(key: 'accept', label: 'Accept'),
    //       NotificationActionButton(key: 'reject', label: 'Reject'),
    //     ],
    //   );
    // });
    () async {
      var order = await getFirstWaitingOrder();

      if (order != null) {
        setState(() {
          newOrder = CarOrder.fromJson(order!);
        });
        context.read<RouteFromToCubit>().set(newOrder);
      } else {
        var orderA = await getFirstActiveOrder();
        if (orderA != null) {
          setState(() {
            activeOrder = CarOrder.fromJson(orderA);
          });
          context.read<RouteFromToCubit>().set(activeOrder);
          print(context.read<RouteFromToCubit>().get().status!);
        }
      }

      print('laoded order=$order');
    }();
    super.initState();
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        print('update');
        () async {
          newOrder = null;
          var order = await getFirstWaitingOrder();
          Map<String, dynamic>? orderA;
          if (order != null) {
            setState(() {
              newOrder = CarOrder.fromJson(order);
            });
            context.read<RouteFromToCubit>().set(newOrder);
          } else {
            orderA = await getFirstActiveOrder();
            if (orderA != null) {
              setState(() {
                activeOrder = CarOrder.fromJson(orderA!);
              });
              context.read<RouteFromToCubit>().set(activeOrder);
            }

            if (orderA == null &&
                order == null &&
                (context.read<RouteFromToCubit>().get().status ==
                        CarOrderStatus.active ||
                    context.read<RouteFromToCubit>().get().status ==
                        CarOrderStatus.waiting)) {
              setState(() {
                activeOrder = null;
                newOrder = null;
              });
              context
                  .read<RouteFromToCubit>()
                  .set(CarOrder(status: CarOrderStatus.waiting));
              context.read<CarOrderBloc>().add(CarOrderEvent.stop());
            }
          }

          print('newOrder=${newOrder?.status}');
        }();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  CarOrder? newOrder;
  CarOrder? activeOrder;
  var mapKey = GlobalKey<MapContainerState>();
  var mapDriverKey = GlobalKey<DrivingMapContainerState>();
  @override
  Widget build(BuildContext context) {
    var state = context.watch<RouteFromToCubit>().get();
    Future.delayed(Duration(seconds: 1), () {
      try {
        key.currentState!.expand();
      } catch (e) {}
    });

    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      floatingActionButton:
          VideoButton(mapKey: mapKey, mapDriverKey: mapDriverKey),
      drawer: DriverMenu(),
      body: ExpandableBottomSheet(
        key: key,
        persistentHeader: newOrder != null
            ? BottomSheetHeader()
            : activeOrder != null
                ? BottomSheetHeader()
                : SizedBox(),
        expandableContent: newOrder != null
            ? DriverOrderForm()
            : activeOrder != null
                ? DriverActiveForm()
                : SizedBox(),
        background: SafeArea(
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Stack(
              children: [
                state.from == null || state.route == null
                    ? MapContainer(key: mapKey, canChangeGeo: false)
                    : DrivingMapContainer(key: mapDriverKey),
                Positioned(
                  child: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                        size: 30,
                      )),
                ),
                Positioned(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    child: Center(
                        child: newOrder != null || activeOrder != null
                            ? DriverCarStatus()
                            : SizedBox()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
