import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/buscarOpcion.dart';
import 'package:acpmovil/views/estructura_corporativa.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:acpmovil/views/certificacionespage.dart';
import 'package:acpmovil/views/culturapage.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:acpmovil/views/galeria.dart';
import 'package:acpmovil/views/galeriaBar.dart';
import 'package:acpmovil/views/gcpgps.dart';
import 'package:acpmovil/views/organigrama.dart';
import 'package:acpmovil/views/page2.dart';
import 'package:acpmovil/views/presentaciones.dart';
import 'package:acpmovil/views/principalpage.dart';
import 'package:acpmovil/views/programas_capacitaciones.dart';
import 'package:acpmovil/views/quejasreclamos.dart';
import 'package:acpmovil/views/radio_web.dart';
import 'package:acpmovil/views/radio_webBar.dart';
import 'package:acpmovil/views/screen_contactanos.dart';
import 'package:acpmovil/views/screen_gcpmundo.dart';
import 'package:acpmovil/views/screen_linea_emergencia.dart';
import 'package:acpmovil/views/screen_nuestros_productos_v2.dart';
import 'package:acpmovil/views/screen_revistas_boletines.dart';
import 'package:acpmovil/views/somosacp2.dart';
import 'package:acpmovil/views/utilidades.dart';
import 'package:acpmovil/views/vista_panoramica_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class ListaInterfaz {
  String? idinterfaz, color,imagen,icono, titulo ;

  ListaInterfaz(this.idinterfaz, this.titulo, this.color, this.imagen, this.icono);
}

class GrupoACP extends StatefulWidget {
  GrupoACP({Key? key}) ;

  @override
  _GrupoACPState createState() => _GrupoACPState();
}

class _GrupoACPState extends State<GrupoACP> {
  late Size size;
  List grupoacpF = [];
  List visitasF = [];
  List visitasF2 = [];
  String? IDCEL;
  bool hasInternet = false;
  int _current = 0;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;
  final myControllerSearch = TextEditingController();
  late FocusNode focusUser;




