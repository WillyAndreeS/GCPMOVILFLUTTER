import 'dart:convert';
import 'dart:io';
import 'package:acpmovil/views/miscanjes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/ver_estrellas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:lottie/lottie.dart';

class CosechandoEstrellas extends StatefulWidget {
  const CosechandoEstrellas({Key? key}) : super(key: key);

  @override
  _CosechandoEstrellasState createState() => _CosechandoEstrellasState();
}

class _CosechandoEstrellasState extends State<CosechandoEstrellas> {
  late final AnimationController _controller;
  List estrellas = [];
  double suma = 0;
  double resta = 0;
  double horas = 0;
  double horas2 = 0;
  String? IDCEL;

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

  Future SaveVisita() async{
    await _getId();
    if(mounted) {
      setState(() {

        final DateTime now = DateTime.now();
        final docUser = FirebaseFirestore.instance.collection("visitas");

        final json = {
          'fecha': now.toString(),
          'idinterfaz': "Cosechando Estrellas",
          'idusuario':  dniUsuario,
          'imagen': "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/gift%20cosechando.gif?alt=media&token=0a5832e2-dca5-4893-95bb-6af7747d6551",
          'icono': "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/estrella-fugaz.gif?alt=media&token=41e52063-b008-43ae-97af-90b03fca9c0e",
          'color': "0XFF3B5977"
        };
        docUser.add(json);
      });
    }
  }

  @override
  void initState() {

    super.initState();
    RecibirMisEstrellas();
    SaveVisita();
  }

  Future<String?> RecibirMisEstrellas() async {
    estrellas.clear();
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var response = await http.post(
          Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
          body: {"accion": "get_recompensas_v4","dni": dniUsuario});
      if (mounted) {
        setState(() {
          var extraerData = json.decode(response.body);

          estrellas = extraerData["resultado"];
          for (int i = 0; i < estrellas.length; i++) {

            if (estrellas[i]["TIPO"] == "SEMANA" ) {
              suma = suma + (double.parse(estrellas[i]["PUNTOS_SEMANA"]) +
                  double.parse(estrellas[i]["PUNTOS_ADICIONAL"]) +
                  double.parse(estrellas[i]["PUNTOS_EXTRA"]) +
                  double.parse(estrellas[i]["PUNTOS_EXTRA_TOTAL_DIA"]));
              horas = horas + double.parse(estrellas[i]["HORAS_SEMANA"]);
            }
            if (estrellas[i]["TIPO"] == "CANJE") {
              resta = resta + double.parse(estrellas[i]["PUNTOS_SEMANA"] == null ? "0" : estrellas[i]["PUNTOS_SEMANA"]);
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final DateTime now = DateTime.now();
    String? mesletras;
    int dia = now.day;
    int mes = now.month;
    int anio = now.year;
    if(mes ==1){
      mesletras = "Enero";
    }else if(mes == 2){
      mesletras = "Febrero";
    }else if(mes == 3){
      mesletras = "Marzo";
    }else if(mes == 4){
      mesletras = "Abril";
    }else if(mes == 5){
     mesletras = "Mayo";
    }else if(mes == 6){
      mesletras = "Junio";
    }else if(mes == 7){
      mesletras = "Julio";
    }else if(mes == 8){
      mesletras = "Agosto";
    }else if(mes == 9){
      mesletras = "Setiembre";
    }else if(mes == 10){
      mesletras = "Octubre";
    }else if(mes == 11){
      mesletras = "Noviembre";
    }else if(mes == 12){
      mesletras = "Diciembre";
    }
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_gcp.png",),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
                width: MediaQuery.of(context).size.width,
              //padding: EdgeInsets.only(top: 20),
              color: Colors.green.withOpacity(0.7),
              child: Container(
                 /* decoration: const BoxDecoration(image:DecorationImage(
                    image: AssetImage("assets/images/animation_640_ldvynjnh.gif"),
                    fit: BoxFit.cover,
                  ) ),*/
                  child: Column(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(top:40),

                  child:
                 Text(
                  nombreUsuario.toString(),
                  style: const TextStyle(
                    color: Colors.white,fontSize: 24, fontFamily: "Schyler", fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 8.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),textAlign: TextAlign.center,
                ),),
                const SizedBox(height: 10,),
                Container(width: size.width/1.5, height: size.height/2.2,decoration: const BoxDecoration(image:DecorationImage(
                  image: AssetImage("assets/images/puntos_img_002.png"),
                  fit: BoxFit.fill,
                ), ),child: Center(child:estrellas.isEmpty?CircularProgressIndicator(color: kDarkSecondaryColor,):Column( mainAxisAlignment: MainAxisAlignment.center, children : [
                  Text((((suma+resta).round()*100)/100).toString()+" Pts.", style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 28), textAlign: TextAlign.center,),
                  Text((horas + horas2).toString()+" H.", style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 26), textAlign: TextAlign.center,),
                  SizedBox(height: 5,),
                  Text("PUNTOS/HORAS", style: TextStyle(color:Colors.white, fontStyle: FontStyle.italic, fontSize: 12), textAlign: TextAlign.center,),
                  SizedBox(height: 10,),
                  Container( width: size.width/2.2,
                  child: Text("Acumulado al "+dia.toString()+" de "+mesletras!+" del "+anio.toString(), style: TextStyle(color:Colors.white, fontSize: 14), textAlign: TextAlign.center,)),
                ]))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                          MediaQuery.of(context).size.width /
                              1.3,
                          48),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(30)),
                      elevation: 5,
                      primary: const Color(0XFF00796B)),
                  onPressed: () {
                  },
                  child: const Text('CANJE DE ESTRELLAS'),
                ),
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
                      elevation: 5,
                      primary: const Color(0XFF00796B)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  Estrellas()));
                  },
                  child: const Text('VER ESTRELLAS'),
                ),
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
                      elevation: 5,
                      primary: const Color(0XFF00796B)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>   Miscanjes()));

                  },

                  child: const Text('HISTORIAL DE CANJES'),
                ),
              ],))
            )
          ),
        );
  }
}
