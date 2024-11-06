class User {
  final String _id;
  final String _name;
  final String _email;
  final String _phone;
  String? _avatar;
  String? _deviceToken;
  final String _idContactList;

  User(
      {required id,
      required name,
      required email,
      required phone,
      String? avatar,
      String? deviceToken,
      required idContactList})
      : _id = id,
        _name = name,
        _email = email,
        _phone = phone,
        _avatar = avatar,
        _deviceToken = deviceToken,
        _idContactList = idContactList;

  // getters
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String? get avatar => _avatar;
  String? get token => _deviceToken;
  String get idContacts => _idContactList;

  // setters
  set deviceToken(String token) {
    _deviceToken = token;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'email': _email,
      'phone': _phone,
      'avatar': _avatar,
      'token': _deviceToken,
      'id_contact_list': _idContactList
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        avatar: json['avatar'],
        deviceToken: json['token'],
        idContactList: json['id_contact_list']);
  }

  @override
  String toString() {
    return '$_name,\n $_email';
  }
}
