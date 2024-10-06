import '../../domain/repositories/socket_repository.dart';
import '../data_sources/remote/socket_service.dart';

class SocketRepositoryImpl implements SocketRepository {
  final SocketService _socketService;

  SocketRepositoryImpl(this._socketService);

  @override
  void emit(String event, data) {
    _socketService.emit(event, data);
  }

  @override
  void on(String event, Function(dynamic) handler) {
    _socketService.on(event, handler);
  }

  @override
  void disconnect() {
    _socketService.disconnect();
  }
}
