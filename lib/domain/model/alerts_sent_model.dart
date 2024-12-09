//
//  Modelo para almacenar las alertas enviadas por el usuario
//  Pensado para funcionar con SQLite
//  - JL
//

class AlertSent {
  final double latitude;
  final double longitude;
  final String dateSended;

  AlertSent({
    required this.latitude,
    required this.longitude,
    required this.dateSended
  });

  Map<String, Object?> toMap() {
    return {
      'dateSended': dateSended,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory AlertSent.fromMap(Map<String, Object?> map) {
    return AlertSent(
        dateSended: map['dateSended'].toString(),
        latitude: double.parse(map['latitude'].toString()),
        longitude: double.parse(map['longitude'].toString()));
  }

  @override
  String toString() {
    return '{latitude: $latitude, longitude: $longitude, dateSended: $dateSended }';
  }
}
