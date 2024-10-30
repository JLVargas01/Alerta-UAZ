abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationConnected extends LocationState {
  final String room;

  LocationConnected(this.room);
}

class LocationDisconnected extends LocationState {}

class LocationReceived extends LocationState {
  final dynamic latitude;
  final dynamic longitude;

  LocationReceived(this.latitude, this.longitude);
}

class LocationError extends LocationState {
  final String error;

  LocationError(this.error);
}
