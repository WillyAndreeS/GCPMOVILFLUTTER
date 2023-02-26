import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/noticias_detalle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';



class Noticias extends StatefulWidget {

  Noticias({Key? key}) ;

  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  late Size size;
  List sublita = [];
  bool hasInternet = false;
  int inee = 0;
  late int currentIndex = 0;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  late PageController pageController;
  ConnectivityResult result = ConnectivityResult.none;
  List<bool>isSelected = [true, false, false, false];

  Future<void> getNoticiasacp(String menu) async{

    sublita.clear();
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var response = await http.post(
          Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
          body: {"accion": "getComunidados", "TIPO": "N"});
      // if (mounted) {
      setState(() {
        var extraerData = json.decode(response.body);
        sublita = extraerData["resultado"];
        print("REST: "+sublita.toString());
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
    getNoticiasacp("6");

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

      body:  Container(
        height: size.height,
        padding: const EdgeInsets.only(top: 20),
    child: Column(children: [
      sublita.isEmpty ? Container(width:size.width, height: size.height * 0.9, child: Center(child: CircularProgressIndicator())): Container( width:size.width, height: size.height*0.76,child:
      ListView.builder(
          //padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: sublita.length,
          itemBuilder: (BuildContext context, int index) {
            return sublita.isNotEmpty ? GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  NoticiasDetalle(titulo: sublita[index]["TITULO"],descripcion: sublita[index]["DESCRIPCION"],urlimagen: sublita[index]["URL_IMG_PREVIA"],fecha: sublita[index]["FECHAREGISTRO"])));
              },
                child: Container(
                    height: size.height/2.1,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(10.0)), color: Colors.white, boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

                    ]),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [

                      Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  sublita[index]["TITULO"].toString(),
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(color: Colors.black,  fontFamily: "Schyler", fontSize: 14))),
                          SizedBox(height: 5,),
                          Container(
                              width: size.width/1.7,
                              child: Text("Publicado el "+sublita[index]["FECHAREGISTRO"].toString().substring(0,10),
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(color: Colors.grey, fontFamily: "Schyler", fontSize: 12)))

                        ]))

                      ]),
                      SizedBox(height: 10,),
                      CachedNetworkImage(imageUrl: sublita[index]["URL_IMG_PREVIA"].toString(), imageBuilder: (context, imageProvider) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: size.width,
                        height: size.height/3.5,
                        decoration:  BoxDecoration(borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight:Radius.circular(10.0) ),),
                        child: Stack(alignment: Alignment.topRight,
                            children: <Widget>[
                              Container(
                                decoration:  BoxDecoration(borderRadius:  BorderRadius.only(topLeft: Radius.circular(70.0), bottomRight:Radius.circular(70.0) ),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),),
                              ),
                            ]),
                      ),placeholder: (context, url) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: size.width,
                        height: size.height/3.5,
                        decoration:  BoxDecoration(borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight:Radius.circular(10.0) ),),
                        child: Stack(alignment: Alignment.topRight,
                            children: <Widget>[
                              Container(
                                decoration:  BoxDecoration(borderRadius:  BorderRadius.only(topLeft: Radius.circular(70.0), bottomRight:Radius.circular(70.0) ),
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/122840-image.gif"),
                                    fit: BoxFit.cover,
                                  ),),
                              ),
                            ]),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),),

                      SizedBox(height: 10,),
                      Container(
                          width: size.width/1.2,
                          child: Text(
                              sublita[index]["DESCRIPCION"].toString() == null || sublita[index]["DESCRIPCION"].toString() == "" ? "" : sublita[index]["DESCRIPCION"].toString().substring(0,100)+"...",
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              style: const TextStyle(color: Colors.black,  fontFamily: "Schyler", fontSize: 12))),
                      Container(
                          width: size.width/1.2,
                          child: Text(
                              "Ver más.",
                              maxLines: 2,
                              textAlign: TextAlign.right,
                              style: const TextStyle(color: kPrimaryColor,  fontFamily: "Schyler", fontSize: 12))),
                      SizedBox(height: 5,),
                    ],)


                )): Center(child: Container(
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