  Future<void> getSomosgcp() async{

    var gcp = FirebaseFirestore.instance.collection("menu_somosgcp").orderBy("id");
    QuerySnapshot menugcp = await gcp.get();
setState((){
  if(menugcp.docs.isNotEmpty){
    for(var doc in menugcp.docs){
      print("DATOS: "+doc.id.toString());
      grupoacpF.add(doc.data());
    }
    print("TITULO: "+grupoacpF[0]["titulo"]);

    }
  });


  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      IDCEL = iosDeviceInfo.identifierForVendor.toString();
      print("IDCEL: "+IDCEL.toString());
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      IDCEL = androidDeviceInfo.androidId.toString();
      print("IDCEL: "+IDCEL.toString());
      return androidDeviceInfo.androidId; // unique ID on Android

    }
  }

  Future<void> getVisitas() async{
    await _getId();
    visitasF.clear();
    if(tipoUsuario.toString().toUpperCase() == "INVITADO"){
      var gcp = FirebaseFirestore.instance.collection("visitas").where("idusuario", isEqualTo: IDCEL).orderBy("fecha", descending: true).limit(5);
      QuerySnapshot visitasgcp = await gcp.get();
      setState((){
        if(visitasgcp.docs.isNotEmpty){
          for(var doc in visitasgcp.docs) {
            print("DATOS: " + doc.id.toString());
            visitasF.add(doc.data());

          }

          for(int x = 0; x<visitasF.length; x++){
            if(visitasF2.isNotEmpty){
              int existe = visitasF2.indexWhere((item) =>
              item.idinterfaz == visitasF[x]["idinterfaz"]);
              if (existe == -1) {
                visitasF2.add(ListaInterfaz(visitasF[x]["idinterfaz"],visitasF[x]["titulo"], visitasF[x]["color"], visitasF[x]["imagen"],visitasF[x]["icono"]),);
                print("INTERFAZ: " + visitasF2[0].idinterfaz);

              }
            }else{
              visitasF2.add(ListaInterfaz("0","-", "-", "-","-"),);
              print("VACIA");

            }


          }
          print("LISTA FINAL"+visitasF2.length.toString());
          visitasF2.removeWhere((item) => item.idinterfaz == "0");
          print("LISTA FINAL"+visitasF2.length.toString());
        }else{
          print("INTERFAZ: vacio");
        }
      });
    }else{
      var gcp = FirebaseFirestore.instance.collection("visitas").where("idusuario", isEqualTo: dniUsuario).limit(5).orderBy("fecha");
      QuerySnapshot visitasgcp = await gcp.get();
      setState((){
        if(visitasgcp.docs.isNotEmpty){
          for(var doc in visitasgcp.docs){
            print("DATOS: "+doc.id.toString());
            visitasF.add(doc.data());
          }
         // print("TITULO: "+visitasF[0]["titulo"]);
          for(int x = 0; x<visitasF.length; x++){
            if(visitasF2.isNotEmpty){
              int existe = visitasF2.indexWhere((item) =>
              item.idinterfaz == visitasF[x]["idinterfaz"]);
              if (existe == -1) {
                visitasF2.add(ListaInterfaz(visitasF[x]["idinterfaz"],visitasF[x]["titulo"], visitasF[x]["color"], visitasF[x]["imagen"],visitasF[x]["icono"]),);
                print("INTERFAZ: " + visitasF2[0].idinterfaz);

              }
            }else{
              visitasF2.add(ListaInterfaz("0","-", "-", "-","-"),);
              print("VACIA");

            }


          }
          print("LISTA FINAL"+visitasF2.length.toString());
          visitasF2.removeWhere((item) => item.idinterfaz == "0");
          print("LISTA FINAL"+visitasF2.length.toString());

        }
      });
    }
    


  }

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
    focusUser = FocusNode();
  //  myControllerSearch.addListener(_printLatestValue);

    getSomosgcp();
    getVisitas();
    if(tipoUsuario != "invitado"){
      DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('MMdd');
      final String formatted = formatter.format(now);
      final String formatted2;
      if(fnacimiento!.length > 4){
        formatted2 = formatter.format(DateTime.parse(fnacimiento.toString()));
      }else{
        formatted2 = fnacimiento.toString();
      }

      print("NOW: "+formatted+" -NOW2: "+formatted2.toString());
      if(formatted2 == formatted){
        WidgetsBinding.instance
            .addPostFrameCallback((_) => showDialog(
            context: context,
            builder: (context) =>
            const CustomDialogsAlertCumple()));
      }

    }

  }

  @override
  void dispose() {
    focusUser.dispose();
    myControllerSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SlidingUpPanel( body: Scaffold(

      body: Container(
        width: size.width,
        height: size.height,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  BuscarOpcion()));
                },
                  child: Container( margin: EdgeInsets.only(top: 20, left: 20),child:
            Container(
              width:
              MediaQuery.of(context).size.width / 1.8,
              //height: 50.0,
              padding: const EdgeInsets.only(
                  top: 0.0,
                  bottom: 0.0,
                  left: 16.0,
                  right: 16.0),
              decoration: const BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(16)),
                  color: Color(0xFFFFFFFF),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0)
                  ]),
              child: TextField(
                //focusNode: focusUser,
                enabled: false,
                //autofocus: true,
                controller: myControllerSearch,
                cursorColor: const Color(0xFFC41A3B),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    border: InputBorder.none,
                    hintText: 'Buscar',
                    hintStyle: TextStyle(
                        fontStyle: FontStyle.normal,
                        color: Colors.black45,
                        fontSize: 15)),
              ),
            ),)),
              Container(margin: EdgeInsets.only(right: 20, top: 20),child: Row(children: [
               tipoUsuario =="gerente"? IconButton(onPressed: (){
                  showDialog(
                      context: context,
                      builder: (context) =>
                      const CustomDialogsAlertIni(
                      ));
                }, icon: Icon(Icons.notifications, color: Colors.black,)): Container(),
                CircleAvatar(
                  backgroundColor: const Color(0XFF00AB74),
                  child: ClipOval(
                    child: tipoUsuario == "gerente" ? CachedNetworkImage(
                      imageUrl:'http://web.acpagro.com/app-gcp/index.php/Imagenfacial/examinarFotoAcpLocation/$dniUsuario',placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ):CachedNetworkImage(
                      imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/ic_colaborador_sf_holder_pg.png?alt=media&token=751befa6-3774-4fae-a937-4e1ecff16d13',placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],),)



          ],),
          Container(
            width: size.width,
            margin: EdgeInsets.only(top: 25,left: 30),
            child: Text("Recientes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: "Schyler"),textAlign: TextAlign.left,),
          ),
          Container(
            width: size.width,
            margin: EdgeInsets.only(left: 30, top: 5),
            child: Text("Últimas secciones visitadas", style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: "Schyler"),textAlign: TextAlign.left,),
          ),
          Container(
            height: size.height/3,
            margin: EdgeInsets.only(left: size.width/6, top: 10),
            child:  Row(children: [
              Container(
                  height: size.height/3,
                  width: size.width/1.22,
                  child: visitasF2.isNotEmpty ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: visitasF2.length,
              itemBuilder: (BuildContext context, int index) {
              return GestureDetector( onTap: (){
                if(visitasF2[index].idinterfaz == "Agricola Cerro Prieto"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  Somosacp(menu:1)));
                }else if(visitasF2[index].idinterfaz == "Contactos de Emergencia"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  LineaEmergencia()));
                }else if(visitasF2[index].idinterfaz == "Galería"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  GaleriaBar()));
                }else if(visitasF2[index].idinterfaz == "GPS GCP"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  GCP_GPS()));
                }else if(visitasF2[index].idinterfaz == "GCP Mundo"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  RevistasBoletines(menu:1)));
                }else if(visitasF2[index].idinterfaz == "Sintoniza Radio Cerro Prieto"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  RadioWebBar()));
                }
              }, child: Container(
                height: size.height/1.5,
                child:
              Stack( children: [
                Container(
                  margin: EdgeInsets.only(left: size.width*0.05, top: 35),
                  height: size.height/4,
                  width: size.width/2,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Color(int.parse(visitasF2[index].color)), boxShadow: [
                    BoxShadow(color:Color(int.parse(visitasF2[index].color)).withOpacity(0.5), blurRadius: 10, offset: const Offset(-5,10)),

                  ]),
                  child: Column( children: [
                    Row( children: [
                    Container(padding: EdgeInsets.only(left: 20, top: 40),child: Image.asset("assets/images/logoacp.png", width: 20,),),
                    Container(width: size.width/3,padding: EdgeInsets.only( left: 5, top: 40), child: Text("GCP MÓVIL", style: TextStyle(fontSize: 11, color: Colors.white, fontFamily: "Schyler"),),),
                    ]),
                    Container(width: size.width/3,padding: EdgeInsets.only( left: 5, top: 5), child: Text(visitasF2[index].idinterfaz, style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler"),),),
                    Container(width: size.width/3,padding: EdgeInsets.only( left: 5, top: 5), child: Image.network(visitasF2[index].imagen, height: size.height*0.11,),),
                  ])
                ),

                Positioned(
                  top: 8,
                    right: size.width * 0.10,
                    child: Container(padding:EdgeInsets.all(10),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 5, offset: const Offset(-5,0)),]),
                        child:Image.network(visitasF2[index].icono, color: Colors.black, width: 35,)))
              ],),));}): Container(
                height: size.height/1.5,
                child:
                Stack( children: [
                  Container(
                      margin: EdgeInsets.only(top: 35),
                      height: size.height/4,
                      width: size.width/1.5,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.grey, boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(-5,10)),

                      ]),
                      child: Column( children: [
                        Row( children: [
                          Container(padding: EdgeInsets.only(left: 20, top: 40),child: Image.asset("assets/images/logoacp.png", width: 20,),),
                          Container(width: size.width/3,padding: EdgeInsets.only( left: 5, top: 40), child: Text("GCP MÓVIL", style: TextStyle(fontSize: 11, color: Colors.white, fontFamily: "Schyler"),),),
                        ]),
                        Container(width: size.width/2,padding: EdgeInsets.only( left: 5, top: 5), child: Text("EXPLORA Y CONOCE MÁS SOBRE EL GRUPO CERRO PRIETO", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler"),),),
                        Container(width: size.width/3,padding: EdgeInsets.only( left: 5, top: 5), child: Image.asset("assets/images/explorador.png", height: size.height*0.09,),),
                      ])
                  ),

                  Positioned(
                      top: 8,
                      right: size.width * 0.10,
                      child: Container(padding:EdgeInsets.all(10),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 5, offset: const Offset(-5,0)),]),
                          child:Image.network("https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/historialp.png?alt=media&token=1aaffaad-10a6-426c-bdd5-69a5513f7d44", color: Colors.black, width: 35,)))
                ],),))

              

            ],),
          ),
          visitasF2.isNotEmpty ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: visitasF2.map((item) {
              int index = visitasF2.indexOf(item);
              return Container(
                width: 8.0,
                height: 8.0,
                margin:
                const EdgeInsets.symmetric( horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index ? Colors.black : Colors.grey,
                ),
              );
            }).toList(),
          ): Container(),
          Container(
            width: size.width,
            margin: EdgeInsets.only(top: 10,left: 30),
            child: Text("Conócenos", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: "Schyler"),textAlign: TextAlign.left,),
          ),
          Container(
            height: size.height/6,
            margin: EdgeInsets.only(left: 20),
            child: grupoacpF.isEmpty? Center(child: CircularProgressIndicator(),): ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: grupoacpF.length,
              itemBuilder: (BuildContext context, int index) {
              return Row(children: [
                GestureDetector(
                  onTap:(){
                    if(grupoacpF[index]["id"] == 3){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  CulturaPage()));
                    }else if(grupoacpF[index]["id"] == 2){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  OrgranigramaPage()));
                    }else if(grupoacpF[index]["id"] == 4){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  CertificacionesPage()));
                    }else if(grupoacpF[index]["id"] == 5){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  Presentaciones()));
                    }else if(grupoacpF[index]["id"] == 1){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  EstructuraCorpPage()));
                    }

              },
                  child:Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: size.height/1.5,
                  child:
                    Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        height: size.height/3,
                        width: size.width/1.5,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Color(int.parse(grupoacpF[index]["color"])), boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, offset: const Offset(-3,3)),

                        ]),
                        child: Row( children: [
                          Container(width: size.width/3 ,padding: EdgeInsets.only( left: 30, top: 5), child: Text(grupoacpF[index]["titulo"], style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler"),),),
                        CachedNetworkImage(imageUrl: grupoacpF[index]["icono"], imageBuilder: (context, imageProvider) =>Container(width: size.width/4.5, height: size.height*0.10 ,padding: EdgeInsets.only( left: 5, top: 5), margin:EdgeInsets.only(left: 15, top: 10),decoration: BoxDecoration( image:  DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),)),placeholder: (context, url) =>Container(width: size.width/4.5, height: size.height*0.10 ,padding: EdgeInsets.only( left: 5, top: 5), margin:EdgeInsets.only(left: 15, top: 10),decoration: const BoxDecoration( image:  DecorationImage(
                          image: AssetImage("assets/images/122840-image.gif"),
                          fit: BoxFit.fill,
                        ),))
                          ,),
                        ])
                    ),),),

              ],);},),
          ),
        ],)
      ),),
      panelBuilder: (controller) => PanelWidget(controller: controller),
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    );
    }


  }

