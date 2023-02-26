import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/GaleriaCapas.dart';
import 'package:acpmovil/views/Presentaciones_web.dart';
import 'package:acpmovil/views/galeriaBar.dart';
import 'package:acpmovil/views/galeria_celebrando_juntos.dart';
import 'package:acpmovil/views/gcpgps.dart';
import 'package:acpmovil/views/grupo_cerro_prieto.dart';

import 'package:acpmovil/views/nuestroequipo.dart';
import 'package:acpmovil/views/page2.dart';
import 'package:acpmovil/views/principalpage.dart';
import 'package:acpmovil/views/programas_capacitaciones.dart';
import 'package:acpmovil/views/quejasreclamos.dart';
import 'package:acpmovil/views/radio_webBar.dart';
import 'package:acpmovil/views/screen_contactanos.dart';
import 'package:acpmovil/views/screen_galeria_videos.dart';
import 'package:acpmovil/views/screen_gcpmundo.dart';
import 'package:acpmovil/views/screen_linea_covid.dart';
import 'package:acpmovil/views/screen_linea_emergencia.dart';
import 'package:acpmovil/views/screen_linea_etica.dart';
import 'package:acpmovil/views/screen_nuestros_productos_v2.dart';
import 'package:acpmovil/views/screen_revistas_boletines.dart';
import 'package:acpmovil/views/somosacp2.dart';
import 'package:acpmovil/views/utilidades.dart';
import 'package:acpmovil/views/videos.dart';
import 'package:acpmovil/views/vista_panoramica_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';



class BuscarOpcion extends StatefulWidget {
  BuscarOpcion({Key? key}) ;

  @override
  _BuscarOpcionState createState() => _BuscarOpcionState();
}

class _BuscarOpcionState extends State<BuscarOpcion> {
  late Size size;
  List conocenosF = [];
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;
  final myControllerSearch = TextEditingController();
  late FocusNode focusUser;
  QuerySnapshot? menus;
  QuerySnapshot? beneficios;
  QuerySnapshot? capacitaciones;
  QuerySnapshot? conocenos;
  QuerySnapshot? galeria;
  List menu = [];
  List filter = [];
  //String? descripcion= "";

  Future<void> getMenus(String descripcion)  async {
   // menu.clear();
    print("ESTA ES LA DESCRIPCION: "+descripcion);
    var usuariosF = FirebaseFirestore.instance.collection("menu").doc("ACP").collection("invitado").where("descripcion",isGreaterThan: descripcion.toUpperCase()).where('descripcion', isLessThan: descripcion.toUpperCase()+'\uf8ff');
    menus = await usuariosF.get();

    setState((){
      if(menus!.docs.isNotEmpty){

        for(var doc in menus!.docs){
          menu.add(doc.data());

        }

      }
      print(menu.toString());
    });
    getMenuBeneficios(descripcion);
  }

  Future<void> getMenuBeneficios(String descripcion)  async {
    print("ESTA ES LA DESCRIPCION: "+descripcion);

    var beneficiosF = FirebaseFirestore.instance.collection("menu_beneficios").where("titulo",isGreaterThan: descripcion.toUpperCase()).where('titulo', isLessThan: descripcion.toUpperCase()+'\uf8ff');
    beneficios = await beneficiosF.get();
    setState((){
      if(beneficios!.docs.isNotEmpty){
       // menu.clear();
        for(var doc in beneficios!.docs){

          menu.add(doc.data());

        }

      }
      print(menu.toString());
    });
    getMenuConocenos(descripcion);
  }

  Future<void> getMenuConocenos(String descripcion)  async {
    print("ESTA ES LA DESCRIPCION: "+descripcion);

    var conocenosF = FirebaseFirestore.instance.collection("menu_conocenos").where("titulo",isGreaterThan: descripcion.toUpperCase()).where('titulo', isLessThan: descripcion.toUpperCase()+'\uf8ff');
    conocenos = await conocenosF.get();
    setState((){
      if(conocenos!.docs.isNotEmpty){
        // menu.clear();
        for(var doc in conocenos!.docs){

          menu.add(doc.data());

        }

      }
      print(menu.toString());
    });
    getMenuGaleria(descripcion);

  }

  Future<void> getMenuGaleria(String descripcion)  async {
    print("ESTA ES LA DESCRIPCION: "+descripcion);

    var galeriaF = FirebaseFirestore.instance.collection("menu_galeria").where("descripcion",isGreaterThan: descripcion.toUpperCase()).where('descripcion', isLessThan: descripcion.toUpperCase()+'\uf8ff');
    galeria = await galeriaF.get();
    setState((){
      if(galeria!.docs.isNotEmpty){
        // menu.clear();
        for(var doc in galeria!.docs){

          menu.add(doc.data());

        }

      }
      print(menu.toString());
    });

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
    focusUser = FocusNode();
    getMenus("");
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Buscar", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),

      body: SingleChildScrollView(child: Container(
        padding: const EdgeInsets.only(top: 20),
    child: Column(
        children: [
      Container( margin: EdgeInsets.only(top: 20),child:
      Container(
        width:
        MediaQuery.of(context).size.width / 1.2,
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
          focusNode: focusUser,
          autofocus: true,
          controller: myControllerSearch,
          onChanged: (text) async {
           // setState((){
              print("texto: " +text);
              menu.clear();
              await getMenus(text);
          //  });



          },
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
      ),),
      SizedBox(height: 25,),
      Divider(height: 10,
      thickness: 1.5),
          SizedBox(height: 10,),
      Container(
        height: size.height*0.65,
          child: menu.isEmpty ? Center(child: Container()): ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
    itemCount: menu.length,
    itemBuilder: (BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
       child:Column(
           children: [
        GestureDetector(
          onTap: (){
              setState((){
                if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "ACP Go"){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GCP_GPS()));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Agrícola Cerro Prieto"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Somosacp()));
                }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Contactos de emergencia"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LineaEmergencia()));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "GCP Mundo"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RevistasBoletines()));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Galería"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GaleriaBar()));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Sintoniza Radio Cerro Prieto"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RadioWebBar()));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "¡Somos el Grupo Cerro Prieto!"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GrupoACP()));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Comunícate con nosotros"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConocenosContactanos()));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Línea covid"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LineaCovid()));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Línea Ética"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LineaEtica()));
                   }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Programas y capacitación interna"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProgramasCapa()));
                   }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Quejas y sugerencias"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuejasReclamos()));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Utilidades"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Utilidades()));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Descripción"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyPrincipalPage()));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Nuestro Equipo"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NuestroEquipoPage()));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Nuestros Productos"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NuestrosProductosV2()));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Celebrando Juntos"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GaleriaCelebrando(titulo: "Celebrando Juntos",)));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Programas y capacitaciones"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GaleriaCapas(titulo: "Capacitaciones",)));
                  }else if((menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]) == "Videos"){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  Videos(titulo: "Videos")));

                }
                });



          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(margin: EdgeInsets.only(left: 30), child: Image.network( menu[index]["icono"], height: 20,color: Colors.black,)),
            Container(margin: EdgeInsets.only(left: 10), child: Text(menu[index]["descripcion"] == null ? menu[index]["titulo"] : menu[index]["descripcion"]))
          ])
        ),
       ])
    );}))]))),);
    }
  }