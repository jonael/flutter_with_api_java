import 'package:projet_api_java/models/rolebean.dart';

import 'genrebean.dart';


class Userbean {
  int? _idUser;
  String? _login;
  String? _password;
  String? _pseudo;
  String? _mail;
  int? _testPass;
  Genrebean? _genrebean;
  Rolebean? _rolebean;

  int? get idUser => _idUser;
  String? get login => _login;
  String? get password => _password;
  String? get pseudo => _pseudo;
  String? get mail => _mail;
  int? get testPass => _testPass;
  Genrebean? get genrebean => _genrebean;
  Rolebean? get rolebean => _rolebean;

  Userbean({
    int? idUser,
    String? login,
    String? password,
    String? pseudo,
    String? mail,
    int? testPass,
    Genrebean? genrebean,
    Rolebean? rolebean}){
    _idUser = idUser;
    _login = login;
    _password = password;
    _pseudo = pseudo;
    _mail = mail;
    _testPass = testPass;
    _genrebean = genrebean;
    _rolebean = rolebean;
  }

  Userbean.fromJson(dynamic json) {
    _idUser = json["idUser"];
    _login = json["login"];
    _password = json["password"];
    _pseudo = json["pseudo"];
    _mail = json["mail"];
    _testPass = json["testPass"];
    _genrebean = json["genrebean"] != null ? Genrebean.fromJson(json["genrebean"]) : null;
    _rolebean = json["role"] != null ? Rolebean.fromJson(json["role"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["idUser"] = _idUser;
    map["login"] = _login;
    map["password"] = _password;
    map["pseudo"] = _pseudo;
    map["mail"] = _mail;
    map["testPass"] = _testPass;
    if (_genrebean != null) {
      map["genrebean"] = _genrebean?.toJson();
    }
    if (_rolebean != null) {
      map["role"] = _rolebean?.toJson();
    }
    return map;
  }

}