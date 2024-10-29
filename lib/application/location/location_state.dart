abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationConnected extends LocationState {
  final String room;

  LocationConnected(this.room);
}

class LocationDisconnected extends LocationState {}

class LocationReceived extends LocationState {
  final Map<String, dynamic> coordinates;

  LocationReceived(this.coordinates);
}

class LocationError extends LocationState {
  final String error;

  LocationError(this.error);
}
