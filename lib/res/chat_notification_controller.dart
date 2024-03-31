import 'package:awesome_notifications/awesome_notifications.dart';

class ChatNotificationController {
  static Future<void> sendChatNotification({
    required String sender,
    required String message,
  }) async {
    // Создаем уведомление
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch,
        channelKey: 'chats',
        title: sender,
        body: message,
      ),
    );
  }
}
