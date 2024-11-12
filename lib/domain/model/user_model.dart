class User {
  String _id;
  String _name;
  String _email;
  String _phone;
  String _avatar;
  String _deviceToken;
  String _idContactList;

  User({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? deviceToken,
    String? avatar,
    String? idContactList,
  })  : _id = id ?? '',
        _name = name ?? '',
        _email = email ?? '',
        _phone = phone ?? '',
        _avatar = avatar ?? '',
        _deviceToken = deviceToken ?? '',
        _idContactList = idContactList ?? '';

  // Getters
  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get avatar => _avatar;
  String get token => _deviceToken;
  String get idContacts => _idContactList;

  // Setters
  set id(String id) => _id = id;
  set name(String name) => _name = name;
  set email(String email) => _email = email;
  set phone(String phone) => _phone = phone;
  set avatar(String avatar) => _avatar = avatar;
  set token(String token) => _deviceToken = token;
  set idContacts(String idContacts) => _idContactList = idContacts;

  // Método para serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'email': _email,
      'phone': _phone,
      'avatar': _avatar,
      'token': _deviceToken,
      'id_contact_list': _idContactList,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? '',
      deviceToken: json['token'] ?? '',
      idContactList: json['id_contact_list'] ?? '',
    );
  }

  @override
  String toString() {
    return '$_id $_name,\n $_email,\n $_phone,\n $_avatar,\n $_deviceToken,\n $_idContactList';
  }
}
