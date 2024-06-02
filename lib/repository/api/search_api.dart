import 'package:cars/models/place.dart';
import 'package:dio/dio.dart';



import '../../res/config.dart';

class SearchApi {
  static Future<List<Place>> search({required String text}) async {
    var dio = Dio();
    var res = await dio.get(
        '$searchHost?lang=ru_RU&ll=39.8845,57.6261&spn=0.552069,0.400552&apikey=$searchApiKey&text=$text');
    List<Place> list = [];
    for (var json in (res.data['features'] as List<dynamic>)) {
      Place place = Place.fromYandexJson(json as Map<String, dynamic>);
      list.add(place);
    }
    return list;
  }
}
