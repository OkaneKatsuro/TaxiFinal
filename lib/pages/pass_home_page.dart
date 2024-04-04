import 'dart:async';

import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/pages/video_player_page.dart';
import 'package:cars/res/odder_functions.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/bottom_sheet/bottom_shet_header.dart';
import 'package:cars/widgets/bottom_sheet/pass_bottom_shet_body.dart';
import 'package:cars/widgets/bottom_sheet/pass_bottom_waiting.dart';
import 'package:cars/widgets/driving_map_container.dart';
import 'package:cars/widgets/menu/pass_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../bloc/car_order_bloc/car_order_bloc.dart';
import '../models/car.dart';
import '../models/car_order.dart';
import '../res/firebase_utils.dart';
import '../res/utils.dart';
import '../widgets/bottom_sheet/pass_bottom_active.dart';
import '../widgets/bottom_sheet/pass_bottom_perenos.dart';
import '../widgets/buttons/video_button.dart';
import '../widgets/car_status.dart';
import '../widgets/driving_map_pass_container.dart';
import '../widgets/map_container.dart';
import '../widgets/maps/res/functions.dart';
import 'package:cars/pages/video_player_page.dart';


class PassHomePage extends StatefulWidget {
  const PassHomePage({super.key});

  @override
  State<PassHomePage> createState() => _PassHomePageState();
}

class _PassHomePageState extends State<PassHomePage> {
  @override
  void initState() {
    // updateCarLocation();

    super.initState();
    // context.read<CarOrderBloc>().add(CarOrderEventInitPassenger());

    if (context.read<CarOrderBloc>().currentOrder.from == null) {
      Future.delayed(const Duration(seconds: 3), () async {
        try {
          var point = await getCurrentPoint();
          print('----------->');
          print(point.description);
          context.read<CarOrderBloc>().currentOrder.from = point;
          setState(() {
            order = order = context.read<CarOrderBloc>().currentOrder;
          });
        } catch (e) {
          print(e);
        }
      });
    }
    if (!(context.read<CarOrderBloc>().state is CarOrderStatePlanAnother)) {
      // FirebaseFirestore.instance
      //     .collection('orders')
      //     .snapshots()
      //     .listen((querySnapshot) async {
      //   context.read<CarOrderBloc>().add(CarOrderEventInitPassenger());
      // });
      streamSubscription = myStream.listen((querySnapshot) async {
        context.read<CarOrderBloc>().add(CarOrderEventInitPassenger());
      });
    }
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
  streamSubscription;
  Stream<QuerySnapshot<Map<String, dynamic>>> myStream =
  FirebaseFirestore.instance.collection("orders").snapshots();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  var mapKey = GlobalKey<MapContainerState>();
  var mapDriverKey = GlobalKey<DrivingMapPassContainerState>();

  bool isWaiting = false;
  bool isPerenos = false;

  String showDateError = '';
  CarOrder order = CarOrder(status: CarOrderStatus.empty);
  @override
  Widget build(BuildContext context) {
    print(context.read<CarOrderBloc>().currentOrder.status);
    if (!(context.read<CarOrderBloc>().state is CarOrderStatePlanAnother))
      order = context.read<CarOrderBloc>().currentOrder;

    context.watch<CarOrderBloc>().state.when(
        loading: () {
          order = context.read<CarOrderBloc>().currentOrder;
          //  order = context.read<CarOrderBloc>().currentOrder;
        },
        error: () {
          order = context.read<CarOrderBloc>().currentOrder;
        },
        active: () => {},
        confirmed: () {
          order = context.read<CarOrderBloc>().currentOrder;
          isWaiting = false;
          isPerenos = false;
        },
        waitingForConfirmation: () async {
          order = context.read<CarOrderBloc>().currentOrder;
          isPerenos = false;
          isWaiting = true;
        },
        perenos: () {
          setState(() {
            order = context.read<CarOrderBloc>().currentOrder;
            isWaiting = false;
            isPerenos = true;
          });
        },
        done: () {
          order = context.read<CarOrderBloc>().currentOrder;
          isWaiting = false;
          isPerenos = false;
          print('ORDER ${order.from}');
        },
        finishedOrCanceled: () {
          Future.delayed(const Duration(seconds: 3), () async {
            try {
              var point = await getCurrentPoint();
              print('----------->');
              print(point.description);
              context.read<CarOrderBloc>().currentOrder.from = point;
              setState(() {
                order = context.read<CarOrderBloc>().currentOrder;
              });
            } catch (e) {
              print(e);
            }
          });
        },
        planAnother: () {
          order = context.read<CarOrderBloc>().currentOrder;
        });

    Future.delayed(
        const Duration(seconds: 0), () => key.currentState!.expand());

    return Scaffold(
      key: _scaffoldKey,
      drawer: const PassMenu(),
      floatingActionButton: VideoButton(
        onPressed: () {
          Get.to(() => VideoPlayerPage());
        }, mapKey: mapKey, mapDriverKey: mapDriverKey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      body: ExpandableBottomSheet(
        key: key,
        persistentHeader: BottomSheetHeader(),
        expandableContent: isPerenos && !isWaiting
            ? PassBottomPerenos()
            : isWaiting && !isPerenos
            ? const PassBottomWaiting()
            : order.status == CarOrderStatus.active
            ? PassBottomActive()
            : PassBottomSheetBody(order: order),
        onIsContractedCallback: () {},
        background: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          alignment: Alignment.center,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  order.from == null ||
                      order.route == null ||
                      order.route!.isEmpty
                      ? MapContainer(key: mapKey, canChangeGeo: false)
                      : DrivingMapPassContainer(key: mapDriverKey),
                  Positioned(
                    top: 50,
                    left: 0,
                    child: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        size: 30,
                        color: Colors.black, // Исправлено: black -> Colors.black
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    child: Container(
                      height: 52,
                      // color: Colors.amber,
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width - 100,
                      child: CarStatus(),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    child: Container(
                      height: 42,
                      // color: Colors.amber,
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width - 100,
                      child: Text(showDateError),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
