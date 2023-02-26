import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:acpmovil/views/detalle_utilidades.dart';
import 'package:acpmovil/views/registro_reclamo.dart';
import 'package:chewie/chewie.dart';
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



class Amarloquehaces extends StatefulWidget {
  String? titulo, urlimagen;
  Amarloquehaces({Key? key, this.titulo, this.urlimagen}) ;

  @override
  _AmarloquehacesState createState() => _AmarloquehacesState();
}

class _AmarloquehacesState extends State<Amarloquehaces> {

  late Size size;
  List alqh = [];
  final myControllerUser = TextEditingController();
  late VideoPlayerController _controller;
  late FocusNode focusUser;
  @override
  void initState() {
    super.initState();
    focusUser = FocusNode();
    getProgramasALQH();


  }

  Future<void> getProgramasALQH() async{

    var ecoin = FirebaseFirestore.instance.collection("AMARLOQUEHACES").orderBy("id");
    QuerySnapshot eco = await ecoin.get();
    setState((){
      if(eco.docs.isNotEmpty){
        for(var doc in eco.docs){
          print("DATOS: "+doc.id.toString());
          alqh.add(doc.data());
        }
        print("TITULO: "+alqh[0]["descripcion"]);

      }
    });

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
        SliverAppBar( backgroundColor: Colors.black,flexibleSpace: FlexibleSpaceBar( title: Container( color: Colors.black.withOpacity(0.5), width: size.width,child: Text(widget.titulo!, style: TextStyle(fontFamily: "Schyler", fontSize: 15), textAlign: TextAlign.right,)),
          background: //Image.network(widget.urlimagen!),
          CachedNetworkImage(imageUrl: widget.urlimagen!, imageBuilder: (context, imageProvider) => Container(
                    decoration:  BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),),
                  ),placeholder: (context, url) => Container(
            decoration:  BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(10.0) ),
              image: DecorationImage(
                image: AssetImage("assets/images/122840-image.gif"),
                fit: BoxFit.cover,
              ),),
          ),
            errorWidget: (context, url, error) => Icon(Icons.error),),
        ),expandedHeight: size.height*0.3,),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              width: size.width,
              height: size.height/1.5,
              child:
            ListView.builder(
            //padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: alqh.length,
            itemBuilder: (BuildContext context, int index) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
              Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(alqh[index]["descripcion"], style: TextStyle(fontSize: 16,fontFamily: "Schyler" ),textAlign: TextAlign.justify,)
              ),
              SizedBox(height: 10,),
              Container(
                width: size.width/1.15,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    Icon(Icons.emoji_objects, color: kPrimaryColor,),
                      Text("OBJETIVO",style: TextStyle(fontSize: 12,fontFamily: "Schyler", color: kPrimaryColor ),textAlign: TextAlign.left)])

              ),
              Container( width: size.width/1.3, height: 0,child: Divider(color: kPrimaryColor,),),
              SizedBox(height: 5,),
              Container(
                width:size.width/1.2,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(alqh[index]["objetivo"], style: TextStyle(fontSize: 14,fontFamily: "Schyler" ),textAlign: TextAlign.justify,)
              ),
            ]);}),),

          ]),
        )
      ] ,));
    }
  }
