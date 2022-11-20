import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/login.dart';
import 'package:acpmovil/views/utilidades.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';



class DetalleUtilidadesFinal extends StatefulWidget {
  List? dataUtilidades = [];
  DetalleUtilidadesFinal({Key? key, this.dataUtilidades}) ;
  @override
  _DetalleUtilidadesFinalState createState() => _DetalleUtilidadesFinalState();
}

class _DetalleUtilidadesFinalState extends State<DetalleUtilidadesFinal> {


bool hasInternet = false;
bool isChecked = false;
late StreamSubscription internetSubscription;
late StreamSubscription subscription;
ConnectivityResult result = ConnectivityResult.none;
List<String> bancoA = [];
List resultado = [];
List bancoB = [];
String? bancoId;
ReceivePort receivePort = ReceivePort();
int progress = 0;
final myControllerCel = TextEditingController();
final myControllerLugar = TextEditingController();
final myControllerCorreo = TextEditingController();
final myControllerCuenta = TextEditingController();
int limite_digitos_cuenta_min = 0 ;
int limite_digitos_cuenta_max = 0;
bool _visible = false;
bool _visiblecuenta = false;
String tv_numero_titulo = "N° DE CUENTA";
String? IDCEL = "";
@override
void initState() {
  super.initState();
  Connectivity().onConnectivityChanged.listen((result) {
    setState(() => this.result = result);
  });
  InternetConnectionChecker().onStatusChange.listen((status) {
    final hasInternet = status == InternetConnectionStatus.connected;
    setState(() => this.hasInternet = hasInternet);
  });
  llenarLista();
  _getId();
}

Future<String?> RegistrarSolicitud() async {

  String results, RPTA, MENSAJE;
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      });
  if(bancoId == "APER_BCP"){
  if(myControllerCel.text.toString().length == 9 && myControllerLugar.text.toString().trim().length > 2 && myControllerCorreo.text.toString().contains("@")){
    var response = await http.post(
        Uri.parse(url_base + "acpmovil/controlador/datos-controlador.php"),
        body: {"accion":"_6081CDFRF6091", "ID_SOLICITUD": widget.dataUtilidades![0]["ID_SOLICITUD_NUEVO"].toString()+"-"+IDCEL.toString(), "IDCODIGOGENERAL":widget.dataUtilidades![0]["IDCODIGOGENERAL"].toString(), "ANIO":widget.dataUtilidades![0]["ANIO"].toString(), "IDTELEFONO": IDCEL,
          "IMEI": "", "IDBANCO": bancoId, "NUMERO_CUENTA": "", "NUMERO_CELULAR": myControllerCel.text, "CORREO": myControllerCel.text, "PROCEDENCIA": myControllerLugar.text});
    var extraerData = json.decode(response.body);
    results = extraerData["resultado"].toString();
    print("RESPONSE: " + results.toString());
    resultado= extraerData["resultado"];
    Navigator.pop(context);
    if(results== null){
      RPTA="ERROR_DESCONOCIDO / SIN RESPUESTA";
      MENSAJE="ERROR DESCONOCIDO / SIN RESPUESTA";
      showDialog(
          context: context,
          builder: (context) => const CustomDialogsAlert(
            title: "ERROR",
            description:
            "ERROR DESCONOCIDO / SIN RESPUESTA",
            imagen: "assets/images/advertencia.png",
          ));
    }else if(results.toUpperCase().contains("TRUE")){//TRUE
      showDialog(
          context: context,
          builder: (context) =>  CustomDialogsAlertExito(
            title: "GENIAL",
            description:
            resultado[0]["MENSAJE"].toString().replaceAll("<b>", "").replaceAll("</b>", ""),
            imagen: "assets/images/97240-success.gif",
          ));

    }else if(results.toUpperCase().contains("FALSE")){//FALSE
      showDialog(
          context: context,
          builder: (context) =>  CustomDialogsAlert(
            title: "HEY!",
            description:
            resultado[0]["MENSAJE"].toString().replaceAll("<b>", "").replaceAll("</b>", ""),
            imagen: "assets/images/advertencia.png",
          ));
    }else{//ERROR
      showDialog(
          context: context,
          builder: (context) => const CustomDialogsAlert(
            title: "MENSAJE",
            description:
            "Error de conexión, inténtalo nuevamente, verifica tu conexión a INTERNET",
            imagen: "assets/images/advertencia.png",
          ));
    }

  }else{
    showDialog(
        context: context,
        builder: (context) => const CustomDialogsAlert(
          title: "MENSAJE",
          description:
          "Debes ingresar un número de CELULAR válido (9 dígitos) / Procedencia y CORREO VÁLIDO.",
          imagen: "assets/images/advertencia.png",
        ));
  }

  }else{
    if(myControllerCuenta.text.toString().trim().length == limite_digitos_cuenta_min || myControllerCuenta.text.toString().trim().length == limite_digitos_cuenta_max) {
      if (myControllerCel.text
          .toString()
          .length == 9 && myControllerLugar.text
          .toString()
          .trim()
          .length > 2 && myControllerCorreo.text.toString().contains("@")) {
        var response = await http.post(
            Uri.parse(url_base + "acpmovil/controlador/datos-controlador.php"),
            body: {
              "accion": "_6081CDFRF6091",
              "ID_SOLICITUD": widget.dataUtilidades![0]["ID_SOLICITUD_NUEVO"].toString()+"-"+IDCEL.toString(),
              "IDCODIGOGENERAL": widget.dataUtilidades![0]["IDCODIGOGENERAL"]
                  .toString(),
              "ANIO": widget.dataUtilidades![0]["ANIO"].toString(),
              "IDTELEFONO": IDCEL,
              "IMEI": "",
              "IDBANCO": bancoId,
              "NUMERO_CUENTA": myControllerCuenta.text.trim(),
              "NUMERO_CELULAR": myControllerCel.text,
              "CORREO": myControllerCel.text,
              "PROCEDENCIA": myControllerLugar.text
            });
        var extraerData = json.decode(response.body);
        results = extraerData["resultado"].toString();
        print("RESPONSE: " + results.toString());
        resultado= extraerData["resultado"];
        print("RESPONSE2: " + resultado[0]["MENSAJE"].toString());
        Navigator.pop(context);
        if(results== null){
          RPTA="ERROR_DESCONOCIDO / SIN RESPUESTA";
          MENSAJE="ERROR DESCONOCIDO / SIN RESPUESTA";
          showDialog(
              context: context,
              builder: (context) => const CustomDialogsAlert(
                title: "ERROR",
                description:
                "ERROR DESCONOCIDO / SIN RESPUESTA",
                imagen: "assets/images/advertencia.png",
              ));
        }else if(results.toUpperCase().contains("TRUE")){//TRUE
          showDialog(
              context: context,
              builder: (context) =>  CustomDialogsAlertExito(
                title: "GENIAL",
                description:
                resultado[0]["MENSAJE"].toString().replaceAll("<b>", "").replaceAll("</b>", ""),
                imagen: "assets/images/97240-success.png",
              ));
          print("RESPONSE: genial - "+ results);
        }else if(results.toUpperCase().contains("FALSE")){//FALSE
          showDialog(
              context: context,
              builder: (context) =>  CustomDialogsAlert(
                title: "HEY!",
                description:
                resultado[0]["MENSAJE"].toString().replaceAll("<b>", "").replaceAll("</b>", ""),
                imagen: "assets/images/advertencia.png",
              ));
        }else{//ERROR
          showDialog(
              context: context,
              builder: (context) => const CustomDialogsAlert(
                title: "MENSAJE",
                description:
                "Error de conexión, inténtalo nuevamente, verifica tu conexión a INTERNET",
                imagen: "assets/images/advertencia.png",
              ));
        }
      } else {
        showDialog(
            context: context,
            builder: (context) =>
            const CustomDialogsAlert(
              title: "MENSAJE",
              description:
              "Debes ingresar un número de CELULAR válido (9 dígitos) / Procedencia y CORREO VÁLIDO.",
              imagen: "assets/images/advertencia.png",
            ));
      }
    }else{
      showDialog(
          context: context,
          builder: (context) =>
          const CustomDialogsAlert(
            title: "MENSAJE",
            description:
            "Debes ingresar un número de cuenta válido, correspondiente al banco seleccionado.",
            imagen: "assets/images/advertencia.png",
          ));
    }
  }
}


