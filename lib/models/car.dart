import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:intl/intl.dart';

class Car {
  static final Car _singleton = Car._internal(
      lat: 57.623805, long: 39.892861, status: true);

  factory Car() {
    return _singleton;
  }

  Car._internal({required this.lat, required this.long, required this.status});

  double lat;
  double long;
  bool status;
  String zajiganie = '';
  String temp = '';
  String toplevo = '';
  String moto = '';
  String probeg = '';
  String parkTime='';
}

//var car = Car(lat: 47.255171, long: 39.708543, status: true); - rostov
//var car = Car(lat: 57.6261, long: 39.8845, status: true); -iaroslavl

//https://support.fort-monitor.ru/article/30787
//https://web.fort-monitor.ru/api/help/index#/ExternalApiV1
//https://web.fort-monitor.ru/newinterface/mainx/buildmainx/index.html


var car = Car();


final url = 'https://web.fort-monitor.ru/api/integration/v1/connect?login=fratellimon&password=23fratelmnt32&lang=ru-ru&timezone=+3';


Future<bool> updateCarLocation() async {
  try {

    var dio = Dio();
    var cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    var res = await dio.get(url);

    if (res.statusCode == 200) {
      res = await dio.get(
          'https://web.fort-monitor.ru/api/integration/v1/gettree?all=true');


      if (res.statusCode == 200) {
        var data = res.data;
        if (data != null &&
            data['children'] != null &&
            data['children'][0] != null &&
            data['children'][0]['children'] != null &&
            data['children'][0]['children'][0] != null &&
            data['children'][0]['children'][0]['children'] != null) {
          car.lat = data['children'][0]['children'][0]['children'][0]['lat'];
          car.long =
          data['children'][0]['children'][0]['children'][0]['lon'];
          var id = data['children'][0]['children'][0]['children'][0]['real_id'];
          print('========================');
          print(car.lat);
          print(car.long);
          print(id);

        }
      }

    }
  } catch (e) {
    print('Ошибка1: $e');
  }
  return false;
}


Future<bool> carStatUpdate() async {
  try{
    var dio = Dio();
    var cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    var res = await dio.get(url);


      res = await dio.get(
          'https://web.fort-monitor.ru/api/integration/v1/objectinfo?oid=98681');

      if (res.statusCode == 200) {

        var sensors = res.data['sensors'];
        print(sensors);
        if (sensors != null && sensors.length > 7) {
          car.zajiganie = sensors[15]['val'].toString().substring(2);
          print('AAAAAA');
          print(car.zajiganie);
          car.temp = sensors[5]['val'];
          print('BBBBBB');
          print(car.temp);
          car.toplevo = sensors[11]['val'];
          print('CCCCCC');
          print(car.toplevo);
          car.moto = sensors[17]['val'];
          print('EEEEE');
          print(car.moto);
          car.probeg = sensors[25]['val'];
          print('DDDDDDD');
          print(car.probeg);
          car.parkTime = sensors[0]['val'];
          print('FFFFF');
          print(car.parkTime);
          return true;
        }
      }
  }
  catch (e) {
    print('Ошибка2: $e');
  }
  return false;

}