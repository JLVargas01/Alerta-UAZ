//
//  Modelo para almacenar los contactos de confianza
//  Este modelo esta pensado para funcionar con sqlite
//  - JL
//

/// Representa un contacto asociado a un usuario dentro del sistema.
/// Contiene información como el identificador, alias y número telefónico.
class MyContact {
  /// ID del usuario al que pertenece el contacto.
  String uid;

  /// Identificador único del contacto.
  String contactId;

  /// Nombre o alias asignado al contacto.
  String alias;

  /// Número de teléfono del contacto.
  String phone;

  /// Constructor de la clase 'MyContact'.
  MyContact({
    required this.uid,
    required this.contactId,
    required this.alias,
    required this.phone,
  });

  /// Convierte la información del contacto en un 'Map<String, Object?>',
  /// útil para almacenamiento en bases de datos locales o envío al servidor.
  /// [return] Un mapa con los datos del contacto.
  Map<String, Object?> toMap() {
    return {
      'uid': uid,
      'contactId': contactId,
      'alias': alias,
      'phone': phone,
    };
  }

  /// Crea una instancia de 'MyContact' a partir de un 'Map<String, dynamic>'.
  /// [map] Mapa con los datos del contacto obtenidos desde la base de datos o servidor.
  /// [return] Una nueva instancia de 'MyContact'.
  factory MyContact.fromMap(Map<String, dynamic> map) {
    return MyContact(
      uid: map['uid'].toString(),
      contactId: map['contactId'].toString(),
      alias: map['alias'].toString(),
      phone: map['phone'],
    );
  }

  /// Representación en cadena del contacto para depuración o logs.
  /// [return] Una cadena con la información del contacto.
  @override
  String toString() {
    return '{uid: $uid, contactId: $contactId, alias: $alias, phone: $phone}';
  }
}