void llenarLista() async{
  bancoA.clear();
  bancoB.clear();
  if(widget.dataUtilidades![0]["ACTIVO"].toString() == "1"){
      bancoB.add({"EMPRESA":"CUENTA_SIS", "NOMBRE":"CUENTA DEL SISTEMA"});
      bancoA.add("CUENTA DEL SISTEMA");
      bancoB.add({"EMPRESA":"BCON", "NOMBRE":"BBVA BANCO CONTINENTAL"});
      bancoB.add({"EMPRESA":"BCRE", "NOMBRE":"BANCO DE CRÉDITO BCP"});
      bancoA.add("BBVA BANCO CONTINENTAL");
      bancoA.add("BANCO DE CRÉDITO BCP");

      if(widget.dataUtilidades![0]["EMPRESA"].toString() == "ACP"){
        bancoB.add({"EMPRESA":"SCOT", "NOMBRE":"SCOTIABANK"});
        bancoA.add("SCOTIABANK");
      }


  }else{
    bancoB.add({"EMPRESA":"0000", "NOMBRE":"--- SELECCIONAR BANCO ---"});
    bancoB.add({"EMPRESA":"BCON", "NOMBRE":"BBVA BANCO CONTINENTAL"});
    bancoB.add({"EMPRESA":"BCRE", "NOMBRE":"BANCO DE CRÉDITO BCP"});
    bancoA.add("--- SELECCIONAR BANCO ---");
    bancoA.add("BBVA BANCO CONTINENTAL");
    bancoA.add("BANCO DE CRÉDITO BCP");
    bancoB.add({"EMPRESA":"APER_BCP", "NOMBRE":"APERTURAR CUENTA BCP"});
    bancoA.add("APERTURAR CUENTA BCP");

    if(widget.dataUtilidades![0]["EMPRESA"].toString() == "ACP"){
      bancoB.add({"EMPRESA":"SCOT", "NOMBRE":"SCOTIABANK"});
      bancoA.add("SCOTIABANK");
    }


  }
}

