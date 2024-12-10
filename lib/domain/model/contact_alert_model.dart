//
//  Modelo para almacenar las alertas recibidas de otros usuarios
//  Esta pensado para funcionar con sqlite
//  - JL
//

class ContactAlert {
  String uid; // ID del usuario actual
  String username; // USERNAME del usuario que envío la alerta.
  double latitude;
  double longitude;
  String date;
  //Media mediaRecivida

  ContactAlert({
    required this.uid,
    required this.username,
    required this.latitude,
    required this.longitude,
    required this.date,
  });

  Map<String, Object?> toMap() {
    return {
      'uid': uid,
      'username': username,
      'latitude': latitude,
      'longitude': longitude,
      'date': date,
    };
  }

  @override
  String toString() {
    return '{ username: $username, latitude: $latitude, longitude: $longitude, date: $date }';
  }
}
