import 'package:alerta_uaz/data/data_sources/remote/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../data_sources/remote/firebase_messaging_service.dart';
import '../../domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationRepository {
  final FirebaseMessagingService _firebaseMessagingService;
  final NotificationService _notificationService;

  NotificationsRepositoryImpl(
      this._firebaseMessagingService, this._notificationService);

  @override
  Stream<RemoteMessage> getNotificationStream() {
    return _firebaseMessagingService.notificationStream;
  }

  @override
  Future<void> initialize() async {
    await _firebaseMessagingService.initialize();
  }

  @override
  Future<bool> requestPermission() async {
    return await _firebaseMessagingService.requestPermission();
  }

  @override
  Future<String?> getDeviceToken() async {
    return await _firebaseMessagingService.getDeviceToken();
  }

  @override
  Future<void> deleteDeviceToken() async {
    await _firebaseMessagingService.deleteDeviceToken();
  }

  @override
  Future<void> notificationAlert() async {
    await _notificationService.notificationAlert();
  }
}
