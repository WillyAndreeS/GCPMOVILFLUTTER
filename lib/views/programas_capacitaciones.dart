import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/galeria_celebrando_juntos.dart';

import 'package:acpmovil/views/nuestroequipo.dart';
import 'package:acpmovil/views/page2.dart';
import 'package:acpmovil/views/principalpage.dart';
import 'package:acpmovil/views/screen_amarloquehaces.dart';
import 'package:acpmovil/views/screen_contactanos.dart';
import 'package:acpmovil/views/screen_ecoin.dart';
import 'package:acpmovil/views/screen_gcpmundo.dart';
import 'package:acpmovil/views/screen_nuestros_productos_v2.dart';
import 'package:acpmovil/views/vista_panoramica_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';



class ProgramasCapa extends StatefulWidget {
  ProgramasCapa({Key? key}) ;

  @override
  _ProgramasCapaState createState() => _ProgramasCapaState();
}

class _ProgramasCapaState extends State<ProgramasCapa> {
  late Size size;
  List capasF = [];
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;

  Future<void> getProgramasCapaacp() async{

    var capa = FirebaseFirestore.instance.collection("menu_capacitaciones").orderBy("id");
    QuerySnapshot capas = await capa.get();
setState((){
  if(capas.docs.isNotEmpty){
    for(var doc in capas.docs){
      print("DATOS: "+doc.id.toString());
      capasF.add(doc.data());
    }
    print("TITULO: "+capasF[0]["descripcion"]);

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
    getProgramasCapaacp();

  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Programas y Capacitaciones", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),

      body: capasF.isEmpty ? Center(child: CircularProgressIndicator()): Container(
        padding: const EdgeInsets.only(top: 20),
    child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
    itemCount: capasF.length,
    itemBuilder: (BuildContext context, int index) {
      return capasF.isNotEmpty ? GestureDetector(
          onTap: (){
            if(capasF[index]["id"] == 1){
              setState((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Ecoin(titulo: capasF[index]["descripcion"],urlimagen: capasF[index]["imagen"],)));

              });
            }else if(capasF[index]["id"] == 3){
              setState((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Amarloquehaces(titulo: capasF[index]["descripcion"],urlimagen: capasF[index]["imagen"],)));

              });
            }


          },
          child: CachedNetworkImage(imageUrl: capasF[index]["imagen"], imageBuilder: (context, imageProvider) => Container(
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
                        capasF[index]["descripcion"] == null ? "": capasF[index]["descripcion"],
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