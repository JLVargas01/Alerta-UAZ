class HistorialAlerta {
  final int id_alerta;
  final int id_usuario_alerta;
  final String URL;
  final DateTime fecha;

  const HistorialAlerta({
    required this.id_alerta,
    required this.id_usuario_alerta,
    required this.URL,
    required this.fecha
  });

  Map<String, Object?> toMap() {
    return {
      'id_alerta': id_alerta,
      'id_usuario_alerta': id_usuario_alerta,
      'URL': URL,
      'fecha': fecha
    };
  }

  @override
  String toString() {
    return '{id_alerta: $id_alerta, id_usuario_alerta: $id_usuario_alerta, URL: $URL, fecha: $fecha}';
  }

}
