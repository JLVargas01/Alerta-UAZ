//
//  Modelo para almacenar las alertas enviadas por el usuario
//  Esta pensado para funcionar con sqlite
//  - JL
//

class MyAlert {
  String userId;
  double latitude;
  double longitude;
  //DateTime dateSended;
  //Media mediaEnviada

  MyAlert(this.userId, this.latitude, this.longitude);

  Map<String, Object?> toMap() {
    return {'userId': userId, 'latitude': latitude, 'longitude': longitude};
  }

  factory MyAlert.fromMap(Map<String, dynamic> map) {
    return MyAlert(map['userId'], map['coordinates']['latitude'],
        map['coordinates']['longitude']);
  }

  @override
  String toString() {
    return '{latitude: $latitude, longitude: $longitude }';
  }
}
