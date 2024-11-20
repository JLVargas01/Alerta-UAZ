//
//  Modelo para almacenar las alertas enviadas por el usuario
//  Esta pensado para funcionar con sqlite
//  - JL
//

class AlertSent {

  final String idAlertSent;
  DateTime dateSended;
  //Media mediaEnviada

  AlertSent({
    required this.idAlertSent,
    required this.dateSended,
  });

  Map<String, Object?> toMap() {
    return {
      'idAlertSent': idAlertSent,
      'dateSended': dateSended
    };
  }

  @override
  String toString() {
    return '{id: $idAlertSent, dateSended: $dateSended }';
  }

}
