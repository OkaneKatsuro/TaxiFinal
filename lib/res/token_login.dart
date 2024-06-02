// token_service.dart
import 'package:dio/dio.dart';

class Token {
  String rtmpLink = '';
}

var token = Token();

final url = 'https://nscar.online/StandardApiAction_login.action?account=Baitek_Mashneri&password=000000';

Future<bool> updateToken() async {
  try {
    var dio = Dio();
    var res = await dio.get(url);

    if (res.statusCode == 200) {
      token.rtmpLink = res.data['jsession'];
      return true;
    }
  } catch (e) {
    print('Ошибка: $e');
  }
  return false;
}
