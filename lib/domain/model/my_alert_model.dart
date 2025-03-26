//
//  Modelo para almacenar las alertas enviadas por el usuario
//  Esta pensado para funcionar con sqlite
//  - JL
//

/// Representa una alerta generada por el usuario actual.
/// Contiene la ubicación, fecha y un posible audio adjunto.
class MyAlert {
  /// ID del usuario que generó la alerta.
  String uid;

  /// Latitud de la ubicación donde se generó la alerta.
  double latitude;

  /// Longitud de la ubicación donde se generó la alerta.
  double longitude;

  /// Fecha y hora en que se generó la alerta.
  String date;

  /// URL o referencia al audio adjunto de la alerta (opcional).
  String? audio;

  /// Constructor de la clase 'MyAlert'.
  MyAlert({
    required this.uid,
    required this.latitude,
    required this.longitude,
    required this.date,
    this.audio,
  });

  /// Convierte la alerta a un 'Map<String, Object?>', útil para almacenamiento en bases de datos locales.
  /// [return] Un mapa con los datos de la alerta.
  Map<String, Object?> toMap() {
    return {
      'uid': uid,
      'latitude': latitude,
      'longitude': longitude,
      'date': date,
      'audio': audio,
    };
  }

  /// Representación en cadena de la alerta para propósitos de depuración o logs.
  /// [return] Una cadena con la información de la alerta.
  @override
  String toString() {
    return '{\n'
        '\tlatitude: $latitude\n'
        '\tlongitude: $longitude\n'
        '\tdate: $date\n'
        '\taudio: $audio\n'
        '}';
  }
}
