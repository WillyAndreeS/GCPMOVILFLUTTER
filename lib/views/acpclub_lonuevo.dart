import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/acpclub_flyer.dart';
import 'package:acpmovil/views/acpclub_promociones.dart';

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



class AcpClubLonuevo extends StatefulWidget {
  AcpClubLonuevo({Key? key}) ;

  @override
  _AcpClubLonuevoState createState() => _AcpClubLonuevoState();
}

class _AcpClubLonuevoState extends State<AcpClubLonuevo> {
  late Size size;
  List categoriasF = [];
  List menus_ocultos = [];
  String? estado_menu1;
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;

  Future<void> getCategoriasacpclub() async{
    DateTime now = new DateTime.now();
    DateTime hoy = now.add(Duration(days: -15));
    var categoria = FirebaseFirestore.instance.collection("acpclub").doc("locales").collection("salud").where("fecharegistro",isGreaterThanOrEqualTo: hoy).orderBy("fecharegistro", descending: true);//.where("categoria", isEqualTo: categoriadet);
    QuerySnapshot categorias = await categoria.get();
    if(categorias.docs.isNotEmpty){
    setState((){
      for(var doc in categorias.docs){
        print("DATOS: "+doc.id.toString());
        categoriasF.add(doc.data());
      }
    print("TITULO: "+categoriasF[0]["nombre"]);
  });
    }else {
      var categoria = FirebaseFirestore.instance.collection("acpclub").doc(
          "locales").collection("salud").orderBy("fecharegistro",
          descending: true).limit(5); //.where("categoria", isEqualTo: categoriadet);
      QuerySnapshot categorias = await categoria.get();
      setState(() {
        if (categorias.docs.isNotEmpty) {
          for (var doc in categorias.docs) {
            print("DATOS: " + doc.id.toString());
            categoriasF.add(doc.data());
          }
        }
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
    getCategoriasacpclub();
  }




  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title:  Text("Lo nuevo en ACP Club", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),

      body: categoriasF.isEmpty ? Center(child: Center( child: Container(child: Text("No hay establecimientos disponibles", style: TextStyle(fontFamily: "Schyler"))))): Container(
        padding: const EdgeInsets.only(top: 20),
    child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
    itemCount: categoriasF.length,
    itemBuilder: (BuildContext context, int index) {
      return categoriasF.isNotEmpty ? GestureDetector(
          onTap: ()async{

            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  AcpClubPromo(urlflyer: categoriasF[index]["foto"], nombre: categoriasF[index]["nombre"], terminos: categoriasF[index]["terminos"], idlocal: categoriasF[index]["idlocal"], cel: categoriasF[index]["cel"], facebook: categoriasF[index]["facebook"], instagram:  categoriasF[index]["instagram"], direccion:  categoriasF[index]["direccion"])));
          },
          child: CachedNetworkImage(imageUrl: categoriasF[index]["foto"], imageBuilder: (context, imageProvider) => Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              height: size.height/7,
              width: size.width/1.5,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white, image:  DecorationImage(
                image: NetworkImage( categoriasF[index]["foto"]),
                fit: BoxFit.cover,
              ), boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(-5,10)),

              ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row (
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        // margin: EdgeInsets.only(top:5),
                        padding: EdgeInsets.only(left: 5),
                        width: size.width/4,height: size.height/17, decoration: BoxDecoration( borderRadius: BorderRadius.only(topLeft: Radius.circular(25)), image:DecorationImage(
                        image: AssetImage("assets/images/Tarjeta-de-descuento.png",),fit: BoxFit.fill,) ),
                        child: Container(alignment: Alignment.centerLeft,margin: EdgeInsets.only(right: 10, left: 5),child: Text(categoriasF[index]["promocion"], style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),textAlign: TextAlign.left, ),),)

                    ],),

                ],)
          ), placeholder: (context, url) => Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              height: size.height/7,
              width: size.width/1.5,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white, image:  DecorationImage(
                image: AssetImage("assets/images/122840-image.gif"),
                fit: BoxFit.cover,
              ), boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(-5,10)),

              ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row (
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        width: size.width/3,height: size.height/15, decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),  boxShadow: [

                      ]), child: Text(categoriasF[index]["promocion"], style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold, color: Colors.white), ),),

                    ],),

                ],)
          ),),): Center(child: Container(
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