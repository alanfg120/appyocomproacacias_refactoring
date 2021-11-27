import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {

  FirebaseMessaging? messaging = FirebaseMessaging.instance;
  NotificationSettings? settings;

  final PushNotification pushNotification;

  static final PushNotification _instancia =
      new PushNotification._internal(PushNotification());

  factory PushNotification() {
    return _instancia;
  }

  PushNotification._internal(this.pushNotification);

  init() async {
    this.settings = await messaging!.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await messaging!.setForegroundNotificationPresentationOptions(
        alert: false, badge: true, sound: true);
  }

  Future<String?> getToken() async {
    return await messaging!.getToken();
  }

  StreamSubscription<RemoteMessage> onMesaje() {
    return FirebaseMessaging.onMessage.listen((event) {});
  }

  StreamSubscription<RemoteMessage> onOpenApp() {
    return FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  }

  Future<RemoteMessage?> onBackground() {
    return this.messaging!.getInitialMessage();
  }
}
