//
//  Modelo para almacenar las alertas enviadas por el usuario
//  Esta pensado para funcionar con sqlite
//  - JL
//

class MyAlert {
  String uid; // ID del usuario actual
  double latitude;
  double longitude;
  String date;
  String audioPath;

  MyAlert({
    required this.uid,
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.audioPath,
  });

  Map<String, Object?> toMap() {
    return {
      'uid': uid,
      'latitude': latitude,
      'longitude': longitude,
      'date': date,
      'audio': audioPath,
    };
  }

  @override
  String toString() {
    return '{latitude: $latitude, longitude: $longitude, date: $date, audio: $audioPath }';
  }
}
