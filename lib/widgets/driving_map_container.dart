import 'dart:async';
import 'dart:math';
import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/models/car.dart';
import 'package:cars/models/place.dart';
import 'package:cars/models/role.dart';
import 'package:cars/res/styles.dart';

import 'package:cars/widgets/maps/red_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azimuth/flutter_azimuth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../bloc/position_bloc/position_bloc.dart';
import 'package:cars/models/car_order.dart';

import '../models/route_from_to.dart';
import 'maps/car_point.dart';
import 'maps/models/app_lat_long.dart';
import 'maps/models/location_service.dart';

class DrivingMapContainer extends StatefulWidget {
  DrivingMapContainer({super.key});

  @override
  State<DrivingMapContainer> createState() => DrivingMapContainerState();
}

class DrivingMapContainerState extends State<DrivingMapContainer> {
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
          latitude: context.watch<RouteFromToCubit>().get().from!.lat,
          longitude: context.watch<RouteFromToCubit>().get().from!.long),
    );

    List<RequestPoint> routeList = [];
    var max = context.read<RouteFromToCubit>().get().route!.length;
    var i = 0;
    context.read<RouteFromToCubit>().get().route!.forEach((e) {
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
          latitude: context.read<RouteFromToCubit>().get().route!.last.lat,
          longitude: context.read<RouteFromToCubit>().get().route!.last.long),
      // icon: PlacemarkIcon.single(PlacemarkIconStyle(
      //     image: BitmapDescriptor.fromAssetImage('lib/assets/route_end.png'),
      //     scale: 0.3)),
    );

    var resultWithSession = YandexDriving.requestRoutes(
      points: [
        if ((context.read<UserCubit>().getUser()!.role == Role.driver)
            // || (context.read<UserCubit>().get()!.role == Role.pass &&
            //         context.read<RouteFromToCubit>().get().status ==
            //             CarOrderStatus.waiting)
            )
          RequestPoint(
              point: Point(latitude: car.lat, longitude: car.long),
              requestPointType: RequestPointType.wayPoint),
        RequestPoint(
            point: startPlacemark.point,
            requestPointType: RequestPointType.wayPoint),
        ...routeList,
        // RequestPoint(
        //     point: endPlacemark.point,
        //     requestPointType: RequestPointType.wayPoint),
      ],
      drivingOptions: const DrivingOptions(
          initialAzimuth: 0, routesCount: 5, avoidTolls: true),
    );

    if (initFlag) {
      initFlag = false;
      () async {
        AppLatLong location;

        if (context.read<UserCubit>().getUser()!.role == Role.driver) {
          location = AppLatLong(lat: car.lat, long: car.long);
        } else {
          location = await LocationService().getCurrentLocation();
        }

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
  int zoomOnce = 0;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    () async {
      await fetchCurrentLocation();
      await init();
      // timer = Timer.periodic(Duration(seconds: 20), (timer) {
      //   fetchCurrentLocation();
      // });
    }();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    close();
  }

  final mapControllerCompleter = Completer<YandexMapController>();

  /// Получение текущей геопозиции пользователя
  Future<void> fetchCurrentLocation({bool showCar = false}) async {
    AppLatLong location;
    if (context.read<UserCubit>().getUser()!.role == Role.driver) {
      location = AppLatLong(lat: car.lat, long: car.long);
    } else {
      location = AppLatLong(
        lat: showCar
            ? car.lat
            : context.read<RouteFromToCubit>().get().from!.lat,
        long: showCar
            ? car.long
            : context.read<RouteFromToCubit>().get().from!.long,
      );
    }

    await _moveToCurrentLocation(location);
    // await _init();
    setState(() {});
  }

  var az = 0;

  /// Метод для показа текущей позиции
  Future<void> _moveToCurrentLocation(
    AppLatLong appLatLong,
  ) async {
    var dist = Geolocator.distanceBetween(
      context.read<RouteFromToCubit>().get().from!.lat,
      context.read<RouteFromToCubit>().get().from!.long,
      context.read<RouteFromToCubit>().get().route!.last.lat,
      context.read<RouteFromToCubit>().get().route!.last.long,
    );
    var maxPoint = Point(
      latitude: context.read<RouteFromToCubit>().get().route!.last.lat,
      longitude: context.read<RouteFromToCubit>().get().route!.last.long,
    );
    context.read<RouteFromToCubit>().get().route!.forEach((element) {
      if (Geolocator.distanceBetween(
            context.read<RouteFromToCubit>().get().from!.lat,
            context.read<RouteFromToCubit>().get().from!.long,
            element.lat,
            element.long,
          ) >
          dist) {
        maxPoint = Point(latitude: element.lat, longitude: element.long);
        dist = Geolocator.distanceBetween(
          context.read<RouteFromToCubit>().get().from!.lat,
          context.read<RouteFromToCubit>().get().from!.long,
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
        latitude:
            context.read<RouteFromToCubit>().get().from!.lat - 0.000065 * dist,
        longitude: context.read<RouteFromToCubit>().get().from!.long,
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
  }

  int lengthOld = 0;

  @override
  Widget build(BuildContext context) {
    try {
      var length = results
          .first.routes!.first.metadata.weight.timeWithTraffic.value!
          .toInt();
      if (lengthOld != length) {
        lengthOld = length;
        context.read<RouteFromToCubit>().setLenth(length);
        var s = context.read<CarOrderBloc>().state;

        if (s is CarOrderStateWaitingForConfirmation) {
          context.read<CarOrderBloc>().add(CarOrderEvent.start());
        } else {
          context.read<CarOrderBloc>().add(CarOrderEvent.routeLoading());
        }
      }
    } catch (e) {}

    context.watch<PositionBloc>().state.when(
          allLoaded: () {},
          allLoading: () {},
          carLoaded: () {
            mapObjects.clear();
            mapObjects.addAll([getCarPoint()]);

            if (context.read<UserCubit>().getUser()!.role == Role.driver &&
                context.read<RouteFromToCubit>().get().status ==
                    CarOrderStatus.active) {}
            //определить ближайшую точку маршрута к машине

            List<RequestPoint> routeList = [];
            var max = context.read<RouteFromToCubit>().get().route!.length;
            var i = 1;
            context.read<RouteFromToCubit>().get().route!.forEach((e) {
              final PlacemarkMapObject place = PlacemarkMapObject(
                mapId: MapObjectId('${Random().nextInt(999999)}'),
                point: Point(latitude: e.lat, longitude: e.long),
              );
              var rPoint = RequestPoint(
                  point: place.point,
                  requestPointType: RequestPointType.wayPoint);
              routeList.add(rPoint);
              i++;
            });
            mapObjects.addAll([
              ...routeList.take(max - 1).map(
                    (e) => getBlackPoint(
                      id: '${Random().nextInt(999999)}',
                      lat: e.point.latitude,
                      long: e.point.longitude,
                      dir: az,
                    ),
                  )
            ]);
            results.asMap().forEach((i, route) {
              if (i == 0)
                mapObjects.add(
                  PolylineMapObject(
                    mapId: MapObjectId('route_${i}_polyline'),
                    polyline: Polyline(
                        points:
                            route.routes!.first.geometry.toList().sublist(0)),
                    strokeColor: blue3,
                    strokeWidth: 2,
                  ),
                );
            });
            mapObjects.addAll([
              getRedPoint(
                lat: widget.startPlacemark!.point.latitude,
                long: widget.startPlacemark!.point.longitude,
                // dir: az,
              ),
              getFinishPoint(
                lat: widget.endPlacemark!.point.latitude,
                long: widget.endPlacemark!.point.longitude,
                // dir: az,
              ),
            ]);

            //--
          },
          carLoading: () {},
          geoLoaded: () {},
          geoLoading: () {},
        );

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: YandexMap(
        zoomGesturesEnabled: true,
        rotateGesturesEnabled: false,
        mapObjects: mapObjects,
        onMapCreated: (controller) {
          mapControllerCompleter.complete(controller);
          controller.getCameraPosition().then((value) {
            value.zoom;
          });
        },
      ),
    );
  }

  List<Widget> getList() {
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

  Future<void> cancel() async {
    await widget.session?.cancel();

    setState(() {
      _progress = false;
    });
  }

  Future<void> close() async {
    await widget.session?.close();
  }

  Future<void> init() async {
    await handleResult(await widget.result!);
  }

  Future<void> handleResult(DrivingSessionResult result) async {
    setState(() {
      _progress = false;
    });

    setState(() {
      results.add(result);
    });

    List<RequestPoint> routeList = [];
    var max = context.read<RouteFromToCubit>().get().route!.length;

    var i = 1;
    context.read<RouteFromToCubit>().get().route!.forEach((e) {
      final PlacemarkMapObject place = PlacemarkMapObject(
        mapId: MapObjectId('${Random().nextInt(999999)}'),
        point: Point(latitude: e.lat, longitude: e.long),
      );
      var rPoint = RequestPoint(
          point: place.point, requestPointType: RequestPointType.wayPoint);
      routeList.add(rPoint);
      i++;
    });
    var car1 = getCarPoint();

    setState(() {
      result.routes!.asMap().forEach((i, route) {
        mapObjects.clear();
        if (i == 0)
          mapObjects.add(
            PolylineMapObject(
              mapId: MapObjectId('route_${i}_polyline'),
              polyline: Polyline(points: route.geometry),
              strokeColor: blue3,
              strokeWidth: 2,
            ),
          );

        mapObjects.addAll([
          getRedPoint(
            lat: widget.startPlacemark!.point.latitude,
            long: widget.startPlacemark!.point.longitude,
          ),
          getFinishPoint(
            lat: widget.endPlacemark!.point.latitude,
            long: widget.endPlacemark!.point.longitude,
          ),
          car1,
          ...routeList.map(
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
