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
import 'package:acpmovil/views/programas_capacitaciones.dart';
import 'package:acpmovil/views/quejasreclamos.dart';
import 'package:acpmovil/views/screen_contactanos.dart';
import 'package:acpmovil/views/screen_gcpmundo.dart';
import 'package:acpmovil/views/screen_linea_covid.dart';
import 'package:acpmovil/views/screen_linea_etica.dart';
import 'package:acpmovil/views/screen_nuestros_productos_v2.dart';
import 'package:acpmovil/views/utilidades.dart';
import 'package:acpmovil/views/vista_panoramica_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';



class Beneficios extends StatefulWidget {
  Beneficios({Key? key}) ;

  @override
  _BeneficiosState createState() => _BeneficiosState();
}

class _BeneficiosState extends State<Beneficios> {
  late Size size;
  List beneficiosF = [];
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;

  Future<void> getBeneficiosacp() async{

    var beneficio = FirebaseFirestore.instance.collection("menu_beneficios").where("estado", isEqualTo: "1").orderBy("id");
    QuerySnapshot beneficios = await beneficio.get();
setState((){
  if(beneficios.docs.isNotEmpty){
    for(var doc in beneficios.docs){
      print("DATOS: "+doc.id.toString());
      beneficiosF.add(doc.data());
    }
    print("TITULO: "+beneficiosF[0]["titulo"]);

    }
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
    getBeneficiosacp();

  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Beneficios y líneas de apoyo", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),

      body: beneficiosF.isEmpty ? Center(child: CircularProgressIndicator()): Container(
        padding: const EdgeInsets.only(top: 20),
    child: RefreshIndicator( onRefresh: ()async{ await getBeneficiosacp();} , child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
    itemCount: beneficiosF.length,
    itemBuilder: (BuildContext context, int index) {
      return beneficiosF.isNotEmpty ? Visibility(
          visible: (tipoUsuario == 'invitado' && (beneficiosF[index]["titulo"] == 'Utilidades' || beneficiosF[index]["titulo"] == 'Quejas y sugerencias')) ? false: true,
          child: GestureDetector(
          onTap: (){
            if(beneficiosF[index]["id"] == 1){
              setState((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  ConocenosContactanos()));

              });
            }else if(beneficiosF[index]["id"] == 3){
              setState((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Utilidades()));

              });
            }else if(beneficiosF[index]["id"] == 2){
              setState((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  LineaCovid()));

              });
            }else if(beneficiosF[index]["id"] == 4){
              setState((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  QuejasReclamos()));

              });
            }else if(beneficiosF[index]["id"] == 6){
              setState((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  ProgramasCapa()));

              });

            }else if(beneficiosF[index]["id"] == 5){
              setState((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  LineaEtica()));

              });

            }



          },
          child: CachedNetworkImage(imageUrl: beneficiosF[index]["imagen"], imageBuilder: (context, imageProvider) => Container(
            height: size.height/7,

        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(20.0)),  image:  DecorationImage(
          
          image: imageProvider,
          fit: BoxFit.cover,
        ), boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, offset: const Offset(-5,5)),

        ]),
        child: Container( decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(20.0)), color: Colors.white.withOpacity(0.9)),child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween , children: [
          Container(padding: const EdgeInsets.only(left: 15), child: CircleAvatar(radius: 35,backgroundColor: kPrimaryColor,
        child: ClipOval(
          child: Image.network(beneficiosF[index]["icono"], width: 40,),
        ),),),


                Container( width:size.width/2, padding:EdgeInsets.symmetric(horizontal: 0), child: Text(
                    beneficiosF[index]["titulo"],
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: kPrimaryColor,fontFamily: "Schyler", fontSize: 20)))


        ],))


      ), placeholder: (context, url) => Container(
              height: size.height/7,

              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(20.0)),  image:  DecorationImage(

                image: AssetImage("assets/images/122840-image.gif"),
                fit: BoxFit.cover,
              ), boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, offset: const Offset(-5,5)),

              ]),
              child: Container( decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(20.0)), color: Colors.white.withOpacity(0.9)),child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween , children: [
                Container(padding: const EdgeInsets.only(left: 15), child: CircleAvatar(radius: 35,backgroundColor: kPrimaryColor,
                  child: ClipOval(
                    child: Image.network(beneficiosF[index]["icono"], width: 40,),
                  ),),),


                Container( width:size.width/2, padding:EdgeInsets.symmetric(horizontal: 0), child: Text(
                    beneficiosF[index]["titulo"],
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: kPrimaryColor,fontFamily: "Schyler", fontSize: 20)))


              ],))


          ),
            errorWidget: (context, url, error) => Icon(Icons.error),))): Center(child: CircularProgressIndicator(),);}
    ))),);
    }
  }