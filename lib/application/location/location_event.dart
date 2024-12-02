import 'package:latlong2/latlong.dart';

abstract class LocationEvent {}

class StartSendingLocation extends LocationEvent {}

class StopSendingLocation extends LocationEvent {}

class StartReceivingLocation extends LocationEvent {
  final String room;

  StartReceivingLocation(this.room);
}

class StopReceivingLocation extends LocationEvent {}

class ReceivingLocation extends LocationEvent {
  final LatLng location;

  ReceivingLocation(this.location);
}
