//
//  Modelo para almacenar las alertas recibidas de otros usuarios
//  Esta pensado para funcionar con sqlite
//  - JL
//

class ContactAlert {
  String uid; // ID del usuario actual
  String username; // USERNAME del usuario que envío la alerta.
  String? avatar;
  double latitude;
  double longitude;
  String date;
  String? audio;

  ContactAlert({
    required this.uid,
    required this.username,
    this.avatar,
    required this.latitude,
    required this.longitude,
    required this.date,
    this.audio,
  });

  Map<String, Object?> toMap() {
    return {
      'uid': uid,
      'username': username,
      'avatar': avatar,
      'latitude': latitude,
      'longitude': longitude,
      'date': date,
      'audio': audio
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'avatar': avatar,
      'coordinates': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'date': date,
      'audio': audio
    };
  }

  @override
  String toString() {
    return '{\n'
        'username: $username,\n'
        'latitude: $latitude,\n'
        'longitude: $longitude,\n'
        'date: $date,\n'
        'audio: $audio\n'
        '}';
  }
}
