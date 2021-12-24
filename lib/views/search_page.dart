import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:projet_api_java/models/errorbean.dart';
import 'package:projet_api_java/models/profilbean.dart';
import 'package:projet_api_java/models/userbean.dart';
import 'package:projet_api_java/utils/constants.dart';
import 'package:projet_api_java/views/profil_page.dart';
import 'package:projet_api_java/webservices/api.dart';
import 'package:universal_platform/universal_platform.dart';

import 'log_reg_page.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({Key? key, required this.user}) : super(key: key);
  final Userbean user;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  late TextEditingController controller;
  Profilbean? profil;

  bool visibleSearch = true;
  bool visibleResult = false;
  String error = "";

  List<Profilbean> profils = [];

  forProfil() async {
    Api.getProfil(userLog).then((response){
      setState(() {
        profil = profilLog;
        if (response == true ) {
          print(profil!.userbean!.login);
          print(widget.user.login);
          if (profil!.userbean!.login == widget.user.login) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context){
                  print(profil);
                  return ProfilPage(profil: profil!,);
                })
            );
          } else {
            Errorbean errorbean = errorLog;
            setState(() {
              error = errorbean.message!;
            });
          }
        }
      });
    });
  }

  searchProfils(String genre) async {
    Api.getProfils(genre).then((response) {
      setState(() {
        for (var i=0; i<response.length; i++){
          profils.add(Profilbean.fromJson(response[i]));
        }
      });
      return profils;
    });
  }

  @override
  void initState() {
    super.initState();
    // tout ce qui sera fait pendant la création (initialisation) du Widget
    controller = TextEditingController();
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    // tout ce que l'on fera lorsque le Widget sera supprimé
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Userbean user = widget.user;

    return Scaffold(
      appBar: AppBar(
        leading : IconButton(
          icon: const Icon(Icons.home),
          color: Colors.white,
          onPressed: () async {},
        ),
        title: const Text("Adopte un cinéphile !"),
        actions:  [
          IconButton(
            icon: const Icon(Icons.login),
            color: Colors.white,
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const LogOrRegPage();
                      }
                  )
              );},
          ),
          IconButton(
            icon: const Icon(Icons.perm_identity_sharp),
            color: Colors.white,
            onPressed: () async {
              forProfil();
              setState(() {
                profil = profilLog;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) {
                        return ProfilPage(profil: profil!);
                      }
                  )
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () async {Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) {
                      return SearchPage(user: user,);
                    }
                )
            );},
          ),
        ],
        backgroundColor: Colors.teal,
        elevation: 30,
        shadowColor: Colors.grey,
        centerTitle: true,
      ),
      body: body(size),

    );
  }

  Widget body(Size size){
    return Stack(
        children: [Container(
          decoration : const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image : AssetImage( "assets/images/background.png")
            ) ,
          ),

        ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible : visibleSearch,
                    child: const Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Text(
                        "Entrez votre genre préféré, et vous trouverez votre âme soeur !",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible : visibleSearch,
                    child: ConstrainedBox(
                      constraints: BoxConstraints
                        (
                        minWidth : size.width *0.05,
                      ),
                      child: SizedBox(
                        width : size.width * 0.5,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            icon: Icon(Icons.movie_outlined),
                            hintText: 'Quel est votre genre préféré ?',
                            labelText: 'Votre genre préféré',

                          ),
                          controller: controller,
                          validator: (String? value) {
                            return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Visibility(
                      visible : visibleResult,
                      child : Container(
                        child: Center(
                          child: listBuilder(),
                          ),
                      ),
                    ),
                  ),
                  NeumorphicButton(
                    margin: const EdgeInsets.all(10.0),
                    onPressed: () {
                      setState(()
                      {
                        visibleSearch = !visibleSearch;
                        visibleResult = !visibleResult;
                        searchUsersList(controller.text.toString());
                      });
                    },
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.concave,
                        color: Colors.white.withOpacity(0.7),
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15))
                    ),
                    child: const Text(
                      "Valider",
                      style: TextStyle(
                        fontWeight:  FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
    );
  }

  searchUsersList(String genre){
    if(genre.isEmpty) {
      setState(() {
        visibleSearch = !visibleSearch;
        visibleResult = !visibleResult;
        error = "Veuillez saisir un genre";
      });
    } else {
      profils = searchProfils(genre);
    }
  }

  listBuilder() {
    if(UniversalPlatform.isWeb) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: profils.length,
        itemBuilder: (context, i) {
          return Center(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(
                        choosePseudo(profils[i].userbean!.pseudo),
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(
                        chooseFirstname(profils[i].firstName),
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(
                        chooseName(profils[i].name),
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(
                        chooseAge(profils[i].age),
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: profils.length,
        itemBuilder: (context, i) {
          return Center(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(
                        choosePseudo(profils[i].userbean!.pseudo),
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(
                        chooseFirstname(profils[i].firstName),
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(
                        chooseName(profils[i].name),
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(
                        chooseAge(profils[i].age),
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  choosePseudo(String? pseudo) {
      if (pseudo == null){
        return "non renseigné";
      } else {
        return pseudo;
      }
  }

  chooseFirstname(String? firstName) {
    if (firstName == null){
      return "non renseigné";
    } else {
      return firstName;
    }
  }

  chooseName(String? name) {
    if (name == null){
      return "non renseigné";
    } else {
      return name;
    }
  }

  chooseAge(int? age) {
    if (age == null){
      return "non renseigné";
    } else {
      return age.toString();
    }
  }
}