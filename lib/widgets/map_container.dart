import 'dart:async';

import 'package:cars/bloc/app_bottom_form/app_bottom_form.dart';
import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/bloc/live_search_bloc/live_search_bloc.dart';
import 'package:cars/bloc/position_bloc/position_bloc.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/models/car.dart';

import 'package:cars/widgets/maps/car_point.dart';

import 'package:cars/widgets/maps/red_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../bloc/user/user_cubit.dart';
import '../models/role.dart';
import 'maps/models/app_lat_long.dart';
import 'maps/models/location_service.dart';

class MapContainer extends StatefulWidget {
  MapContainer({super.key, this.canChangeGeo = true});
  bool canChangeGeo;
  @override
  State<MapContainer> createState() => MapContainerState();
}

class MapContainerState extends State<MapContainer> {
  final mapControllerCompleter = Completer<YandexMapController>();

  /// Проверка разрешений на доступ к геопозиции пользователя
  Future<void> initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await fetchCurrentLocation();
  }

  /// Получение текущей геопозиции пользователя
  Future<void> fetchCurrentLocation({bool showCar = false}) async {
    AppLatLong location;
    var defLocation = MoscowLocation();

    if (!showCar &&
        context.read<CarOrderBloc>().user.getUser()!.role != Role.driver) {
      try {
        if (context.read<CarOrderBloc>().currentOrder.from == null) {
          location = await LocationService().getCurrentLocation();
        } else {
          print('-');
          location = AppLatLong(
              lat: context.read<CarOrderBloc>().currentOrder.from!.lat,
              long: context.read<CarOrderBloc>().currentOrder.from!.long);
        }
      } catch (_) {
        location = defLocation;
      }
      _moveToCurrentLocation(location);
    } else {
      print('${car.lat} - ${car.long}');
      _moveToCurrentLocation(AppLatLong(lat: car.lat, long: car.long),
          showCar: showCar);
    }
  }

  /// Метод для показа текущей позиции
  Future<void> _moveToCurrentLocation(AppLatLong appLatLong,
      {bool showCar = false}) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        context.read<CarOrderBloc>().currentOrder.from != null &&
                showCar == false
            ? CameraPosition(
                target: Point(
                  latitude:
                      context.read<CarOrderBloc>().currentOrder.from!.lat -
                          0.0015,
                  longitude:
                      context.read<CarOrderBloc>().currentOrder.from!.long,
                ),
                zoom: 15,
              )
            : CameraPosition(
                target: Point(
                  latitude: appLatLong.lat - 0.0015,
                  longitude: appLatLong.long,
                ),
                zoom: 15,
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initPermission();
  }

  final List<MapObject> mapObjects = [];
  bool initFlag = true;

  @override
  Widget build(BuildContext context) {
    if (initFlag) {
      print('initFlag=');
      initFlag = false;
      () async {
        AppLatLong location;

        if (context.read<CarOrderBloc>().user.getUser()!.role == Role.driver) {
          location = AppLatLong(lat: car.lat, long: car.long);
          try {
            setState(() {
              mapObjects.addAll([
                getCarPoint(),
              ]);
            });
          } catch (e) {}
        } else {
          if (context.read<CarOrderBloc>().currentOrder.from != null) {
            location = AppLatLong(
              lat: context.read<CarOrderBloc>().currentOrder.from!.lat,
              long: context.read<CarOrderBloc>().currentOrder.from!.long,
            );
            setState(() {
              context.read<LiveSearchBloc>().add(LiveSearchEvent.fetch(
                  text: '${location.lat} ${location.long}'));
            });
          } else {
            location = await LocationService().getCurrentLocation();
            setState(() {
              context.read<LiveSearchBloc>().add(LiveSearchEvent.fetch(
                  text: '${location.lat} ${location.long}'));
            });
          }
          try {
            setState(() {
              mapObjects.addAll([
                getRedPoint(
                  lat: location.lat,
                  long: location.long,
                ),
                getCarPoint(),
              ]);
            });
          } catch (e) {}
        }
        Future.delayed(Duration(seconds: 10), () {
          print('start fetch data');
          //  context.read<PositionBloc>().add(PositionEvent.startService());
        });
      }();
    }

    context.watch<PositionBloc>().state.when(
          allLoaded: () {},
          allLoading: () {},
          carLoaded: () {
            mapObjects.addAll([
              getCarPoint(),
            ]);
          },
          carLoading: () {},
          geoLoaded: () {},
          geoLoading: () {},
        );

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: YandexMap(
        rotateGesturesEnabled: false,
        onMapTap: (p) {
          if (widget.canChangeGeo)
            setState(() {
              context.read<LiveSearchBloc>().add(
                  LiveSearchEvent.fetch(text: '${p.latitude} ${p.longitude}'));
              mapObjects.add(getRedPoint(lat: p.latitude, long: p.longitude));
              print(mapObjects.length);
            });
        },
        mapObjects: mapObjects.toList(),
        onMapCreated: (controller) {
          mapControllerCompleter.complete(controller);
        },
      ),
    );
  }
}
