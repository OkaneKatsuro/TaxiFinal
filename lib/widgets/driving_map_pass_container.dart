import 'dart:async';
import 'dart:math';
import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/models/car.dart';
import 'package:cars/models/place.dart';
import 'package:cars/res/styles.dart';

import 'package:cars/widgets/maps/red_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../bloc/position_bloc/position_bloc.dart';
import '../models/route_from_to.dart';
import 'maps/car_point.dart';
import 'maps/models/app_lat_long.dart';
import 'maps/models/location_service.dart';

class DrivingMapPassContainer extends StatefulWidget {
  DrivingMapPassContainer({super.key});

  @override
  State<DrivingMapPassContainer> createState() =>
      DrivingMapPassContainerState();
}

class DrivingMapPassContainerState extends State<DrivingMapPassContainer> {
  GlobalKey<SessionState> keyS = GlobalKey();

  /// Получение текущей геопозиции пользователя
  Future<void> fetchCurrentLocation({bool showCar = false}) async {
    print('object');
    keyS.currentState?.fetchCurrentLocation(showCar: showCar);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  final List<MapObject> mapObjects = [];

  bool initFlag = true;

  @override
  Widget build(BuildContext context) {
    final PlacemarkMapObject startPlacemark = PlacemarkMapObject(
      mapId: const MapObjectId('start_placemark'),
      point: Point(
          latitude: context.read<CarOrderBloc>().currentOrder.from!.lat,
          longitude: context.read<CarOrderBloc>().currentOrder.from!.long),
      // icon: PlacemarkIcon.single(
      //   PlacemarkIconStyle(
      //       image: BitmapDescriptor.fromAssetImage('asstes/point.png'),
      //       scale: 0.2),
      // ),
    );

    List<RequestPoint> routeList = [];
    var max = context.read<CarOrderBloc>().currentOrder.route!.length;
    var i = 0;
    context.read<CarOrderBloc>().currentOrder.route!.forEach((e) {
      final PlacemarkMapObject place = PlacemarkMapObject(
        mapId: MapObjectId(
            i < max ? '${Random().nextInt(999999)}' : 'end_placemark'),
        point: Point(latitude: e.lat, longitude: e.long),
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage('asstes/point.png'),
              scale: 0.3),
        ),
      );
      var rPoint = RequestPoint(
          point: place.point, requestPointType: RequestPointType.wayPoint);
      routeList.add(rPoint);
      i++;
    });

    final PlacemarkMapObject endPlacemark = PlacemarkMapObject(
      mapId: const MapObjectId('end_placemark'),
      point: Point(
          latitude: context.read<CarOrderBloc>().currentOrder.route!.last.lat,
          longitude:
              context.read<CarOrderBloc>().currentOrder.route!.last.long),
      // icon: PlacemarkIcon.single(PlacemarkIconStyle(
      //     image: BitmapDescriptor.fromAssetImage('lib/assets/route_end.png'),
      //     scale: 0.3)),
    );

    var resultWithSession = YandexDriving.requestRoutes(
        points: [
          RequestPoint(
              point: startPlacemark.point,
              requestPointType: RequestPointType.wayPoint),
          ...routeList,
          // RequestPoint(
          //     point: endPlacemark.point,
          //     requestPointType: RequestPointType.wayPoint),
        ],
        drivingOptions: const DrivingOptions(
            initialAzimuth: 0, routesCount: 5, avoidTolls: true));

    if (initFlag) {
      initFlag = false;
      () async {
        var location = await LocationService().getCurrentLocation();
        var mapObject = getRedPoint(lat: location.lat, long: location.long);
        setState(() {
          mapObjects.add(mapObject);
        });
      }();
    }
    return _SessionPage(
      key: keyS,
      startPlacemark: startPlacemark,
      endPlacemark: endPlacemark,
      session: resultWithSession.session,
      result: resultWithSession.result,
    );
  }
}

class _SessionPage extends StatefulWidget {
  final Future<DrivingSessionResult>? result;
  final DrivingSession? session;
  final PlacemarkMapObject? startPlacemark;
  final PlacemarkMapObject? endPlacemark;

