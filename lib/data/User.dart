import 'dart:convert';

class User {
  String id = '';
  bool admin = false;
  String? avatar;
  String? callbackUrl;
  String? notifyUrl;
  String? username;
  String token = '';

  User();

  User.formJson(Map<String, dynamic> json)
      : id = json['id'],
        admin = json['admin'] ?? false,
        avatar = json['avatar'],
        callbackUrl = json['callbackUrl'],
        notifyUrl = json['notifyUrl'],
        username = json['username'],
        token = json['token'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'admin': admin,
        'avatar': avatar,
        'callbackUrl': callbackUrl,
        'notifyUrl': notifyUrl,
        'username': username,
        'token': token,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
