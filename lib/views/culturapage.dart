
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



class CulturaPage extends StatefulWidget {
  CulturaPage({Key? key}) ;

  @override
  CulturaPageState createState() => CulturaPageState();
}

class CulturaPageState extends State<CulturaPage> {
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
        title: const Text("Cultura", style: TextStyle(fontFamily: "Schyler"),),
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
            hasInternets ? CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/bandera.png?alt=media&token=ff43e76d-1259-4096-b78c-b81d56f237cc", width: 30,placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)):
            Image.asset("assets/images/bandera.png", width: 30,),
            hasInternets ? CachedNetworkImage(imageUrl:"https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/ICON-VISION.png?alt=media&token=d6b482bd-a201-4f22-ba81-ab365cd81e12",width: 30,placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)): Image.asset("assets/images/ICON-VISION.png", width: 30,),
            hasInternets ? CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/VALORES-IMG.png?alt=media&token=3958d990-6940-420d-91b6-47f212589151",width: 30, placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)): Image.asset("assets/images/VALORES-IMG.png", width: 30,),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
              print(_page);
            });
          },
        ),
        body: _page == 0 ? Container(
         // padding: const EdgeInsets.only(top: 40),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/img_mvv_mision.jpg",),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: const Color.fromRGBO(0,0, 0, 0.4),
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
                      child: const Text("Misión", style: TextStyle(color: Colors.white, fontSize: 22,fontFamily: "Schyler"))
                  ),
                    const SizedBox(height: 20,),
                    Container(
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.center,
                        child: const Text('"Llegamos al mundo con alimentos naturales, saludables y de alta calidad"', style: TextStyle(color: Colors.white, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.center)
                    ),
                  ]
                ),),
              ],

            ),
          ),
        ) : _page == 1 ? Container(
          // padding: const EdgeInsets.only(top: 40),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_mvv_valores.jpg",),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: const Color.fromRGBO(0,0, 0, 0.4),
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
                            child: const Text("Visión", style: TextStyle(color: Colors.white, fontSize: 22,fontFamily: "Schyler"))
                        ),
                        const SizedBox(height: 20,),
                        Container(
                            padding: const EdgeInsets.all(12),
                            alignment: Alignment.center,
                            child: const Text('"Ser reconocidos como una empresa saludable, en nuestros negocios, en nuestros productos y en nuestras relaciones con la gente y el entorno"', style: TextStyle(color: Colors.white, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.center)
                        ),
                      ]
                  ),),
              ],

            ),
          ),
        ) : Scaffold(
          body: Stack(
            children: [
              Opacity(
                opacity: 0.4,
                child: Image.asset(
                  'assets/images/background_gcp.png',
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                  child: Column(
                    children: [
                      Container(
                        width: size.width/2,
                        child:Image.asset("assets/images/TODO-VALORES.png"),
                      ),
                      SizedBox(height: 10,),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration:  BoxDecoration(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(100.0), topLeft: Radius.circular(100.0)), color: iconMenu,),
                          child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 7),
                                    decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(100)),  border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),),
                                    child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 1.0, end: 0.0),
                                        curve: Curves.decelerate,
                                        child: Image.asset(
                                          'assets/images/valor_001.png',
                                          height: double.infinity,
                                          width: double.infinity,
                                        ),
                                        duration: const Duration(milliseconds: 800),
                                        builder: (context, value, child) {
                                          return Transform.translate(
                                            offset: Offset(0.0, -200 * value),
                                            child: child,
                                          );
                                        })))),
                            Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 30),

                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      Row(
                                        children: [
                                          TweenAnimationBuilder<double>(
                                              tween: Tween(begin: 1.0, end: 0.0),
                                              curve: Curves.decelerate,
                                              child:  Text(
                                                'Respeto',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold, color: Colors.white,fontFamily: "Schyler"),
                                              ),
                                              duration:
                                              const Duration(milliseconds: 500),
                                              builder: (context, value, child) {
                                                return Transform.translate(
                                                  offset: Offset(200 * value, 0.0),
                                                  child: child,
                                                );
                                              })
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      AnimatedOpacity(
                                        opacity: opacity == 1 ? 0 : 1,
                                        curve: Curves.easeIn,
                                        duration: const Duration(milliseconds: 500),
                                        child: const Text(
                                            'Mostramos respeto por todas las personas por igual, la ley, nuestra empresa, la naturaleza y nosotros mismos.',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(fontSize: 13, color: Colors.white,fontFamily: "Schyler")),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration:  BoxDecoration(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(100.0), topLeft: Radius.circular(100.0)), color: moradoacp,),
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 7),
                              decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(100)),  border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 1.0, end: 0.0),
                                      curve: Curves.decelerate,
                                      child: Image.asset(
                                        'assets/images/valor_002.png',
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                                      duration: const Duration(milliseconds: 600),
                                      builder: (context, value, child) {
                                        return Transform.translate(
                                          offset: Offset(0.0, -200 * value),
                                          child: child,
                                        );
                                      }),
                                )),),
                            Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          TweenAnimationBuilder<double>(
                                              tween: Tween(begin: 1.0, end: 0.0),
                                              curve: Curves.decelerate,
                                              child: const Text(
                                                'Pasión',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold, color: Colors.white,fontFamily: "Schyler"),
                                              ),
                                              duration:
                                              const Duration(milliseconds: 500),
                                              builder: (context, value, child) {
                                                return Transform.translate(
                                                  offset: Offset(200 * value, 0.0),
                                                  child: child,
                                                );
                                              })
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      AnimatedOpacity(
                                        opacity: opacity == 1 ? 0 : 1,
                                        curve: Curves.easeIn,
                                        duration: const Duration(milliseconds: 500),
                                        child: const Text(
                                            'Nos encanta lo que hacemos, la naturaleza y lo que entregamos al mundo.',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(fontSize: 13, color: Colors.white,fontFamily: "Schyler")),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration:  BoxDecoration(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(100.0), topLeft: Radius.circular(100.0)), color: azulacp,),
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 7),
                              decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(100)),  border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 1.0, end: 0.0),
                                      curve: Curves.decelerate,
                                      child: Image.asset(
                                        'assets/images/valor_003.png',
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                                      duration: const Duration(milliseconds: 500),
                                      builder: (context, value, child) {
                                        return Transform.translate(
                                          offset: Offset(0.0, -200 * value),
                                          child: child,
                                        );
                                      }),
                                )),),
                            Flexible(
                                flex: 2,

                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          TweenAnimationBuilder<double>(
                                              tween: Tween(begin: 1.0, end: 0.0),
                                              curve: Curves.decelerate,
                                              child: const Text(
                                                'Compromiso',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold, color: Colors.white,fontFamily: "Schyler"),
                                              ),
                                              duration:
                                              const Duration(milliseconds: 500),
                                              builder: (context, value, child) {
                                                return Transform.translate(
                                                  offset: Offset(200 * value, 0.0),
                                                  child: child,
                                                );
                                              })
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      AnimatedOpacity(
                                        opacity: opacity == 1 ? 0 : 1,
                                        curve: Curves.easeIn,
                                        duration: const Duration(milliseconds: 500),
                                        child: const Text(
                                            'Damos lo mejor de nosotros, a nuestra gente, nuestros clientes y a nuestro entorno.',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(fontSize: 13, color: Colors.white,fontFamily: "Schyler")),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration:  BoxDecoration(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(100.0), topLeft: Radius.circular(100.0)), color: amarilloacp,),
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 7),
                              decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(100)),  border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 1.0, end: 0.0),
                                      curve: Curves.decelerate,
                                      child: Image.asset(
                                        'assets/images/valor_004.png',
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                                      duration: const Duration(milliseconds: 300),
                                      builder: (context, value, child) {
                                        return Transform.translate(
                                          offset: Offset(0.0, -200 * value),
                                          child: child,
                                        );
                                      }),
                                )),),
                            Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          TweenAnimationBuilder<double>(
                                              tween: Tween(begin: 1.0, end: 0.0),
                                              curve: Curves.decelerate,
                                              child: const Text(
                                                'Excelencia',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold, color: Colors.white,fontFamily: "Schyler"),
                                              ),
                                              duration:
                                              const Duration(milliseconds: 500),
                                              builder: (context, value, child) {
                                                return Transform.translate(
                                                  offset: Offset(200 * value, 0.0),
                                                  child: child,
                                                );
                                              })
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      AnimatedOpacity(
                                        opacity: opacity == 1 ? 0 : 1,
                                        curve: Curves.easeIn,
                                        duration: const Duration(milliseconds: 500),
                                        child: const Text(
                                            'Hacemos bien nuestro trabajo y siempre buscamos superar nuestras metas.',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(fontSize: 13, color:Colors.white,fontFamily: "Schyler")),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),),
                      )
                    ],
                  ))
            ],
          ),
        ),
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
