import 'dart:convert';

import 'package:cars/models/place.dart';
import 'package:cars/widgets/car_status.dart';

class CarOrder {
  DateTime? startDate;
  DateTime? endDate;
  int? lengthSec;
  Place? from;
  List<Place>? route;
  CarOrderStatus status;
  String? comment;
  String? driverName;
  String? passName;
  String? id;
  String? passId;
  String? driverId;
  bool? isCarFree;
  int? arriveTime;
  int? backTime;
  CarOrder({
    this.startDate,
    this.endDate,
    this.lengthSec,
    this.driverName,
    this.passName,
    this.route,
    this.from,
    this.comment,
    required this.status,
    this.id,
    this.passId,
    this.driverId,
    this.isCarFree,
    this.arriveTime,
    this.backTime,
  });

  Map<String, dynamic> toJson() {
    var routeStr = '';
    route?.forEach((element) {
      if (routeStr.isNotEmpty) {
        routeStr = routeStr + ',' + element.toJson().toString();
      } else {
        routeStr = element.toJson().toString();
      }
    });
    routeStr = '[$routeStr]';
    return {
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'lengthSec': lengthSec,
      'driverName': driverName,
      'from': from?.toJson(),
      'route': routeStr,
      'comment': comment,
      'status': status.name,
      'passName': passName,
      'id': id,
      'passId': passId,
      'driverId': driverId,
      'arriveTime': arriveTime,
      'backTime': backTime,
    };
  }

  factory CarOrder.fromJson(Map<String, dynamic> json) {
    CarOrderStatus status = switch (json['status']) {
      'waiting' => CarOrderStatus.waiting,
      'active' => CarOrderStatus.active,
      _ => CarOrderStatus.planed,
    };
    List<Place>? route = jsonDecode(json['route'])
        .map((data) => Place.fromJson(data))
        .toList()
        .cast<Place>();

    print('type=${route.runtimeType}');
    CarOrder carOrder = CarOrder(
      status: status,
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(
        json['endDate'],
      ),
      lengthSec: json['lengthSec'],
      driverName: json['driverName'],
      passName: json['passName'],
      route: route,
      from: Place.fromJson(jsonDecode(json['from'].toString())),
      comment: json['comment'],
      id: json['id'],
      passId: json['passId'],
      driverId: json['driverId'],
      arriveTime: json['arriveTime'],
      backTime: json['backTime'],
    );

    return carOrder;
  }
}

enum CarOrderStatus {
  empty,
  active,
  waiting,
  planed,
}
