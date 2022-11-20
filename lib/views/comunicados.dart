import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:acpmovil/views/directorio.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:acpmovil/constants.dart';
import 'package:http/http.dart' as http;
import 'package:acpmovil/views/screen_gcpmundo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';



class Comunicado extends StatefulWidget {
  Comunicado({Key? key}) ;

  @override
  _ComunicadoState createState() => _ComunicadoState();
}

class _ComunicadoState extends State<Comunicado> {
  String nombre = "USER";
  String dni = "00000000";
  late Size size;
  Timer? _timer;
  bool fullsize = false;
  List comunicados = [];
  int indice = 0;
  List<LatLng> polylineareaEmpresa = [];
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;

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
    RecibirDatos();
    //_showDialog();

  }

  Future<String?> RecibirDatos() async {

    comunicados.clear();
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var response = await http.post(
          Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
          body: {"accion": "getComunidados", "TIPO": "C"});
      // if (mounted) {
      setState(() {
        var extraerData = json.decode(response.body);
        comunicados = extraerData["resultado"];
        print("REST: "+comunicados.toString());
      });

    }
  }
  void openGallery(List<String> urlImages,String descripcion) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => GalleryWidget(
    urlImagenes: urlImages, descripcion: descripcion,
  )));

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text("Comunicados", style: TextStyle(fontFamily: "Schyler"),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop (context, false);
            },
          ),

        ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/images/background_gcp.png",),
          fit: BoxFit.cover,
        ),
    ),
    child: comunicados.isEmpty ? Center(child: CircularProgressIndicator()): Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.7)
        ),
        child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
    itemCount: comunicados.length,
    itemBuilder: (BuildContext context, int index) {
      return GestureDetector(
          onTap: ()async {
            final urlImages = [
              comunicados[index]["URL_IMG_PREVIA"].toString()
            ];

            openGallery(urlImages, comunicados[index]["DESCRIPCION"]);
          },
          child: Container(
        height: indice==index ? fullsize == true ? size.height/6.5 : size.height/7 : size.height/7 ,
        width: fullsize == true ? size.width : size.width,
        margin: EdgeInsets.symmetric(horizontal: indice==index ? fullsize == true ? 10 : 20: 20, vertical: 15),
        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

        ]),
        child: Row(children: [
          Align(alignment: Alignment.topCenter, child:Container(
            width: fullsize == true ? size.width/2.5 : size.width/2.5,
            decoration:  BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)), color:const Color(0xFF0000000).withOpacity(0),),
            padding: const EdgeInsets.only(top:5, bottom: 5 ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                    comunicados[index]["TITULO"],
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black, fontFamily: "Schyler", fontSize: 13))),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text("Fecha: "+
                        comunicados[index]["FECHAREGISTRO"].toString().substring(0,10),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black, fontFamily: "Schyler", fontSize: 10)))
              ],
            ),

          ),),
          Align(alignment: Alignment.topCenter, child: hasInternets || hasInternet ?CachedNetworkImage(
            imageUrl: comunicados[index]["URL_IMG_PREVIA"],
            imageBuilder: (context, imageProvider) =>Container(
            width: size.width / 2.21,
            decoration:  BoxDecoration( color:const Color(0xFF0000000).withOpacity(0),image: DecorationImage(
              image:  imageProvider, fit: BoxFit.fitWidth, ),),


          ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ): CircularProgressIndicator()),

        ],)
      ));}
    ))),);
    }
  }

class GalleryWidget extends StatefulWidget{
  final List<String> urlImagenes;
  final String descripcion;

  GalleryWidget({
    required this.urlImagenes, required this.descripcion
  });

  @override
  State<StatefulWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget>{
  @override
  Widget build(BuildContext context) => Scaffold(
      body: PhotoViewGallery.builder(itemCount: widget.urlImagenes.length, builder: (context, index){
        final urlImage  = widget.urlImagenes[index];
        return PhotoViewGalleryPageOptions(imageProvider: NetworkImage(urlImage),
        heroAttributes: PhotoViewHeroAttributes(tag: widget.descripcion));
      })
  );
}