import 'dart:convert';
import 'dart:io';
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/models/nisira.dart';
import 'package:acpmovil/views/create_user.dart';
import 'package:acpmovil/views/home.dart';
import 'package:acpmovil/views/menudrawer_normal.dart';
import 'package:acpmovil/views/olvide_pass.dart';
import 'package:acpmovil/views/screen_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final myControllerUser = TextEditingController();
  final myControllerPassword = TextEditingController();
  bool _secureText = true;
  late FocusNode focusUser, focusPassword;
  List menus_ocultos = [];
  String? estado_menu1;
  bool _typeKeyboardText = true;
  bool tipomenu = false;

  List usuarios = [];
  List dataUser = [];

  List menu = [];
  QuerySnapshot? menus;

  Future<void> datosUsuario(nombre, dni, empresa, tipo, fnacimiento) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("name", nombre.toString());
      prefs.setString("dni", dni.toString());
      prefs.setString("empresa", empresa.toString());
      prefs.setString("tipo", tipo.toString());
      prefs.setString("fnacimiento", fnacimiento.toString());
    });
  }



  Future<void> getMenusO() async{
    menus_ocultos.clear();
    var menus = FirebaseFirestore.instance.collection("menus_ocultos").where("menu", isEqualTo: "drawer");
    QuerySnapshot menu = await menus.get();
    setState((){
      if(menu.docs.isNotEmpty){
        for(var doc in menu.docs){
          print("DATOS: "+doc.id.toString());
          menus_ocultos.add(doc.data());
        }

        print("GERENTE: "+menus_ocultos[0]["estado"]);
        estado_menu1 = menus_ocultos[0]["estado"];

      }
    });


  }

  Future<void> getMenus()  async {
    String? tipouser;
    if(estado_menu1 == "0"){
      tipouser = "apple";
     // tipoUsuario == "apple";
    }else{
      tipouser = tipoUsuario!;
    }
    var usuariosF = FirebaseFirestore.instance.collection("menu").doc(empresaUsuario).collection(tipouser == "gerente" ? "directivo" : tipouser);
    menus = await usuariosF.get();

    if(menus!.docs.isNotEmpty){
      menu.clear();
      for(var doc in menus!.docs){
        menu.add(doc.data());

      }
        tipomenu = true;
    }else {
      tipomenu = false;
    }
  }

  Future<void> getMenusgcp() async{
    menusgcp.clear();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    var menuF = FirebaseFirestore.instance.collection("menu_sgcp").where("estado",isEqualTo: "1");
    QuerySnapshot menus = await menuF.get();

    if(menus.docs.isNotEmpty){
      for(var doc in menus.docs){
        print("DATOS: "+doc.id.toString());

        menusgcp.add(doc.data());
      }
      print("TITULO: "+menusgcp[0]["titulo"]);

    }
  }

  void getUsers(dni, pass) async{

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    var usuariosF = FirebaseFirestore.instance.collection("users").where("dni",isEqualTo: dni).where("password", isEqualTo: pass);
    QuerySnapshot users = await usuariosF.get();

    if(users.docs.isNotEmpty){
      for(var doc in users.docs){
        print("DATOS: "+doc.id.toString());
        usuarios.add(doc.data());
      }
      nombreUsuario = usuarios[0]["name"];
      dniUsuario = usuarios[0]["dni"];
      empresaUsuario = usuarios[0]["empresa"];
      fnacimiento = usuarios[0]["nacimiento"];
      if(usuarios[0]["tipouser"] == "OBR" || usuarios[0]["tipouser"] == "ORG"){
        tipoUsuario = "obrero";
      }else{
        tipoUsuario = "empleado";
      }

      datosUsuario(nombreUsuario, dniUsuario, empresaUsuario, tipoUsuario, fnacimiento);
      await getMenus();
      await getMenusgcp();
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuDrawerNormal(menu:menu)),
      );
    }else{
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => const CustomDialogsAlert(
            title: "Advertencia",
            description:
            "Revisa tus credenciales. Usuario o contraseña incorrecta.",
            imagen: "assets/images/usuario.png",
          ));
    }
  }
  @override
  void initState() {
    super.initState();
    focusUser = FocusNode();
    focusPassword = FocusNode();
    myControllerUser.addListener(_printLatestValue);
    getMenusO();

    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);*/
  }

  Future<String?> RecibirDatosUsuarios() async {
    String login = myControllerUser.text;
    String clave = myControllerPassword.text;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await http.post(
            Uri.parse("${url_base}acpmovil/controlador/usuario.php"),
            body: {"accion": "start_flutter", "login": login, "clave": clave});
       // if (mounted) {
          setState(() {
            var extraerData = json.decode(response.body);
            dataUser = extraerData["resultado"];
            print("REST: "+dataUser.toString());
          });
            if(dataUser[0]["RPTA"] == "TRUE"){
              nombreUsuario = dataUser[0]["USR_NOMBRES"];
              dniUsuario = dataUser[0]["DNI"];
              empresaUsuario = dataUser[0]["EMPRESA"];
              tipoUsuario = dataUser[0]["TIPOUSUARIO"];
              print("REST: "+dataUser[0]["TIPOUSUARIO"]);
              fnacimiento = dataUser[0]["FECHA_NACIMIENTO"];;
              datosUsuario(nombreUsuario, dniUsuario, empresaUsuario,tipoUsuario, fnacimiento);
              await getMenus();
              await getMenusgcp();
              Navigator.pop(context);
              if(tipomenu = true){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuDrawerNormal(menu:menu)),
                );
              }


            }else{
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (context) => const CustomDialogsAlert(
                    title: "Advertencia",
                    description:
                    "Revisa tus credenciales. Usuario o contraseña incorrecta.",
                    imagen: "assets/images/usuario.png",
                  ));
            }

       // }

      }
    } on SocketException catch (_) {
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
                child: AlertDialog(
                    content: const Text('Revisa tu conexión a internet'),
                    actions: [okButton]));
          });
      print('not connected');
    }

    //print("NAME: " + data[0]['TRANSPNAME']);
  }

  @override
  void dispose() {
    focusUser.dispose();
    focusPassword.dispose();
    myControllerUser.dispose();
    myControllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
      home: Scaffold(
      extendBodyBehindAppBar: true,
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ScreenHome()));
          },
        ),
        elevation: 0,
        //title: const Text('Iniciar Sesión'),
        backgroundColor: Colors.transparent, //Color(0XFF00AB74)
        systemOverlayStyle: SystemUiOverlayStyle.light,
        //backwardsCompatibility: true,
        //systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.orange),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.4,
            child: Image.asset(
              'assets/images/background_gcp.png',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          /*_getCirculo(0.0, -MediaQuery.of(context).size.width / 0.60, 3.0,
              const Color(0XFF00AB74)),*/
          /*_getCirculo(
              MediaQuery.of(context).size.width / 5.0,
              -MediaQuery.of(context).size.width / 1.0,
              1.70,
              const Color(0XFF00796B)),*/
          _getCirculo(
              MediaQuery.of(context).size.width / 1.6,
              -MediaQuery.of(context).size.width / 1.2,
              1.20,
              const Color(0XFF00AB74)),
          _getCirculo(
              MediaQuery.of(context).size.width / 1.5,
              -MediaQuery.of(context).size.width / 2.0,
              0.70,
              const Color(0XFF00796B)),
          TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: 0.0),
              curve: Curves.decelerate,
              child:  Image.asset(
                "assets/images/avocado_tree.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              duration: const Duration(milliseconds: 1200),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(200 * value, 0.0),
                  child: child,
                );
              }),
          SafeArea(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  height: double.infinity,
                  //color: Colors.transparent,
                  child: SingleChildScrollView(
                    child: Center(
                      child: Container(
                          padding: const EdgeInsets.all(0),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                /*Image.asset(
                                  "assets/images/gcp_color.png",
                                  width: MediaQuery.of(context).size.width / 2,
                                ),*/
                                const SizedBox(height: 80),
                                const Text(
                                  'Bienvenid@',
                                  style: TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Ingresa con tu usuario ó DNI',
                                  style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  //height: 50.0,
                                  padding: const EdgeInsets.only(
                                      top: 0.0,
                                      bottom: 0.0,
                                      left: 16.0,
                                      right: 16.0),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      color: Color(0xFFFFFFFF),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10.0)
                                      ]),
                                  child: TextField(
                                    focusNode: focusUser,
                                    //autofocus: true,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9_A-Za-zñÑ]')),
                                      LengthLimitingTextInputFormatter(25)
                                    ],
                                    controller: myControllerUser,
                                    cursorColor: const Color(0xFFC41A3B),
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.account_circle,
                                          color: Colors.black,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Usuario / DNI',
                                        hintStyle: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black45,
                                            fontSize: 15)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  //height: 50.0,
                                  padding: const EdgeInsets.only(
                                      top: 0.0,
                                      bottom: 0.0,
                                      left: 16.0,
                                      right: 16.0),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      color: Color(0xFFFFFFFF),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10.0)
                                      ]),
                                  child: TextField(
                                    focusNode: focusPassword,
                                    controller: myControllerPassword,
                                    obscureText: _secureText,
                                    obscuringCharacter: "*",
                                    cursorColor: const Color(0xFFC41A3B),
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        icon: const Icon(
                                          Icons.lock_outline,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _secureText = !_secureText;
                                              });
                                            },
                                            icon: Icon(
                                                _secureText
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Colors.black45)),
                                        border: InputBorder.none,
                                        hintText: 'Contraseña',
                                        hintStyle: const TextStyle(
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black45,
                                            fontSize: 15)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 0,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RenewPassUser()),
                                      );
                                    },
                                    child: const Text(
                                      '¿Olvidé mi contraseña?',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0XFF00796B)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(
                                          MediaQuery.of(context).size.width /
                                              1.3,
                                          48),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      elevation: 10,
                                      primary: const Color(0XFF00AB74)),
                                  onPressed: () {
                                    _validarDatos();
                                  },
                                  child: const Text('INGRESAR'),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(
                                          MediaQuery.of(context).size.width /
                                              1.3,
                                          48),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      elevation: 10,
                                      primary: const Color(0XFF00796B)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CreateUser()),
                                    );
                                  },
                                  child: const Text('CREAR USUARIO'),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(
                                          MediaQuery.of(context).size.width /
                                              1.3,
                                          48),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30)),
                                      elevation: 10,
                                      primary: kDarkSecondaryColor),
                                  onPressed: () {
                                    showDialog(

                                        context: context,
                                        builder: (context) =>  CustomDialogsAlertEliminar(
                                          title: "Confirma tus credenciales",
                                          description:
                                          "Recuerda que al eliminar tu cuenta de usuario, también se eliminarán todos los datos relacionados con esta cuenta, para la protección de tu información",
                                          imagen: "assets/images/usuario.png",
                                        ));
                                  },
                                  child: const Text('ELIMINAR USUARIO'),
                                ),
                                /*const Text(
                                  'PERSONAL AUTORIZADO',
                                  style: TextStyle(fontSize: 16),
                                ),*/
                                const SizedBox(
                                  height: 18,
                                ),
                                /*ElevatedButton.icon(
                                  icon: const Icon(Icons.fingerprint),
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(
                                          MediaQuery.of(context).size.width /
                                              1.3,
                                          48),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      elevation: 10,
                                      side: const BorderSide(
                                          width: 4.0, color: Color(0XFF00AB74)),
                                      primary: const Color(0XFF2d2d2d)),
                                  onPressed: () {},
                                  label: const Text(
                                    'OLVIDÉ MI CONTRASEÑA',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )*/
                              ],
                            ),
                          )),
                    ),
                  )))
        ],
      ),
    ));
  }

  _getCirculo(dx, dy, _scale, _color) {
    return Transform.translate(
      offset: Offset(dx, dy),
      child: Transform.scale(
        scale: _scale,
        child: Container(
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: _color,
              borderRadius:
                  BorderRadius.circular(MediaQuery.of(context).size.width),
              boxShadow: const [
                BoxShadow(color: Colors.black45, blurRadius: 20.0)
              ]),
        ),
      ),
    );
  }

  void _validarDatos() {
    if (myControllerUser.text.isNotEmpty) {
      if (myControllerPassword.text.isNotEmpty) {
        //validar si es DNI o NISIRA
        final regExp = RegExp('[0-9]');
        if (regExp.hasMatch(myControllerUser.text)) {
          //Llamar a Login Obrero(DNI)

          String? pass = nisira.encriptar(myControllerPassword.text);
          getUsers(myControllerUser.text,pass!, );

          //getSesionObrero();

         // getUsers(myControllerUser.text);
        } else {
          RecibirDatosUsuarios();
          //llamar a Login NISIRA
         // getSesionNisira();
        }
      } else {
        focusPassword.requestFocus();
        EasyLoading.showToast(
            "Por favor ingresa tu contraseña. Completa los campos requeridos para INGRESAR.");
      }
    } else {
      focusUser.requestFocus();
      EasyLoading.showToast(
          "Por favor ingresa tu usuario. Completa los campos requeridos para INGRESAR.");
    }
  }

  _printLatestValue() {
    //print("Second text field: ${myControllerUser.text}");
    if (myControllerUser.text.isNotEmpty) {
      final regExp = RegExp('[0-9]');
      if (!regExp.hasMatch(myControllerUser.text)) {
        _typeKeyboardText = true;
      } else {
        _typeKeyboardText = false;
      }
    } else {
      _typeKeyboardText = true;
    }
  }

  TextInputType _getTextInputTypeText(bool option) {
    if (option) {
      print("texto");
      return TextInputType.text;
    } else {
      print("numero");
      return TextInputType.number;
    }
    //option ? return TextInputType.text : return TextInputType.number;
  }




}


