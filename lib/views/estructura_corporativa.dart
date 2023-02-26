
import 'dart:async';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';



class EstructuraCorpPage extends StatefulWidget {
  EstructuraCorpPage({Key? key}) ;

  @override
  EstructuraCorpPageState createState() => EstructuraCorpPageState();
}

class EstructuraCorpPageState extends State<EstructuraCorpPage> {
  /*bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;*/

  @override
  void initState(){
    super.initState();
   /* Connectivity().onConnectivityChanged.listen((result) {
      setState(() => this.result = result);
    });
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });*/
    getPostsData();
    controller.addListener(() {

      double value = controller.offset/119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
    changeOpacity();

  }


  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  //final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  double opacity = 1.0;

  List<Widget> itemsData = [];

  void getPostsData() {
    List<dynamic> responseList = FOOD_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        post["brand"],
                        style: const TextStyle(fontSize: 17, color: Colors.black),
                    ),
                    const Divider(
                      height: 5,
                      thickness: 5,
                      indent: 20,
                      endIndent: 0,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                      post["name"],
                      style: const TextStyle(fontSize: 13, color: Colors.black,),
                    )),
                    Text(post["leer"], style: const TextStyle(fontSize: 11, color: Colors.grey,),)
                  ],
                ),
                SizedBox(
                  width: 70,
                  child: Center(child: Image.asset(
                    "assets/images/${post["image"]}",
                    height: 70,)
                  )
                )

              ],
            ),
          )));
    });
    setState(() {
      itemsData = listItems;
    });
  }
  /*@override
  void dispose(){
    internetSubscription.cancel();
    subscription.cancel();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height*0.30;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Estructura Corporativa", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),
        bottomNavigationBar: CurvedNavigationBar(
          color: const Color(0XFF388E3C),
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: iconMenu,

          key: _bottomNavigationKey,
          items: <Widget>[
            hasInternets ? CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/acp_002_512.png?alt=media&token=b6c2f961-caf8-4b07-91cc-f614602c6712", width: 30,placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)):
            Image.asset("assets/images/acp_002_512.png", width: 30,),
            hasInternets ? CachedNetworkImage(imageUrl:"https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/icp_002_256.png?alt=media&token=1bafde6c-3140-4371-aa19-f21922d32ffa",width: 30,placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)): Image.asset("assets/images/icp_002_256.png", width: 30,),
            hasInternets ? CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/qali_002_256.png?alt=media&token=a54b6eb7-c946-4981-ba84-cb060a28449b",width: 30, placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)): Image.asset("assets/images/qali_002_256.png", width: 30,),
            hasInternets ? CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/cpc_002_256.png?alt=media&token=b8757030-2720-4770-9e85-fdc36b8b8e03",width: 30, placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)): Image.asset("assets/images/cpc_002_256.png", width: 30,),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
              print(_page);
            });
          },
        ),
        body: _page == 0 ? Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_gcp.png",),
              fit: BoxFit.cover,
            ),
          ),
         // padding: const EdgeInsets.only(top: 40),
          //color: Colors.white,
          child: Container(
            color: const Color.fromRGBO(255,255, 255, 0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Container(
                            child: Image.asset("assets/images/planta (1).png",height: 64,)),
                      const Text("Agrícola Cerro Prieto", style: TextStyle(color: Colors.black54, fontSize: 22,fontFamily: "Schyler"))
                      ])
                  ),
                    const SizedBox(height: 5,),
                    Container( margin: EdgeInsets.symmetric(horizontal: 25),child: Divider(thickness: 4, color: kPrimaryColor,)),
                    const SizedBox(height: 20,),
                    Container(
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.center,
                        child: const Text('Agronegocios', style: TextStyle(color: Colors.black54, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.center)
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        alignment: Alignment.centerLeft,
                        child: const Text('- Plantación, mantenimiento, cosecha y comercialización de cultivos.', style: TextStyle(color: Colors.black45, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.start)
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        alignment: Alignment.centerLeft,
                        child: const Text('- Area total de 4660 has.', style: TextStyle(color: Colors.black45, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.start)
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        alignment: Alignment.centerLeft,
                        child: const Text('- Area en uso de 1,927 has.', style: TextStyle(color: Colors.black45, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.start)
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        alignment: Alignment.centerLeft,
                        child: const Text('- Planta de Empaque', style: TextStyle(color: Colors.black45, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.start)
                    ),
                  ]
                ),),
              ],

            ),
          ),
        ) : _page == 1 ? Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_gcp.png",),
              fit: BoxFit.cover,
            ),
          ),
          // padding: const EdgeInsets.only(top: 40),
          //color: Colors.white,
          child: Container(
            color: const Color.fromRGBO(255,255, 255, 0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      child: Image.asset("assets/images/soltar.png",height: 64,)),
                                  const Text("Irrigadora Cerro Prieto", style: TextStyle(color: Colors.black54, fontSize: 22,fontFamily: "Schyler"))
                                ])
                        ),
                        const SizedBox(height: 5,),
                        Container( margin: EdgeInsets.symmetric(horizontal: 25),child: Divider(thickness: 4, color: Colors.lightBlue,)),
                        const SizedBox(height: 20,),
                        Container(

                            padding: const EdgeInsets.all(12),
                            alignment: Alignment.center,
                            child: const Text('Desarrollo de activos reales', style: TextStyle(color: Colors.black54, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.center)
                        ),
                        const SizedBox(height: 10,),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                            alignment: Alignment.centerLeft,
                            child: const Text('- Canal verde privado con capacidad para regar 12.400 ha.', style: TextStyle(color: Colors.black45, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.start)
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                            alignment: Alignment.centerLeft,
                            child: const Text('- Gestión de canal y recursos hídricos', style: TextStyle(color: Colors.black45, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.start)
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                            alignment: Alignment.centerLeft,
                            child: const Text('- Desarrollo de nuevos proyectos', style: TextStyle(color: Colors.black45, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.start)
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                            alignment: Alignment.centerLeft,
                            child: const Text('- Planta de Empaque', style: TextStyle(color: Colors.black45, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.start)
                        ),
                      ]
                  ),),
              ],

            ),
          ),
        ) : _page == 2 ?
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_gcp.png",),
              fit: BoxFit.cover,
            ),
          ),
          // padding: const EdgeInsets.only(top: 40),
          //color: Colors.white,
          child: Container(
            color: const Color.fromRGBO(255,255, 255, 0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      child: Image.asset("assets/images/arandanos.png",height: 64,)),
                                  const Text("Qali Cerro Prieto", style: TextStyle(color: Colors.black54, fontSize: 22,fontFamily: "Schyler"))
                                ])
                        ),
                        const SizedBox(height: 5,),
                        Container( margin: EdgeInsets.symmetric(horizontal: 25),child: Divider(thickness: 4, color: moradoacp,)),
                        const SizedBox(height: 20,),
                        Container(
                            padding: const EdgeInsets.all(12),
                            alignment: Alignment.center,
                            child: const Text('Agronegocios', style: TextStyle(color: Colors.black54, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.center)
                        ),
                        const SizedBox(height: 10,),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                            alignment: Alignment.centerLeft,
                            child: const Text('- Proyecto para desarrollar mas de 50 hectareas de arándano en Santa Rosa(Lima).', style: TextStyle(color: Colors.black45, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.start)
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                            alignment: Alignment.centerLeft,
                            child: const Text('- Parte de nuestro plan de diversificación geográfica', style: TextStyle(color: Colors.black45, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.start)
                        ),
                      ]
                  ),),
              ],

            ),
          ),
        )  :
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_gcp.png",),
              fit: BoxFit.cover,
            ),
          ),
          // padding: const EdgeInsets.only(top: 40),
          //color: Colors.white,
          child: Container(
            color: const Color.fromRGBO(255,255, 255, 0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      child: Image.asset("assets/images/palta.png",height: 64,)),
                                  const Text("Cerro Prieto Colombia", style: TextStyle(color: Colors.black54, fontSize: 22,fontFamily: "Schyler"))
                                ])
                        ),
                        const SizedBox(height: 5,),
                        Container( margin: EdgeInsets.symmetric(horizontal: 25),child: Divider(thickness: 4, color: kDarkPrimaryColor,)),
                        const SizedBox(height: 20,),
                        Container(
                            padding: const EdgeInsets.all(12),
                            alignment: Alignment.center,
                            child: const Text('Agronegocios', style: TextStyle(color: Colors.black54, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.center)
                        ),
                        const SizedBox(height: 10,),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                            alignment: Alignment.centerLeft,
                            child: const Text('- Primer proyecto de expansión del Grupo Cerro Prieto fuera del Perú en la zona de Riosucio, Colombia.', style: TextStyle(color: Colors.black45, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.start)
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                            alignment: Alignment.centerLeft,
                            child: const Text('- Cuenta con 110 hectáreas para el cultivo y exportación de palta Hass.', style: TextStyle(color: Colors.black45, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.start)
                        ),
                      ]
                  ),),
              ],

            ),
          ),
        )
    );
  }
  changeOpacity() {
    Future.delayed(
        const Duration(milliseconds: 100),
            () => setState(() {
          opacity = opacity == 0.0 ? 1.0 : 0.0;
          //changeOpacity();
        }));
  }
}
