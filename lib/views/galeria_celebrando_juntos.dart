import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class ListaGalerias {
  String? IDSUBCATEGORIA,SUBCATEGORIA, URL_FOTO,FECHAHORAREGISTRO;
  ListaGalerias(this.IDSUBCATEGORIA, this.SUBCATEGORIA, this.URL_FOTO, this.FECHAHORAREGISTRO);
}

class ListaFotos {
  String? IDSUBCATEGORIA, URL_FOTO;

  ListaFotos(this.IDSUBCATEGORIA, this.URL_FOTO);
}

class GaleriaCelebrando extends StatefulWidget {
  String? titulo;
  GaleriaCelebrando({Key? key, this.titulo}) ;

  @override
  _GaleriaCelebrandoState createState() => _GaleriaCelebrandoState();
}

class _GaleriaCelebrandoState extends State<GaleriaCelebrando> {
  late Size size;
  List galeriaF = [];
  List arandanoF = [];
  List fotos = [];
  List <ListaFotos> fotoscategoria = [];
  List prueba = [];
  List categorias_sub = [];
  List<ListaGalerias>sublita = [];
  bool hasInternet = false;
  int inee = 0;
  late int currentIndex = 0;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  late PageController pageController;
  ConnectivityResult result = ConnectivityResult.none;
  List<bool>isSelected = [true, false, false, false];
  static final String getToken = 'Bearer ${ttok1}.${ttok2}.${ttok3}';

