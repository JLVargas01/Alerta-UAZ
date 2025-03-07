/// Representa un usuario en la aplicación.
/// Utiliza el patrón Singleton para asegurar que haya solo una instancia en ejecución.
class User {
  /// ID único del usuario en la base de datos.
  String? id;

  /// Nombre del usuario.
  String? name;

  /// Correo electrónico del usuario.
  String? email;

  /// Número de teléfono del usuario.
  String? phone;

  /// URL del avatar o foto de perfil del usuario.
  String? avatar;

  /// Token de autenticación del usuario, utilizado para notificaciones push.
  String? token;

  /// ID de la lista de contactos del usuario.
  String? idContactList;

  /// ID de la lista de alertas del usuario.
  String? idAlertList;

  /// Instancia única de la clase 'User' (implementando el patrón Singleton).
  static final User _instance = User._internal();

  /// Constructor privado para evitar instanciaciones externas.
  User._internal();

  /// Devuelve la única instancia de 'User' (Singleton).
  factory User() => _instance;

  /// Convierte la información del usuario en un mapa JSON.
  /// [return] Mapa con los datos del usuario.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'token': token,
      'id_contact_list': idContactList,
      'id_alert_list': idAlertList
    };
  }

  /// Carga los datos del usuario desde un JSON.
  /// [json] Mapa con los datos a cargar en la instancia del usuario.
  void fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    name = json['name']?.toString();
    email = json['email']?.toString();
    phone = json['phone']?.toString();
    avatar = json['avatar']?.toString();
    token = json['token']?.toString();
    idContactList = json['id_contact_list']?.toString();
    idAlertList = json['id_alert_list']?.toString();
  }

  /// Limpia los datos almacenados en la instancia del usuario.
  void clean() {
    id = null;
    name = null;
    email = null;
    phone = null;
    avatar = null;
    token = null;
    idContactList = null;
    idAlertList = null;
  }

  /// Representación en cadena de la información del usuario.
  /// [return] Una cadena con los datos del usuario.
  @override
  String toString() {
    return 'id: $id, name: $name, email: $email, phone: $phone, avatar: $avatar, token: $token, id_contact: $idContactList, id_alert: $idAlertList';
  }
}
