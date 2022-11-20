import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:acpmovil/views/drawer.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';



class ConstanciaBoleta extends StatefulWidget {
  @override
  _ConstanciaBoletaState createState() => _ConstanciaBoletaState();
}

class _ConstanciaBoletaState extends State<ConstanciaBoleta> {

List dataBoleta = [];
bool hasInternet = false;
bool isChecked = false;
late StreamSubscription internetSubscription;
late StreamSubscription subscription;
ConnectivityResult result = ConnectivityResult.none;

ReceivePort receivePort = ReceivePort();
int progress = 0;
@override
void initState() {
  /*IsolateNameServer.registerPortWithName(receivePort.sendPort, "descargando");
  receivePort.listen((message) {
    if(mounted){
      setState((){
        progress = message;
      });
    }

  });
  FlutterDownloader.registerCallback(downloadCallback);*/
  super.initState();
  Connectivity().onConnectivityChanged.listen((result) {
    setState(() => this.result = result);
  });
  InternetConnectionChecker().onStatusChange.listen((status) {
    final hasInternet = status == InternetConnectionStatus.connected;
    setState(() => this.hasInternet = hasInternet);
  });
  print("ESTADO INTERNET $hasInternets");
  MostrarDatosBoleta();
}

_launchURL() async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Column(children: [
            CircularProgressIndicator(),
            Text("Descargando boleta"),
          ] ),
        );
      });
  var url = 'https://web.acpagro.com/acp/index.php/boleta/pdf_boleta_final/'+dniUsuario.toString()+'/15/'+dniUsuario.toString()+'.pdf';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
  Navigator.pop(context);
}

/*static downloadCallback(id, status, progress){
SendPort sendPort = IsolateNameServer.lookupPortByName("descargando")!;
sendPort.send(progress);
}
  void _downloadFile() async{
    final status = await Permission.storage.request();
    if(status.isGranted){
      final baseStorage = await getExternalStorageDirectory();
      final id = await FlutterDownloader.enqueue(url: "https://web.acpagro.com/acp/index.php/boleta/pdf_boleta_final/43121221/15/43121221.pdf", savedDir: baseStorage!.path, fileName: "filename.pdf");
    }else{
      print("permiso denegado");
    }

  }*/
  Future<void>MostrarDatosBoleta() async{
    dataBoleta.clear();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await http.post(
            Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
            body: {"accion": "_5UKSTFA8W2SYFQV5", "_5UKQTIRF82SYFQ": dniUsuario, "_5UKXNFWJY2SYFQ": "256"});
        // if (mounted) {
        setState(() {
          var extraerData = json.decode(response.body);
          dataBoleta = extraerData["resultado"];
          if(dataBoleta.isEmpty){
             var objeto = {
               "RESULTADO" : "SIN DATA"
             };

             dataBoleta.add(objeto);
          }
          print("REST: $dataBoleta");
        });


        // }

      }else{
        showDialog(
            context: context,
            builder: (context) => const CustomDialogsAlert(
              title: "MENSAJE",
              description:
              "Revisa tu conexión a internet",
              imagen: "assets/images/advertencia.png",
            ));
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: dataBoleta.isEmpty? Center(child:CircularProgressIndicator()): dataBoleta[0]["RESULTADO"] == "SIN DATA" ? Center(child: Container( color:Colors.white, child:Column( mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset("assets/images/buscar.gif", width: 100,),
          Container(margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20), child: Text("AÚN NO CUENTA CON BOLETA DE PAGO EN ÉSTA SEMANA. / ESPERE E INTENTE NUEVAMENTE EN UNOS MINUTOS.")),
        ],)) ):Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
            const Text('BOLETA DE REMUNERACIONES', style: TextStyle(fontFamily: "Schyler", fontSize: 16)),
              const  SizedBox(height: 20,),
              Text(dataBoleta[0]["codigo"], style: TextStyle(fontFamily: "Schyler")),
              const SizedBox(height: 10,),
              Text(dataBoleta[0]["apenom"], style: TextStyle(fontFamily: "Schyler", color: kPrimaryColor)),
              const SizedBox(height: 10,),
              Text("${"${"SEMANA: "+dataBoleta[0]["semana"]+" ("+dataBoleta[0]["desde1"]} - "+dataBoleta[0]["hasta1"]})", style: TextStyle(fontFamily: "Schyler")),
              const SizedBox(height: 10,),
              Text("NRO CTA: "+dataBoleta[0]["cta_banco"], style: TextStyle(fontFamily: "Schyler")),
              const SizedBox(height: 20,),
              const Divider(color: Colors.black, thickness: 2.0),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("- TOTAL INGRESOS ", style: TextStyle(fontFamily: "Schyler"), textAlign: TextAlign.left,),
                  Text("S/."+dataBoleta[0]["TOTALINGRESO"], style: TextStyle(fontFamily: "Schyler"), textAlign: TextAlign.right,),
              ],),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text("- TOTAL RETENCIONES ", style: TextStyle(fontFamily: "Schyler"), textAlign: TextAlign.left,),

                Text("S/."+dataBoleta[0]["TOTALDESCUENTO"], style: TextStyle(fontFamily: "Schyler"),textAlign: TextAlign.right,),
              ],),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("- TOTAL APORTACIÓN ", style: TextStyle(fontFamily: "Schyler"), textAlign: TextAlign.left,),
                Text("S/."+dataBoleta[0]["TOTALAPORTES"], style: TextStyle(fontFamily: "Schyler"), textAlign: TextAlign.right,),
              ],),
              const SizedBox(height: 20,),
              const Divider(color: Colors.black, thickness: 2.0),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("NETO A PAGAR ", style: TextStyle(fontFamily: "Schyler",fontSize: 18), textAlign: TextAlign.left,),
                  const SizedBox(width: 70,),
                  Text("S/."+dataBoleta[0]["NETOPAGAR"], style: TextStyle(fontFamily: "Schyler", fontSize: 18), textAlign: TextAlign.right,),
                ],),
          ],)
        ),
    bottomNavigationBar: dataBoleta.isEmpty? Container(color:Colors.white, height: size.height/5,): dataBoleta[0]["RESULTADO"] == "SIN DATA" ? Container(color:Colors.white,height: size.height/5,) :Container(
      height: size.height/5,
        color: Colors.grey[300],
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [
            Checkbox(
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                  print("ESTADO:" + isChecked.toString());
                });
              },
            ),
            Container(
                width: size.width*0.7,
                child:const Text("DECLARO ESTAR CONFORME Y HABER RECIBIDO MI BOLETA DE PAGO", style: const TextStyle(color: Colors.black,fontFamily: "Schyler",fontSize: 14),maxLines: 2,
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
              if(isChecked == true){
                _launchURL();
              }else{
                showDialog(
                    context: context,
                    builder: (context) => const CustomDialogsAlert(
                      title: "MENSAJE",
                      description:
                      "Debes aceptar la conformidad para descargar la boleta",
                      imagen: "assets/images/advertencia.png",
                    ));
              }

            },
            child: const Text("DESCARGAR CONSTANCIA DETALLADA", style: TextStyle(fontFamily: "Schyler"),),
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