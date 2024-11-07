class GoogleData {
  final String _nameGoogle;
  final String _emailGoogle;
  final String _avatarUrlGoogle;
  final String _deviceToken;

  GoogleData( {
    required String nameGoogle,
    required String emailGoogle ,
    required String avatarUrlGoogle,
    required String deviceToken
    }) : 
    _nameGoogle = nameGoogle,
    _emailGoogle = emailGoogle,
    _avatarUrlGoogle = avatarUrlGoogle,
    _deviceToken = deviceToken;

  // getters
  String get nameGoogle => _nameGoogle;
  String get emailGoogle => _emailGoogle;
  String get avatarUrlGoogle => _avatarUrlGoogle;
  String get deviceToken => _deviceToken;

  Map<String, dynamic> toJson() {
    return {
      'nameGoogle': _nameGoogle,
      'emailGoogle': _emailGoogle,
      'avatarUrlGoogle': _avatarUrlGoogle,
      'deviceToken': _deviceToken,
    };
  }

}