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



class Ecoin extends StatefulWidget {
  String? titulo, urlimagen;
  Ecoin({Key? key, this.titulo, this.urlimagen}) ;

  @override
  _EcoinState createState() => _EcoinState();
}

class _EcoinState extends State<Ecoin> {

  late Size size;
  List ecoins = [];
  final myControllerUser = TextEditingController();
  late VideoPlayerController _controller;
  late FocusNode focusUser;
  @override
  void initState() {
    super.initState();
    focusUser = FocusNode();
    getProgramasEcoin();


  }

  Future<void> getProgramasEcoin() async{

    var ecoin = FirebaseFirestore.instance.collection("ECOIN").orderBy("id");
    QuerySnapshot eco = await ecoin.get();
    setState((){
      if(eco.docs.isNotEmpty){
        for(var doc in eco.docs){
          print("DATOS: "+doc.id.toString());
          ecoins.add(doc.data());
        }
        print("TITULO: "+ecoins[0]["enlace"]);

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
        SliverAppBar( backgroundColor: Colors.black,flexibleSpace: FlexibleSpaceBar( title: Container( color: Colors.black.withOpacity(0.5), width: size.width,child: Text("¿Qué es "+widget.titulo!+"?", style: TextStyle(fontFamily: "Schyler", fontSize: 15), textAlign: TextAlign.right,)),
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
            itemCount: ecoins.length,
            itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    decoration:  BoxDecoration( color: Colors.white,
                        borderRadius:  BorderRadius.all(Radius.circular(10.0) ), boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

                ]),
                  child:
                      VideoPlayerView(url: ecoins[index]["enlace"],dataSourceType: DataSourceType.network, tumbnails: ecoins[index]["thumbnail"],)
                    ),
    );}),),

          ]),
        )
      ] ,));
    }
  }

class VideoPlayerView extends StatefulWidget{
  final String url;
  final DataSourceType dataSourceType;
  final tumbnails;
  const VideoPlayerView({super.key, required this.url, required this.dataSourceType, required this.tumbnails});

  @override
  State<VideoPlayerView>createState() => _VideoPlayerViewState();
}
class _VideoPlayerViewState extends State<VideoPlayerView>{
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  initState(){
   super.initState();

   switch(widget.dataSourceType){
     case DataSourceType.asset:
       _videoPlayerController = VideoPlayerController.asset(widget.url);
       break;
     case DataSourceType.network:
       _videoPlayerController = VideoPlayerController.network(widget.url)..initialize().then((_) {
         setState(() {});
       });
       break;
     case DataSourceType.file:
       _videoPlayerController = VideoPlayerController.file(File(widget.url));
       break;
     case DataSourceType.contentUri:
       _videoPlayerController = VideoPlayerController.contentUri(Uri.parse(widget.url));
       break;
   }

   _chewieController = ChewieController(videoPlayerController: _videoPlayerController, placeholder: Container(child: Image.network(widget.tumbnails),),
   aspectRatio: 16 / 9);
  }

  @override
  void dispose(){
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
    
  }

  @override

  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _videoPlayerController.value.isInitialized ?
        AspectRatio(aspectRatio: 16 / 9,
        child: Chewie(controller: _chewieController)):
            Container(
                decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), image:  DecorationImage(
                    image: NetworkImage(widget.tumbnails),
                  fit: BoxFit.cover,
                ), boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

                ]),
                child: Column(children:[
                    Align(alignment: Alignment.center, child:Container(
                      width: size.width,
                      height: size.height/3,
                      decoration: const BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),),
                      padding: const EdgeInsets.only(top:5, bottom: 5, left: 2 ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){

                              if(_videoPlayerController.value.isPlaying){
                                print("HOLA");
                                _videoPlayerController.pause();
                              }else{
                                print("NO HOLA");
                                _videoPlayerController.play();
                              }
                            },
                            child: Container(
                              child: Center(child: CircularProgressIndicator(),)),
                          )


                        ],
                      ),

                    ))
                ]))
      ],
    );
  }
}