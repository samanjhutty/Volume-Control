import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:volume_control/model/util/app_constants.dart';

final _notiPlugin = FlutterLocalNotificationsPlugin();

class NotificationServices {
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, paload) =>
                showNotification(
                    id: id,
                    title: title ?? '',
                    body: body ?? '',
                    payload: paload ?? ''));
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await _notiPlugin.initialize(initializationSettings,
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
      required String body,
      required String payload}) async {
    // display a dialog with the notification details, tap ok to go to another page
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      AppConstants.channelId,
      AppConstants.channelName,
      channelDescription: AppConstants.channelDesc,
      importance: Importance.high,
    );
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: AppConstants.channelId,
      interruptionLevel: InterruptionLevel.active,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
    await _notiPlugin.show(id, title, body, notificationDetails,
        payload: payload);
  }
}
