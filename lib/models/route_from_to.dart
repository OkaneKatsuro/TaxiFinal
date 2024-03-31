import 'package:cars/models/place.dart';

class RouteFromTo {
  Place? from;
  Place? to;
  String? comment;
  RouteFromTo({
    required this.from,
    required this.to,
    this.comment,
  });
}
