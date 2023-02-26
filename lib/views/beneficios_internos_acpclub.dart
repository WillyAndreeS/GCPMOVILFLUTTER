import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:acpmovil/Animations/FadeAnimation.dart';
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/beneficios_detalle.dart';

import 'package:acpmovil/views/nuestroequipo.dart';
import 'package:acpmovil/views/organigrama.dart';
import 'package:acpmovil/views/page2.dart';
import 'package:acpmovil/views/principalpage.dart';
import 'package:acpmovil/views/screen_contactanos.dart';
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



class BeneficiosInternos extends StatefulWidget {
  BeneficiosInternos({Key? key}) ;

  @override
  _BeneficiosInternosState createState() => _BeneficiosInternosState();
}

class _BeneficiosInternosState extends State<BeneficiosInternos> {
  late Size size;
  List beneficiosF = [];
  List menus_ocultos = [];
  String? estado_menu1;
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;

  Future<void> getBeneficiosInternosacp() async{

    var conoce = FirebaseFirestore.instance.collection("menu_beneficios_internos").orderBy("id");
    QuerySnapshot conocenos = await conoce.get();
setState((){
  if(conocenos.docs.isNotEmpty){
    for(var doc in conocenos.docs){
      print("DATOS: "+doc.id.toString());
      beneficiosF.add(doc.data());
    }
    print("TITULO: "+beneficiosF[0]["nombre"]);

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
    getBeneficiosInternosacp();

  }



  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Beneficios Internos", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),

      body: beneficiosF.isEmpty ? Center(child: CircularProgressIndicator()): Container(
        padding: const EdgeInsets.only(top: 20),
    child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
    itemCount: beneficiosF.length,
    itemBuilder: (BuildContext context, int index) {
      return beneficiosF.isNotEmpty ? GestureDetector(
          onTap: ()async{
              setState((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  BeneficiosDetalle(objetivo: beneficiosF[index]["objetivo"], dirigido:beneficiosF[index]["dirigido"], terminos: beneficiosF[index]["terminos"],periodicidad: beneficiosF[index]["periodicidad"], alcance: beneficiosF[index]["alcance"], imagen: beneficiosF[index]["imagen"], nombre: beneficiosF[index]["nombre"])));

              });


          },
          child: CachedNetworkImage(imageUrl: beneficiosF[index]["imagen"], imageBuilder: (context, imageProvider) => FadeAnimation(1.4,Container(
            height: size.height/4,

        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(borderRadius:  const BorderRadius.all(Radius.circular(10.0)), image: hasInternets || hasInternet ? DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ): const DecorationImage(
          image: AssetImage("assets/images/122840-image.gif"),
          fit: BoxFit.cover,
        ), boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 5.0, offset:Offset(0,10)),

        ]),
        child: Column(children: [
          Align(alignment: Alignment.centerLeft, child:Container(
            width: size.width,
            height: size.height/15,
            decoration:  BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)), color:const Color(0xFF0000000).withOpacity(0.3),),
            padding: const EdgeInsets.only(top:10, bottom: 5, left: 2 ),
            child: SizedBox(
                width: size.width*0.80,
                child: Row(
                children: [

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(1.4, Container(
                      margin: const EdgeInsets.only(left: 20),
                      width: size.width*0.7,
                      child: Text(
                          beneficiosF[index]["nombre"] == null ? "": beneficiosF[index]["nombre"],
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler", fontSize: 20)))),
                  FadeAnimation(1.4, Container(
                      margin: const EdgeInsets.only(left: 20),
                      width: size.width*0.7,
                      child: const Text(
                          "Beneficios Internos",
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler", fontSize: 12)))),

                ],
              ),
                FadeAnimation(1.4, SizedBox(width: size.width*0.1,child: Image.network("https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/gcp_005.png?alt=media&token=d85ed989-1bb0-424f-a8a5-3d3ab3a158ae",width: 28,height: 28,)))
            ]))

          ),),
        ],)


      )),placeholder: (context, url) => Container(
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