class CustomDialogsAlert extends StatelessWidget {
  final String? title, description, buttontext, imagen, nombre;
  final Image? image;

  const CustomDialogsAlert(
      {Key? key,
        this.title,
        this.description,
        this.buttontext,
        this.image,
        this.imagen,
        this.nombre})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: dialogContents(context),
    );
  }

  dialogContents(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(50),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                imagen!,
                width: 64,
                height: 64,
              ),
              const SizedBox(height: 20.0),
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Divider(),
              const SizedBox(height: 10.0),
              Text(
                description!,
                style: const TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: Offset(0.0, 10.0),
                            )
                          ]),
                      child: TextButton(
                        //color: kArandano,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class CustomDialogsAlertEliminar extends StatefulWidget {
  final String? title, description, buttontext, imagen, nombre;
  final Image? image;

  CustomDialogsAlertEliminar({Key? key,
    this.title,
    this.description,
    this.buttontext,
    this.image,
    this.imagen,
    this.nombre})
      : super(key: key);

  @override
  _CustomDialogsAlertEliminarState createState() => _CustomDialogsAlertEliminarState();
}

class _CustomDialogsAlertEliminarState extends State<CustomDialogsAlertEliminar> {
  final myControllerUser = TextEditingController();
  final myControllerPassword = TextEditingController();
  bool _secureText = true;
  late FocusNode focusUser, focusPassword;
  bool _typeKeyboardText = true;
  String? ideliminar;
  int estado_eliminado = 0;

