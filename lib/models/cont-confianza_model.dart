class ContactoConfianza {
  final int id_confianza;
  final String telephone;
  final String alias;
  final String relacion;

  const ContactoConfianza({
    required this.id_confianza,
    required this.telephone,
    required this.alias,
    required this.relacion
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
