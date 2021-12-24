import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projet_api_java/models/errorbean.dart';
import 'package:projet_api_java/models/genrebean.dart';
import 'package:projet_api_java/models/profilbean.dart';
import 'package:projet_api_java/models/userbean.dart';
import 'package:projet_api_java/utils/constants.dart';
import 'package:projet_api_java/views/profil_page.dart';
import 'package:projet_api_java/views/search_page.dart';
import 'package:projet_api_java/webservices/api.dart';

class LogOrRegPage extends StatefulWidget {
  const LogOrRegPage({Key? key}) : super(key: key);

  @override
  LogOrRegPageState createState() => LogOrRegPageState();
}

class LogOrRegPageState extends State<LogOrRegPage> {

  String nom = "";
  String login = "";
  String password = "";
  String confPassword = "";
  String email = "";
  String error = "";
  String? genre;

  List<Genrebean> genres = <Genrebean>[];
  List<DropdownMenuItem<String>> listGenres = [];

  late int idGenre;

  late TextEditingController nomController;
  late TextEditingController loginController;
  late TextEditingController passwordController;
  late TextEditingController confPasswordController;
  late TextEditingController emailController;

  bool visible = false;
  bool textForButton = false;
  bool visibleError = false;
  bool buttonUpdate = false;

  void addListItem() {
    listGenres.clear();
    // listGenres.add(
    //   const DropdownMenuItem(
    //       value: 'aucun',
    //       child: Text('aucun')
    //   ),
    // );
    for (var element in genres) {
      listGenres.add(
        DropdownMenuItem(
          value: element.genreName,
          child: Text(
            element.genreName!,
            style: const TextStyle(
                color: Colors.indigo,
                fontSize: 16.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      );
    }
  }

  getGenresfromApi() async {
    Api.getGenres().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(list);
        genres = list.map((model) => Genrebean.fromJson(model)).toList();
      });
    });
  }

  forLogin(login, password) async {
    Api.loginApi(login , password).then((response){
      setState(() {
        if (response == true ) {
          if (userLog.login == login) {
            Userbean user = userLog;
            Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context){
                  return SearchPage(user: user);
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

  forRegister(nom, login, password, email, genre) async {
    Api.registerApi(nom, login , password, email, genre).then((response){
      setState(() {
        if (response == true ) {
          if (userLog.login == login) {
            Profilbean profil = Api.getProfil(userLog) as Profilbean;
            Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context){
                  return ProfilPage(profil: profil,);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // tout ce qui sera fait pendant la création (initialisation) du Widget
    nomController = TextEditingController();
    loginController = TextEditingController();
    passwordController = TextEditingController();
    confPasswordController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    nomController.dispose();
    loginController.dispose();
    passwordController.dispose();
    confPasswordController.dispose();
    emailController.dispose();
    super.dispose();
    // tout ce que l'on fera lorsque le Widget sera supprimé
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;
    print(size);
    print(platform);
    print(size.width);

    if (size.width > 700) {
      if(visible == true){
        addListItem();
      }
      return Stack(// <-- STACK AS THE SCAFFOLD PARENT
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/lightwood.jpg"), // <-- BACKGROUND IMAGE
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Scaffold(
                backgroundColor: const Color.fromRGBO(201, 155, 75, 0.3),
                body: body(size))
          ]);
    } else {
      if(visible == true){
        addListItem();
      }
      return Stack(// <-- STACK AS THE SCAFFOLD PARENT
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/lightwood.jpg"), // <-- BACKGROUND IMAGE
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Scaffold(
                backgroundColor: const Color.fromRGBO(201, 155, 75, 0.3),
                appBar: AppBar(
                  title: const Text(
                    "Join us",
                    style: TextStyle(
                      color: Color.fromRGBO(57, 28, 28, 1),
                      fontSize: 30,
                      //fontWeight: FontWeight.w600,
                      //fontStyle: FontStyle.italic,
                    ),
                  ),
                  centerTitle: true,
                  elevation: 20,
                  shadowColor: Colors.pink,
                  backgroundColor: const Color.fromRGBO(119, 179, 212, 1),
                ),
                body: bodySmall(size))
          ]);
    }
  }

  Widget body(Size size) {
    addListItem();
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Row(
        children: [
          Container(
            width: size.width * 0.5,
            height: size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/joinus.jpeg"),
                  fit: BoxFit.fill,
                )),
          ),
          Container(
            width: size.width * 0.5,
            height: size.height,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          child:
                          assetImage(size, "../assets/images/logobt1.png")),
                      dividerItems(50),
                      Visibility(
                        visible: visible,
                        child: inputField(
                            false,
                            "Votre pseudo ?",
                            TextInputType.text,
                            nom,
                            nomController,
                        ),
                      ),
                      dividerItems(20),
                      inputField(
                          false, "Votre login ?", TextInputType.text, login, loginController),
                      dividerItems(20),
                      inputField(
                          true, "Password ?", TextInputType.text, password, passwordController),
                      dividerItems(20),
                      Visibility(
                        visible: visible,
                        child: inputField(
                          true,
                          "Confirmez Password ?",
                          TextInputType.text,
                          confPassword,
                          confPasswordController),
                      ),
                      Visibility(visible: visible,child: dividerItems(20)),
                      Visibility(
                        visible: visible,
                        child: inputField(
                          false,
                          "Votre Email ?",
                          TextInputType.emailAddress,
                          email,
                          emailController),
                      ),
                      Visibility(visible: visible,child: dividerItems(20)),
                      Visibility(
                        visible: visible,
                        child: Container(
                          alignment: Alignment.center,
                          child: DropdownButton(
                            value: genre,
                            elevation: 15,
                            items: listGenres,
                            hint: const Text(
                              'Choisissez un genre',
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                genre = value as String?;
                              });
                            },
                          ),
                        ),
                      ),
                      Visibility(visible: visible,child: Text(error)),
                      Visibility(visible: visible, child: dividerItems(20),),
                      TextButton(
                          onPressed: updatePage,
                          child: Text(updateTextButton())),
                      dividerItems(20),
                      send(),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget bodySmall(Size size) {
    addListItem();
    return Container(
      //color: Colors.amber,
      width: size.width,
      height: size.height,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: assetImage(size, "../assets/images/logobt1.png")),
                dividerItems(30),
                inputField(false, "Votre pseudo ?", TextInputType.text, nom, nomController),
                dividerItems(10),
                inputField(false, "Votre login ?", TextInputType.text, login, loginController),
                dividerItems(10),
                inputField(true, "Password ?", TextInputType.text, password, passwordController),
                dividerItems(10),
                inputField(
                    true, "Confirmation Password ?", TextInputType.text, confPassword, confPasswordController),
                dividerItems(10),
                inputField(false, "Votre Email ?", TextInputType.emailAddress, email, emailController),
                dividerItems(20),
                send(),
              ],
            ),
          )),
    );
  }

  Divider dividerItems(double heigth) {
    return Divider(
      height: heigth,
      color: Colors.transparent,
    );
  }

  TextField inputField(
      bool obscureText, String hint, TextInputType type, String field, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      keyboardType: type,
      onChanged: (newString) {
        setState(() {
          field = newString;
        });
      },
    );
  }

  ElevatedButton send() {
    return ElevatedButton(
      onPressed: () {
        logOrReg(
          nomController.text.toString(),
          loginController.text.toString(),
          passwordController.text.toString(),
          confPasswordController.text.toString(),
          emailController.text.toString(),
          Genrebean(genreName: genre)
        );
      },
      child: Text(buttonUpdateText()),
      style: ElevatedButton.styleFrom(
        primary: const Color.fromRGBO(119, 179, 212, 1),
        onPrimary: const Color.fromRGBO(57, 28, 28, 1),
        elevation: 20,
        shadowColor: Colors.pink,
        padding: const EdgeInsets.all(20),
        textStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 20,
        ),
      ),
    );
  }

  Image assetImage(Size size, String chemin) {
    return Image.asset(
      chemin,
      height: size.height * 0.15,
      width: size.width * 0.15,
      fit: BoxFit.contain,
    );
  }

  updatePage() {
    getGenresfromApi();
    setState(() {
      visible = !visible;
      textForButton = !textForButton;
      buttonUpdate = !buttonUpdate;
    });
  }

  buttonUpdateText() {
    return(buttonUpdate)? "Sign Up" : "Sign In";
  }

  updateTextButton() {
    return(textForButton)? "Connectez-vous" : "Inscrivez-vous";
  }

  logOrReg(String nom, String login, String password, String confPass, String email, Genrebean? genre){
    if(login.isEmpty){
      setState(() {
        visibleError = !visibleError;
        error = "Veuillez saisir votre login";
      });
    }
    else if(password.isEmpty) {
      setState(() {
        visibleError = !visibleError;
        error = "Veuillez saisir votre mot de passe";
      });
    }
    else {
      if(visible == false) {
        forLogin(login, password);
      }
      else {
        if(nom.isEmpty){
          setState(() {
            visibleError = !visibleError;
            error = "Veuillez saisir votre nom";
          });
        }
        else if(confPass.isEmpty) {
          setState(() {
            visibleError = !visibleError;
            error = "Veuillez confirmer votre mot de passe";
          });
        }
        else if(email.isEmpty) {
          setState(() {
            visibleError = !visibleError;
            error = "Veuillez saisir votre mail";
          });
        }
        else if(genre == "Choisissez genre") {
          setState(() {
            visibleError = !visibleError;
            error = "Veuillez choisir un genre de film";
          });
        } else if(password != confPass) {
          setState(() {
            visibleError = !visibleError;
            error = "Les mots de passes ne correspondent pas";
          });
        }
        else {
          forRegister(nom, login, password, email, genre);
        }
      }
    }
  }
}
