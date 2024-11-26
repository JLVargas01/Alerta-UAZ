//
//  Modelo para almacenar las alertas recividas de otros usuarios
//  Esta pensado para funcionar con sqlite
//  - JL
//

class AlertReceived {

  final String idAlertReceived;
  final String idAlerta;
  String aliasContact;
  String nameUser;
  DateTime dateReceived;
  //Media mediaRecivida

  AlertReceived({
    required this.idAlertReceived,
    required this.idAlerta,
    required this.aliasContact,
    required this.nameUser,
    required this.dateReceived,
  });

  Map<String, Object?> toMap() {
    return {
      'idAlertReceived': idAlertReceived,
      'aliasContact': aliasContact,
      'nameUser': nameUser,
      'dateReceived': dateReceived
    };
  }

  @override
  String toString() {
    return '{id: $idAlertReceived, idAlerta: $idAlerta aliasContact: $aliasContact, nameUser: $nameUser, dateReceived: $dateReceived }';
  }

}

