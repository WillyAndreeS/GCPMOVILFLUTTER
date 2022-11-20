
import 'dart:async';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'dart:math';
import 'package:acpmovil/documento.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:url_launcher/url_launcher.dart';



class CertificacionesPage extends DrawerContent {
  CertificacionesPage({Key? key}) ;

  @override
  CertificacionesPageState createState() => CertificacionesPageState();
}

class CertificacionesPageState extends State<CertificacionesPage> {
  late Size size;
  /*bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;*/

  final List<String> titles = ['', '', '', '', '', '', '', '', '', '', ''];

  final List<Widget> images = [
    //BuildContext context;
    GestureDetector(
      onTap: (){
        /* print("HOLAaaa");
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  MyPrincipalPage()));*/
      },
      child: Hero(
          tag: '1',
          child: GestureDetector(
              onTap: (){
                /*   print("HOLAaaa");
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  MyPrincipalPage()));*/
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child:  Image.network(
                  'https://web.acpagro.com/acpmovil/vista/para_productos/imagenes_acp/logo_europa.jpg',
                  fit: BoxFit.cover,
                ),
              ))),),
    GestureDetector(
      onTap: (){
        /* Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  CulturaPage()));*/
      },
      child:Hero(
          tag: '2',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              'https://web.acpagro.com/acpmovil/vista/para_productos/imagenes_acp/logo_global_gap.jpg',
              fit: BoxFit.cover,
            ),
          )),),
    GestureDetector(
      onTap: (){
        /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  CertificacionesPage()));*/
      },
      child:Hero(
          tag: const Text('3', style: TextStyle(fontSize: 12),),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              'https://web.acpagro.com/acpmovil/vista/para_productos/imagenes_acp/logo_etical.jpg',
              fit: BoxFit.cover,
            ),
          )),),
    Hero(
        tag: '4',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            'https://web.acpagro.com/acpmovil/vista/para_productos/imagenes_acp/logo_haccp.jpg',
            fit: BoxFit.cover,
          ),
        )),
    Hero(
        tag: '5',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            'https://web.acpagro.com/acpmovil/vista/para_productos/imagenes_acp/logo_nop.jpg',
            fit: BoxFit.cover,
          ),
        )),
    Hero(
        tag: '6',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            'https://web.acpagro.com/acpmovil/vista/para_productos/imagenes_acp/logo_senasa.jpg',
            fit: BoxFit.cover,
          ),
        )),
    Hero(
        tag: '7',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            'https://web.acpagro.com/acpmovil/vista/para_productos/imagenes_acp/logo_smeta.jpg',
            fit: BoxFit.cover,
          ),
        )),
    Hero(
        tag: '8',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            'https://web.acpagro.com/acpmovil/vista/para_productos/imagenes_acp/logo_tesco.jpg',
            fit: BoxFit.cover,
          ),
        )),
    Hero(
        tag: '9',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            'https://web.acpagro.com/acpmovil/vista/para_productos/imagenes_acp/logo_walmart.jpg',
            fit: BoxFit.cover,
          ),
        )),
    Hero(
        tag: '10',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            'https://web.acpagro.com/acpmovil/vista/para_productos/imagenes_acp/logo_danza.png',
            fit: BoxFit.cover,
          ),
        )),
    Hero(
        tag: '11',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            'https://web.acpagro.com/acpmovil/vista/para_productos/imagenes_acp/logo_yaku.jpg',
            fit: BoxFit.cover,
          ),
        )),
  ];

  final List<Widget> images_offline = [
    //BuildContext context;
    GestureDetector(
      onTap: (){
        /* print("HOLAaaa");
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  MyPrincipalPage()));*/
      },
      child: Hero(
          tag: '1',
          child: GestureDetector(
              onTap: (){
                /*   print("HOLAaaa");
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  MyPrincipalPage()));*/
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child:  Image.asset(
                  'assets/images/loader.gif',
                  fit: BoxFit.cover,
                ),
              ))),),
    GestureDetector(
      onTap: (){
        /* Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  CulturaPage()));*/
      },
      child:Hero(
          tag: '2',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              'assets/images/loader.gif',
              fit: BoxFit.cover,
            ),
          )),),
    GestureDetector(
      onTap: (){
        /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  CertificacionesPage()));*/
      },
      child:Hero(
          tag: const Text('3', style: TextStyle(fontSize: 12),),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              'assets/images/loader.gif',
              fit: BoxFit.cover,
            ),
          )),),
    Hero(
        tag: '4',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            'assets/images/loader.gif',
            fit: BoxFit.cover,
          ),
        )),
    Hero(
        tag: '5',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            'assets/images/loader.gif',
            fit: BoxFit.cover,
          ),
        )),
    Hero(
        tag: '6',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            'assets/images/loader.gif',
            fit: BoxFit.cover,
          ),
        )),
    Hero(
        tag: '7',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            'assets/images/loader.gif',
            fit: BoxFit.cover,
          ),
        )),
    Hero(
        tag: '8',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            'assets/images/loader.gif',
            fit: BoxFit.cover,
          ),
        )),
    Hero(
        tag: '9',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            'assets/images/loader.gif',
            fit: BoxFit.cover,
          ),
        )),
    Hero(
        tag: '10',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            'assets/images/loader.gif',
            fit: BoxFit.cover,
          ),
        )),
    Hero(
        tag: '11',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            'assets/images/loader.gif',
            fit: BoxFit.cover,
          ),
        )),
  ];

  @override
  void initState() {
    super.initState();
    /*Connectivity().onConnectivityChanged.listen((result) {
      setState(() => this.result = result);
    });
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });*/
  }

  /*@override
  void dispose(){
    internetSubscription.cancel();
    subscription.cancel();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[700],
            title: const Text("Certificaciones", style: TextStyle(fontFamily: "Schyler"),),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop (context, false);
              },
            ),

          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/BACK-CERTIFICACIONES.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 30, bottom: 130),
                child:SafeArea(
              child: Column(
                children: [
                  Expanded(child: VerticalCardPager(
                    titles: titles ,
                    images: hasInternets ? images: images_offline,
                    textStyle: const TextStyle(color:  Colors.white, fontWeight: FontWeight.bold,fontSize: 12),
                    initialPage: 2,
                    align: ALIGN.CENTER,
                  ))
                ],
              ),)),),);
  }

}