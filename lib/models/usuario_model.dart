class Usuario {
  final int id_usuario;
  final String sensibilidad;
  final String agitacion;
  final String tiempo;

  const Usuario({
    required this.id_usuario,
    required this.sensibilidad,
    required this.agitacion,
    required this.tiempo
  });

  Map<String, Object?> toMap() {
    return {
      'id_usuario': id_usuario,
      'sensibilidad': sensibilidad,
      'agitacion': agitacion,
      'tiempo': tiempo
    };
  }

  @override
  String toString() {
    return '{id_usuario: $id_usuario, sensibilidad: $sensibilidad, alias: $agitacion, agitacion: $agitacion, tiempo: $tiempo}';
  }

}
