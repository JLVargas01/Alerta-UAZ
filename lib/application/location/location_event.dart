import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:latlong2/latlong.dart';

abstract class LocationEvent {}

class EnabledLocation extends LocationEvent {
  final User user;

  EnabledLocation(this.user);
}

class DisabledLocation extends LocationEvent {}

// Eventos escenciales
class StartSendingLocation extends LocationEvent {}

class StopSendingLocation extends LocationEvent {}

class StartReceivingLocation extends LocationEvent {
  final String room;

  StartReceivingLocation(this.room);
}

class StopReceivingLocation extends LocationEvent {}

// Eventos hechos para callbacks
class ReceivedLocation extends LocationEvent {
  final LatLng location;

  ReceivedLocation(this.location);
}