Future<String?> _getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    IDCEL = iosDeviceInfo.identifierForVendor.toString();
    print("IDCEL: "+IDCEL.toString());
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if(Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    IDCEL = androidDeviceInfo.androidId.toString();
    print("IDCEL: "+IDCEL.toString());
    return androidDeviceInfo.androidId; // unique ID on Android

  }
}


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
    //  resizeToAvoidBottomInset : false,
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("3/3 Finalizar solicitud", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),
        body: widget.dataUtilidades!.isEmpty? Center(child:CircularProgressIndicator()): Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(scrollDirection: Axis.vertical,
    child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
           Container(
              width: size.width,
                  child:Text('NETO A PAGAR', style: TextStyle(fontFamily: "Schyler", fontSize: 24), textAlign: TextAlign.center,)),
              SizedBox(height: 10,),
              Text("S/. "+widget.dataUtilidades![0]["NETO_PAGADO"], style: TextStyle(fontFamily: "Schyler", fontSize: 24)),
              const  SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.symmetric( vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: size.width,
                decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.white, boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

                    ]),
                child: SingleChildScrollView(scrollDirection: Axis.vertical, child: Column( children: [
                  Text("SELECCIONAR BANCO", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey)),
                  SizedBox(height: 5,),
                  Row(children: [
                    Container( padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.maps_home_work_outlined)),
                    Container( width: size.width/1.5, margin: EdgeInsets.symmetric(horizontal: 12), child: FormHelper.dropDownWidget(context, "--- SELECCIONAR BANCO ---", bancoId, bancoB, (onChangedVal){
                      setState((){
                        bancoId = onChangedVal;
                        print("Banco seleccionado"+ onChangedVal);
                        //edt_cuenta.setText("");
                        if(bancoId == "APER_BCP" || bancoId == "0000" || bancoId == "CUENTA_SIS"){
                          tv_numero_titulo = "N° DE CUENTA";
                          limite_digitos_cuenta_min=0;
                          limite_digitos_cuenta_max=0;
                          _visible = false;
                          _visiblecuenta = false;
                        }else if(bancoId == "BCRE"){
                          tv_numero_titulo = "N° DE CUENTA (14 DÍGITOS)";
                          _visible = true;
                          _visiblecuenta = true;
                          limite_digitos_cuenta_min=14;
                          limite_digitos_cuenta_max=14;
                        }else if(bancoId == "BCON"){
                          tv_numero_titulo = "NÚMERO DE CUENTA";
                          _visible = true;
                          _visiblecuenta = true;
                          limite_digitos_cuenta_min=18;
                          limite_digitos_cuenta_max=20;
                        }else if(bancoId == "SCOT"){
                          tv_numero_titulo = "N° DE CUENTA (10 DÍGITOS)";
                          _visible = true;
                          _visiblecuenta = true;
                          limite_digitos_cuenta_min=10;
                          limite_digitos_cuenta_max=10;
                        }
                      });

                    }, (onValidateVal){
                      if(onValidateVal == null){
                        return "Por favor selecciona un Banco";
                      }
                      return null;
                    },
                      borderColor: kDarkSecondaryColor,
                      borderFocusColor: kDarkSecondaryColor,
                      borderRadius: 25,
                      optionValue: "EMPRESA",
                      optionLabel: "NOMBRE"

                    )),
                  ],),
                AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child:Divider(thickness: 2),),
                  AnimatedOpacity(
                    opacity: _visible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Text(tv_numero_titulo, style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey)),
                  ),
                AnimatedOpacity(
                  opacity: _visiblecuenta ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Row(children: [
                    Container( padding: _visiblecuenta ? EdgeInsets.all(10): EdgeInsets.all(0),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.account_balance_wallet_rounded)),
                    Container( width:  _visiblecuenta ? size.width/1.5 : 0, height: _visiblecuenta ? size.height/15 : 0, margin: _visiblecuenta ? EdgeInsets.symmetric(horizontal: 12) : EdgeInsets.symmetric(horizontal: 0), child: TextField(
                      controller: myControllerCuenta,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.red
                            ),),
                          hintText: 'NÚMERO DE CUENTA'//43121221 - 2323
                      ),
                    ),)

                  ],),),
                  Divider(thickness: 2),
                  Text("LUGAR DE PROCEDENCIA", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey)),
                  Row(children: [
                    Container( padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.location_pin)),
                    Container( width: size.width/1.5, margin: EdgeInsets.symmetric(horizontal: 12), child: TextField(
                      controller: myControllerLugar,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.red
                              ),),
                          hintText: 'PROCEDENCIA'
                      ),
                    ),)
                  ],),
                  Divider(thickness: 2),
                  Text("CORREO", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey)),
                  Row(children: [
                    Container( padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.mail)),
                    Container( width: size.width/1.5, margin: EdgeInsets.symmetric(horizontal: 12), child: TextField(
                      controller: myControllerCorreo,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.red
                            ),),
                          hintText: 'micorreo@ejemplo.com'
                      ),
                    ),)
                  ],),
                  Divider(thickness: 2),
                  Text("NÚMERO DE CELULAR", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey)),
                  Row(children: [
                    Container( padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.phone_android)),
                    Container( width: size.width/1.5, margin: EdgeInsets.symmetric(horizontal: 12), child: TextField(
                      controller: myControllerCel,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.red
                            ),),
                          hintText: 'CELULAR (9 DÍGITOS)'//43121221 - 2323
                      ),
                    ),)

                  ],),
                ],),),
              )

          ],)),
        ),
    bottomNavigationBar: widget.dataUtilidades!.isEmpty? Container(color:Colors.white, height: size.height/6,) :Container(
      height: size.height/6,
        color: Colors.grey[300],
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          Row(children: [
            Container(
                width: size.width/1.1,
                child: Text("NOTA: Recuerda verificar los datos ingresados para posteriormente pulsar en FINALIZAR PROCESO", style: const TextStyle(color: Colors.black,fontFamily: "Schyler",fontSize: 14), textAlign: TextAlign.center,maxLines: 3,
                  overflow: TextOverflow.ellipsis,))]),
          SizedBox(height: 10,),
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
                primary: kPrimaryColor),
            onPressed: () {
              RegistrarSolicitud();

            },
            child: const Text("FINALIZAR PROCESO", style: TextStyle(fontFamily: "Schyler", fontSize: 13), textAlign: TextAlign.center,),
          ),
        ],)
    ),);
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

class CustomDialogsAlertExito extends StatelessWidget {
  final String? title, description, buttontext, imagen, nombre;
  final Image? image;

  const CustomDialogsAlertExito(
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  Utilidades()));
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