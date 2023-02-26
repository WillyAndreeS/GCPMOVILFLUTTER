import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/models/Menu.dart';
import 'package:acpmovil/views/certificacionespage.dart';
import 'package:acpmovil/views/culturapage.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:acpmovil/views/gcpgps.dart';
import 'package:acpmovil/views/page2.dart';
import 'package:acpmovil/views/principalpage.dart';
import 'package:acpmovil/views/screen_contactanos.dart';
import 'package:acpmovil/views/screen_gcpmundo.dart';
import 'package:acpmovil/views/vista_panoramica_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';



class Vistapanoramica extends StatefulWidget {
  Vistapanoramica({Key? key}) ;

  @override
  _VistapanoramicaState createState() => _VistapanoramicaState();
}

class _VistapanoramicaState extends State<Vistapanoramica> {
  late Size size;
  List vistasF = [];

  Future<void> getVistasacp() async{

    var vista = FirebaseFirestore.instance.collection("vistas360").orderBy("id");
    QuerySnapshot vistas = await vista.get();
setState((){
  if(vistas.docs.isNotEmpty){
    for(var doc in vistas.docs){
      print("DATOS: "+doc.id.toString());
      vistasF.add(doc.data());
    }
    print("TITULO: "+vistasF[0]["titulo"]);

    }
  });

  }

  @override
  void initState() {
    super.initState();
    getVistasacp();

  }
//final List<String> titles = ['¿Quiénes Somos?', 'Cultura', 'Certificaciones', 'Contáctanos', 'ACP en el mundo', 'GPS ACP'];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Vista 360º", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),

      body: Container(
        padding: const EdgeInsets.only(top: 20),
    child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
    itemCount: vistasF.length,
    itemBuilder: (BuildContext context, int index) {
      return vistasF.isNotEmpty ? GestureDetector(
          onTap: (){
            setState((){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  VistapanoramicaWeb(url: vistasF[index]["url"], titulo: vistasF[index]["titulo"])));

            });

          },
          child: Container(
            height: size.height/4,

        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), image: DecorationImage(
          image: const AssetImage("assets/images/certificaciones_campo_planta.jpg"),
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
                        vistasF[index]["titulo"] == null ? "": vistasF[index]["titulo"],
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler", fontSize: 20))),

              ],
            ),

          ),),
          const SizedBox(height: 20,),
          Align(alignment: Alignment.center, child:Container(
            width: size.width,
            decoration: const BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),),
            padding: const EdgeInsets.only(top:5, bottom: 5, left: 2 ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    child: Image.asset("assets/images/video-360.png"), width: 50,),

              ],
            ),

          ),),
        ],)


      )): const Center(child: CircularProgressIndicator(),);}
    )),);
    }
  }