  @override
  void initState() {
    super.initState();
    focusUser = FocusNode();
    focusPassword = FocusNode();
    myControllerUser.addListener(_printLatestValue);

    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);*/
  }

  Future<void> deleteUsers(String id) async{
    final collection = FirebaseFirestore.instance.collection('users');
    collection
        .doc(id) // <-- Doc ID to be deleted.
        .delete() // <-- Delete
        .then((_) => print('Deleted'))
        .catchError((error) => print('Delete failed: $error'));

  }

  Future<void> getUsers(dni, pass) async{

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    var usuariosF = FirebaseFirestore.instance.collection("users").where("dni",isEqualTo: dni).where("password", isEqualTo: pass);
    QuerySnapshot users = await usuariosF.get();
    setState((){
      if(users.docs.isNotEmpty){
        for(var doc in users.docs){
          //ideliminar = doc.id.toString();
          deleteUsers(doc.id.toString());
        }

        Navigator.pop(context);
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) => const CustomDialogsAlert(
              title: "Mensaje",
              description:
              "Usuario eliminado correctamente.",
              imagen: "assets/images/usuario.png",
            ));
            estado_eliminado = 1;
      }else{

        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) => const CustomDialogsAlert(
              title: "Advertencia",
              description:
              "Revisa tus credenciales. Usuario o contraseña incorrecta.",
              imagen: "assets/images/usuario.png",
            ));
      }
    });

  }

  _printLatestValue() {
    //print("Second text field: ${myControllerUser.text}");
    if (myControllerUser.text.isNotEmpty) {
      final regExp = RegExp('[0-9]');
      if (!regExp.hasMatch(myControllerUser.text)) {
        _typeKeyboardText = true;
      } else {
        _typeKeyboardText = false;
      }
    } else {
      _typeKeyboardText = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: dialogContents(context),
    );
  }

  dialogContents(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(50),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                widget.imagen!,
                width: 48,
                height: 48,
              ),
              const SizedBox(height: 20.0),
              Text(
                widget.title!,
                style: const TextStyle(fontFamily: "Schyler",
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 15.0),
              Container(
                width:
                MediaQuery.of(context).size.width / 1.3,
                //height: 50.0,
                padding: const EdgeInsets.only(
                    top: 0.0,
                    bottom: 0.0,
                    left: 16.0,
                    right: 16.0),
                decoration: const BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(16)),
                    color: Color(0xFFFFFFFF),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0)
                    ]),
                child: TextField(
                  focusNode: focusUser,
                  //autofocus: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp('[0-9_A-Za-zñÑ]')),
                    LengthLimitingTextInputFormatter(25)
                  ],
                  controller: myControllerUser,
                  cursorColor: const Color(0xFFC41A3B),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.account_circle,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      hintText: 'Usuario / DNI',
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black45,
                          fontSize: 15)),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                width:
                MediaQuery.of(context).size.width / 1.3,
                //height: 50.0,
                padding: const EdgeInsets.only(
                    top: 0.0,
                    bottom: 0.0,
                    left: 16.0,
                    right: 16.0),
                decoration: const BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(16)),
                    color: Color(0xFFFFFFFF),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0)
                    ]),
                child: TextField(
                  focusNode: focusPassword,
                  controller: myControllerPassword,
                  obscureText: _secureText,
                  obscuringCharacter: "*",
                  cursorColor: const Color(0xFFC41A3B),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      icon: const Icon(
                        Icons.lock_outline,
                        color: Colors.black,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _secureText = !_secureText;
                            });
                          },
                          icon: Icon(
                              _secureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black45)),
                      border: InputBorder.none,
                      hintText: 'Contraseña',
                      hintStyle: const TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black45,
                          fontSize: 15)),
                ),
              ),
              const Divider(),
              const SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                widget.description!,
                style: const TextStyle(fontSize: 12.0,fontFamily: "Schyler"),
                textAlign: TextAlign.justify,
              ),),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: BoxDecoration(
                          color: kDarkSecondaryColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: Offset(0.0, 10.0),
                            )
                          ]),
                      child: TextButton(
                        //color: kArandano,
                          onPressed: () async {
                            String? pass = nisira.encriptar(myControllerPassword.text);
                              await getUsers(myControllerUser.text,pass! );
                           // Navigator.pop(context);
                              /*if(estado_eliminado == 1){
                                Navigator.pop(context);
                              }*/
                          },
                          child: const Text(
                            "Eliminar cuenta",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: Offset(0.0, 10.0),
                            )
                          ]),
                      child: TextButton(
                        //color: kArandano,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}