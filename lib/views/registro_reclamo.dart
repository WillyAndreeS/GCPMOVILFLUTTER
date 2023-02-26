import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/login.dart';
import 'package:acpmovil/views/quejasreclamos.dart';
import 'package:acpmovil/views/utilidades.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';



class RegistroReclamo extends StatefulWidget {
  List? quejasDetalle = [];
  List? reclamospadre = [];
  List? grupotrabajo = [];
  List? bono = [];
  List? anioutilidades = [];
  int? idpadre;
  int? idtiporeclamo;
  RegistroReclamo({Key? key, this.quejasDetalle, this.reclamospadre, this.idpadre, this.grupotrabajo, this.bono, this.anioutilidades, this.idtiporeclamo}) ;
  @override
  _RegistroReclamoState createState() => _RegistroReclamoState();
}

class _RegistroReclamoState extends State<RegistroReclamo> {


bool hasInternet = false;
bool isChecked = false;
late StreamSubscription internetSubscription;
late StreamSubscription subscription;
ConnectivityResult result = ConnectivityResult.none;
ReceivePort receivePort = ReceivePort();
int progress = 0;
final myControllerCel = TextEditingController();
final myControllerFecha = TextEditingController();
final myControllerTareador = TextEditingController();
final myControllerLabor = TextEditingController();
final myControllerSemana = TextEditingController();
final myControllerDetalle = TextEditingController();
final myControllerOtro = TextEditingController();
final DateTime now = DateTime.now();
List? datatiporeclamo = [];
bool tiporeclamo = false;
bool grupotrabajo = false;
bool fecha = false;
bool tareador = false;
bool labor = false;
bool semana = false;
bool bonoreclamo = false;
bool anioreclamo = false;
bool detallereclamo = false;
bool celular = false;
bool otro = false;

String? IDCEL, idsubreclamo, idgruposeleccionado, idbonoseleccionado, idanioseleccionada,tv_dato_extra_01;



@override
void initState() {
  super.initState();
  MostrarControles();
  Connectivity().onConnectivityChanged.listen((result) {
    setState(() => this.result = result);
  });
  InternetConnectionChecker().onStatusChange.listen((status) {
    final hasInternet = status == InternetConnectionStatus.connected;
    setState(() => this.hasInternet = hasInternet);
  });
  print("ID:"+widget.idtiporeclamo.toString());
  TiposReclamos();
  _getId();
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

Future<List?> TiposReclamos() async{
  datatiporeclamo!.clear();

  setState((){
    for(int i = 0; i < widget.reclamospadre!.length ; i++ ){
      print("DATOS ID "+widget.reclamospadre![i]["IDRECLAMO_PADRE"].toString());
      print("DATOS PADRE "+widget.idpadre.toString());
      if(widget.reclamospadre![i]["IDRECLAMO_PADRE"].toString() == widget.idtiporeclamo.toString()){
        print(widget.reclamospadre![i]["DESCRIPCION"]);
        datatiporeclamo!.add({"ID": widget.reclamospadre![i]["IDTIPORECLAMO"], "DESCRIPCION": widget.reclamospadre![i]["DESCRIPCION"]});
      }
    }
  });
return datatiporeclamo;
}

void alerta_crear_reclamo(final String p01, final String p02, final String p03, final String p04, final String p05, final String p06, final String p07, final String p08, final String p09, final String p10, final String p11, final String p12, final String p13, final String p14) async {
  String RPTA = "VACIO";
  String MENSAJE = "SIN_MENSAJE";
  List resultado = [];
  return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("¿ENVIAR RECLAMO?"),
          content: Text("Recuerda que los datos ingresados deben ser verdaderos, para solucionar rápidamente tu RECLAMO."),
          actions: <Widget>[
          TextButton(onPressed: () async{
  var response = await http.post(
      Uri.parse(url_base + "acpmovil/controlador/datos-controlador.php"),
      body: {
        "accion": "_5WQFZV24D2SYFQ",
        "_5WQ1RY9JK2SYFQ": p01,
        "_5WQJJTNFX2SYFQ": p02,
        "_5WQ1QKI5N2SYFQ": p03,
        "_5WQRXWX0Q2SYFQ": p04,
        "_5WQ33D9F2SYFQG": p05,
        "_5WQYLCVTI2SYFQ": p06,
        "_5WQA68Y6H2SYFQ": p07,
        "_5WQM3R1NM2SYFQ": p08,
        "_5WQQ6G6HX2SYFQ": p09,
        "_5WQEISDU22SYFQ": p10,
        "_5WQPF9XBN2SYFQ": p11,
        "_5WQPG6OSF2SYFQ": p12,
        "_5WQPG6OSF2SYFZ": p13,
        "_5WQPG6OSF2SYZZ": empresaUsuario,
        "_5WQPG6OSF2SYDD": p14
      });
  var extraerData = json.decode(response.body);
  resultado = extraerData["resultado"];
  for(int i = 0; i< resultado.length; i++){
    RPTA = resultado[i]["RPTA"];
    MENSAJE = resultado[i]["MENSAJE"];
  }
  if(RPTA== null){
    RPTA="ERROR_DESCONOCIDO / SIN RESPUESTA";
    MENSAJE="ERROR DESCONOCIDO / SIN RESPUESTA";
  }
  Navigator.pop(context);
  showDialog(
      context: context,
      builder: (context) =>   CustomDialogsAlertExito(
        title: "MENSAJE",
        description: MENSAJE,
        imagen: "assets/images/97240-success.gif",
      ));

          }, child: Text("OK")),
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("CANCELAR")),
          ],
      )
  );

  print("RESPONSE: " + resultado.toString());
}

