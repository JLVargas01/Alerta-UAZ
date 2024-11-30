//
//  Modelo para almacenar las alertas enviadas por el usuario
//  Esta pensado para funcionar con sqlite
//  - JL
//

class AlertSent {

  String latitude;
  String longitude;
  //final String idAlertSent;
  //DateTime dateSended;
  //Media mediaEnviada

  AlertSent({
    //required this.idAlertSent,
    //required this.dateSended,
    required this.latitude,
    required this.longitude,
  });

  Map<String, Object?> toMap() {
    return {
      //'idAlertSent': idAlertSent,
      //'dateSended': dateSended'
      'latitude': latitude,
      'longitude': longitude
    };
  }

  @override
  String toString() {
    //return '{id: $idAlertSent, dateSended: $dateSended }';
    return '{latitude: $latitude, longitude: $longitude }';
  }

}
