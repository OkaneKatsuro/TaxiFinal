import 'dart:async';

import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/models/car_order.dart';



import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/res/token_login.dart';
import 'package:cars/res/utils.dart';
import 'package:cars/widgets/bottom_sheet/bottom_shet_header.dart';
import 'package:cars/widgets/bottom_sheet/pass_bottom_shet_body.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:ext_video_player/ext_video_player.dart';
import 'package:cars/widgets/menu/pass_menu.dart';
import 'package:cars/widgets/buttons/map_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



import '../models/route_from_to.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late VideoPlayerController? _firstController;
  late VideoPlayerController? _secondController;
  late CarOrder order;

  StreamSubscription<dynamic>? streamSubscription;

  String url1 = "";
  String url2 = "";

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    order = context.read<CarOrderBloc>().currentOrder;
    _setupFirebaseListener();
  }

  Future<void> _initializeControllers() async {
    bool success = await updateToken();
    if (success) {
      setState(() {
        url1 = "rtmp://nscar.online:6604/3/3?AVType=1&jsession=${token.rtmpLink}&DevIDNO=0151376&Channel=0&Stream=1";
        url2 = "rtmp://nscar.online:6604/3/3?AVType=1&jsession=${token.rtmpLink}&DevIDNO=0151376&Channel=1&Stream=1";
        print("AAAAAAAAAAa:$url1");
        _firstController = VideoPlayerController.network(url1);
        _secondController = VideoPlayerController.network(url2);
      });
      // Initializing the controllers asynchronously
      await Future.wait([
        _firstController!.initialize(),
        _secondController!.initialize(),
      ]);
      // After initialization, if mounted, setState to rebuild UI
      if (mounted) {
        setState(() {});
      }
      _firstController!.play();
    } else {
      print('Ошибка создания rtmp ссылки');
    }

  }

  void _setupFirebaseListener() {
    if (context.read<CarOrderBloc>().currentOrder.from == null) {
      Future.delayed(const Duration(seconds: 3), () async {
        try {
          var point = await getCurrentPoint();
          context.read<CarOrderBloc>().currentOrder.from = point;
          setState(() {
            order = context.read<CarOrderBloc>().currentOrder;
          });
        } catch (e) {
          print(e);
        }
      });
    }

    if (!(context.read<CarOrderBloc>().state is CarOrderStatePlanAnother)) {
      streamSubscription = FirebaseFirestore.instance
          .collection("orders")
          .snapshots()
          .listen((querySnapshot) async {
        context.read<CarOrderBloc>().add(CarOrderEventInitPassenger());
      });
    }
  }

  @override
  void dispose() {
    _firstController?.dispose();
    _secondController?.dispose();
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<RouteFromToCubit>().get();

    Future.delayed(Duration(seconds: 1), () => key.currentState!.expand());
    return Scaffold(
      key: _scaffoldKey,
      drawer: PassMenu(),
      floatingActionButton: MapButton(
        onPressed: () {
          Get.to(() => PassHomePage());
        },
      ),
      body: ExpandableBottomSheet(
        key: key,
        persistentHeader: BottomSheetHeader(),
        expandableContent: PassBottomSheetBody(order: order),
        onIsExtendedCallback: () {
          print('expanded');
        },
        onIsContractedCallback: () {},
        background: SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 1000),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 50),
                      Expanded(
                        child: _firstController?.value?.initialized ?? false
                            ? VideoPlayer(_firstController!)
                            : CircularProgressIndicator(),
                      ),
                      Expanded(
                        child: _secondController?.value?.initialized ?? false
                            ? VideoPlayer(_secondController!)
                            : CircularProgressIndicator(),
                      ),
                    ],
                  ),
                  Positioned(
                    child: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }}
