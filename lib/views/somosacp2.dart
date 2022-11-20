import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/models/Menu.dart';
import 'package:acpmovil/views/beneficios.dart';
import 'package:acpmovil/views/certificacionespage.dart';
import 'package:acpmovil/views/comunicados.dart';
import 'package:acpmovil/views/conocenos.dart';
import 'package:acpmovil/views/culturapage.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:acpmovil/views/gcpgps.dart';
import 'package:acpmovil/views/page2.dart';
import 'package:acpmovil/views/principalpage.dart';
import 'package:acpmovil/views/screen_contactanos.dart';
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



class Somosacp extends StatefulWidget {
  Somosacp({Key? key}) ;

  @override
  _SomosacpState createState() => _SomosacpState();
}

class _SomosacpState extends State<Somosacp> {
  String nombre = "USER";
  String dni = "00000000";
  late Size size;
  Timer? _timer;
  bool fullsize = false;
  int indice = 0;
  List<LatLng> polylineareaEmpresa = [];
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;



  _obtenerUsuario() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombre = (prefs.get("name") ?? "USER") as String;
      dni = (prefs.get("dni") ?? "00000000") as String;
    });
  }

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
    print("ESTADO INTERNET "+hasInternets.toString());
    _obtenerUsuario();
    //_showDialog();

  }
//final List<String> titles = ['¿Quiénes Somos?', 'Cultura', 'Certificaciones', 'Contáctanos', 'ACP en el mundo', 'GPS ACP'];

  /*@override
  void dispose(){
    internetSubscription.cancel();
    subscription.cancel();
    super.dispose();
  }*/


  Future<void> cargarAreaACPIni() async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    var area =  await FirebaseFirestore.instance.collection("areaacp").orderBy("id");
    QuerySnapshot areaacp = await area.get();
    if(areaacp.docs.isNotEmpty) {
      for (var doc in areaacp.docs) {
        polylineareaEmpresa.add(LatLng(doc.get("latitud"), doc.get("longitud")));
        print("GEO: "+doc.get("latitud").toString()+" , "+doc.get("longitud").toString());
      }


    }
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        print("No puedes ir atras");
        // ignore: null_check_always_fails
        return null!;
      },
      child: Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/images/background_gcp.png",),
          fit: BoxFit.cover,
        ),
    ),
    child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.7)
        ),
        child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
    itemCount: menusgcp.length,
    itemBuilder: (BuildContext context, int index) {
      return GestureDetector(
          onTap: ()async {
          if(menusgcp[index]["titulo"] == "GPS ACP") {
            var area = await FirebaseFirestore.instance.collection("areaacp")
                .orderBy("id");
            QuerySnapshot areaacp = await area.get();
            if (areaacp.docs.isNotEmpty) {
              for (var doc in areaacp.docs) {
                polylineareaEmpresa.add(LatLng(
                    doc.get("latitud"), doc.get("longitud")));
                print("GEO: " + doc.get("latitud").toString() + " , " + doc.get(
                    "longitud").toString());
              }
            }
          }
            setState((){
              fullsize = !fullsize;
              print("Full: "+fullsize.toString()+""+index.toString());
              indice = index;
              _timer = Timer (const Duration (milliseconds: 500), () {

                fullsize = false;

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  menusgcp[index]["titulo"] == 'Conócenos' ?Conocenos(): menusgcp[index]["titulo"] == 'Beneficios y líneas de apoyo' ? Beneficios() : menusgcp[index]["titulo"] == 'Certificaciones' ? CertificacionesPage() : menusgcp[index]["titulo"] == 'Contáctanos' ? ConocenosContactanos() : menusgcp[index]["titulo"] == 'Comunicados' ? Comunicado() : GCP_GPS(areaempresa: polylineareaEmpresa,)));
              }


              );
            });

          },
          child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: indice==index ? fullsize == true ? size.height/6.5 : size.height/7 : size.height/7 ,
        width: fullsize == true ? size.width : size.width,
        margin: EdgeInsets.symmetric(horizontal: indice==index ? fullsize == true ? 10 : 20: 20, vertical: 15),
        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)),/* image: DecorationImage(
          image:  NetworkImage(
            menusgcp[index]["imagen"],
          ), fit: BoxFit.cover, ),*/ color: Colors.green, boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.29), blurRadius: 10.0, offset: Offset(-10,10)),

        ]),
        child: Row(children: [
          Align(alignment: Alignment.center, child: hasInternets || hasInternet ?CachedNetworkImage(
            imageUrl: menusgcp[index]["imagen"],
            imageBuilder: (context, imageProvider) =>Container(
            width: fullsize == true ? size.width/2.3  : size.width / 2.3,
            decoration:  BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)), color:const Color(0xFF0000000).withOpacity(0),image: DecorationImage(
              image:  imageProvider, fit: BoxFit.fill, ),),

            padding: const EdgeInsets.only(top:5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler"))
              ],
            ),
          ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ): CircularProgressIndicator()),
          Align(alignment: Alignment.center, child:Container(
            width: fullsize == true ? size.width/2.5 : size.width/2.5,
            decoration:  BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)), color:const Color(0xFF0000000).withOpacity(0),),
            padding: const EdgeInsets.only(top:5, bottom: 5, left: 2 ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(child: Text(
                menusgcp[index]["titulo"],
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontFamily: "Schyler", fontSize: 19)))
              ],
            ),

          ),),
        ],)
      ));}
    ))/*GridView.builder(
        itemCount: menusgcp.isNotEmpty ? menusgcp.length: 0,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index){
      return menusgcp.isEmpty ? CircularProgressIndicator() :GestureDetector(
          onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  menusgcp[index]["titulo"] == '¿Quiénes somos?' ?MyPrincipalPage(): menusgcp[index]["titulo"] == 'Cultura' ? CulturaPage() : menusgcp[index]["titulo"] == 'Certificaciones' ? CertificacionesPage() : menusgcp[index]["titulo"] == 'Contáctanos' ? ConocenosContactanos() : menusgcp[index]["titulo"] == 'ACP en el mundo' ? GCPMundo() : Page2()));
      },
        child: hasInternets || hasInternet ? Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)), image: DecorationImage(
            image:  NetworkImage(
              menusgcp[index]["imagen"],
            ), fit: BoxFit.cover, ), color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

          ]),
          child: Align(alignment: AlignmentDirectional(0,1), child:Container(
            height: 30,
            width: 200,
            decoration:  BoxDecoration(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)), color:const Color(0xFF0000000).withOpacity(0.5),),

            padding: const EdgeInsets.only(top:5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(menusgcp[index]["titulo"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler"))
              ],
            ),

          ),),
        ) :Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)), image: DecorationImage(
            image:  AssetImage(
              "assets/images/loader.gif",
            ), fit: BoxFit.cover, ), color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

          ]),
          child: Align(alignment: AlignmentDirectional(0,1), child:Container(
            height: 30,
            width: 200,
            decoration:  BoxDecoration(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)), color:const Color(0xFF0000000).withOpacity(0.5),),

            padding: const EdgeInsets.only(top:5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(menusgcp[index]["titulo"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler"))
              ],
            ),

          ),),
        ));
        })*/),));
    }
  }