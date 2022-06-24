import 'dart:convert';

class User {
  int id = 0;
  String? avatar;
  String? text;
  String username = '';
  String token = '';

  User();

  User.formJson(Map<String, dynamic> json)
      : id = json['id'],
        avatar = json['avatar'],
        text = json['text'],
        username = json['username'],
        token = json['token'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'text': text,
        'username': username,
        'token': token,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
