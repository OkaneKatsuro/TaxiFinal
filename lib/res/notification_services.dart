import 'dart:convert';
import 'package:cars/pages/plan_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../bloc/user/user_cubit.dart';

final userCubit = UserCubit();

Future<void> sendNotificationToDriverPlaning() async {
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
    print(userName);

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
        "headings": {"en": 'Запланирована новая поездка!'},
        "contents": {"en": '$userName создал новый заказ. Проверьте и подтвердите.'},
      }),
    );
  } catch (e) {
    print('Error sending notification: $e');
    throw e;
  }
}
Future<void> sendNotificationToDriver() async {
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
    print(userName);

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
        "contents": {"en": '$userName создал новый заказ. Проверьте и подтвердите.'},
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
        "headings": {"en": 'Отмена Поездки!'},
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

Future<void> sendNotificationToDriverCancelFromList() async {
  final currentUser = userCubit.getUser();
  String? userName;

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
    print(userName);

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
        "headings": {"en": 'Отмена запланированной поездки!'},
        "contents": {"en": '$userName отменил запланированную поездку!'},
      }),
    );
  } catch (e) {
    print('Error sending notification: $e');
    throw e;
  }
}

Future<void> sendNotificationToPassStartOrder({required String? orderId}) async {
  final currentUser = userCubit.getUser();
  String? userName;
  String? userId;

  if (currentUser != null) {
    userName = currentUser.name;
    userId = currentUser.id;// Получение имени текущего пользователя
    print('Имя текущего пользователя: $userName');
  } else {
    print('Текущий пользователь не найден.');
  }

  List<String> oneSignalIds = [];
  final String kAppId = "44659ce6-937c-4e6f-a97c-9893a3ed5f02"; // Замените на свой App ID OneSignal
  final String oneSignalUrl = 'https://onesignal.com/api/v1/notifications';



  QuerySnapshot<Map<String, dynamic>> ordersSnapshot =
  await FirebaseFirestore.instance.collection('orders').get();

  for (QueryDocumentSnapshot<Map<String, dynamic>> orderSnapshot
  in ordersSnapshot.docs) {
    if (orderSnapshot.id == orderId) { // Проверяем, совпадает ли id заказа с переданным orderId
      String? passOrderId = orderSnapshot.data()['passId'];
      print('AUE$passOrderId');
      if (passOrderId != null && passOrderId.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> passDocumentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(passOrderId).get();

// Проверка, существует ли документ с passId
        if (passDocumentSnapshot.exists) {
          // Получение oneId из найденного документа
          String? oneId = passDocumentSnapshot.data()?['oneId'];
          if (oneId != null && oneId.isNotEmpty) {
            // Добавление oneId в список
            oneSignalIds.add(oneId);
          }
        } else {
          // Документ с passId не найден
        }
      }
      break; // Выходим из цикла, так как нашли нужный заказ
    }
  }

  try {
    print('00000000000000000000');
    print('отправка ');
    print(kAppId,);
    print(oneSignalIds);
    print(userName);

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
        "contents": {"en": 'Водител $userName принял заказ!'},
      }),
    );
    print('Водител $userName принял заказ!');
  } catch (e) {
    print('Error sending notification: $e');
    throw e;
  }
}


void handleOneSignalNotification(OSNotificationClickEvent event) {
  print('Received OneSignal notification:');
  print('Notification ID: ${event.notification.notificationId}');
  print('Title: ${event.notification.title}');
  print('Additional Data: ${event.notification.additionalData}');

  // Получаем заголовок уведомления
  String? title = event.notification.title;

  // Определяем, какую страницу открыть в зависимости от заголовка
  if (title == 'Отмена запланированной поездки!' || title == 'Запланирована новая поездка!' ) {
    Get.to(PlanPage());
  }

  }



