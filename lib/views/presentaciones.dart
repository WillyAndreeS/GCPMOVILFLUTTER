import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/Presentaciones_web.dart';

import 'package:acpmovil/views/nuestroequipo.dart';
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



class Presentaciones extends StatefulWidget {
  Presentaciones({Key? key}) ;

  @override
  _PresentacionesState createState() => _PresentacionesState();
}

class _PresentacionesState extends State<Presentaciones> {
  late Size size;
  List conocenosF = [];
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;



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

  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Presentaciones", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),

      body: Container(
        padding: const EdgeInsets.only(top: 20),
    child: SingleChildScrollView(
       child:Column( children: [
        GestureDetector(
          onTap: (){
              setState((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  PresentacionesWeb(titulo: "Presentaciones Palta", url: "https://web.acpagro.com/acpmovil/vista/para_productos/presentaciones_palta.php")));

              });



          },
          child: CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/img_palta.jpg?alt=media&token=5f359b8d-13a7-4eab-8a6c-135786ed7700", imageBuilder: (context, imageProvider) => Container(
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
                        "PALTA",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler", fontSize: 20))),

              ],
            ),

          ),),
          SizedBox(height: 20,),
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


          ), )),
         SizedBox(height: 30,),
         GestureDetector(
             onTap: (){
               setState((){
                 Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) =>  PresentacionesWeb(titulo: "Presentaciones Arandano", url: "https://web.acpagro.com/acpmovil/vista/para_productos/presentaciones_arandano.php")));

               });



             },
             child: CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/img_arandano.jpg?alt=media&token=19dc8eba-9353-44e6-91e8-99e57d621b03", imageBuilder: (context, imageProvider) => Container(
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
                                 "ARANDANO",
                                 maxLines: 2,
                                 textAlign: TextAlign.center,
                                 style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler", fontSize: 20))),

                       ],
                     ),

                   ),),
                   SizedBox(height: 20,),
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


             ), )),
         SizedBox(height:30),
         GestureDetector(
             onTap: (){
               setState((){
                 Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) =>  PresentacionesWeb(titulo: "Presentaciones Esparrago", url: "https://web.acpagro.com/acpmovil/vista/para_productos/presentaciones_esparrago.php",)));

               });



             },
             child: CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/img_esparrago.jpg?alt=media&token=e223dd1b-cb92-4d52-aece-d0d07c597a02", imageBuilder: (context, imageProvider) => Container(
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
                                 "ESPARRAGO",
                                 maxLines: 2,
                                 textAlign: TextAlign.center,
                                 style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler", fontSize: 20))),

                       ],
                     ),

                   ),),
                   SizedBox(height: 20,),
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


             ), )),
       ])
    )),);
    }
  }