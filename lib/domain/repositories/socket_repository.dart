abstract class SocketRepository {
  void emit(String event, dynamic data);
  void on(String event, Function(dynamic) handler);
  void disconnect();
}
