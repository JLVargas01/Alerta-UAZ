//
//  Modelo para almacenar las alertas enviadas por el usuario
//  Esta pensado para funcionar con sqlite
//  - JL
//

class AlertSent {
  String userId;
  double latitude;
  double longitude;
  //final String idAlertSent;
  //DateTime dateSended;
  //Media mediaEnviada

  AlertSent(
      {required this.userId, required this.latitude, required this.longitude});

  Map<String, Object?> toMap() {
    return {
      //'idAlertSent': idAlertSent,
      //'dateSended': dateSended'
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude
    };
  }

  factory AlertSent.fromMap(Map<String, Object?> map) {
    return AlertSent(
        userId: map['userId'].toString(),
        latitude: double.parse(map['latitude'].toString()),
        longitude: double.parse(map['longitude'].toString()));
  }

  @override
  String toString() {
    //return '{id: $idAlertSent, dateSended: $dateSended }';
    return '{latitude: $latitude, longitude: $longitude }';
  }
}
