import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/detalle_utilidades_final.dart';
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



class DetalleUtilidades extends StatefulWidget {
  List? dataUtilidades = [];
  DetalleUtilidades({Key? key, this.dataUtilidades}) ;
  @override
  _DetalleUtilidadesState createState() => _DetalleUtilidadesState();
}

class _DetalleUtilidadesState extends State<DetalleUtilidades> {


bool hasInternet = false;
bool isChecked = false;
late StreamSubscription internetSubscription;
late StreamSubscription subscription;
ConnectivityResult result = ConnectivityResult.none;

ReceivePort receivePort = ReceivePort();
int progress = 0;
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
  print("ESTADO INTERNET $hasInternets");
}





  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final DateTime now = DateTime.now();
    int anioactual = now.year;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("2/3 Procesar solicitud", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),
        body: widget.dataUtilidades!.isEmpty? Center(child:CircularProgressIndicator()): Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [

             Text('PARTICIPACIÓN DE UTILIDADES '+anioactual.toString(), style: TextStyle(fontFamily: "Schyler", fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10,),
              Text('LIQUIDACIÓN DE LA PARTICIÓN DE UTILIDADES', style: TextStyle(fontFamily: "Schyler", fontSize: 14)),
              const  SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

          Container(
            width: size.width/1.8,
            child:
                Text("1. Por "+widget.dataUtilidades![0]["DIAS_POR_DISTRIBUIR"]+" días laborados ("+widget.dataUtilidades![0]["MITAD_PORCENT_RN"]+" x "+widget.dataUtilidades![0]["DIAS_POR_DISTRIBUIR"]+" / "+widget.dataUtilidades![0]["DIAS_TODOS"]+")", style: TextStyle(fontFamily: "Schyler")),
),
          Container(

              width: size.width/3,
            child:
                Text("S/."+widget.dataUtilidades![0]["IMPORTE_DIAS"], style: TextStyle(fontFamily: "Schyler"), textAlign: TextAlign.right,),

             ),
            const SizedBox(height: 10,),
        ],),
          SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width/1.8,
                  child: Text("2. Por "+widget.dataUtilidades![0]["REMU_1"]+" de remuneraciones percibidas ("+widget.dataUtilidades![0]["MITAD_PORCENT_RN"]+" x "+widget.dataUtilidades![0]["REMU_2"]+" / "+widget.dataUtilidades![0]["REMU_TODOS_TRABAJADORES"]+")", style: TextStyle(fontFamily: "Schyler"))),
                  Container(
                    width: size.width/3,
                  child: Text("S/."+widget.dataUtilidades![0]["IMPORTE_INGRESO"], style: TextStyle(fontFamily: "Schyler"), textAlign: TextAlign.right,)),
                  const SizedBox(height: 10,),
                ],),
              Align(
                alignment: Alignment.centerRight,
                child: Container(width: size.width/4 ,child: const Divider(color: Colors.black, thickness: 2.0)
                )

                ,),
              const SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width/1.8,
                    child:
                  const Text("TOTAL INGRESOS ", style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
                  Container(
                    width: size.width/3,
                    child:
                  Text("S/."+widget.dataUtilidades![0]["TOTAL_INGRESOS"], style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold), textAlign: TextAlign.right,)),
              ],),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width/1.8,
                    child:
                  Text("3. Por retención de Renta de Quinta Categoría", style: TextStyle(fontFamily: "Schyler"))),
                  Container(
                    width: size.width/3,
                    child:
                  Text("S/."+widget.dataUtilidades![0]["DSCTO_RENTA_QUINTA"], style: TextStyle(fontFamily: "Schyler"), textAlign: TextAlign.right,)),
                  const SizedBox(height: 10,),
                ],),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width/1.8,
                    child:
                  Text("4. Descuento judicial", style: TextStyle(fontFamily: "Schyler"))),
                  Container(
                    width: size.width/3,
                    child:
                  Text("S/."+widget.dataUtilidades![0]["DSCTO_JUDICIAL"], style: TextStyle(fontFamily: "Schyler"), textAlign: TextAlign.right,)),
                  const SizedBox(height: 10,),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width/1.8,
                    child:
                  Text("5. Dscto. por pago transitorio "+anioactual.toString(), style: TextStyle(fontFamily: "Schyler"))),
                  Container(
                    width: size.width/3,
                    child:
                  Text("S/."+widget.dataUtilidades![0]["PAGO_TRANSITORIO"], style: TextStyle(fontFamily: "Schyler"), textAlign: TextAlign.right,)),
                  const SizedBox(height: 10,),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width/1.8,
                    child:
                  Text("6. Descuento otros "+anioactual.toString(), style: TextStyle(fontFamily: "Schyler"))),
                  Container(
                    width: size.width/3,
                    child:
                  Text("S/."+widget.dataUtilidades![0]["DSCTO_BONO_ASIST"], style: TextStyle(fontFamily: "Schyler"), textAlign: TextAlign.right,)),
                  const SizedBox(height: 10,),
                ],),
              const SizedBox(height: 20,),
              Align(
                alignment: Alignment.centerRight,
                child: Container(width: size.width/4 ,child: const Divider(color: Colors.black, thickness: 2.0)
              )

                ,),

              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width/1.8,
                    child:
                  const Text("TOTAL DESCUENTOS ", style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
                  Container(
                    width: size.width/3,
                    child:
                  Text("S/."+widget.dataUtilidades![0]["TOTAL_DESCUENTOS"], style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold), textAlign: TextAlign.right,)),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: size.width/1.8,
                    child:
                  const Text("NETO A PAGAR ", style: TextStyle(fontFamily: "Schyler",fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
                  Container(
                    width: size.width/3,
                    child:
                  Text("S/."+widget.dataUtilidades![0]["NETO_PAGADO"], style: TextStyle(fontFamily: "Schyler", fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.right,)),
                ],),
          ],)
        ),
    bottomNavigationBar: widget.dataUtilidades!.isEmpty? Container(color:Colors.white, height: size.height/5,) :Container(
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
                child: Text("DECLARO ESTAR CONFORME CON LA PRESENTE LIQUIDACIÓN DE PARTICIPACIÓN DE UTILIDADES "+anioactual.toString(), style: const TextStyle(color: Colors.black,fontFamily: "Schyler",fontSize: 14),maxLines: 3,
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
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  DetalleUtilidadesFinal(dataUtilidades: widget.dataUtilidades,)));
              }else{
                showDialog(
                    context: context,
                    builder: (context) => const CustomDialogsAlert(
                      title: "MENSAJE",
                      description:
                      "Debes aceptar la conformidad de las utilidades",
                      imagen: "assets/images/advertencia.png",
                    ));
              }

            },
            child: const Text("DESCARGAR CONSTANCIA Y CONTINUAR", style: TextStyle(fontFamily: "Schyler", fontSize: 13), textAlign: TextAlign.center,),
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