void MostrarControles(){
  setState((){
    if(widget.idtiporeclamo! == 19) {
      tiporeclamo = true;
      grupotrabajo = true;
      fecha = true;
      tareador = true;
      labor = true;
      semana = false;
      bonoreclamo = false;
      anioreclamo = false;
      detallereclamo = true;
      celular = true;
    }else if(widget.idtiporeclamo! == 25){
      tiporeclamo = false;
      grupotrabajo = true;
      fecha = false;
      tareador = false;
      labor = false;
      semana = false;
      bonoreclamo = false;
      anioreclamo = true;
      detallereclamo = true;
      celular = true;
    }else if(widget.idtiporeclamo! == 26){
      tiporeclamo = false;
      grupotrabajo = true;
      fecha = false;
      tareador = false;
      labor = false;
      semana = false;
      bonoreclamo = false;
      anioreclamo = false;
      detallereclamo = true;
      celular = true;
    }else if(widget.idtiporeclamo! == 27){
      tiporeclamo = false;
      grupotrabajo = true;
      fecha = true;
      tareador = false;
      labor = false;
      semana = false;
      bonoreclamo = false;
      anioreclamo = false;
      detallereclamo = true;
      celular = true;
    }else if(widget.idtiporeclamo! == 28){
      tiporeclamo = true;
      grupotrabajo = true;
      fecha = false;
      tareador = false;
      labor = false;
      semana = false;
      bonoreclamo = false;
      anioreclamo = false;
      detallereclamo = true;
      celular = true;
    }else if(widget.idtiporeclamo! == 31){
      tiporeclamo = false;
      grupotrabajo = true;
      fecha = false;
      tareador = false;
      labor = false;
      semana = false;
      bonoreclamo = false;
      anioreclamo = false;
      detallereclamo = true;
      celular = true;
    }else if(widget.idtiporeclamo! == 32){
      tiporeclamo = false;
      grupotrabajo = true;
      fecha = false;
      tareador = false;
      labor = false;
      semana = false;
      bonoreclamo = false;
      anioreclamo = false;
      detallereclamo = true;
      celular = true;
    }else if(widget.idtiporeclamo! == 33){
      tiporeclamo = false;
      grupotrabajo = true;
      fecha = false;
      tareador = false;
      labor = false;
      semana = false;
      bonoreclamo = false;
      anioreclamo = false;
      detallereclamo = true;
      celular = true;
    }else if(widget.idtiporeclamo! == 34){
      tiporeclamo = false;
      grupotrabajo = true;
      fecha = false;
      tareador = false;
      labor = false;
      semana = false;
      bonoreclamo = false;
      anioreclamo = false;
      detallereclamo = true;
      celular = true;
    }else if(widget.idtiporeclamo! == 35){
      tiporeclamo = false;
      grupotrabajo = true;
      fecha = false;
      tareador = false;
      labor = false;
      semana = true;
      bonoreclamo = false;
      anioreclamo = false;
      detallereclamo = true;
      celular = true;
    }else if(widget.idtiporeclamo! == 36){
      tiporeclamo = true;
      grupotrabajo = true;
      fecha = false;
      tareador = false;
      labor = false;
      semana = false;
      bonoreclamo = false;
      anioreclamo = false;
      detallereclamo = true;
      celular = true;
    }else if(widget.idtiporeclamo! == 37){
      tiporeclamo = false;
      grupotrabajo = true;
      fecha = false;
      tareador = false;
      labor = false;
      semana = false;
      bonoreclamo = false;
      anioreclamo = false;
      detallereclamo = true;
      celular = true;
    }else if(widget.idtiporeclamo! == 38){
      tiporeclamo = true;
      grupotrabajo = true;
      fecha = false;
      tareador = false;
      labor = false;
      semana = false;
      bonoreclamo = false;
      anioreclamo = false;
      detallereclamo = true;
      celular = true;
    }else if(widget.idtiporeclamo! == 39){
      tiporeclamo = false;
      grupotrabajo = true;
      fecha = false;
      tareador = false;
      labor = false;
      semana = false;
      bonoreclamo = false;
      anioreclamo = false;
      detallereclamo = true;
      celular = true;
    }else{
      tiporeclamo = false;
      grupotrabajo = false;
      fecha = false;
      tareador = false;
      labor = false;
      semana = false;
      bonoreclamo = false;
      anioreclamo = false;
      detallereclamo = false;
      celular = false;
    }
  });

}


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int anioactual = now.year;
    final List anio = [{"ID":"1", "DESCRIPCION":(anioactual - 3).toString()}, {"ID":"2", "DESCRIPCION":(anioactual - 2).toString()}, {"ID":"3", "DESCRIPCION":(anioactual - 1).toString()}];
    return Scaffold(
    //  resizeToAvoidBottomInset : false,
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Registrar Reclamo", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),
        body:Container(
          //padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration:  const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_gcp.png",),
              fit: BoxFit.cover,
            ),
          ),
          child: Container( width: size.width, height: size.height,color: const Color.fromRGBO(255,255, 255, 0.8), child: SingleChildScrollView(scrollDirection: Axis.vertical,
    child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric( vertical: 20),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                width: size.width,
                child: SingleChildScrollView(scrollDirection: Axis.vertical, child: Column( mainAxisAlignment: MainAxisAlignment.start, children: [
                Visibility(maintainSize: tiporeclamo,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: tiporeclamo,
                  child: Container(width: size.width/1.6,child: Text("TIPO DE RECLAMO", style: TextStyle(fontFamily: "Schyler", fontSize: 11, color: Colors.grey)))),
                  SizedBox(height: tiporeclamo ? 5: 0,),
                  Visibility(maintainSize: tiporeclamo,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: tiporeclamo,
                  child: Row(children: [
                    Container( padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.receipt_long)),
                    datatiporeclamo == null ? Container(width: size.width/1.43,child: CircularProgressIndicator()): Container( width: size.width/1.35, child: FormHelper.dropDownWidget(context, "SELECCIONAR TIPO RECLAMO", "", datatiporeclamo!, (onChangedVal){
                      setState((){
                        idsubreclamo = onChangedVal;
                        switch (int.parse(idsubreclamo.toString())){
                          case 20://TAREO
                            fecha == true;
                            tareador == true;
                            labor == true;
                            anioreclamo == false;
                            bonoreclamo == false;
                            tv_dato_extra_01 = "DETALLE OTROS";
                            semana = false;
                            otro = false;
                            break;
                          case 21://BONOS
                            fecha = true;
                            tareador = false;
                            labor = false;
                            anioreclamo = false;
                            bonoreclamo = true;
                            tv_dato_extra_01 = "SEMANA (Opcional)";
                            semana = true;
                            otro = false;
                            break;
                          case 22://ASIGNACION FAMILIAR
                            fecha = true;
                            tareador = false;
                            labor = false;
                            anioreclamo = false;
                            bonoreclamo = false;
                            tv_dato_extra_01 = "A QUIÉN SE LE PRESENTÓ";
                            semana = true;
                            otro = false;
                            break;
                          case 23://VACACIONES
                            fecha = false;
                            tareador = false;
                            labor = false;
                            anioreclamo = false;
                            bonoreclamo = false;
                            tv_dato_extra_01 = "A QUIÉN SE LE PRESENTÓ";
                            semana = false;
                            otro = false;
                            break;
                          case 24://LIQUIDACIONES
                            fecha = false;
                            tareador = false;
                            labor = false;
                            anioreclamo = true;
                            bonoreclamo = false;
                            tv_dato_extra_01 = "A QUIÉN SE LE PRESENTÓ";
                            semana = false;
                            otro = false;
                            break;

                          case 29://LICENCIAS -> PATERNIDAD
                          case 30://LICENCIAS -> FALLECIMIENTO
                          fecha = false;
                          tareador = false;
                          labor = false;
                          anioreclamo = false;
                          bonoreclamo = false;
                          semana = false;
                          otro = false;
                            break;

                          case 44://BAÑOS -> FALTA PAPEL, AGUA Y/O JABÓN
                            fecha = false;
                            tareador = false;
                            labor = false;
                            anioreclamo = false;
                            bonoreclamo = false;
                            semana = false;
                            otro = false;
                            break;
                          case 45://BAÑOS -> PROBLEMAS DE LIMPIEZA
                            fecha = false;
                            tareador = false;
                            labor = false;
                            anioreclamo = false;
                            bonoreclamo = false;
                            semana = false;
                            otro = false;
                            break;
                          case 46://BAÑOS -> OTROS: DETALLE
                            fecha = false;
                            tareador = false;
                            labor = false;
                            anioreclamo = true;
                            bonoreclamo = false;
                            semana = false;
                            otro = true;
                            break;

                          case 40://MALOS TRATOS -> HOSTIGAMIENTO SEXUAL
                            fecha = false;
                            tareador = false;
                            labor = false;
                            anioreclamo = false;
                            bonoreclamo = false;
                            semana = false;
                            otro = false;
                            break;
                          case 41://MALOS TRATOS -> ACOSO SEXUAL
                            fecha = false;
                            tareador = false;
                            labor = false;
                            anioreclamo = false;
                            bonoreclamo = false;
                            semana = false;
                            otro = false;
                            break;
                          case 42://MALOS TRATOS -> HOSTIGAMIENTO SEXUAL
                            fecha = false;
                            tareador = false;
                            labor = false;
                            anioreclamo = false;
                            bonoreclamo = false;
                            semana = false;
                            otro = false;
                            break;
                          case 43://MALOS TRATOS -> OTROS: DETALLE
                            fecha = false;
                            tareador = false;
                            labor = false;
                            anioreclamo = false;
                            bonoreclamo = false;
                            semana = false;
                            otro = true;
                            break;
                        }
                      });

                    }, (onValidateVal){
                      if(onValidateVal == null){
                        return "Por favor selecciona un tipo de Reclamo";
                      }
                      return null;
                    },
                      borderColor: kDarkSecondaryColor,
                      borderFocusColor: kDarkSecondaryColor,
                      borderRadius: 15,
                        borderWidth: 1,
                        focusedBorderWidth: 0.5,
                        enabledBorderWidth: 1,
                      optionValue: "ID",
                      optionLabel: "DESCRIPCION"

                    )),
                    Visibility(maintainSize: otro,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: otro,
                        child: Container( width:MediaQuery.of(context).size.width / 1.5,
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
                                      blurRadius: 1.0)
                                ]), child: TextField(
                              controller: myControllerOtro,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Especifique...'
                              ),
                            ),)),
                  ],),),
                  SizedBox(height: tiporeclamo? 20:0,),
                  Visibility(maintainSize: grupotrabajo,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: grupotrabajo, child: Container(width: size.width/1.6,child:Text("GRUPO DE TRABAJO ACTUAL", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey)))),
                  Visibility(maintainSize: grupotrabajo,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: grupotrabajo,
                 child: Row(children: [
                   Container( padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.grass_outlined)),
                   Container( width: size.width/1.35, child: FormHelper.dropDownWidget(context, "SELECCIONAR GRUPO TRAB.", "", widget.grupotrabajo!, (onChangedVal){
                     setState((){
                       idgruposeleccionado = onChangedVal;
                     });

                   }, (onValidateVal){
                     if(onValidateVal == null){
                       return "Por favor selecciona un tipo de Reclamo";
                     }
                     return null;
                   },
                       borderColor: kDarkSecondaryColor,
                       borderFocusColor: kDarkSecondaryColor,
                       borderRadius: 15,
                       borderWidth: 1,
                       focusedBorderWidth: 0.5,
                       enabledBorderWidth: 1,
                       optionValue: "IDGRUPOTRABAJO",
                       optionLabel: "DESCRIPCION"

                   )),

                  ],)),
                  SizedBox(height: grupotrabajo ? 20: 0,),
                  Visibility(maintainSize: fecha,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: fecha,
                    child: Container(width: size.width/1.7,child:Text("FECHA", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey)))),
                  Visibility(maintainSize: fecha,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: fecha,
                    child: Row(children: [
                    Container( padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.date_range_outlined)),
                    SizedBox(width: fecha ? 5:0,),
                    Container( width:MediaQuery.of(context).size.width / 1.5,
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
                                blurRadius: 1.0)
                          ]), child: TextField(
                        controller: myControllerFecha,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                          hintText: 'DD/MM/AAAA'
                      ),
                    ),)
                  ],)),
                  SizedBox(height: fecha ? 20: 0,),
                  Visibility(maintainSize: tareador,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: tareador,
                    child: Container(width: size.width/1.7,child:Text("TAREADOR", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey)))),
                  Visibility(maintainSize: tareador,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: tareador,
                    child: Row(children: [
                    Container( padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.account_box)),
                    SizedBox(width: tareador ? 5: 0,),
                    Container( width:MediaQuery.of(context).size.width / 1.5,
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
                                blurRadius: 1.0)
                          ]), child: TextField(
                        controller: myControllerTareador,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                          hintText: 'Tareador'
                      ),
                    ),)
                  ],)),
                  SizedBox(height: tareador?20:0,),
                  Visibility(maintainSize: labor,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: labor,
                    child: Container(width: size.width/1.7,child:Text("LABOR", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey)))),
                  Visibility(maintainSize: labor,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: labor,
                    child: Row(children: [
                    Container( padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.work)),
                    SizedBox(width: labor?5:0,),
                    Container( width:MediaQuery.of(context).size.width / 1.5,
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
                                blurRadius: 1.0)
                          ]), child: TextField(
                        controller: myControllerLabor,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                          hintText: 'Labor'//43121221 - 2323
                      ),
                    ),)

                  ],),),
                  SizedBox(height: labor?20:0,),
                  Visibility(maintainSize: semana,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: semana,
                    child: Container(width: size.width/1.7,child:Text(tv_dato_extra_01.toString(), style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey)))),
                  Visibility(maintainSize: semana,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: semana,
                    child: Row(children: [
                    Container( padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.document_scanner)),
                    SizedBox(width: semana ? 5:0,),
                    Container( width:MediaQuery.of(context).size.width / 1.5,
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
                                blurRadius: 1.0)
                          ]), child: TextField(
                        controller: myControllerSemana,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                          hintText: '######'//43121221 - 2323
                      ),
                    ),)

                  ],)),
                  SizedBox(height: semana?20:0,),
                  Visibility(maintainSize: bonoreclamo,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: bonoreclamo,
                    child: Container(width: size.width/1.6,child:Text("SELECCIONAR BONO", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey)))),

                  Visibility(maintainSize: bonoreclamo,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: bonoreclamo,
                    child: Row(children: [
                    Container( padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.money)),
                   Container( width: size.width/1.35, child: FormHelper.dropDownWidget(context, "SELECCIONAR BONO", "", widget.bono!, (onChangedVal){
                      setState((){
                        idbonoseleccionado = onChangedVal;
                      });

                    }, (onValidateVal){
                      if(onValidateVal == null){
                        return "Por favor selecciona un tipo de Reclamo";
                      }
                      return null;
                    },
                      borderColor: kDarkSecondaryColor,
                      borderFocusColor: kDarkSecondaryColor,
                      borderRadius: 15,
                        borderWidth: 1,
                        focusedBorderWidth: 0.5,
                        enabledBorderWidth: 1,
                      optionValue: "IDCONCEPTO",
                      optionLabel: "DESCRIPCION"

                    )),

                  ],)),
                  SizedBox(height: bonoreclamo?20:0,),
                  Visibility(maintainSize: anioreclamo,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: anioreclamo,
                    child: Container(width: size.width/1.6,child:Text("SELECCIONAR AÑO", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey)))),

                  Visibility(maintainSize: anioreclamo,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: anioreclamo,
                    child: Row(children: [
                    Container( padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.date_range)),
                    Container( width: size.width/1.35, child: FormHelper.dropDownWidget(context, "SELECCIONAR AÑO", "", widget.anioutilidades!, (onChangedVal){
                      setState((){
                        idanioseleccionada = onChangedVal;
                      });

                    }, (onValidateVal){
                      if(onValidateVal == null){
                        return "Por favor selecciona un tipo de Reclamo";
                      }
                      return null;
                    },
                        borderColor: kDarkSecondaryColor,
                        borderFocusColor: kDarkSecondaryColor,
                        borderRadius: 15,
                        borderWidth: 1,
                        focusedBorderWidth: 0.5,
                        enabledBorderWidth: 1,
                        optionValue: "ANIO_UTILIDADES",
                        optionLabel: "ANIO_UTILIDADES"

                    )),

                  ],)),
                  SizedBox(height: anioreclamo?20:0,),
                  Visibility(maintainSize: detallereclamo,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: detallereclamo,
                    child: Container(width: size.width/1.7,child:Text("DETALLE SU RECLAMO", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey)))),
                  Visibility(maintainSize: detallereclamo,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: detallereclamo,
                    child: Row(children: [
                    Container( padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.text_snippet)),
                    SizedBox(width: detallereclamo?5:0,),
                    Container( width:MediaQuery.of(context).size.width / 1.5,
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
                                            blurRadius: 1.0)
                                      ]), child: TextField(
                      controller: myControllerDetalle,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Detalle'//43121221 - 2323
                      ),
                    ),)

                  ],)),
                  SizedBox(height: detallereclamo?20:0,),
                  Visibility(maintainSize: celular,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: celular,
                    child: Container(width: size.width/1.7,child:Text("NÚMERO DE CONTACTO (Opcional)", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey)))),
                  Visibility(maintainSize: celular,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: celular,
                    child: Row(children: [
                    Container( padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.grey[350], borderRadius: const BorderRadius.all(Radius.circular(8.0))), child: Icon(Icons.phone_android)),
                    SizedBox(width: celular?5:0,),
                    Container( width:MediaQuery.of(context).size.width / 1.5,
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
                                            blurRadius: 1.0)
                                      ]), child: TextField(
                      controller: myControllerCel,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '### ### ###'//43121221 - 2323
                      ),
                    ),)

                  ],)),
                ],),),
              )

          ],)),),
        ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        switch (widget.idtiporeclamo){
          case 19:
            switch (int.parse(idsubreclamo.toString())){
              case 20://TAREO
                if(myControllerFecha.text.toString().trim().length==10){
                  if(int.parse(myControllerFecha.text.toString().substring(0, 2))>0 && int.parse(myControllerFecha.text.toString().substring(0, 2))<=31){
                    if(int.parse(myControllerFecha.text.toString().substring(3, 5))>0 && int.parse(myControllerFecha.text.toString().substring(3, 5))<=12){
                      if(myControllerTareador.text.toString().trim().length>5){
                        if(myControllerLabor.text.toString().trim().length!=0){

                                  alerta_crear_reclamo(
                                      ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                                      ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                                      ""+widget.idtiporeclamo.toString(), ""+myControllerLabor.text.toString(),
                                      ""+myControllerLabor.text.toString(), ""+idsubreclamo.toString(),
                                      "", ""+myControllerCel.text.toString().trim(),
                                      ""+myControllerFecha.text.toString().trim(), "", "", "");


                        }else{
                          showDialog(
                              context: context,
                              builder: (context) =>  const CustomDialogsAlert(
                                title: "Advertencia",
                                description: "Debe ingresar valor",
                                imagen: "assets/images/advertencia.png",
                              ));
                        }

                      }else{
                        showDialog(
                            context: context,
                            builder: (context) =>  const CustomDialogsAlert(
                              title: "Advertencia",
                              description: "Debes ingresar el tareador a cargo",
                              imagen: "assets/images/advertencia.png",
                            ));

                      }
                    }else{
                      showDialog(
                          context: context,
                          builder: (context) =>  const CustomDialogsAlert(
                            title: "Advertencia",
                            description: "Mes ingresado en la Fecha, es incorrecto.",
                            imagen: "assets/images/advertencia.png",
                          ));
                    }

                  }else{
                    showDialog(
                        context: context,
                        builder: (context) =>  const CustomDialogsAlert(
                          title: "Advertencia",
                          description: "Día ingresado en la Fecha, es incorrecto.",
                          imagen: "assets/images/advertencia.png",
                        ));

                  }

                }else{
                  showDialog(
                      context: context,
                      builder: (context) =>  const CustomDialogsAlert(
                        title: "Advertencia",
                        description: "Fecha ingresada es incorrecta. Ejemplo: 01/01/2020",
                        imagen: "assets/images/advertencia.png",
                      ));

                }
                break;
              case 21://BONOS
                if(myControllerFecha.text.toString().trim().length==10){
                  if(int.parse(myControllerFecha.text.toString().substring(0, 2))>0 && int.parse(myControllerFecha.text.toString().substring(0, 2))<=31){
                    if(int.parse(myControllerFecha.text.toString().substring(3, 5))>0 && int.parse(myControllerFecha.text.toString().substring(3, 5))<=12){
                      if(myControllerSemana.text.toString().trim().length!=0){

                        alerta_crear_reclamo(
                            ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                            ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                            ""+widget.idtiporeclamo.toString(), "",
                            "", ""+idsubreclamo.toString(),
                            "", ""+myControllerCel.text.toString().trim(),
                            ""+myControllerFecha.text.toString().trim(), ""+myControllerSemana.text.toString(), "", ""+idbonoseleccionado.toString());

                      }else{
                        showDialog(
                            context: context,
                            builder: (context) =>  const CustomDialogsAlert(
                              title: "Advertencia",
                              description: "Debes ingresar un número de semana.",
                              imagen: "assets/images/advertencia.png",
                            ));
                      }
                    }else{
                      showDialog(
                          context: context,
                          builder: (context) =>  const CustomDialogsAlert(
                            title: "Advertencia",
                            description: "Mes ingresado en la Fecha, es incorrecto",
                            imagen: "assets/images/advertencia.png",
                          ));
                    }

                  }else{
                    showDialog(
                        context: context,
                        builder: (context) =>  const CustomDialogsAlert(
                          title: "Advertencia",
                          description: "Día ingresado en la Fecha, es incorrecto.",
                          imagen: "assets/images/advertencia.png",
                        ));

                  }

                }else{
                  showDialog(
                      context: context,
                      builder: (context) =>  const CustomDialogsAlert(
                        title: "Advertencia",
                        description: "Fecha ingresada es incorrecta. Ejemplo: 01/01/2020",
                        imagen: "assets/images/advertencia.png",
                      ));

                }
                break;
              case 22://ASIGNACION FAM
                if(myControllerFecha.text.toString().trim().length==10){
                  if(int.parse(myControllerFecha.text.toString().substring(0, 2))>0 && int.parse(myControllerFecha.text.toString().substring(0, 2))<=31){
                    if(int.parse(myControllerFecha.text.toString().substring(3, 5))>0 && int.parse(myControllerFecha.text.toString().substring(3, 5))<=12){
                      if(myControllerSemana.text.toString().trim().length!=0){
                        alerta_crear_reclamo(
                            ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                            ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                            ""+widget.idtiporeclamo.toString(), "",
                            "", ""+idsubreclamo.toString(),
                            "", ""+myControllerCel.text.toString().trim(),
                            ""+myControllerFecha.text.toString().trim(), ""+myControllerSemana.text.toString(), "", "");

                      }else{
                        showDialog(
                            context: context,
                            builder: (context) =>  const CustomDialogsAlert(
                              title: "Advertencia",
                              description: "Debes ingresar un nombre refiriendo a quien se le presentó.",
                              imagen: "assets/images/advertencia.png",
                            ));

                      }
                    }else{
                      showDialog(
                          context: context,
                          builder: (context) =>  const CustomDialogsAlert(
                            title: "Advertencia",
                            description: "Mes ingresado en la Fecha, es incorrecto.",
                            imagen: "assets/images/advertencia.png",
                          ));

                    }

                  }else{
                    showDialog(
                        context: context,
                        builder: (context) =>  const CustomDialogsAlert(
                          title: "Advertencia",
                          description: "Día ingresado en la Fecha, es incorrecto.",
                          imagen: "assets/images/advertencia.png",
                        ));

                  }

                }else{
                  showDialog(
                      context: context,
                      builder: (context) =>  const CustomDialogsAlert(
                        title: "Advertencia",
                        description: "Fecha ingresada es incorrecta. Ejemplo: 01/01/2020",
                        imagen: "assets/images/advertencia.png",
                      ));

                }
                break;
              case 23://VACACIONES
                alerta_crear_reclamo(
                    ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                    ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                    ""+widget.idtiporeclamo.toString(), "",
                    "", ""+idsubreclamo.toString(),
                    "", ""+myControllerCel.text.toString().trim(),
                    "", "", "", "");
                break;
              case 24://LIQUIDACION
                alerta_crear_reclamo(
                    ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                    ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                    ""+widget.idtiporeclamo.toString(), "",
                    "", ""+idsubreclamo.toString(),
                    ""+idanioseleccionada.toString(), ""+myControllerCel.text.toString().trim(),
                    "", "", "", "");
                break;
            }

            break;
          case 25://UTILIDADES
            alerta_crear_reclamo(
                ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                ""+widget.idtiporeclamo.toString(), "",
                "", "0",
                ""+idanioseleccionada.toString(), ""+myControllerCel.text.toString().trim(),
                "", "", "", "");
            break;
          case 26://ERRORES NRO CUENTA
            alerta_crear_reclamo(
                ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                ""+widget.idtiporeclamo.toString(), "",
                "", "0",
                ""+idanioseleccionada.toString(), ""+myControllerCel.text.toString().trim(),
                "", "", "", "");
            break;
          case 27://DESCANSOS MEDICOS/SUBSIDIOS
            if(myControllerFecha.text.toString().trim().length==10){
              if(int.parse(myControllerFecha.text.toString().substring(0, 2))>0 && int.parse(myControllerFecha.text.toString().substring(0, 2))<=31){
                if(int.parse(myControllerFecha.text.toString().substring(3, 5))>0 && int.parse(myControllerFecha.text.toString().substring(3, 5))<=12){
                  alerta_crear_reclamo(
                      ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                      ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                      ""+widget.idtiporeclamo.toString(), "",
                      "", "0",
                      "", ""+myControllerCel.text.toString().trim(),
                      ""+myControllerFecha.text.toString().trim(), "", "", "");
                }else{
                  showDialog(
                      context: context,
                      builder: (context) =>  const CustomDialogsAlert(
                        title: "Advertencia",
                        description: "Mes ingresado en la Fecha, es incorrecto.",
                        imagen: "assets/images/advertencia.png",
                      ));
                }

              }else{
                showDialog(
                    context: context,
                    builder: (context) =>  const CustomDialogsAlert(
                      title: "Advertencia",
                      description: "Día ingresado en la Fecha, es incorrecto.",
                      imagen: "assets/images/advertencia.png",
                    ));

              }

            }else{
              showDialog(
                  context: context,
                  builder: (context) =>  const CustomDialogsAlert(
                    title: "Advertencia",
                    description: "Fecha ingresada es incorrecta. Ejemplo: 01/01/2020",
                    imagen: "assets/images/advertencia.png",
                  ));

            }
            break;
          case 28://LICENCIAS
            switch (widget.idpadre){
              case 29://PATERNIDAD
              case 30://FALLECIMIENTO

                alerta_crear_reclamo(
                    ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                    ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                    ""+widget.idtiporeclamo.toString(), "",
                    "", ""+idsubreclamo.toString(),
                    "", ""+myControllerCel.text.toString().trim(),
                    "", "", "", "");
                break;
            }
            break;
          case 31://LACTANCIA
            alerta_crear_reclamo(
                ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                ""+widget.idtiporeclamo.toString(), "",
                "", "0",
                "", ""+myControllerCel.text.toString().trim(),
                "", "", "", "");
            break;
          case 32://ACTIVACION DE SEGURO
            alerta_crear_reclamo(
                ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                ""+widget.idtiporeclamo.toString(), "",
                "", "0",
                "", ""+myControllerCel.text.toString().trim(),
                "", "", "", "");
            break;
          case 33://TRANSPORTE
            alerta_crear_reclamo(
                ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                ""+widget.idtiporeclamo.toString(), "",
                "", "0",
                "", ""+myControllerCel.text.toString().trim(),
                "", "", "", "");
            break;
          case 34://SEGURIDAD
            alerta_crear_reclamo(
                ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                ""+widget.idtiporeclamo.toString(), "",
                "", "0",
                "", ""+myControllerCel.text.toString().trim(),
                "", "", "", "");
            break;
          case 35://INCUMPLIMIENTO DE ENTREGA
            if(myControllerSemana.text.toString().trim().length!=0){
              alerta_crear_reclamo(
                  ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                  ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                  ""+widget.idtiporeclamo.toString(), "",
                  "", "0",
                  "", ""+myControllerCel.text.toString().trim(),
                  "", "", "", "");
            }else{
              showDialog(
                  context: context,
                  builder: (context) =>  const CustomDialogsAlert(
                    title: "Advertencia",
                    description: "Ingresa nombre de objeto entregado.",
                    imagen: "assets/images/advertencia.png",
                  ));

            }

            break;
          case 36://BAÑOS
            switch (widget.idpadre){
              case 44://FALTA PAPEL, AGUA Y/O JABÓN
              case 45://PROBLEMAS DE LIMPIEZA
                alerta_crear_reclamo(
                    ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                    ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                    ""+widget.idtiporeclamo.toString(), "",
                    "", ""+idsubreclamo.toString(),
                    "", ""+myControllerCel.text.toString().trim(),
                    "", "", "", "");
                break;
              case 46://OTROS
                if(myControllerOtro.text.toString().trim().length!=0){
                  alerta_crear_reclamo(
                      ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                      ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                      ""+widget.idtiporeclamo.toString(), "",
                      "", ""+idsubreclamo.toString(),
                      "", ""+myControllerCel.text.toString().trim(),
                      "", "", ""+myControllerOtro.text.toString(), "");
                }else{
                  showDialog(
                      context: context,
                      builder: (context) =>  const CustomDialogsAlert(
                        title: "Advertencia",
                        description: "Has seleccionado OTROS, debes completar el campo y especificar.",
                        imagen: "assets/images/advertencia.png",
                      ));

                }

                break;
            }
            break;
          case 37://ABASTECIMIENTO AGUA
            alerta_crear_reclamo(
                ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                ""+widget.idtiporeclamo.toString(), "",
                "", "0",
                "", ""+myControllerCel.text.toString().trim(),
                "", "", "", "");
            break;
          case 38://MALOS TRATOS
            switch (int.parse(idsubreclamo.toString())){
              case 40://HOSTIGAMIENTO LABORAL
                alerta_crear_reclamo(
                    ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                    ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                    ""+widget.idtiporeclamo.toString(), "",
                    "", ""+idsubreclamo.toString(),
                    "", ""+myControllerCel.text.toString().trim(),
                    "", "", "", "");
                break;
              case 41://ACOSO SEXUAL
                alerta_crear_reclamo(
                    ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                    ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                    ""+widget.idtiporeclamo.toString(), "",
                    "", ""+idsubreclamo.toString(),
                    "", ""+myControllerCel.text.toString().trim(),
                    "", "", "", "");
                break;
              case 42://ABUSO DE PODER
                alerta_crear_reclamo(
                    ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                    ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                    ""+widget.idtiporeclamo.toString(), "",
                    "", ""+idsubreclamo.toString(),
                    "", ""+myControllerCel.text.toString().trim(),
                    "", "", "", "");
                break;
              case 43://OTROS
                if(myControllerOtro.text.toString().trim().length!=0){
                  alerta_crear_reclamo(
                      ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                      ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                      ""+widget.idtiporeclamo.toString(), "",
                      "", ""+idsubreclamo.toString(),
                      "", ""+myControllerCel.text.toString().trim(),
                      "", "", ""+myControllerOtro.text.toString(), "");
                }else{
                  showDialog(
                      context: context,
                      builder: (context) =>  const CustomDialogsAlert(
                        title: "Advertencia",
                        description: "Has seleccionado OTROS, debes completar el campo y especificar.",
                        imagen: "assets/images/advertencia.png",
                      ));
                }
                break;
            }
            break;
          case 39://OTROS RECLAMOS O SUGERENCIAS
            alerta_crear_reclamo(
                ""+IDCEL.toString(), ""+idgruposeleccionado.toString(),
                ""+ dniUsuario.toString(), ""+myControllerDetalle.text.toString(),
                ""+widget.idtiporeclamo.toString(), "",
                "", "0",
                "", ""+myControllerCel.text.toString().trim(),
                "", "", "", "");
            break;

        }
        // Add your onPressed code here!
      },
      backgroundColor: Colors.green,
      child: const Icon(Icons.send),
    ), );
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
                                MaterialPageRoute(builder: (context) =>  QuejasReclamos()));
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