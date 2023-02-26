import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:acpmovil/views/detalle_utilidades.dart';
import 'package:acpmovil/views/registro_reclamo.dart';
import 'package:acpmovil/views/trabajaconnosotros_web.dart';
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



class TrabajaNosotros extends StatefulWidget {
  String? titulo, urlimagen;
  TrabajaNosotros({Key? key, this.titulo, this.urlimagen}) ;

  @override
  _TrabajaNosotrosState createState() => _TrabajaNosotrosState();
}

class _TrabajaNosotrosState extends State<TrabajaNosotros> {

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
        SliverAppBar( backgroundColor: Colors.black,flexibleSpace: FlexibleSpaceBar( title: Container( color: Colors.black.withOpacity(0.5), width: size.width,child: Text("Trabaja con nosotros", style: TextStyle(fontFamily: "Schyler", fontSize: 24), textAlign: TextAlign.right,)),
          background: //Image.network(widget.urlimagen!),
          CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/nav_003.png?alt=media&token=bdb68179-37e1-48ee-b455-262b6fa1aed1", imageBuilder: (context, imageProvider) => Container(
                    decoration:  BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),),
                  ),placeholder: (context, url) => Container(
            decoration:  BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(10.0) ),
              image: DecorationImage(
                image: AssetImage("assets/images/nav_003.png"),
                fit: BoxFit.cover,
              ),),
          ),
            errorWidget: (context, url, error) => Icon(Icons.error),),
        ),expandedHeight: size.height*0.3,),
        SliverList(
          delegate: SliverChildListDelegate([
            GestureDetector( onTap:(){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  TrabajaNosotrosWeb(titulo: "Trabaja con nosotros",url: "https://web.acpagro.com/reclutamiento/index.php/ccreclutamiento#newsRegistrate")));
            }, child: Container(
              width: size.width,
             // height: size.height/1.5,
              child:
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child:  Container( padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15), decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(10.0)), color: Colors.white, boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, offset: const Offset(-5,5)),

                  ]), child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: kPrimaryColor,
                          radius: 25,
                          child: ClipOval(

                            child: Text("1",style: TextStyle(fontFamily: "Schyler", color: Colors.white, fontSize: 15)),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                    Text("TRABAJA CON NOSOTROS", style: TextStyle(fontFamily: "Schyler", color: Colors.black, fontSize: 20)),
                    Text("¡Registrate aquí!", style: TextStyle(fontFamily: "Schyler", color: Colors.grey, fontSize: 14))
                  ])])
                    ),
    ),),),),
            SizedBox(height: 10,),
      GestureDetector( onTap:(){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  TrabajaNosotrosWeb(titulo: "Pasa la voz",url: "https://docs.google.com/forms/d/e/1FAIpQLSeJDW4vrc6wHwD4kHYKbfx26178PQ74h_X3PTKCuKjewQijWQ/viewform")));
      }, child: Container(
              width: size.width,
              // height: size.height/1.5,
              child:
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child:  Container( padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15), decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(10.0)), color: Colors.white, boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, offset: const Offset(-5,5)),

                  ]), child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          backgroundColor: kPrimaryColor,
                          radius: 25,
                          child: ClipOval(

                            child: Text("2",style: TextStyle(fontFamily: "Schyler", color: Colors.white, fontSize: 15)),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                    Text("PASA LA VOZ", style: TextStyle(fontFamily: "Schyler", color: Colors.black, fontSize: 20)),
                    Text("¡Registrate aquí!", style: TextStyle(fontFamily: "Schyler", color: Colors.grey, fontSize: 14))
                  ])]
                  ),
                ),),)))


          ]),
        )
      ] ,));
    }
  }
