import 'dart:convert';

import 'package:projet_api_java/models/errorbean.dart';
import 'package:projet_api_java/models/genrebean.dart';
import 'package:projet_api_java/models/profilbean.dart';
import 'package:projet_api_java/models/userbean.dart';
import 'package:projet_api_java/utils/constants.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:http/http.dart' as http;

class Api {

  static Future registerApi(String nom, String login, String password, String email, Genrebean genre) async {
    String url = '';
    errorLog = Errorbean();
    print(nom + login + password+ email + genre.genreName!);
    if (UniversalPlatform.isAndroid) {
      url = "http://10.0.2.2:8080/rest/register";
    } else {
      url = "http://localhost:8080/rest/register";
    }
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          "name": nom,
          "login": login,
          "password": password,
          "mail": email,
          "genrebean": genre
        })
      );
      print(response.statusCode);
      var test = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(test);
        userLog = Userbean.fromJson(test);
        errorLog = Errorbean.fromJson(test);
        return true;
      } else {
        print(response.body);
        print(response.statusCode);
        errorLog = Errorbean.fromJson(test);
        return false;
      }
    } on Exception catch (e) {
      print(e);
      print(Exception);
      print("Error occured");
    }
  }

  static Future loginApi(String login, String password) async {
    String url = '';
    if (UniversalPlatform.isAndroid) {
      url = "http://10.0.2.2:8080/rest/login";
    } else {
      url = "http://localhost:8080/rest/login";
    }
    try {
      final response = await http.post(
          Uri.parse(url),
          headers: {"content-type": "application/json"},
          body: jsonEncode({
            "login": login,
            "password": password
          }));
      print(response.statusCode);
      var test = jsonDecode(response.body);
      if (response.statusCode == 200) {
        userLog = Userbean.fromJson(test);
        errorLog = Errorbean.fromJson(test);
        return true;
      } else {
        print(response.body);
        print(response.statusCode);
        errorLog = Errorbean.fromJson(test);
        return false;
      }
    } on Exception catch (e) {
      print(e);
      print(Exception);
      print("Error occured");
    }
  }

  static Future getGenres() async {
    String url = '';
    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2:8080/rest/listgenres";
    }else {
      url = "http://localhost:8080/rest/listgenres";
    }
    return http.get(Uri.parse(url));
  }

  static Future getProfils(String genre) async {
    String url = '';
    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2:8080/rest/search";
    }else {
      url = "http://localhost:8080/rest/search";
    }
    final response = await http.post(
      Uri.parse(url),
      headers: {"content-type": "application/json"},
      body: jsonEncode({
        "genreName": genre
      }),
    );
    var test = jsonDecode(response.body);
    return test;
  }

  static Future getProfil(Userbean userbean) async {
    String url = '';
    String login = userbean.login!;
    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2:8080/rest/profil";
    }else {
      url = "http://localhost:8080/rest/profil";
    }
    final response = await http.post(
        Uri.parse(url),
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          "login": login
        }));
    print(response.statusCode);
    var test = jsonDecode(response.body);
    if (response.statusCode == 200) {
      profilLog = Profilbean.fromJson(test);
      errorLog = Errorbean.fromJson(test);
      return true;
    }
    else {
      print(response.body);
      print(response.statusCode);
      errorLog = Errorbean.fromJson(test);
      return false;
    }
  }

  static Future upProfil(int idProfil, String nom, String prenom, String age) async {
    String url = '';
    print(idProfil);
    print(nom);
    print(prenom);
    print("ttyyyth + $age");
    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2:8080/rest/upProfil";
    }else {
      url = "http://localhost:8080/rest/upProfil";
    }
    final response = await http.post(
        Uri.parse(url),
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          "idProfil": idProfil,
          "name": nom,
          "firstName": prenom,
          "age": age
        }));
    print(response.statusCode);
    var test = jsonDecode(response.body);
    if (response.statusCode == 200) {
      errorLog = Errorbean.fromJson(test);
      return true;
    }
    else {
      print(response.body);
      print(response.statusCode);
      errorLog = Errorbean.fromJson(test);
      return false;
    }
  }
}