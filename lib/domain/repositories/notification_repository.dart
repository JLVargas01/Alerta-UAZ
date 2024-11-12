abstract class NotificationRepository {
  Future<void> sendAlert(String contacts, Map<String, dynamic> data);
}
