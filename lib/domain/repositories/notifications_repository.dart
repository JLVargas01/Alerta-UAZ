import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationRepository {
  Stream<RemoteMessage> getNotificationStream();
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<String?> getDeviceToken();
  Future<void> deleteDeviceToken();
}