  const _SessionPage(
      {super.key,
      this.startPlacemark,
      this.endPlacemark,
      this.session,
      this.result});

  @override
  SessionState createState() => SessionState();
}

class SessionState extends State<_SessionPage> {
  late final List<MapObject> mapObjects = [
    widget.startPlacemark!,
    widget.endPlacemark!
  ];

  final List<DrivingSessionResult> results = [];
  bool _progress = true;

  @override
  void initState() {
    super.initState();
    () async {
      await fetchCurrentLocation();
      await _init();
    }();
  }

  @override
  void dispose() {
    super.dispose();

    _close();
  }

  final mapControllerCompleter = Completer<YandexMapController>();

  /// Получение текущей геопозиции пользователя
  Future<void> fetchCurrentLocation({bool showCar = false}) async {
    AppLatLong location = AppLatLong(
      lat: showCar
          ? car.lat
          : context.read<CarOrderBloc>().currentOrder.from!.lat,
      long: showCar
          ? car.long
          : context.read<CarOrderBloc>().currentOrder.from!.long,
    );
    if (showCar) {
      (await mapControllerCompleter.future).moveCamera(
        animation:
            const MapAnimation(type: MapAnimationType.linear, duration: 0.5),
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(
              latitude: location.lat,
              longitude: location.long,
            ),
            zoom: 14,
          ),
        ),
      );
    } else {
      // const defLocation = MoscowLocation();
      // try {
      //   location = await LocationService().getCurrentLocation();
      // } catch (_) {
      //   location = defLocation;
      // }

      await _moveToCurrentLocation(location);
    }
    // await _init();
    setState(() {});
  }

  /// Метод для показа текущей позиции
  Future<void> _moveToCurrentLocation(
    AppLatLong appLatLong,
  ) async {
    // PolylineMapObject(
    //         mapId: MapObjectId('route_${i}_polyline'),
    //         polyline: Polyline(points: route.geometry),
    //         strokeColor: blue3,
    //         strokeWidth: 2,
    //       )
    var dist = Geolocator.distanceBetween(
      context.read<CarOrderBloc>().currentOrder.from!.lat,
      context.read<CarOrderBloc>().currentOrder.from!.long,
      context.read<CarOrderBloc>().currentOrder.route!.last.lat,
      context.read<CarOrderBloc>().currentOrder.route!.last.long,
    );
    var maxPoint = Point(
      latitude: context.read<CarOrderBloc>().currentOrder.route!.last.lat,
      longitude: context.read<CarOrderBloc>().currentOrder.route!.last.long,
    );
    context.read<CarOrderBloc>().currentOrder.route!.forEach((element) {
      if (Geolocator.distanceBetween(
            context.read<CarOrderBloc>().currentOrder.from!.lat,
            context.read<CarOrderBloc>().currentOrder.from!.long,
            element.lat,
            element.long,
          ) >
          dist) {
        maxPoint = Point(latitude: element.lat, longitude: element.long);
        dist = Geolocator.distanceBetween(
          context.read<CarOrderBloc>().currentOrder.from!.lat,
          context.read<CarOrderBloc>().currentOrder.from!.long,
          element.lat,
          element.long,
        );
      }
    });
    print('dis=$dist');
    if (dist < 100) {
      dist = 100;
    }
    var newGeometry = Geometry.fromBoundingBox(BoundingBox(
      northEast: Point(
        latitude: context.read<CarOrderBloc>().currentOrder.from!.lat -
            0.000065 * dist,
        longitude: context.read<CarOrderBloc>().currentOrder.from!.long,
      ),
      southWest: Point(
        latitude: maxPoint.latitude + 0.000035 * dist,
        longitude: maxPoint.longitude,
      ),
    ));
    // await controller.moveCamera(
    //     CameraUpdate.newTiltAzimuthGeometry(newGeometry, azimuth: 1, tilt: 1),
    //     animation: animation);

    (await mapControllerCompleter.future).moveCamera(
      animation:
          const MapAnimation(type: MapAnimationType.linear, duration: 0.5),
      CameraUpdate.newTiltAzimuthGeometry(newGeometry, azimuth: 1, tilt: 1),
    );

    // (await mapControllerCompleter.future).moveCamera(
    //   animation:
    //       const MapAnimation(type: MapAnimationType.linear, duration: 0.5),
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(
    //       target: Point(
    //         latitude: appLatLong.lat - 0.008,
    //         longitude: appLatLong.long,
    //       ),
    //       // zoom: 14,
    //     ),
    //   ),
    // );
  }

  int lengthOld = 0;
  PolylineMapObject? pol;
  @override
  Widget build(BuildContext context) {
    try {
      var length = results
          .first.routes!.first.metadata.weight.timeWithTraffic.value!
          .toInt();
      if (lengthOld != length) {
        lengthOld = length;

        context.read<CarOrderBloc>().currentOrder.lengthSec = length;
        var s = context.read<CarOrderBloc>().state;

        if (s is CarOrderStateWaitingForConfirmation) {
          context.read<CarOrderBloc>().add(CarOrderEvent.routeLoading());
        } else {
          context.read<CarOrderBloc>().add(CarOrderEvent.routeLoading());
        }
      }
    } catch (e) {
      print(e);
    }

    context.watch<PositionBloc>().state.when(
          allLoaded: () {},
          allLoading: () {},
          carLoaded: () {
            mapObjects.addAll([getCarPoint()]);
          },
          carLoading: () {},
          geoLoaded: () {},
          geoLoading: () {},
        );

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Stack(children: [
        YandexMap(
          rotateGesturesEnabled: false,
          mapObjects: mapObjects,
          onMapCreated: (controller) {
            mapControllerCompleter.complete(controller);
          },
        ),
        Text('DRIVER'),
      ]),
    );
  }

  List<Widget> _getList() {
    final list = <Widget>[];

    for (var r in results) {
      list.add(Container(height: 20));

      r.routes!.asMap().forEach((i, route) {
        list.add(
            Text('Route $i: ${route.metadata.weight.timeWithTraffic.text}'));
      });

      list.add(Container(height: 20));
    }

    return list;
  }

  Future<void> _cancel() async {
    await widget.session?.cancel();

    setState(() {
      _progress = false;
    });
  }

  Future<void> _close() async {
    await widget.session?.close();
  }

  Future<void> _init() async {
    await _handleResult(await widget.result!);
  }

  Future<void> _handleResult(DrivingSessionResult result) async {
    setState(() {
      _progress = false;
    });

    if (result.error != null) {
      print('Error: ${result.error}');
      return;
    }

    setState(() {
      results.add(result);
    });

    List<RequestPoint> routeList = [];
    var max = context.read<CarOrderBloc>().currentOrder.route!.length;
    var i = 1;
    context.read<CarOrderBloc>().currentOrder.route!.forEach((e) {
      final PlacemarkMapObject place = PlacemarkMapObject(
        mapId: MapObjectId('${Random().nextInt(999999)}'),
        point: Point(latitude: e.lat, longitude: e.long),
      );
      var rPoint = RequestPoint(
          point: place.point, requestPointType: RequestPointType.wayPoint);
      routeList.add(rPoint);
      i++;
    });

    setState(() {
      result.routes!.asMap().forEach((i, route) {
        if (i == 0) {
          pol = PolylineMapObject(
            mapId: MapObjectId('route_${i}_polyline'),
            polyline: Polyline(points: route.geometry),
            strokeColor: blue3,
            strokeWidth: 2,
          );
          mapObjects.add(PolylineMapObject(
            mapId: MapObjectId('route_${i}_polyline'),
            polyline: Polyline(points: route.geometry),
            strokeColor: blue3,
            strokeWidth: 2,
          ));
        }
        mapObjects.addAll([
          getRedPoint(
              lat: widget.startPlacemark!.point.latitude,
              long: widget.startPlacemark!.point.longitude),
          getFinishPoint(
              lat: widget.endPlacemark!.point.latitude,
              long: widget.endPlacemark!.point.longitude),
          getCarPoint(),
          ...routeList.take(max - 1).map(
                (e) => getBlackPoint(
                  id: '${Random().nextInt(999999)}',
                  lat: e.point.latitude,
                  long: e.point.longitude,
                ),
              ),
        ]);
      });
    });
  }
}
