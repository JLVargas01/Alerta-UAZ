import 'package:latlong2/latlong.dart';

abstract class LocationState {}

// Estados escenciales
class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationStarted extends LocationState {
  final String room;

  LocationStarted(this.room);
}

class LocationReceived extends LocationState {
  final LatLng location;

  LocationReceived(this.location);
}

class LocationError extends LocationState {
  final String error;

  LocationError(this.error);
}
