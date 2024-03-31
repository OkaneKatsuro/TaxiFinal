import 'package:cars/models/car.dart';
import 'package:cars/models/parking.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

MapObjectId mapObjectId = const MapObjectId('parking');
getParkingPoint() {
  return PlacemarkMapObject(
    mapId: mapObjectId,
    point: Point(latitude: parking.lat, longitude: parking.long),
    opacity: 1,
    //direction: 90,
    isDraggable: true,
    // icon: PlacemarkIcon.single(
    //   PlacemarkIconStyle(
    //       image: BitmapDescriptor.fromAssetImage('asstes/car.png'),
    //       scale: 0.12,
    //       rotationType: RotationType.rotate),
    // ),
  );
}
