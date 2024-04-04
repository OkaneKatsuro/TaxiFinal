import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/route_from_to.dart';
import 'package:cars/res/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/car_order.dart';
import '../../models/role.dart';
import '../../pages/video_player_page.dart';
import '../../res/styles.dart';
import '../driving_map_container.dart';
import '../map_container.dart';

class VideoButton extends StatelessWidget {
  VideoButton({
    super.key,
    required this.mapKey,
    required this.mapDriverKey, required Null Function() onPressed,
  });
  GlobalKey<MapContainerState> mapKey;
  GlobalKey<dynamic> mapDriverKey;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 420, right: 0),
        child: Container(
            width: 30,
            height: 110,
            child: Column(
                children: [
            if (context.read<UserCubit>().getUser()!.role == Role.pass)
        InkWell(
        onTap: () async {
      try {
        mapKey.currentState!.fetchCurrentLocation(showCar: false);
      } catch (e) {}
      try {
        mapDriverKey.currentState!
            .fetchCurrentLocation(showCar: false);
      } catch (e) {}
    },
    child: Container(
    width: 30,
    height: 30,
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
    BoxShadow(
    color: Color.fromARGB(255, 151, 150, 151)
        .withOpacity(0.5),
    spreadRadius: 2,
    blurRadius: 3,
    offset: Offset(0, 3), // changes position of shadow
    ),
    ],
    ),
    child: (context.read<CarOrderBloc>().currentOrder.from !=
    null &&
    context.read<CarOrderBloc>().currentOrder.route !=
    null &&
    context
        .read<CarOrderBloc>()
        .currentOrder
        .route!
        .length >=
    1)
    ? Image.asset(
    'asstes/route.png',
    color: blue,
    // fit: BoxFit.fill,
    scale: 10,
    )
        : Image.asset(
    'asstes/point_1.png',
    color: blue,
    // fit: BoxFit.fill,
    scale: 15,
    )),
    ),
    SizedBox(height: 10),
    InkWell(
    onTap: () async {
    try {
    mapKey.currentState!.fetchCurrentLocation(showCar: true);
    } catch (e) {}
    try {
    mapDriverKey.currentState!
        .fetchCurrentLocation(showCar: true);
    } catch (e) {}
    },
    child: Container(
    width: 30,
    height: 30,
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
    BoxShadow(
    color:
    Color.fromARGB(255, 151, 150, 151).withOpacity(0.5),
    spreadRadius: 2,
    blurRadius: 3,
    offset: Offset(0, 3), // changes position of shadow
    ), ],
    ),
    child: (context.read<RouteFromToCubit>().get().status ==
    CarOrderStatus.active ||
    context.read<CarOrderBloc>().currentOrder.status ==
    CarOrderStatus.active) &&
    context.read<UserCubit>().getUser()!.role == Role.driver
    ? Image.asset(
    'asstes/route.png',
    color: blue,
    // fit: BoxFit.fill,
    scale: 10,
    )
        : Image.asset(
    'asstes/car.png',
    // color: blue,
    fit: BoxFit.fill,
    scale: 30,
    ),
    ),
    ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => VideoPlayerPage()),
                      );
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color:
                            Color.fromARGB(255, 151, 150, 151).withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'asstes/cam7.png',
                        color: blue,
                        fit: BoxFit.fill,
                        scale: 20,
                      ),
                    ),
                  ),
                ],
            ),
        ),
    );
  }
}