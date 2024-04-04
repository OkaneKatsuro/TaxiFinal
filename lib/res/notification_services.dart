import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../bloc/user/user_cubit.dart';

final userCubit = UserCubit();

Future<void> sendNotificationToDriver({required String passName, required String passFName}) async {
  final currentUser = userCubit.getUser();
  String? userName; // Объявляем переменную userName здесь, чтобы она была доступна во всей функции

  if (currentUser != null) {
    userName = currentUser.name; // Получение имени текущего пользователя
    print('Имя текущего пользователя: $userName');
  } else {
    print('Текущий пользователь не найден.');
  }

  List<String> oneSignalIds = [];
  final String kAppId = "44659ce6-937c-4e6f-a97c-9893a3ed5f02"; // Замените на свой App ID OneSignal
  final String oneSignalUrl = 'https://onesignal.com/api/v1/notifications';


  QuerySnapshot<Map<String, dynamic>> usersSnapshot =
  await FirebaseFirestore.instance
      .collection('users')
      .where('is_pass', isEqualTo: false)
      .get();

  for (QueryDocumentSnapshot<Map<String, dynamic>> userSnapshot
  in usersSnapshot.docs) {
    String? oneSignalId = userSnapshot.data()['oneId'];
    if (oneSignalId != null && oneSignalId.isNotEmpty) {
      oneSignalIds.add(oneSignalId);
    }
  }

  try {
    print('00000000000000000000');
    print('отправка ');
    print(kAppId,);
    print(oneSignalIds);
    print(userName); // Теперь userName доступна здесь

    print('ХХХХХХХХХХХХХХХХХХХХ');
    print('00000000000000');

    await http.post(
      Uri.parse(oneSignalUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',

      },
      body: jsonEncode(<String, dynamic>{
        "app_id": kAppId,
        "include_player_ids": oneSignalIds,
        "android_accent_color": "FF9976D2",
        "small_icon": "ic_stat_onesignal_default",
        "large_icon": "https://i.ibb.co/DRNmm9Y/icon.png",
        "headings": {"en": 'Новый заказ!'},
        "contents": {"en": ' $userName создал новый заказ. Проверьте и подтвердите.'},
      }),
    );
  } catch (e) {
    print('Error sending notification: $e');
    throw e;
  }
}

Future<void> sendNotificationToDriverCancel({required String? driverId}) async {
  final currentUser = userCubit.getUser();
  String? userName; // Объявляем переменную userName здесь, чтобы она была доступна во всей функции

  if (currentUser != null) {
    userName = currentUser.name; // Получение имени текущего пользователя
    print('Имя текущего пользователя: $userName');
  } else {
    print('Текущий пользователь не найден.');
  }

  List<String> oneSignalIds = [];
  final String kAppId = "44659ce6-937c-4e6f-a97c-9893a3ed5f02"; // Замените на свой App ID OneSignal
  final String oneSignalUrl = 'https://onesignal.com/api/v1/notifications';


  DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
  await FirebaseFirestore.instance
      .collection('users')
      .doc(driverId)
      .get();

  // Если документ существует и содержит поле oneId, добавляем его значение в список идентификаторов OneSignal
  if (userDocSnapshot.exists && userDocSnapshot.data() != null) {
    String? oneSignalId = userDocSnapshot.data()!['oneId'];
    if (oneSignalId != null && oneSignalId.isNotEmpty) {
      oneSignalIds.add(oneSignalId);
    }
  }

  try {
    print('00000000000000000000');
    print('отправка отмены');
    print(kAppId,);
    print(oneSignalIds);
    print('driver: $driverId'); // Теперь userName доступна здесь

    print('ХХХХХХХХХХХХХХХХХХХХ');
    print('00000000000000');

    await http.post(
      Uri.parse(oneSignalUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',

      },
      body: jsonEncode(<String, dynamic>{
        "app_id": kAppId,
        "include_player_ids": oneSignalIds,
        "android_accent_color": "FF9976D2",
        "small_icon": "ic_stat_onesignal_default",
        "large_icon": "https://i.ibb.co/DRNmm9Y/icon.png",
        "headings": {"en": 'Отмена Поездки !'},
        "contents": {"en": ' $userName отменил заказ!'},
      }),
    );
  } catch (e) {
    print('Error sending notification: $e');
    throw e;
  }
}

Future<void> sendNotificationToPassCancel({required String? userId}) async {
  final currentUser = userCubit.getUser();
  String? userName; // Объявляем переменную userName здесь, чтобы она была доступна во всей функции

  if (currentUser != null) {
    userName = currentUser.name; // Получение имени текущего пользователя
    print('Имя текущего пользователя: $userName');
  } else {
    print('Текущий пользователь не найден.');
  }

  List<String> oneSignalIds = [];
  final String kAppId = "44659ce6-937c-4e6f-a97c-9893a3ed5f02"; // Замените на свой App ID OneSignal
  final String oneSignalUrl = 'https://onesignal.com/api/v1/notifications';


  DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .get();

  // Если документ существует и содержит поле oneId, добавляем его значение в список идентификаторов OneSignal
  if (userDocSnapshot.exists && userDocSnapshot.data() != null) {
    String? oneSignalId = userDocSnapshot.data()!['oneId'];
    if (oneSignalId != null && oneSignalId.isNotEmpty) {
      oneSignalIds.add(oneSignalId);
    }
  }

  try {
    print('00000000000000000000');
    print('отправка отмены');
    print(kAppId,);
    print(oneSignalIds);
    print('driver: $userId'); // Теперь userName доступна здесь

    print('ХХХХХХХХХХХХХХХХХХХХ');
    print('00000000000000');

    await http.post(
      Uri.parse(oneSignalUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',

      },
      body: jsonEncode(<String, dynamic>{
        "app_id": kAppId,
        "include_player_ids": oneSignalIds,
        "android_accent_color": "FF9976D2",
        "small_icon": "ic_stat_onesignal_default",
        "large_icon": "https://i.ibb.co/DRNmm9Y/icon.png",
        "headings": {"en": 'Отмена Поездки !'},
        "contents": {"en": 'Водитель $userName отменил заказ!'},
      }),
    );
  } catch (e) {
    print('Error sending notification: $e');
    throw e;
  }
}