class PanelWidget extends StatefulWidget {
  final ScrollController? controller;
  PanelWidget({Key? key,this.controller});

  @override
  _PanelWidgetState createState() => _PanelWidgetState();

}

class _PanelWidgetState extends State<PanelWidget> {


  String currentsong = "";
  String imageStream = "assets/images/playradio.png";

  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      if(mounted){
        setState((){
          isPlaying = state == PlayerState.PLAYING;
          if(isPlaying){
            imageStream = "assets/images/pausa.png";
          }
        });
      }

    });
  }


  @override

  Widget build(BuildContext context) =>

      Material(
          child: Container(height: MediaQuery.of(context).size.height * 0.10,
              decoration: BoxDecoration(color: Colors.white,),
              child: Container(
                decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0)),
                    ), child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20,),
                  Center(child:
                  Container(
                    width: 32,
                    height: 8,
                    decoration: BoxDecoration(color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.02,
                    margin: EdgeInsets.only(top: 15, left: 30),

                    child: Text("Sintoniza Radio Cerro Prieto", style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: "Schyler"), textAlign: TextAlign.left,),
                  ),
                  Divider(),
                  SizedBox(height: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.43,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        Center( child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.22,
                          decoration:  const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/rcp.png"),
                                fit: BoxFit.fitWidth,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(16)),
                              color: Color(0xFFFFFFFF),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10.0)
                              ]),

                        )),
                        SizedBox(height: 20,),
                        GestureDetector( onTap:() async{
                         /* Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  RadioWebBar()));*/
                          //https://stream-57.zeno.fm/1p6rkv8szc9uv?zs=FJnBQ5fURICNVFMMSpq_kg
                          if(isPlaying){
                            imageStream = "assets/images/playradio.png";
                            await audioPlayer.pause();
                            setState((){
                              isPlaying = false;
                              print("isplaying"+isPlaying.toString());
                            });

                          }else{
                            String url = "https://stream-57.zeno.fm/1p6rkv8szc9uv?zs=FJnBQ5fURICNVFMMSpq_kg";
                            imageStream = "assets/images/pausa.png";
                            await audioPlayer.play(url);
                            setState((){
                              isPlaying = true;
                              print("isplaying"+isPlaying.toString());
                            });
                          }
                        },child: Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.1,margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Image.asset(imageStream),

                          ),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: Column(children: [
                        IconButton(icon: Icon(Icons.add_box,color: Colors.grey,size: 40,),
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (context) => const CustomDialogsAlertMultimedia(
                                  title: "Multimedia",
                                  description:
                                  "",
                                  imagen: "assets/images/multimedia.png",
                                ));
                          } ,),
                        Container(width: MediaQuery.of(context).size.width* 0.20, child: Text("Contenido multimedia.", style: TextStyle(fontSize: 12),textAlign: TextAlign.center,))
                      ],)
                    ),
                   /* Container(
                      margin: EdgeInsets.only(right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        IconButton(icon: Icon(Icons.list,color: Colors.grey,size: 40,),
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (context) => const CustomDialogsAlert(
                                  title: "Offline",
                                  description:
                                  "Aún no iniciamos la transmisión",
                                  imagen: "assets/images/mudo.png",
                                ));
                          } ,),
                        Container(width: MediaQuery.of(context).size.width* 0.20, child: Text("Chat en vivo.", style: TextStyle(fontSize: 12),textAlign: TextAlign.center,))
                      ],)
                    )*/
                  ],)
                  //      SizedBox(height: 20,),
             /*       GestureDetector( /*onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  RadioWeb()));
                    }, */child: Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.07,margin: EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(color: kPrimaryColor,  boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, offset: const Offset(-3,3)),

                        ]), child: Container(margin: EdgeInsets.symmetric(horizontal: 15), padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.white, child: Center( child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.control_camera),
                                  SizedBox(width: 10,),
                                  Text("Juegos", style: TextStyle(fontFamily: "Schyler", fontSize: 16, color: Colors.black),textAlign: TextAlign.center,)])),),)),
                        SizedBox(height: 20,),*/
                 /*  GestureDetector(onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  GaleriaBar()));
                    }, child: Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.07,margin: EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(color: kPrimaryColor,  boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, offset: const Offset(-3,3)),

                        ]), child: Container(margin: EdgeInsets.symmetric(horizontal: 15), padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.white, child: Center( child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                               Icon(Icons.photo),
                               SizedBox(width: 10,),
                               Text("Galería", style: TextStyle(fontFamily: "Schyler", fontSize: 16, color: Colors.black),textAlign: TextAlign.center,)])),),)),*/
                      ],),
                    ),
                  )
                ],
              ),))
      );
      /*aterial(
          child: Container(
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25))),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  ListView(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.only(top: 16),
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            "Datos generales", textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: "Schyler",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        color: Colors.white,

                        padding: EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),),
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            "Información extra", textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: "Schyler",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ),
                      SizedBox(height: 5,),


                    ],
                  )
                ],
              ))
      );*/




}

