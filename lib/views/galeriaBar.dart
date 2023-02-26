import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/GaleriaCapas.dart';
import 'package:acpmovil/views/galeria_celebrando_juntos.dart';

import 'package:acpmovil/views/nuestroequipo.dart';
import 'package:acpmovil/views/page2.dart';
import 'package:acpmovil/views/principalpage.dart';
import 'package:acpmovil/views/screen_contactanos.dart';
import 'package:acpmovil/views/screen_gcpmundo.dart';
import 'package:acpmovil/views/screen_nuestros_productos_v2.dart';
import 'package:acpmovil/views/videos.dart';
import 'package:acpmovil/views/vista_panoramica_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';



class GaleriaBar extends StatefulWidget {
  GaleriaBar({Key? key}) ;

  @override
  _GaleriaBarState createState() => _GaleriaBarState();
}

class _GaleriaBarState extends State<GaleriaBar> {
  late Size size;
  List galeriaF = [];
  String? IDCEL;
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;

  Future<void> getGaleriaacp() async{

    var galeria = FirebaseFirestore.instance.collection("menu_galeria").orderBy("id");
    QuerySnapshot galerias = await galeria.get();
setState((){
  if(galerias.docs.isNotEmpty){
    for(var doc in galerias.docs){
      print("DATOS: "+doc.id.toString());
      galeriaF.add(doc.data());
    }
    print("TITULO: "+galeriaF[0]["descripcion"]);

    }
  });

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

  Future SaveVisita() async{
    await _getId();
    if(mounted) {
      setState(() {

        final DateTime now = DateTime.now();
        final docUser = FirebaseFirestore.instance.collection("visitas");

        final json = {
          'fecha': now.toString(),
          'idinterfaz': "Galería",
          'idusuario': tipoUsuario.toString().toUpperCase() == "INVITADO" ? IDCEL.toString() : dniUsuario,
          'imagen': "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/fotografia.png?alt=media&token=ec7719e9-31d9-4780-8ae1-bad187830c19",
          'icono': "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/galeria-de-imagenes.png?alt=media&token=b21e3c2b-543e-4dcb-b4a5-3c3572180a96",
          'color':"0XFF89AA4E"
        };
        docUser.add(json);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((result) {
      if(mounted){
        setState(() => this.result = result);
      }

    });
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });
    print("ESTADO INTERNET "+hasInternets.toString());
    getGaleriaacp();
    SaveVisita();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Galería", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),

      body: galeriaF.isEmpty ? Center(child: CircularProgressIndicator()): Container(
        padding: const EdgeInsets.only(top: 20),
    child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
    itemCount: galeriaF.length,
    itemBuilder: (BuildContext context, int index) {
      return galeriaF.isNotEmpty ? GestureDetector(
          onTap: (){
            if(galeriaF[index]["id"] == 1){
              setState((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  GaleriaCelebrando(titulo: galeriaF[index]["descripcion"],)));

              });
            }else if(galeriaF[index]["id"] == 2){
              setState((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  GaleriaCapas(titulo: galeriaF[index]["descripcion"])));

              });

            }else if(galeriaF[index]["id"] == 3){
              setState((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Videos(titulo: galeriaF[index]["descripcion"])));

              });

            }


          },
          child: CachedNetworkImage(imageUrl: galeriaF[index]["imagen"], imageBuilder: (context, imageProvider) => Container(
            height: size.height/4,

        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(10.0)), image: hasInternets || hasInternet ? DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ): DecorationImage(
          image: AssetImage("assets/images/122840-image.gif"),
          fit: BoxFit.cover,
        ), boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

        ]),
        child: Column(children: [
          Align(alignment: Alignment.topCenter, child:Container(
            width: size.width,
            height: size.height/15,
            decoration:  BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)), color:const Color(0xFF0000000).withOpacity(0.3),),
            padding: const EdgeInsets.only(top:5, bottom: 5, left: 2 ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(

                    child: Text(
                        galeriaF[index]["descripcion"] == null ? "": galeriaF[index]["descripcion"],
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler", fontSize: 20))),

              ],
            ),

          ),),
          SizedBox(height: 20,),
          Align(alignment: Alignment.center, child:Container(
            width: size.width,
            decoration: const BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),),
            padding: const EdgeInsets.only(top:5, bottom: 5, left: 2 ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: Image.asset("assets/images/grifo.png"), width: 50,),

              ],
            ),

          ),),
        ],)


      ),placeholder: (context, url) => Container(
              height: size.height/4,

              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), image: const DecorationImage(
                image: AssetImage("assets/images/122840-image.gif"),
                fit: BoxFit.cover,
              ), boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

              ]),
              child: Column(children: [
                Align(alignment: Alignment.topCenter, child:Container(
                  width: size.width,
                  height: size.height/15,
                  decoration:  BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)), color:const Color(0xFF0000000).withOpacity(0.3),),
                  padding: const EdgeInsets.only(top:5, bottom: 5, left: 2 ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(

                          child: const Text(
                              "",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler", fontSize: 20))),

                    ],
                  ),

                ),),
                SizedBox(height: 20,),
                Align(alignment: Alignment.center, child:Container(
                  width: size.width,
                  decoration: const BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),),
                  padding: const EdgeInsets.only(top:5, bottom: 5, left: 2 ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.asset("assets/images/grifo.png"), width: 50,),

                    ],
                  ),

                ),),
              ],)


          ), )): Center(child: Container(
      height: size.height/4,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), image: const DecorationImage(
      image: AssetImage("assets/images/9826-simple-loader.gif"),
      fit: BoxFit.cover,
      ), boxShadow: [
      BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

      ]),),);}
    )),);
    }
  }