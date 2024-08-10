import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:volume_control/model/util/string_resources.dart';

final _notiPlugin = FlutterLocalNotificationsPlugin();

class NotificationServices {
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  static Future<void> init() async {
    var andriodInit =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    final darvinInit = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, paload) =>
            showNotification(
                id: id,
                title: title ?? '',
                body: body ?? '',
                payload: paload ?? ''));
    final initSettings =
        InitializationSettings(android: andriodInit, iOS: darvinInit);
    await _notiPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      logPrint('notification payload: $payload');
    }
  }

  static void showNotification(
      {required int id,
      required String title,
      String? body,
      String? payload}) async {
    // display a dialog with the notification details, tap ok to go to another page
    const androidDetails = AndroidNotificationDetails(
      StringRes.channelId,
      StringRes.channelName,
      channelDescription: StringRes.channelDesc,
      importance: Importance.high,
    );
    const iosDetails = DarwinNotificationDetails(
      categoryIdentifier: StringRes.channelId,
      interruptionLevel: InterruptionLevel.active,
    );
    const notiDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _notiPlugin.show(id, title, body, notiDetails, payload: payload);
  }
}
