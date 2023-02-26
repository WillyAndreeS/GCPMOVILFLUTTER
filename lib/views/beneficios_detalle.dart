import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:acpmovil/Animations/FadeAnimation.dart';
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/beneficios_internos_acpclub.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';



class BeneficiosDetalle extends StatefulWidget {
  String? objetivo, dirigido, terminos,periodicidad, alcance, imagen, nombre;
  BeneficiosDetalle({Key? key, this. objetivo, this.dirigido, this.terminos, this.periodicidad, this.alcance, this.imagen, this.nombre}) ;

  @override
  _BeneficiosDetalleState createState() => _BeneficiosDetalleState();
}

class _BeneficiosDetalleState extends State<BeneficiosDetalle> {
  late Size size;
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;


  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((result) {
      if (mounted) {
        setState(() => this.result = result);
      }
    });
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery
        .of(context)
        .size;
    return Scaffold(

        body: Container(
          width: size.width,
          height: size.height,
          child: Stack( children: [
            Column(children: [
          CachedNetworkImage(imageUrl: widget.imagen!, imageBuilder: (context, imageProvider) =>FadeAnimation(1,Container(
              width: size.width,
              height: size.height*0.4,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
                image: DecorationImage(image:imageProvider, fit: BoxFit.cover),
                boxShadow: const [
                  BoxShadow(
                          color: Colors.black,
                          blurRadius: 10.0)
                ]
              ),
            ),),placeholder: (context, url) => FadeAnimation(1,Container(
            width: size.width,
            height: size.height*0.4,
            decoration: const BoxDecoration(
                borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
                image: DecorationImage(image:AssetImage("assets/images/122840-image.gif"), fit: BoxFit.cover),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 10.0)
                ]
            ),
          ),), errorWidget: (context, url, error) =>const Center(child: Icon(Icons.error)),),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top:size.height*0.1, left: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.emoji_objects, color: kPrimaryColor,),
                      SizedBox(width: 5,),
                      Text("OBJETIVOS", style: TextStyle(color: kPrimaryColor),)
                    ],
                  ),
                  SizedBox(height: 10,),
                  FadeAnimation(1.4,Container(margin: EdgeInsets.symmetric(horizontal: 35), child:
                    Text(widget.objetivo!, style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.justify,)
                  ),),
                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Icon(Icons.rule, color: Colors.black,),
                      SizedBox(width: 5,),
                      Text("Términos y Condiciones", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                    ],
                  ),
                  SizedBox(height: 10,),
                  FadeAnimation(1.4, Container(margin: EdgeInsets.symmetric(horizontal: 35), child:
                  Text(widget.terminos!, style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.justify,)
                  ),),
                ],
              )
            )
          ],),
          Align( alignment: const Alignment(-0.9, -0.90),
            child: IconButton(icon: Icon(Icons.arrow_back_ios,), onPressed: (){
              Navigator.pop (context, false);
            },),
          ),
            Align( alignment: const Alignment(0.0, -0.25),

                child:Container(
                  width: size.width*0.8,
                  height: size.height*0.18,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:  BorderRadius.all(Radius.circular(25)),
                      boxShadow:  [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 10.0)
                      ]
                  ),
                  child: Column(children:[
                    Center( child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      FadeAnimation(1.4,Container(
                          margin: EdgeInsets.only(top: 12, left: 15),
                          alignment: Alignment.topLeft,
                          //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(widget.nombre!, style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16),)),),
                        FadeAnimation(1.4,Container(
                          margin: EdgeInsets.only(top: 8, right: 15),
                          alignment: Alignment.topRight, child: Image.network("https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/gcp_005.png?alt=media&token=d85ed989-1bb0-424f-a8a5-3d3ab3a158ae", width: 28, height: 28,color: kPrimaryColor,)))
                    ],)),
                    SizedBox(height: 10,),
                    FadeAnimation(1.4,Container(
                      width: size.width,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("Dirigido a: "+ widget.dirigido!, style: TextStyle(fontWeight: FontWeight.bold),)
                    ),),
                    SizedBox(height: 5,),
                    FadeAnimation(1.4,Container(
                        width: size.width,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Text("Periodicidad: "+ widget.periodicidad!, style: TextStyle(fontWeight: FontWeight.bold))
                    ),),
                    SizedBox(height: 10,),
                    FadeAnimation(1.4,Container(
                        //width: size.width*0.8,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(children: [
                          Icon(Icons.location_on_sharp, color: Colors.grey,),
                          Container( width: size.width * 0.6,child:Text("Alcance: "+ widget.alcance!, style: TextStyle(fontWeight: FontWeight.bold, color:Colors.grey, fontSize: 12)))
                        ],))
                    )
                  ])
                )

            )
          ]),
        )
    );
  }

}