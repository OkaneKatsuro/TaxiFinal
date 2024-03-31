import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class ChatNotificationController {
  static Future<void> initialize() async {
    // Инициализация Awesome Notifications
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'chat_channel',
          channelName: 'Chat notifications',
          channelDescription: 'Notification channel for chat messages',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
      ],
    );
  }

  static Future<void> sendChatNotification({
    required String sender,
    required String message,
  }) async {
    // Проверка разрешения на отправку уведомлений
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // Если разрешение не предоставлено, запрашиваем его у пользователя
      isAllowed = await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    if (isAllowed) {
      // Создание уведомления для сообщения из чата
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch,
          channelKey: 'chat_channel',
          title: sender,
          body: message,
        ),
      );
    } else {
      // В случае отказа от предоставления разрешения
      print('Пользователь отказал в предоставлении разрешения на отправку уведомлений.');
    }
  }
}
