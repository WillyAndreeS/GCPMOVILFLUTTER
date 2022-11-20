import 'dart:convert';
import 'dart:io';
import 'package:acpmovil/views/login.dart';
import 'package:intl/intl.dart';
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

var myControllerFecha = TextEditingController();


class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final myControllerUser2 = TextEditingController();
  final myControllerPassword2 = TextEditingController();
  Color? coloralertaDni = Colors.black45;
  Color? coloralertaFecha = Colors.black45;
  Color? coloralertaPass = Colors.black45;
  List dataUser= [];
  bool _secureText = true;
  late FocusNode focusUser, focusPassword, focusFecha;
  bool _typeKeyboardText = true;

  List usuarios = [];

  Future<void> datosUsuario(nombre, dni) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("name", nombre.toString());
      prefs.setString("dni", dni.toString());

    });
  }

  Future createUser(String clave, String nombre, String empresa) async{
    var usuariosF = FirebaseFirestore.instance.collection("users").where("dni",isEqualTo: myControllerUser2.text);
    QuerySnapshot users = await usuariosF.get();

    if(users.docs.isEmpty) {
      print("vacio");
      setState((){
        final docUser = FirebaseFirestore.instance.collection("users");
        final json = {
          'dni': myControllerUser2.text,
          'nacimiento': myControllerFecha.text,
          'password': clave,
          'name': nombre,
          'empresa': empresa
        };
        docUser.add(json);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      });

    }else{
      print("lleno");
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => const CustomDialogsAlert(
            title: "Advertencia",
            description:
            "Usted ya tiene una cuenta activa",
            imagen: "assets/images/usuario.png",
          ));
    }
  }

  Future<String?> RecibirDatosUsuarios() async {
    String login = myControllerUser2.text;
    String clave = myControllerPassword2.text;
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
            body: {"accion": "datos_login", "dni": login, "clave": clave});
   //     if (mounted) {
        //  setState(() {
            var extraerData = json.decode(response.body);
            dataUser = extraerData["resultado"];
            print("REST: "+dataUser.toString());
            if(dataUser.isNotEmpty){
            if(dataUser[0]["RPTA"] == "TRUE"){
              if(dataUser[0]["FECHA_NACIMIENTO"] == myControllerFecha.text) {
                nombreUsuario = dataUser[0]["USR_NOMBRES"];
                await createUser(dataUser[0]["CLAVE"], dataUser[0]["USR_NOMBRES"],
                    dataUser[0]["EMPRESA"]);
                 datosUsuario(nombreUsuario, dniUsuario);
                /*EasyLoading.showToast(
                    "Registrado Correctamente");*/


              }else{
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => const CustomDialogsAlert(
                      title: "Advertencia",
                      description:
                      "Revisa tus credenciales. DNI o Fecha de nacimiento. incorrecta",
                      imagen: "assets/images/usuario.png",
                    ));

              }
            }else{
              Navigator.pop(context);

              showDialog(
                  context: context,
                  builder: (context) => const CustomDialogsAlert(
                    title: "Advertencia",
                    description:
                    "Revisa tus credenciales. DNI o Fecha de nacimiento. incorrecta",
                    imagen: "assets/images/usuario.png",
                  ));
             }
            }else{
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (context) => const CustomDialogsAlert(
                    title: "Advertencia",
                    description:
                    "Revisa tus credenciales. DNI o Fecha de nacimiento. incorrecta",
                    imagen: "assets/images/usuario.png",
                  ));
            }
         // });
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
  void initState() {
    super.initState();
    focusUser = FocusNode();
    focusPassword = FocusNode();
    focusFecha = FocusNode();
    myControllerUser2.addListener(_printLatestValue);

    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);*/
  }

  @override
  void dispose() {
    focusUser.dispose();
    focusPassword.dispose();
    focusFecha.dispose();
    myControllerUser2.dispose();
    myControllerPassword2.dispose();
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
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
                                  'Colaborador',
                                  style: TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Ingresa tus datos',
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
                                  decoration:  BoxDecoration(
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(16)),
                                      color: const Color(0xFFFFFFFF),
                                      boxShadow: [
                                        BoxShadow(
                                            color: coloralertaDni!,
                                            blurRadius: 10.0)
                                      ]),
                                  child: TextField(
                                    focusNode: focusUser,
                                    //autofocus: true,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9]')),
                                      LengthLimitingTextInputFormatter(8)
                                    ],
                                    controller: myControllerUser2,
                                    cursorColor: coloralertaDni,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.account_circle,
                                          color: Colors.black,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Ingresa tu DNI',
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
                                  decoration:  BoxDecoration(
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(16)),
                                      color: const Color(0xFFFFFFFF),
                                      boxShadow: [
                                        BoxShadow(
                                            color: coloralertaFecha!,
                                            blurRadius: 10.0)
                                      ]),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context, builder: (context) => CustomDialogsBuscar());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      // margin: EdgeInsets.only(left: 10),
                                      height: 60,
                                      width: MediaQuery.of(context).size.width / 1.3,
                                      child: TextFormField(
                                        focusNode: focusFecha,
                                        enabled: false,
                                        cursorColor: kPrimaryColor,
                                        controller: myControllerFecha,
                                        decoration: const InputDecoration(
                                            icon:  Icon(
                                              Icons.date_range,
                                              color: Colors.black,
                                            ),
                                            border: InputBorder.none,
                                            hintText: 'Selec. Fecha de Nac.',
                                            hintStyle:  TextStyle(
                                                fontStyle: FontStyle.normal,
                                                color: Colors.black45,
                                                fontSize: 15)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox( height: 16,),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  //height: 50.0,
                                  padding: const EdgeInsets.only(
                                      top: 0.0,
                                      bottom: 0.0,
                                      left: 16.0,
                                      right: 16.0),
                                  decoration:  BoxDecoration(
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(16)),
                                      color: const Color(0xFFFFFFFF),
                                      boxShadow: [
                                        BoxShadow(
                                            color: coloralertaPass!,
                                            blurRadius: 10.0)
                                      ]),
                                  child: TextField(
                                    focusNode: focusPassword,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(4)
                                    ],
                                    controller: myControllerPassword2,
                                    obscureText: _secureText,
                                    obscuringCharacter: "*",
                                    cursorColor: coloralertaPass,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.number,
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
                                      primary: const Color(0XFF00AB74)),
                                  onPressed: () {
                                    _validarDatos();
                                  },
                                  child: const Text('REGISTRAR'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width:  MediaQuery.of(context).size.width / 1.3,
                                  child: const Text("EN CASO DE TENER INCONVENIENTES CON SU REGISTRO, COMUNICARSE CON EL Nº CEL: 994601340", style: TextStyle(fontSize: 12),),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width:  MediaQuery.of(context).size.width / 1.3,
                                  child: const Text("PERSONAL AUTORIZADO", style: TextStyle(fontWeight: FontWeight.bold),),
                                ),

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
    if (myControllerUser2.text.isNotEmpty) {
      coloralertaDni = Colors.black45;
      if (myControllerPassword2.text.isNotEmpty) {
        coloralertaPass = Colors.black45;
        if(myControllerFecha.text.isNotEmpty){
          coloralertaFecha = Colors.black45;
        //validar si es DNI o NISIRA
        final regExp = RegExp('[0-9]');
        if (regExp.hasMatch(myControllerUser2.text)) {
          if(myControllerUser2.text.length == 8){
            coloralertaDni = Colors.black45;

            //createUser();
            RecibirDatosUsuarios();
          }else{
            showDialog(
                context: context,
                builder: (context) => const CustomDialogsAlert(
                  title: "Advertencia",
                  description:
                  "Por favor ingresa un DNI válido",
                  imagen: "assets/images/usuario.png",
                ));
               coloralertaDni = const Color(0xFFC41A3B);
          }

        } else {
          showDialog(
              context: context,
              builder: (context) => const CustomDialogsAlert(
                title: "Advertencia",
                description:
                "Por favor ingresa un DNI válido",
                imagen: "assets/images/usuario.png",
              ));
            coloralertaDni = const Color(0xFFC41A3B);
          //llamar a Login NISIRA
         // getSesionNisira();
        }
         } else {
          focusFecha.requestFocus();
          showDialog(
              context: context,
              builder: (context) => const CustomDialogsAlert(
                title: "Advertencia",
                description:
                "Por favor ingresa tu Fecha de nacimiento. Completa los campos requeridos para INGRESAR",
                imagen: "assets/images/usuario.png",
              ));
          coloralertaFecha = const Color(0xFFC41A3B);
        }
      } else {
        focusPassword.requestFocus();
        showDialog(
            context: context,
            builder: (context) => const CustomDialogsAlert(
              title: "Advertencia",
              description:
              "Por favor ingresa tu Contraseña. Completa los campos requeridos para INGRESAR",
              imagen: "assets/images/usuario.png",
            ));
        coloralertaPass = const Color(0xFFC41A3B);
      }
    } else {
      focusUser.requestFocus();
      showDialog(
          context: context,
          builder: (context) => const CustomDialogsAlert(
            title: "Advertencia",
            description:
            "Por favor ingresa tu DNI. Completa los campos requeridos para INGRESAR",
            imagen: "assets/images/usuario.png",
          ));
     /* EasyLoading.showToast(
          "Por favor ingresa tu DNI. Completa los campos requeridos para INGRESAR.");*/
      coloralertaDni = const Color(0xFFC41A3B);
    }
  }



  _printLatestValue() {
    //print("Second text field: ${myControllerUser.text}");
    if (myControllerUser2.text.isNotEmpty) {
      final regExp = RegExp('[0-9]');
      if (!regExp.hasMatch(myControllerUser2.text)) {
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

class CustomDialogsBuscar extends StatefulWidget {
  CustomDialogsBuscar({Key? key}) : super(key: key);

  @override
  _CustomDialogsBuscarState createState() => _CustomDialogsBuscarState();
}

class _CustomDialogsBuscarState extends State<CustomDialogsBuscar> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
        // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
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
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          width: size.width * 0.9,
          height: size.height / 2,
          padding: const EdgeInsets.only(bottom: 40, left: 20),
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
              Container(
                child: Column(children: <Widget>[
                  SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.single,
                    //showActionButtons: true
                  )
                ]),
              ),
              const SizedBox(height: 10.0),
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
                            myControllerFecha.text =
                                _selectedDate.substring(0, 10);
                            //cargarDatos(_selectedDate.substring(0, 10));
                          },
                          child: const Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                  const SizedBox(width: 10),
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