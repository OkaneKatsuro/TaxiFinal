import 'dart:async';

import 'package:cars/models/place.dart';
import 'package:cars/repository/api/search_api.dart';
import 'package:cars/repository/repo.dart';
import 'package:cars/widgets/maps/models/app_lat_long.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../bloc/app_bottom_form/app_bottom_form.dart';
import '../bloc/route_from_to/route_from_to.dart';
import '../widgets/maps/models/app_location.dart';
import '../widgets/maps/models/location_service.dart';
import 'styles.dart';

Future<Place> getCurrentPoint() async {
  var location = await LocationService().getCurrentLocation();
  var result = await SearchApi.search(text: '${location.lat} ${location.long}');
  return result[0];
}

class Utils {
  Utils({required this.context});
  BuildContext context;
  final mapControllerCompleter = Completer<YandexMapController>();

  /// Проверка разрешений на доступ к геопозиции пользователя
  Future<void> initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  /// Получение текущей геопозиции пользователя
  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    var defLocation = MoscowLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location);
  }

  /// Метод для показа текущей позиции
  Future<void> _moveToCurrentLocation(
    AppLatLong appLatLong,
  ) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        context.read<AppBottomFormCubit>().get() == ShowBottomForm.orderNow
            ? CameraPosition(
                target: Point(
                  // latitude: car.lat,
                  // longitude: car.long,
                  latitude: appLatLong.lat,
                  longitude: appLatLong.long,
                ),
                zoom: 15,
              )
            : context.read<RouteFromToCubit>().get().from != null
                ? CameraPosition(
                    target: Point(
                      latitude:
                          context.read<RouteFromToCubit>().get().from!.lat,
                      longitude:
                          context.read<RouteFromToCubit>().get().from!.long,
                    ),
                    zoom: 15,
                  )
                : CameraPosition(
                    target: Point(
                      latitude: appLatLong.lat,
                      longitude: appLatLong.long,
                    ),
                    zoom: 15,
                  ),
      ),
    );
  }
}

showBadOrderMessage(context, res) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: 5),
    content: Container(
      width: 300,
      height: 150,
      color: Colors.white,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text(
            'Заказ в это время не возможен!',
            style: h17w500Black,
          ),
          SizedBox(height: 3),
          Text(
            'т.к ранее был запланирован другой заказ:',
            style: h14w400Black.copyWith(color: grey),
          ),
          SizedBox(height: 20),
          Text(
            '${DateFormat('hh:mm, dd MMM').format(res.startDate!)} - ${DateFormat('hh:mm, dd MMM').format(res.endDate!)} \n${res.passName}',
            style: h15w500Black,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    backgroundColor: Colors.white,
  ));
}
