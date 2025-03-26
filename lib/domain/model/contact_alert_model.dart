//
//  Modelo para almacenar las alertas recibidas de otros usuarios
//  Esta pensado para funcionar con sqlite
//  - JL
//

/// Representa una alerta enviada por un contacto.
/// Contiene información del usuario que envió la alerta, su ubicación y otros detalles.
class ContactAlert {
  /// ID del usuario que envió la alerta.
  String uid;

  /// Nombre de usuario del remitente de la alerta.
  String username;

  /// URL o ruta del avatar del usuario (opcional).
  String? avatar;

  /// Latitud de la ubicación donde se generó la alerta.
  double latitude;

  /// Longitud de la ubicación donde se generó la alerta.
  double longitude;

  /// Fecha y hora en que se generó la alerta.
  String date;

  /// URL o referencia al audio adjunto de la alerta (opcional).
  String? audio;

  /// Constructor de la clase 'ContactAlert'.
  ContactAlert({
    required this.uid,
    required this.username,
    this.avatar,
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
      'username': username,
      'avatar': avatar,
      'latitude': latitude,
      'longitude': longitude,
      'date': date,
      'audio': audio
    };
  }

  /// Convierte la alerta a un 'Map<String, dynamic>', útil para su representación en formato JSON.
  /// [return] Un mapa con los datos de la alerta en estructura JSON.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'avatar': avatar,
      'coordinates': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'date': date,
      'audio': audio
    };
  }

  /// Representación en cadena de la alerta para propósitos de depuración o logs.
  /// [return] Una cadena con la información de la alerta.
  @override
  String toString() {
    return '{\n'
        'username: $username,\n'
        'latitude: $latitude,\n'
        'longitude: $longitude,\n'
        'date: $date,\n'
        'audio: $audio\n'
        '}';
  }
}
