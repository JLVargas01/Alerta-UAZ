//
//  Modelo para almacenar los contactos de confianza
//  Este modelo esta pensado para funcionar con sqlite
//  - JL
//

class ContactoConfianza {
  final String id_confianza;
  String telephone;
  String alias;
  String relacion;

   ContactoConfianza({
    required this.id_confianza,
    required this.telephone,
    required this.alias,
    this.relacion = '',
  });

  Map<String, Object?> toMap() {
    return {
      'id_confianza': id_confianza,
      'telephone': telephone,
      'alias': alias,
      'relacion': relacion
    };
  }

  @override
  String toString() {
    return '{id: $id_confianza, telephone: $telephone, alias: $alias, relacion: $relacion}';
  }

}
