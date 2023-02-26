import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:acpmovil/views/detalle_utilidades.dart';
import 'package:acpmovil/views/registro_reclamo.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:acpmovil/constants.dart';
import 'package:http/http.dart' as http;
import 'package:acpmovil/views/screen_gcpmundo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:video_player/video_player.dart';



class LineaCovid extends StatefulWidget {
  String? titulo, urlimagen;
  LineaCovid({Key? key, this.titulo, this.urlimagen}) ;

  @override
  _LineaCovidState createState() => _LineaCovidState();
}

class _LineaCovidState extends State<LineaCovid> {

  late Size size;
  List ecoins = [];
  final myControllerUser = TextEditingController();
  late VideoPlayerController _controller;
  late FocusNode focusUser;
  @override
  void initState() {
    super.initState();
    focusUser = FocusNode();


  }




  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    size = MediaQuery.of(context).size;
    return  Scaffold(
       /* appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text("Quejas y Sugerencias", style: TextStyle(fontFamily: "Schyler"),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop (context, false);
            },
          ),

        ),*/
      body: CustomScrollView( slivers: [
        SliverAppBar( backgroundColor: Colors.black,flexibleSpace: FlexibleSpaceBar( title: Container( color: Colors.black.withOpacity(0.5), width: size.width,child: Text("línea COVID -19", style: TextStyle(fontFamily: "Schyler", fontSize: 15), textAlign: TextAlign.right,)),
          background: //Image.network(widget.urlimagen!),
          CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/Imag-1%20(1).png?alt=media&token=1d6da4ce-bc88-4151-98da-d17e253d9342", imageBuilder: (context, imageProvider) => Container(
                    decoration:  BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),),
                  ),placeholder: (context, url) => Container(
            decoration:  BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(10.0) ),
              image: DecorationImage(
                image: AssetImage("assets/images/Imag-1.png"),
                fit: BoxFit.cover,
              ),),
          ),
            errorWidget: (context, url, error) => Icon(Icons.error),),
        ),expandedHeight: size.height*0.3,),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              width: size.width,
             // height: size.height/1.5,
              child:
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child:  Container( padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15), child:
                      Text("Si presentas tos, fiebre, o síntomas COVID - 19, comunícate al", style: TextStyle(fontFamily: "Schyler", color: Colors.black, fontSize: 24)))
                    ),
    ),),
            GestureDetector(onTap:()async{ FlutterPhoneDirectCaller.callNumber("949323707");}, child: Container(margin: EdgeInsets.symmetric(horizontal: 30),height: size.height/10, width: size.width/1.5, decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(20.0)), color: kPrimaryColor, boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, offset: const Offset(-5,5)),

            ]), child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Icon(Icons.call, color: Colors.white,),
              Center( child:Text("949 323 707", style: TextStyle(fontFamily: "Schyler", color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)))
    ])),),

          ]),
        )
      ] ,));
    }
  }
