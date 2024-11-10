abstract class LocationRepository {
  void startSendLocation(String room, String username);
  void stopSendLocation();
  void startReceivedLocation(
      String room, String username, Function(dynamic) handler);
  void stopReceivedLocation();
}
