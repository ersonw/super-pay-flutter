import 'dart:convert';

class Config {
  String mainDomain = "pay.telebott.com";
  String? channelDomain;
  Config();
  Config.formJson(Map<String, dynamic> json):
      mainDomain = json['mainDomain'],
        channelDomain = json['channelDomain']
  ;
  Map<String, dynamic> toJson() => {
    'mainDomain': mainDomain,
    'channelDomain': channelDomain,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
