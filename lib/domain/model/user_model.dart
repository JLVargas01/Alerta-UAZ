class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? avatar;
  String? token;
  String? idContactList;
  String? idAlertList;

  static final User _instance = User._internal();

  // Constructor privado
  User._internal();

  // Factory para una única instancia
  factory User() => _instance;

  // Método para serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'token': token,
    };
  }

  // Método para actualizar los datos desde un JSON
  void fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? id;
    name = json['name'] ?? name;
    email = json['email'] ?? email;
    phone = json['phone'] ?? phone;
    avatar = json['avatar'] ?? avatar;
    token = json['token'] ?? token;
    idContactList = json['id_contact_list'] ?? idContactList;
    idAlertList = json['id_alert_list'] ?? idAlertList;
  }

  void clean() {
    id = null;
    name = null;
    email = null;
    phone = null;
    token = null;
    idContactList = null;
    idAlertList = null;
  }

  @override
  String toString() {
    return '$id $name,\n $email,\n $phone,\n $avatar,\n $token,\n $idContactList,\n $idAlertList';
  }
}
