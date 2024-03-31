import 'package:cars/models/car.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

MapObjectId mapObjectId = const MapObjectId('car');
getCarPoint({int dir = 0}) {
  return PlacemarkMapObject(
    mapId: mapObjectId,
    point: Point(latitude: car.lat, longitude: car.long),
    opacity: 1,
    direction: dir.toDouble(),
    isDraggable: true,
    icon: PlacemarkIcon.single(PlacemarkIconStyle(
        image: BitmapDescriptor.fromAssetImage('asstes/car.png'),
        scale: 0.12,
        rotationType: RotationType.rotate)),
  );
}

MapObjectId mapObjectId1 = const MapObjectId('car1');
getCarPoint1({int dir = 0}) {
  return PlacemarkMapObject(
    mapId: mapObjectId1,
    point: Point(latitude: car.lat, longitude: car.long),
    opacity: 1,
    direction: dir.toDouble(),
    isDraggable: true,
    icon: PlacemarkIcon.single(PlacemarkIconStyle(
        image: BitmapDescriptor.fromAssetImage('asstes/car.png'),
        scale: 0.12,
        rotationType: RotationType.rotate)),
  );
}
