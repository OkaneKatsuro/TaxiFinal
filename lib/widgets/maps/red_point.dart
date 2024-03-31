import 'dart:math';

import 'package:yandex_mapkit/yandex_mapkit.dart';

MapObjectId mapObjectId = const MapObjectId('point');
MapObjectId mapObjectIdF = const MapObjectId('pointF');
getRedPoint({
  required double lat,
  required double long,
  int dir = 0,
}) {
  return PlacemarkMapObject(
    mapId: mapObjectId,
    point: Point(latitude: lat, longitude: long),
    opacity: 1,
    isDraggable: true,
    direction: dir.toDouble(),
    icon: PlacemarkIcon.single(
      PlacemarkIconStyle(
        image: BitmapDescriptor.fromAssetImage('asstes/point.png'),
        scale: 0.28,
        rotationType: RotationType.rotate,
      ),
    ),
  );
}

getBlackPoint({
  required double lat,
  required double long,
  String id = '',
  int dir = 0,
}) {
  return PlacemarkMapObject(
    mapId: MapObjectId('${Random().nextInt(99999)}point'),
    point: Point(latitude: lat, longitude: long),
    opacity: 0.7,
    isDraggable: true,
    direction: dir.toDouble(),
    icon: PlacemarkIcon.single(
      PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('asstes/point_black.png'),
          scale: 0.28,
          rotationType: RotationType.rotate),
    ),
  );
}

getFinishPoint({required double lat, required double long, int dir = 0}) {
  return PlacemarkMapObject(
    mapId: mapObjectIdF,
    point: Point(latitude: lat, longitude: long),
    opacity: 1,
    direction: dir.toDouble(),
    isDraggable: true,
    icon: PlacemarkIcon.single(PlacemarkIconStyle(
        image: BitmapDescriptor.fromAssetImage('asstes/finish.png'),
        scale: 0.12,
        rotationType: RotationType.rotate)),
  );
}