class CustomDialogsAlertIni extends StatefulWidget {


  const  CustomDialogsAlertIni(
      {Key? key})
      : super(key: key);

  @override
  _CustomDialogsAlertIniState createState() => _CustomDialogsAlertIniState();
}
class _CustomDialogsAlertIniState extends State<CustomDialogsAlertIni> {
  List comunicados = [];
  final List<String> imgListCom = [];
  int _currents = 0;
  @override
  void initState() {
    super.initState();
    RecibirDatos();
  }


  Future<String?> RecibirDatos() async {

    comunicados.clear();
    imgListFotos2.clear();
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var response = await http.post(
          Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
          body: {"accion": "getComunidados_inicio_empresa", "empresa": empresaUsuario});
      if (mounted) {
        setState(() {
          var extraerData = json.decode(response.body);
          comunicados = extraerData["resultado"];
          print("REST: " + comunicados.toString());
          for(int i = 0; i< comunicados.length; i++){
            print("IMG: "+comunicados.length.toString());
            imgListFotos2.add(comunicados[i]["URL_IMG_PREVIA"]);
          }
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      elevation: 0,
      backgroundColor: Colors.black.withOpacity(0.2),
      child: dialogContents(context),
    );
  }

  dialogContents(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[

        Container(
          padding: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
          margin: const EdgeInsets.only(top: 0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            shape: BoxShape.rectangle,),
          child: Container(height: size.height/1.8, child:Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                comunicados.isNotEmpty? //_getCarouselImagenes():Center(child: Container())
                GestureDetector(onTap: (){
                  final urlImages = [
                    comunicados[_currents]["URL_IMG_PREVIA"].toString()
                  ];
                  openGallery(urlImages, comunicados[_currents]["TITULO"]);
                }, child: Container( height: size.height/2.2,child: CarouselSlider(
                  items: imageSlidersFotos,
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      aspectRatio: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currents = index;
                        });
                      }),
                ))): Center(child: CircularProgressIndicator()),
                Container(padding: EdgeInsets.symmetric(vertical: 20),color: kPrimaryColor,child:
                Column(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imgListFotos2.map((url) {
                        int index = imgListFotos2.indexOf(url);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric( horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currents == index
                                ? Color.fromRGBO(255, 255, 255, 0.9)
                                : Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                        );
                      }).toList(),
                    ),
                    GestureDetector(onTap: (){final urlImages = [
                      comunicados[_currents]["URL_IMG_PREVIA"].toString()
                    ];
                    openGallery(urlImages,comunicados[_currents]["TITULO"].toString());},child: Container(margin:EdgeInsets.only(top: 10, bottom: 0),child: Text("Ver mas...", style: TextStyle(fontSize: 16, fontFamily: "Schyler",color: Colors.white),textAlign: TextAlign.end,),),),

                  ],)
                ),
              ]),
          ),),
        Positioned(bottom: size.height/2,right: size.width/14,child: Container( child: FloatingActionButton(
          mini: true,
          elevation: 16,
          backgroundColor: Colors.black38,
          onPressed: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),)),
      ],
    );
  }
  void openGallery(List<String> urlImages, String titulo) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => GalleryWidget(
      urlImages: urlImages,titulo: titulo
  )));
}


