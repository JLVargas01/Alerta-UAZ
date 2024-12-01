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

  // Método para actualizar los datos desde un JSON
  void fromJson(Map<String, dynamic> json) {
    id = json['_id'].toString();
    name = json['name'].toString();
    email = json['email'].toString();
    phone = json['phone'].toString();
    avatar = json['avatar'].toString();
    token = json['token'].toString();
    idContactList = json['id_contact_list'].toString();
    idAlertList = json['id_alert_list'].toString();
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
    return 'id: $id, name: $name, email: $email, phone: $phone, avatar: $avatar, token: $token, id_contact: $idContactList, id_alert: $idAlertList';
  }
}
