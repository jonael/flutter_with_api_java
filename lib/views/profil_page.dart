import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:projet_api_java/models/profilbean.dart';
import 'package:projet_api_java/models/userbean.dart';
import 'package:projet_api_java/utils/constants.dart';
import 'package:projet_api_java/views/search_page.dart';
import 'package:projet_api_java/webservices/api.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({ Key? key, required this.profil}) : super(key: key);
  final Profilbean profil;


  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {

  Userbean user = userLog;
  late Profilbean profilUser;

  String login = "A.T.A.";
  String email = "ata@gmail.com";
  String role = "Maître du Monde";
  String nomProfile = "";
  String nomProfil = "";
  String prenomProfile = "";
  String prenomProfil = "";
  String ageProfile = "";
  String ageProfil = "";

  late TextEditingController controllerFirstName;
  late TextEditingController controllerName;
  late TextEditingController controllerAge;

  updateProfiluser(int? idProfil, String nomProfile, String prenomProfile, String ageProfilUser) async {
    print(idProfil);
    print(nomProfile);
    print(prenomProfile);
    print(ageProfilUser);
    Api.upProfil(idProfil!, nomProfile, prenomProfile, ageProfilUser).then((response){
      setState(() {
          if(errorLog.code == 200) {
            final snackBar = SnackBar(content: Text(errorLog.message!));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            nomProfil = nomProfile;
            prenomProfil = prenomProfile;
            ageProfil = ageProfilUser;
          } else {
            AlertDialog alert = AlertDialog(
              title: const Text("ERREUR"),
              content: Text(errorLog.message!),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext ctx) {
                  return alert;
              },
            );
          }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // tout ce qui sera fait pendant la création (initialisation) du widget
    controllerFirstName = TextEditingController();
    controllerName = TextEditingController();
    controllerAge = TextEditingController();
    profilUser = widget.profil;
    if (widget.profil.name == null || widget.profil.name!.isEmpty) {
      nomProfile = "non renseigné";
    }
    else {
      nomProfile = widget.profil.name!;
    }
    if (widget.profil.firstName == null || widget.profil.firstName!.isEmpty) {
      prenomProfile = "non renseigné";
    }
    else {
      prenomProfile = widget.profil.firstName!;
    }
    if (widget.profil.age == null || widget.profil.age! == 0) {
      ageProfile = "non renseigné";
    }
    else {
      ageProfile = widget.profil.age!.toString();
    }
  }

  @override
  void dispose() {
    controllerFirstName.dispose();
    controllerName.dispose();
    controllerAge.dispose();
    super.dispose();
    // tout ce que l'on fera quand le widget sera supprimé
  }

// ...

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(
            fontSize: 50,
            color: Colors.blue,
          ),
        ),
        leading: Icon(
          Icons.account_circle_outlined,
          size: size.width / 31,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return SearchPage(user: user,);
                  }));
            },
            child: Row(
              children: [
                Icon(
                  Icons.exit_to_app,
                  color: Colors.blue,
                  size: size.width / 31,
                ),
                const Text(
                  "Sortie",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
        centerTitle: true,
        elevation: 42,
        shadowColor: Colors.indigoAccent,
        backgroundColor: Colors.blue[420],
        foregroundColor: Colors.blue,
      ),
      body: body(size),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return SearchPage(user: user,);
                    }));
              },
            ),
              label: ("Home"),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.arrow_circle_up),
            label: ("Haut de Page"),
          ),
        ],
        elevation: 7,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.blue,
        //fixedColor: Colors.orange,
        iconSize: 31.0,
      ),
    );
  }

  Widget body(Size size) {
    print(widget.profil);
    return Container(
      child: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.all(13.0),
                  child: Text(
                    "Veuillez changer l'image de fond : ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 31,
                    ),
                  ),
                ),
                Image.network(
                    "https://images.pexels.com/photos/1323550/pexels-photo-1323550.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                divide(420, 2),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.orangeAccent,
                    child: Text("Choisir un Avatar"),
                    foregroundColor: Colors.blue,
                  ),
                ),
                divide(420, 2),
                const Text(
                  "Veuillez renseigner les champs du profil : ",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 31,
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 100, right: 100, top: 10, bottom: 10),
                          child: TextFormField(
                            autofocus: true,
                            textInputAction: TextInputAction.next,
                            controller: controllerFirstName,
                            onChanged: (newString) => setState(() {
                              prenomProfil = newString;
                            }),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white24,
                              border: OutlineInputBorder(),
                              hintText: "Veuillez entrer votre prénom...",
                              labelText: 'Prénom : ',
                            ),
                          ),
                        ),
                        divide(130, 1),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 100, right: 100, top: 10, bottom: 10),
                          child: TextFormField(
                            autofocus: true,
                            controller: controllerName,
                            textInputAction: TextInputAction.next,
                            onChanged: (newString) => setState(() {
                              nomProfil = newString;
                            }),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white24,
                              border: OutlineInputBorder(),
                              hintText: "Veuillez entrer votre nom...",
                              labelText: 'Nom : ',
                            ),
                          ),
                        ),
                        divide(130, 1),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 100, right: 100, top: 10, bottom: 10),
                          child: TextFormField(
                            autofocus: true,
                            controller: controllerAge,
                            onChanged: (newString) => setState(() {
                              ageProfil = newString;
                            }),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white24,
                              border: OutlineInputBorder(),
                              hintText: "Veuillez entrer votre âge...",
                              labelText: 'Âge : ',
                            ),
                          ),
                        ),
                        NeumorphicButton(
                          margin: const EdgeInsets.all(13.0),
                          onPressed: () => setState(() {
                            nomProfile = nomProfil;
                            prenomProfile = prenomProfil;
                            ageProfile = ageProfil;
                            controllerFirstName.clear();
                            controllerName.clear();
                            controllerAge.clear();
                            updateProfil(nomProfile, prenomProfile, ageProfile);
                          }),
                          style: NeumorphicStyle(
                            surfaceIntensity: 0.7,
                            shape: NeumorphicShape.concave,
                            color: Colors.orange.withOpacity(0.8),
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(13)),
                          ),
                          child: const Text(
                            "Validez vos choix",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        divide(420, 2),
                        rowLabels(["Login : ${profilUser.userbean!.login}", "e-mail : ${profilUser.userbean!.mail}"], false),
                        divide(100, 1),
                        label("Rôle : ${profilUser.userbean!.rolebean!.roleName}", false),
                        divide(100, 1),
                        const Padding(
                          padding: EdgeInsets.all(30),
                        ),
                        rowLabels([
                          "Nom : $nomProfile",
                          "Prénom : $prenomProfile",
                          "Âge : $ageProfile"
                        ], false),
                        const Padding(
                          padding: EdgeInsets.all(30),
                        ),
                        divide(220, 2),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  hautDePage() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context){
          return SearchPage(user: user);
        })
    );
  }

  Container divide(double leftRight, double thick) {
    return Container(
        margin: EdgeInsets.fromLTRB(leftRight, 10, leftRight, 10),
        child: Divider(
          color: Colors.orangeAccent.withOpacity(0.6),
          thickness: thick,
        ));
  }

  Text label(String label, bool underline) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w400,
        color: Colors.blue.withOpacity(0.8),
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }

  Stack rowLabels(List<String> labels, bool underline) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [for (var lbl in labels) label(lbl, underline)],
        ),
      ],
    );
  }

  updateProfil(String nomProfile, String prenomProfile, String ageProfile) {
    if(nomProfile.isEmpty) {
      nomProfile = "non renseigné";
    }
    if(prenomProfile.isEmpty) {
      prenomProfile = "non renseigné";
    }
    if(ageProfile.isEmpty) {
      ageProfile = "non renseigné";
    }
    updateProfiluser(widget.profil.idProfil, nomProfile, prenomProfile, ageProfile);
  }
}
