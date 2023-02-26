
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

  final List<String> titles = ['', '', '', '', '', '', '', '', '', '', '', '', ''];




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

    final List<Widget> images = [
      //BuildContext context;
      GestureDetector(
        onTap: (){
          print("HOLAaaa");
        },
        child: Hero(
            tag: '1',
            child: GestureDetector(
                onTap: (){
                  print("HOLA HOLA");
                  showDialog(
                      context: context,
                      builder: (context) => const CustomDialogsAlert(
                        title: "Norma HACCP",
                        description:
                        "Certificación Alimentaria cuyo objetivo es a la prevención y a la máxima reducción del riesgo alimentario. así permite mejorar la seguridad de los alimentos. \n Asegurar la inocuidad del productor a lo largo de la cadena de suministro alimentario, para así ganar la confianza del consumidor.",
                        imagen: "assets/images/advertencia.png",
                      ));
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child:  CachedNetworkImage(
                      imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/analisis-peligros-puntos-criticos-control3.jpg?alt=media&token=31289950-7334-4709-9410-00ee9d0e0fd0',
                      imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),),),
                      placeholder: (context, url) => Image.asset(
                        'assets/images/loader.gif',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      width: 120,
                      height: 120,
                      fit: BoxFit.fill,
                    )/*Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/analisis-peligros-puntos-criticos-control3.jpg?alt=media&token=31289950-7334-4709-9410-00ee9d0e0fd0',
                  fit: BoxFit.cover,
                ),*/
                ))),),
      GestureDetector(
        onTap: (){
          print("PRUEBAAAAAAAAAAA");
          /* Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  CulturaPage()));*/
        },
        child:Hero(
            tag: '2',
            child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: CachedNetworkImage(
                  imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/iconos-nuevos-07.png?alt=media&token=8e6eb67b-e31d-4200-9d08-5ee7bbd35df4',
                  imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),),),
                  placeholder: (context, url) => Image.asset(
                    'assets/images/loader.gif',
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: 120,
                  height: 120,
                  fit: BoxFit.fill,
                )
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
                child: CachedNetworkImage(
                  imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/iconos%20nuevos-04.png?alt=media&token=b28fd2a5-8896-4a60-a474-9924488979b1',
                  imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),),),
                  placeholder: (context, url) => Image.asset(
                    'assets/images/loader.gif',
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: 120,
                  height: 120,
                  fit: BoxFit.fill,
                )
            )),),
      Hero(
          tag: '4',
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CachedNetworkImage(
                imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/ETI.png?alt=media&token=3a1cd1e4-17aa-4967-b70e-73aab15d68f4',
                imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),),),
                placeholder: (context, url) => Image.asset(
                  'assets/images/loader.gif',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 120,
                height: 120,
                fit: BoxFit.fill,
              )
          )),
      Hero(
          tag: '5',
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CachedNetworkImage(
                imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/iconos%20nuevos-02.png?alt=media&token=d4128827-e1ce-4da6-9ce5-feb484f62de9',
                imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),),),
                placeholder: (context, url) => Image.asset(
                  'assets/images/loader.gif',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 120,
                height: 120,
                fit: BoxFit.fill,
              )
          )),
      Hero(
          tag: '6',
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child:
              CachedNetworkImage(
                imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/iconos%20nuevos-06.png?alt=media&token=315a4de7-e200-43e7-a842-ec7f688db7e1',
                imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),),),
                placeholder: (context, url) => Image.asset(
                  'assets/images/loader.gif',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 120,
                height: 120,
                fit: BoxFit.fill,
              )
          )),
      Hero(
          tag: '7',
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child:
              CachedNetworkImage(
                imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/iconos%20nuevos-05.png?alt=media&token=243f4d17-ed8c-4eed-804e-42e79bb39b3b',
                imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),),),
                placeholder: (context, url) => Image.asset(
                  'assets/images/loader.gif',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 120,
                height: 120,
                fit: BoxFit.fill,
              )
          )),
      Hero(
          tag: '8',
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child:
              CachedNetworkImage(
                imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/iconos%20nuevos-03.png?alt=media&token=b06a2484-f212-451f-9aff-44069dc6ee3c',
                imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),),),
                placeholder: (context, url) => Image.asset(
                  'assets/images/loader.gif',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 120,
                height: 120,
                fit: BoxFit.fill,
              )
          )),
      Hero(
          tag: '9',
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child:
              CachedNetworkImage(
                imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/GLOBAL-GAP.png?alt=media&token=4da76de7-7aef-4dbe-973c-89ecbc396bba',
                imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),),),
                placeholder: (context, url) => Image.asset(
                  'assets/images/loader.gif',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 120,
                height: 120,
                fit: BoxFit.fill,
              )
          )),
      Hero(
          tag: '10',
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: /*Image.network(
            'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/USDA.png?alt=media&token=34798b48-b33c-48d6-a1ee-d674c85f92fb',
            fit: BoxFit.cover,
          ),*/
              CachedNetworkImage(
                imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/USDA.png?alt=media&token=34798b48-b33c-48d6-a1ee-d674c85f92fb',
                imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),),),
                placeholder: (context, url) => Image.asset(
                  'assets/images/loader.gif',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 120,
                height: 120,
                fit: BoxFit.fill,
              )
          )),
      Hero(
          tag: '11',
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child:
              CachedNetworkImage(
                imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/TESCO.png?alt=media&token=f296841c-54b6-4c30-b920-2bff2241f268',
                imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),),),
                placeholder: (context, url) => Image.asset(
                  'assets/images/loader.gif',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 120,
                height: 120,
                fit: BoxFit.fill,
              )
          )),
      Hero(
          tag: '12',
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child:
              CachedNetworkImage(
                imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/SENASA.png?alt=media&token=9a000132-f87a-43b9-a8bf-d469536f631c',
                imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),),),
                placeholder: (context, url) => Image.asset(
                  'assets/images/loader.gif',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 120,
                height: 120,
                fit: BoxFit.fill,
              )
          )),
      Hero(
          tag: '13',
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child:
              CachedNetworkImage(
                imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/Walmart-Logo-PNG-Transparent.webp?alt=media&token=306522fc-97d0-42b8-8fa6-17b3dc610870',
                imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),),),
                placeholder: (context, url) => Image.asset(
                  'assets/images/loader.gif',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 120,
                height: 120,
                fit: BoxFit.fill,
              )
          )),
    ];

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