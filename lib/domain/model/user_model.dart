class User {

  User({String? id, String? name, String? email, String? phone, String? deviceToken, String? avatar, String? idContactList});

  late String _id;
  late String _name;
  late String _email;
  late String _phone;
  late String _avatar;
  late String _deviceToken;
  late String _idContactList;

  // getters
  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get avatar => _avatar;
  String get token => _deviceToken;
  String get idContacts => _idContactList;

  // setters
  set deviceId(String id) {
    _id = id;
  }
  set deviceName(String name) {
    _name = name;
  }
  set deviceEmail(String email) {
    _email = email;
  }
  set devicePhone(String phone) {
    _phone = phone;
  }
  set deviceAvatar(String avatar) {
    _avatar = avatar;
  }
  set deviceToken(String token) {
    _deviceToken = token;
  }
  set deviceIdContacts(String idContacts) {
    _idContactList = idContacts;
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