  Future<void> getGaleriaacp(String menu) async{

    galeriaF.clear();
    arandanoF.clear();
    fotos.clear();
    categorias_sub.clear();
    sublita.clear();
    fotoscategoria.clear();
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var response = await http.post(
          Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
          body: {"accion": "getdatos_fotos"}, headers: {HttpHeaders.authorizationHeader: getToken});
      // if (mounted) {
      setState(() {
        var extraerData = json.decode(response.body);
        galeriaF = extraerData["categorias"];
        fotos = extraerData["fotos"];
        categorias_sub = extraerData["categorias_sub"];
            for(int x = 0; x<fotos.length; x++){
              if(fotos[x]["IDCATEGORIA"] != "1") {
                if (fotos[x]["IDCATEGORIA"] == menu) {
                  if(sublita.isNotEmpty){
                    print("NO VACIA");
                    int existe = sublita.indexWhere((item) => item.IDSUBCATEGORIA == fotos[x]["IDSUBCATEGORIA"]);
                    if( existe == -1){
                      sublita.add(ListaGalerias(fotos[x]["IDSUBCATEGORIA"],fotos[x]["SUBCATEGORIA"], fotos[x]["URL_FOTO"], fotos[x]["FECHAHORAREGISTRO"]),);
                    }
                    fotoscategoria.add(ListaFotos(fotos[x]["IDSUBCATEGORIA"], fotos[x]["URL_FOTO"]),);
                  }else{
                    print("VACIA");
                    sublita.add(ListaGalerias("0","-", "-", "-"),);
                  }



                    print("REST: " + sublita.toString());
                }
              }else{
                if(fotos[x]["IDCATEGORIA"] == "1"){
                  sublita.add(
                    ListaGalerias(fotos[x]["IDSUBCATEGORIA"],fotos[x]["SUBCATEGORIA"], fotos[x]["URL_FOTO"], fotos[x]["FECHAHORAREGISTRO"]),
                  );
                }
              }
            }
        sublita.removeWhere((item) => item.IDSUBCATEGORIA == "0");
        print("REST: "+extraerData.toString());
        pageController = PageController(initialPage: currentIndex);

      });

    }

  }
  Future<void> MostrarFotos(String id) async{
    prueba.clear();
    if(mounted){
        for(int i = 0; i<fotoscategoria.length; i++){
          if(fotoscategoria[i].IDSUBCATEGORIA == id){
            prueba.add({"FOTOS": fotoscategoria[i].URL_FOTO});
          }
        }
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
    getGaleriaacp("6");

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
      Container(width:size.width,child: Text("¡CONÓCENOS!", textAlign: TextAlign.center,style: TextStyle(fontFamily: "Schyler", color: Colors.black, fontSize: 20),)),
      SizedBox(height: 10,),
      Container(padding: EdgeInsets.symmetric(horizontal: 20),width:size.width,child: Text("Esta sección retrata nuestra verdadera pasión. ¡Descúbrela aquí!", textAlign: TextAlign.center,style: TextStyle(fontFamily: "Schyler", color: Colors.black, fontSize: 14),)),

      Container(width: size.width/1.1,child: Center( child:ToggleButtons(isSelected: isSelected,renderBorder: true,borderRadius: BorderRadius.all(Radius.circular(15)),borderWidth: 0,disabledBorderColor: Colors.white,borderColor: Colors.white,
      selectedColor: Colors.white,textStyle: TextStyle(fontWeight: FontWeight.bold),color: Colors.black,fillColor: kPrimaryColor,children:[
        Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0))),child:Text("EVENTOS", textAlign: TextAlign.center,style: TextStyle(fontFamily: "Schyler", fontSize: 12),))),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("PALTA", textAlign: TextAlign.center,style: TextStyle(fontFamily: "Schyler", fontSize: 12),)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("ARANDANO", textAlign: TextAlign.center,style: TextStyle(fontFamily: "Schyler", fontSize: 12),)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("ESPARRAGO", textAlign: TextAlign.center,style: TextStyle(fontFamily: "Schyler", fontSize: 12),))
        ],
        onPressed: (int newIndex){
        setState((){
          for(int index = 0; index < isSelected.length; index++){
            if(index == newIndex){
              isSelected[index] = true;
              String? menus;
              if(index == 0){
                menus = "6";
              }else if(index == 1){
                menus = "3";
              }else if(index == 2){
                menus = "2";
              }else if(index == 3){
                menus = "4";
              }
              print("MENU: "+menus.toString());
              getGaleriaacp(menus!);
              print("REST: "+sublita.toString());
            }else{
              isSelected[index] = false;
            }
          }
        });
        }
        ,)),),
      galeriaF.isEmpty ? Container(width:size.width, height: size.height/1.4, child: Center(child: CircularProgressIndicator())): Container( width:size.width, height: size.height/1.4,child:
      ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: sublita.length,
          itemBuilder: (BuildContext context, int index) {
            return sublita.isNotEmpty ? Container(
                    height: size.height/2.5,
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
                          PhotoViewGallery.builder(
                          scrollPhysics: const BouncingScrollPhysics(),
                          builder: (BuildContext context, int inde) {
                            MostrarFotos(sublita[index].IDSUBCATEGORIA.toString());
                            inee = inde;
                            print("PRUEBA2: "+prueba.length.toString());
                            return PhotoViewGalleryPageOptions(
                              imageProvider: NetworkImage(prueba[inde]["FOTOS"].toString()),
                              initialScale: PhotoViewComputedScale.covered,
                              heroAttributes: PhotoViewHeroAttributes(tag: fotoscategoria[inde].IDSUBCATEGORIA.toString()+""+inde.toString()),
                            );
                          },
                          itemCount: fotoscategoria.where((item) => item.IDSUBCATEGORIA == sublita[index].IDSUBCATEGORIA).length,
                          loadingBuilder: (context, event) => Center(
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          backgroundDecoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15.0)),),
                          pageController: pageController,
                          onPageChanged: onPageChanged,

                        ),
                          Container(
                            margin:EdgeInsets.only(top: 10, right: 10),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.4),borderRadius: BorderRadius.all(Radius.circular(25.0)),),
                            child: Text(
                              "${currentIndex + 1}/"+fotoscategoria.where((item) => item.IDSUBCATEGORIA == sublita[index].IDSUBCATEGORIA).length.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                decoration: null,
                              ),
                            ),
                          )]),
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