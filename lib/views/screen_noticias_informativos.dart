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
import 'package:acpmovil/views/screen_noticias.dart';
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



class Noticias_informativos extends StatefulWidget {
  Noticias_informativos({Key? key}) ;

  @override
  _Noticias_informativosState createState() => _Noticias_informativosState();
}

class _Noticias_informativosState extends State<Noticias_informativos> {
  late Size size;
  List galeriaF = [];
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  String? IDCEL;
  ConnectivityResult result = ConnectivityResult.none;

  Future<void> getGaleriaacp() async{

    var galeria = FirebaseFirestore.instance.collection("menu_noticias").orderBy("id");
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

  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Galería", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),*/

      body: galeriaF.isEmpty ? Center(child: CircularProgressIndicator()): Container(
        padding: const EdgeInsets.only(top: 20),
    child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
    itemCount: galeriaF.length,
    itemBuilder: (BuildContext context, int index) {
      return galeriaF.isNotEmpty ? GestureDetector(
          onTap: (){
            print("NOTIssssss "+galeriaF[index]["id"]);
            if(galeriaF[index]["id"] == "1"){
            //  setState((){
                print("NOTI: "+galeriaF[index]["id"]);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Noticias(titulo: galeriaF[index]["descripcion"],tipo: galeriaF[index]["tipo"],)));

             // });
            }else if(galeriaF[index]["id"] == "2"){
             // setState((){
                print("NOTI: "+galeriaF[index]["id"]);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Noticias(titulo: galeriaF[index]["descripcion"],tipo: galeriaF[index]["tipo"])));

             // });

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