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
  String? audio;

  MyAlert({
    required this.uid,
    required this.latitude,
    required this.longitude,
    required this.date,
    this.audio,
  });

  Map<String, Object?> toMap() {
    return {
      'uid': uid,
      'latitude': latitude,
      'longitude': longitude,
      'date': date,
      'audio': audio,
    };
  }

  @override
  String toString() {
    return '{\n'
        '\tlatitude: $latitude\n'
        '\tlongitude: $longitude\n'
        '\tdate: $date\n'
        '\taudio: $audio\n'
        '}';
  }
}
