import 'package:cars/models/place.dart';
import 'package:cars/repository/api/search_api.dart';

class Repository {
  Future<List<Place>> search({required String text}) async {
    return await SearchApi.search(text: text);
  }
}
