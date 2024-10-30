import 'package:alerta_uaz/domain/model/user_model.dart';

abstract class LocationEvent {}

class EnabledLocation extends LocationEvent {
  final User user;

  EnabledLocation(this.user);
}

class DisabledLocation extends LocationEvent {}

class StartSendingLocation extends LocationEvent {}

class StopSendingLocation extends LocationEvent {}

class StartReceivedLocation extends LocationEvent {
  final String room;

  StartReceivedLocation(this.room);
}

class StopReceivedLocation extends LocationEvent {}

class ReceivedLocation extends LocationEvent {
  final dynamic latitude;
  final dynamic longitude;

  ReceivedLocation(this.latitude, this.longitude);
}
