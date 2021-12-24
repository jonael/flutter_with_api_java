import 'package:projet_api_java/models/userbean.dart';

class Profilbean {
  int? _idProfil;
  String? _name;
  String? _firstName;
  int? _age;
  Userbean? _userbean;

  int? get idProfil => _idProfil;
  String? get name => _name;
  String? get firstName => _firstName;
  int? get age => _age;
  Userbean? get userbean => _userbean;

  Profilbean({
      int? idProfil, 
      String? name,
      String? firstName,
      int? age, 
      Userbean? userbean}){
    _idProfil = idProfil;
    _name = name;
    _firstName = firstName;
    _age = age;
    _userbean = userbean;
}

  Profilbean.fromJson(dynamic json) {
    _idProfil = json["idProfil"];
    _name = json["name"];
    _firstName = json["firstName"];
    _age = json["age"];
    _userbean = json["user"] != null ? Userbean.fromJson(json["user"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["idProfil"] = _idProfil;
    map["name"] = _name;
    map["firstName"] = _firstName;
    map["age"] = _age;
    if (_userbean != null) {
      map["user"] = _userbean?.toJson();
    }
    return map;
  }

}


/// idRole : 0
/// roleName : "Modérateur"