class CustomDialogsAlert extends StatelessWidget {
  final String? title, description, buttontext, imagen, nombre;
  final Image? image;

  const CustomDialogsAlert(
      {Key? key,
        this.title,
        this.description,
        this.buttontext,
        this.image,
        this.imagen,
        this.nombre})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: dialogContents(context),
    );
  }

  dialogContents(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(50),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                imagen!,
                width: 64,
                height: 64,
              ),
              const SizedBox(height: 20.0),
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Divider(),
              const SizedBox(height: 10.0),
              Text(
                description!,
                style: const TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: Offset(0.0, 10.0),
                            )
                          ]),
                      child: TextButton(
                        //color: kArandano,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}


class CustomDialogsAlertMultimedia extends StatelessWidget {
  final String? title, description, buttontext, imagen, nombre;
  final Image? image;

  const CustomDialogsAlertMultimedia(
      {Key? key,
        this.title,
        this.description,
        this.buttontext,
        this.image,
        this.imagen,
        this.nombre})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: dialogContents(context),
    );
  }

  dialogContents(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(50),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                imagen!,
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
           /* GestureDetector( /*onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  RadioWeb()));
                    }, */child: Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.07,margin: EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(color: kPrimaryColor,  boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, offset: const Offset(-3,3)),

            ]), child: Container(margin: EdgeInsets.symmetric(horizontal: 15), padding: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white, child: Center( child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.control_camera),
                    SizedBox(width: 10,),
                    Text("Juegos", style: TextStyle(fontFamily: "Schyler", fontSize: 16, color: Colors.black),textAlign: TextAlign.center,)])),),)),*/
            SizedBox(height: 20,),
              GestureDetector(onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  GaleriaBar()));
                    }, child: Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.07,margin: EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(color: kPrimaryColor,  boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, offset: const Offset(-3,3)),

                        ]), child: Container(margin: EdgeInsets.symmetric(horizontal: 15), padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.white, child: Center( child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                               Icon(Icons.photo),
                               SizedBox(width: 10,),
                               Text("Galería", style: TextStyle(fontFamily: "Schyler", fontSize: 16, color: Colors.black),textAlign: TextAlign.center,)])),),)),
              const SizedBox(height: 24.0),
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: Offset(0.0, 10.0),
                            )
                          ]),
                      child: TextButton(
                        //color: kArandano,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}