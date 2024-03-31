import 'dart:math';

import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/models/parking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../bloc/route_from_to/route_from_to.dart';
import '../../../models/car.dart';
import '../models/location_service.dart';

Future<String> getRouteToPass(BuildContext context) async {
  PlacemarkMapObject tmp;
  if (context.read<CarOrderBloc>().currentOrder.from != null) {
    tmp = PlacemarkMapObject(
      mapId: const MapObjectId('start_placemark'),
      point: Point(
          latitude: context.read<CarOrderBloc>().currentOrder.from!.lat,
          longitude: context.read<CarOrderBloc>().currentOrder.from!.long),
    );
  } else {
    var location = await LocationService().getCurrentLocation();
    tmp = PlacemarkMapObject(
        mapId: const MapObjectId('start_placemark'),
        point: Point(
          latitude: location.lat,
          longitude: location.long,
        ));
  }

  final PlacemarkMapObject startPlacemark = tmp;

  var resultWithSession = YandexDriving.requestRoutes(
    points: [
      RequestPoint(
          point: Point(latitude: car.lat, longitude: car.long),
          requestPointType: RequestPointType.wayPoint),
      RequestPoint(
          point: startPlacemark.point,
          requestPointType: RequestPointType.wayPoint),
    ],
    drivingOptions: const DrivingOptions(
        initialAzimuth: 0, routesCount: 5, avoidTolls: true),
  );
  var res = await resultWithSession.result;
  var time = res.routes!.first.metadata.weight.timeWithTraffic.value!.toInt();
  context.read<CarOrderBloc>().currentOrder.arriveTime = time;

  print('=====> time= ${time.toInt()}');

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  final d1 = Duration(seconds: time);

  print('===1-->${format(d1)}');
  return format(d1);
}

Future<int> getBackTime(BuildContext context) async {
  try {
    PlacemarkMapObject tmp;

    tmp = PlacemarkMapObject(
      mapId: const MapObjectId('end_placemark'),
      point: Point(
          latitude: context.read<CarOrderBloc>().currentOrder.route!.last!.lat,
          longitude:
              context.read<CarOrderBloc>().currentOrder.route!.last!.long),
    );

    final PlacemarkMapObject endPlacemark = tmp;

    var resultWithSession = YandexDriving.requestRoutes(
      points: [
        RequestPoint(
            point: endPlacemark.point,
            requestPointType: RequestPointType.wayPoint),
        RequestPoint(
            point: Point(latitude: parking.lat, longitude: parking.long),
            requestPointType: RequestPointType.wayPoint),
      ],
      drivingOptions: const DrivingOptions(
          initialAzimuth: 0, routesCount: 5, avoidTolls: true),
    );
    var res = await resultWithSession.result;
    var time = res.routes!.first.metadata.weight.timeWithTraffic.value!.toInt();
    context.read<CarOrderBloc>().currentOrder.backTime = time;
    return time;
  } catch (e) {}
  return 0;
}
