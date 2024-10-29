import 'package:alerta_uaz/domain/model/user_model.dart';

abstract class LocationEvent {}

class EnabledLocation extends LocationEvent {
  final User user;

  EnabledLocation(this.user);
}

class DisabledLocation extends LocationEvent {}

class StartSendingLocation extends LocationEvent {}

class StopSendingLocation extends LocationEvent {}

class ReceivedLocation extends LocationEvent {}
