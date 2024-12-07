//
//  Modelo para almacenar los contactos de confianza
//  Este modelo esta pensado para funcionar con sqlite
//  - JL
//

class MyContact {
  String uid;
  String contactId;
  String alias;
  String phone;

  MyContact({
    required this.uid,
    required this.contactId,
    required this.alias,
    required this.phone,
  });

  // Común para poder enviar los datos recolectados hacia el servidor o para guardar en local.
  Map<String, Object?> toMap() {
    return {'uid': uid, 'contactId': contactId, 'alias': alias, 'phone': phone};
  }

  // Función que transorma los datos de un map a un objecto Contact (Usado en ContactDB).
  factory MyContact.fromMap(Map<String, dynamic> map) {
    return MyContact(
        uid: map['uid'].toString(),
        contactId: map['contactId'].toString(),
        alias: map['alias'].toString(),
        phone: map['phone']);
  }

  @override
  String toString() {
    return '{uid: $uid, contactId: $contactId, alias: $alias, phone: $phone}';
  }
}
