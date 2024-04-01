import 'package:awesome_notifications/awesome_notifications.dart';

class ChatNotificationController {
  static int _notificationId = 1; // Начальное значение для уникального идентификатора уведомления

  static Future<void> sendChatNotification({
    required String sender,
    required String message,
  }) async {
    // Увеличиваем идентификатор уведомления на единицу
    _notificationId++;

    // Создаем уведомление
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _notificationId,
        channelKey: 'basic_channel',
        title: sender,
        body: message,
      ),
    );
  }
}