//
//  Modelo para almacenar las alertas recibidas de otros usuarios
//  Esta pensado para funcionar con sqlite
//  - JL
//

class ContactAlert {
  String userId;
  String username;
  double latitude;
  double longitude;
  //Media mediaRecivida

  ContactAlert(this.userId, this.username, this.latitude, this.longitude);

  Map<String, Object?> toMap() {
    return {
      'userId': userId,
      'username': username,
      'latitude': latitude,
      'longitude': longitude
    };
  }

  factory ContactAlert.fromMap(Map<String, dynamic> map) {
    return ContactAlert(
      map['userId'].toString(),
      map['username'].toString(),
      double.parse(map['coordinates_latitude'].toString()),
      double.parse(map['coordinates_longitude'].toString()),
    );
  }

  @override
  String toString() {
    return '{ userId: $userId, username: $username, latitude: $latitude, longitude: $longitude }';
  }
}
