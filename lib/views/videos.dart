import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/screen_galeria_videos.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:video_player/video_player.dart';

class ListaVideos {
  String? IDSUBCATEGORIA,SUBCATEGORIA, URL_FOTO,FECHAHORAREGISTRO, URL_VIDEO;
  ListaVideos(this.IDSUBCATEGORIA, this.SUBCATEGORIA, this.URL_FOTO, this.FECHAHORAREGISTRO, this.URL_VIDEO);
}

class ListaVH {
  String? IDSUBCATEGORIA, URL_FOTO;

  ListaVH(this.IDSUBCATEGORIA, this.URL_FOTO);
}

class Videos extends StatefulWidget {
  String? titulo;
  Videos({Key? key, this.titulo}) ;

  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  late Size size;
  List galeriaF = [];
  List arandanoF = [];
  List videos = [];
  List <ListaVH> fotoscategoria = [];
  List prueba = [];
  List<ListaVideos>sublita = [];
  bool hasInternet = false;
  int inee = 0;
  late int currentIndex = 0;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  late PageController pageController;
  ConnectivityResult result = ConnectivityResult.none;
  List<bool>isSelected = [true, false, false, false];

  Future<void> getVideosacp(String menu) async{

    galeriaF.clear();
    arandanoF.clear();
    videos.clear();
    sublita.clear();
    fotoscategoria.clear();
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var response = await http.post(
          Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
          body: {"accion": "getdatos_videos"});
      // if (mounted) {
      setState(() {
        var extraerData = json.decode(response.body);
        galeriaF = extraerData["categorias"];
        videos = extraerData["videos"];
            for(int x = 0; x<videos.length; x++){
              if(videos[x]["IDCATEGORIA"] != "7") {
                if (videos[x]["IDCATEGORIA"] == menu) {
                  if(sublita.isNotEmpty){
                    //print("NO VACIA");
                    //int existe = sublita.indexWhere((item) => item.IDSUBCATEGORIA == videos[x]["IDSUBCATEGORIA"]);
                   // if( existe == -1){
                      sublita.add(ListaVideos(videos[x]["IDSUBCATEGORIA"],videos[x]["TITULO"], videos[x]["URL_IMG_PREVIA"], videos[x]["FECHAHORAREGISTRO"], videos[x]["URL_VIDEO"]),);
                    //}
                    fotoscategoria.add(ListaVH(videos[x]["IDSUBCATEGORIA"], videos[x]["URL_IMG_PREVIA"]),);
                  }else{
                    print("VACIA");
                    sublita.add(ListaVideos("0","-", "-", "-", "-"),);
                  }



                    print("REST: " + sublita.toString());
                }
              }else{
                if(videos[x]["IDCATEGORIA"] == "7"){
                  sublita.add(ListaVideos(videos[x]["IDSUBCATEGORIA"],videos[x]["TITULO"], videos[x]["URL_IMG_PREVIA"], videos[x]["FECHAHORAREGISTRO"], videos[x]["URL_VIDEO"]),);
                }
              }
            }
        sublita.removeWhere((item) => item.IDSUBCATEGORIA == "0");
        print("REST: "+extraerData.toString());
        pageController = PageController(initialPage: currentIndex);

      });

    }

  }
  /*Future<void> MostrarFotos(String id) async{
    prueba.clear();
    if(mounted){
        for(int i = 0; i<fotoscategoria.length; i++){
          if(fotoscategoria[i].IDSUBCATEGORIA == id){
            prueba.add({"FOTOS": fotoscategoria[i].URL_FOTO});
          }
        }
    }
  }*/

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
    getVideosacp("8");

  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(widget.titulo!, style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),

      body:  Container(
        padding: const EdgeInsets.only(top: 20),
    child: Column(children: [
      Container(width:size.width,child: Text("VIDEOS - ACP", textAlign: TextAlign.center,style: TextStyle(fontFamily: "Schyler", color: Colors.black, fontSize: 20),)),
      SizedBox(height: 10,),
      Container(padding: EdgeInsets.symmetric(horizontal: 20),width:size.width,child: Text("Esta sección retrata nuestra verdadera pasión. ¡Descúbrela aquí!", textAlign: TextAlign.center,style: TextStyle(fontFamily: "Schyler", color: Colors.black, fontSize: 14),)),

      Container(width: size.width/1.1,child: Center( child:SingleChildScrollView( scrollDirection: Axis.horizontal, child:ToggleButtons(isSelected: isSelected,renderBorder: true,borderRadius: BorderRadius.all(Radius.circular(15)),borderWidth: 0,disabledBorderColor: Colors.white,borderColor: Colors.white,
      selectedColor: Colors.white,textStyle: TextStyle(fontWeight: FontWeight.bold),color: Colors.black,fillColor: kPrimaryColor,children:[

          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("EVENTOS", textAlign: TextAlign.center,style: TextStyle(fontFamily: "Schyler", fontSize: 12),)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("INSTITUCIONAL", textAlign: TextAlign.center,style: TextStyle(fontFamily: "Schyler", fontSize: 12),)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("COMUNIDAD", textAlign: TextAlign.center,style: TextStyle(fontFamily: "Schyler", fontSize: 12),)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("TESTIMONIOS", textAlign: TextAlign.center,style: TextStyle(fontFamily: "Schyler", fontSize: 12),))
        ],
        onPressed: (int newIndex){
        setState((){
          for(int index = 0; index < isSelected.length; index++){
            if(index == newIndex){
              isSelected[index] = true;
              String? menus;
               if(index == 0){
                menus = "8";
              }else if(index == 1){
                menus = "9";
              }else if(index == 2){
                menus = "10";
              }else if(index == 3){
                menus = "11";
              }
              print("MENU: "+menus.toString());
              getVideosacp(menus!);
              print("REST: "+sublita.toString());
            }else{
              isSelected[index] = false;
            }
          }
        });
        }
        ,))),),
      galeriaF.isEmpty ? Container(width:size.width, height: size.height/1.4, child: Center(child: CircularProgressIndicator())): Container( width:size.width, height: size.height/1.4,child:
      ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: sublita.length,
          itemBuilder: (BuildContext context, int index) {
            return sublita.isNotEmpty ? Container(
                    height: size.height/2.6,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(10.0)), color: Colors.white, boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

                    ]),
                    child: Column(children: [
                      Row(
                          children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: CircleAvatar(
                            backgroundColor: const Color(0XFF00AB74),
                            child: ClipOval(
                              child: Image.asset("assets/images/"+ (empresaUsuario! == "ACP" ? "acp_002_512" : empresaUsuario! == "ICP" ? "icp_002_256" : empresaUsuario! == "CPC" ? "cpc_002_256" : "qali_002_256")+".png",)
                            ),
                          ),
                        ),
                        Container(
                          width: size.width/1.7,
                            padding: EdgeInsets.only(top:5),
                            child:
                        Column(children:[
                          SizedBox(height: 5,),
                          Container(
                              width: size.width/1.7,
                              child: Text(
                                  sublita[index].SUBCATEGORIA.toString(),
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(color: Colors.grey,  fontFamily: "Schyler", fontSize: 14))),
                          SizedBox(height: 5,),
                          Container(
                              width: size.width/1.7,
                              child: Text("Publicado el "+sublita[index].FECHAHORAREGISTRO.toString().substring(0,10),
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(color: Colors.black, fontFamily: "Schyler", fontSize: 12)))

                        ]))

                      ]),
                      SizedBox(height: 10,),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        width: size.width,
                        height: size.height/3.5,
                          decoration:  BoxDecoration(borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight:Radius.circular(10.0) ),),
                        child: Stack(alignment: Alignment.topRight,
                        children: <Widget>[
                          GestureDetector(
                              onTap: (){
                                print("VIDEOS: "+sublita[index].URL_VIDEO.toString().substring(33));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  GaleriaVideos(video: sublita[index].URL_VIDEO.toString().substring(33))));
                              },
                          child:Container(
                              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), image:  DecorationImage(
                                image: NetworkImage(sublita[index].URL_FOTO.toString()),
                                fit: BoxFit.cover,
                              ), boxShadow: [
                                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

                              ]),
                              child: Column(children:[
                                Align(alignment: Alignment.center, child:Container(
                                  width: size.width,
                                  height: size.height/3.5,
                                  decoration: const BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),),
                                  padding: const EdgeInsets.only(top:5, bottom: 5, left: 2 ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                            child: Center(child: Image.asset("assets/images/boton-de-play.png"),)),


                                    ],
                                  ),

                                ))
                              ])))
                          //VideoPlayerView(url: sublita[index].URL_VIDEO.toString(),dataSourceType: DataSourceType.network, tumbnails: sublita[index].URL_FOTO,)
                          ]),
                      ),
                    ],)


                ): Center(child: Container(
              height: size.height/3,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), image: const DecorationImage(
                image: AssetImage("assets/images/9826-simple-loader.gif"),
                fit: BoxFit.cover,
              ), boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

              ]),),);}
      )),
    ],) ),);
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
                height: size.height/3.5,
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