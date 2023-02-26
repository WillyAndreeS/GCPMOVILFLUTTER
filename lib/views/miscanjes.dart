import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:acpmovil/views/beneficios.dart';
import 'package:acpmovil/views/detalle_utilidades.dart';
import 'package:acpmovil/views/quejasreclamos_padre.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:acpmovil/constants.dart';
import 'package:http/http.dart' as http;
import 'package:acpmovil/views/screen_gcpmundo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';



class Miscanjes extends StatefulWidget {
  Miscanjes({Key? key}) ;

  @override
  _MiscanjesState createState() => _MiscanjesState();
}

class _MiscanjesState extends State<Miscanjes> {

  late Size size;
  List datos = [];
  final myControllerUser = TextEditingController();
  late FocusNode focusUser;
  double suma = 0;
  @override
  void initState() {
    super.initState();
    focusUser = FocusNode();
    RecibirMisCanjes();
    //_showDialog();

  }


  Future<String?> RecibirMisCanjes() async {
    datos.clear();
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var response = await http.post(
          Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
          body: {"accion": "get_historial_mis_canjes_puntos","IDCODIGOGENERAL": dniUsuario, "EMPRESA": empresaUsuario});
      // if (mounted) {
      setState(() {
        var extraerData = json.decode(response.body);
        datos = extraerData["resultado"];
        print("REST: "+datos.toString());
        for(int i = 0; i< datos.length; i++){
          suma = suma + double.parse(datos[i]["PUNTOS"]);
        }


      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text("Mis Canjes", style: TextStyle(fontFamily: "Schyler"),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop (context, false);
            },
          ),

        ),
      body: Container(
       child: Container( child: datos.isEmpty ? Column( mainAxisAlignment: MainAxisAlignment.center, children: [

      Container( margin: EdgeInsets.symmetric(horizontal: 20), width: size.width, child: Column(children: [
        Container(child: Image.asset("assets/images/88554-no-content.gif"), width: 120,),
        Text("Aún no ha registrados canjes", textAlign: TextAlign.center, style: TextStyle(fontFamily: "Schyler"),)
      ],))
    ]):Column( children: [
        Container( margin: EdgeInsets.symmetric(horizontal: 20), width: size.width, height: size.height/ 1.3, child: RefreshIndicator( onRefresh: ()async{ await RecibirMisCanjes();} ,child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
    itemCount: datos.length,
    itemBuilder: (BuildContext context, int index) {
      return datos.isEmpty ? Center(child: CircularProgressIndicator(),) :Container(
          height: size.height/7,
          margin: const EdgeInsets.symmetric( vertical: 5),
          decoration: BoxDecoration(borderRadius:  const BorderRadius.all(Radius.circular(20.0)),  image:  const DecorationImage(
            image: AssetImage("assets/images/background_recompensa_puntos.jpg"),
            fit: BoxFit.cover,
          ), boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, offset: const Offset(-5,5)),

          ]),
          child: Container( decoration: BoxDecoration(borderRadius:  const BorderRadius.all(Radius.circular(20.0)), color: Colors.white.withOpacity(0.8)),child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween , children: [
            Container(
                width: size.width *0.3, decoration:  BoxDecoration(
              borderRadius:  const BorderRadius.only(topLeft: Radius.circular(20.0), bottomLeft:Radius.circular(20.0) ),
              color: Color.fromRGBO(0, 0, 0, 0.4),
              image: DecorationImage(
                image: NetworkImage(datos[index]["URL_IMAGEN"],),
                fit: BoxFit.fill,
              ),
            ) ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container( width: size.width*0.31, child: Text(
                   datos[index]["PREMIO"],
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.black,fontFamily: "Schyler", fontSize: 14))),
                Container( width: size.width*0.31, child: Text(datos[index]["FECHAREGISTRO"].substring(0, 10),
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: kPrimaryColor,fontFamily: "Schyler", fontSize: 12)))
              ],),
            SizedBox(width: 5,),
            Container(  padding:EdgeInsets.only(top: 20, right: 15), child: Text(
                datos[index]["PUNTOS"],
                maxLines: 2,
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.black,fontFamily: "Schyler", fontSize: 14))),
          ],))


      );
    })),)
      ])),),
      bottomNavigationBar: Container(width: size.width,
        child: Container(child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),width: size.width*0.75,color: Colors.grey[300],child:Text("TOTAL PUNTOS CANJEADOS: ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontFamily: "Schyler"),textAlign: TextAlign.right,)),
          Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),width: size.width*0.25,color: Colors.grey[500],child:Text(((suma.round()*100)/100).toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontFamily: "Schyler"),textAlign: TextAlign.right,)),
        ],)),
      ),
    );
    }
  }



class CustomDialogsAlert extends StatelessWidget {
  final String? title, description, buttontext, imagen, nombre;
  final List? utilidades;

  const CustomDialogsAlert(
      {Key? key,
        this.title,
        this.description,
        this.buttontext,
        this.imagen,
        this.nombre,
      this.utilidades})
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            "Cancelar",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  DetalleUtilidades(dataUtilidades: utilidades,)));
                          },
                          child: const Text(
                            "PROCESAR SOLICITUD",
                            style: TextStyle(color: Colors.white, fontSize: 12),
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

class CustomDialogsAlertError extends StatelessWidget {
  final String? title, description, buttontext, imagen, nombre;
  final List? utilidades;

  const CustomDialogsAlertError(
      {Key? key,
        this.title,
        this.description,
        this.buttontext,
        this.imagen,
        this.nombre,
        this.utilidades})
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            style: TextStyle(color: Colors.white, fontSize: 12),
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
