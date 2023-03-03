import 'dart:async';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AcpClubPromo extends StatefulWidget {
  String? urlflyer, nombre, terminos, idlocal, cel, facebook, instagram,direccion;
  AcpClubPromo({Key? key, this.urlflyer, this.nombre, this.terminos, this.idlocal, this.cel,this.facebook, this.instagram, this.direccion});

  @override
  AcpClubPromoState createState() => AcpClubPromoState();
}

class AcpClubPromoState extends State<AcpClubPromo> {
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;
  List promociones = [];

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
    // getPostsData();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
    changeOpacity();
    getPromociones();
  }

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  //final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  double opacity = 1.0;
  static const double _appBarBottomBtnPosition = 24.0;

  List<Widget> itemsData = [];

  void _launchURL(String url) async => await canLaunch(url) ? await launch(url) : throw 'Coult not launch $url';

  Future<void> getPromociones() async{
    promociones.clear();
    var promoF = FirebaseFirestore.instance.collection("promosacpclub").where("idlocal", isEqualTo: widget.idlocal!);
    QuerySnapshot promos = await promoF.get();
    setState(() {
      if(promos.docs.isNotEmpty){
        for(var doc in promos.docs){
          print("DATOS: "+doc.id.toString());

          promociones.add(doc.data());
        }
        print("TITULO: "+promociones[0]["nombre"]);

      }
    });

  }

  void getPostsData() {
    List<dynamic> responseList = FOOD_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
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
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        )),
                    Text(
                      post["leer"],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                SizedBox(
                    width: 70,
                    child: Center(
                        child: Image.asset(
                      "assets/images/${post["image"]}",
                      height: 70,
                    )))
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
    const Key centerKey = ValueKey<String>('bottom-sliver-list');
    final double categoryHeight = size.height * 0.30;
    return Scaffold(
      backgroundColor: Colors.green,
        bottomNavigationBar: BottomNavigationBar(
          //color: const Color(0XFF388E3C),
          backgroundColor: Color(0XFF388E3C),
          //backgroundColor: iconMenu,

          key: _bottomNavigationKey,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: hasInternets
                  ? CachedNetworkImage(
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/llamada-telefonica%20(1).png?alt=media&token=892f76f1-e470-42fd-9780-2af6a83e54a6",
                      width: 30,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error))
                  : Image.asset(
                      "assets/images/llamada-telefonica (1).png",
                      width: 30,
                    ),
              label: "Cel.: "+ widget.cel! ?? "-",
              backgroundColor: Color(0XFF388E3C),
            ),
            BottomNavigationBarItem(
              icon: hasInternets
                  ? CachedNetworkImage(
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/logotipo-circular-de-facebook.png?alt=media&token=9c1c7c2f-869d-4b10-8e38-6c4b177bd524",
                      width: 30,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error))
                  : Image.asset(
                      "assets/images/logotipo-circular-de-facebook.png",
                      width: 30,
                    ),
              label: "",
              backgroundColor: Color(0XFF388E3C),
            ),
            BottomNavigationBarItem(
              icon: hasInternets
                  ? CachedNetworkImage(
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/instagram.png?alt=media&token=fca4ed1d-7726-4c5c-80ca-7b514321e25e",
                      width: 30,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error))
                  : Image.asset(
                      "assets/images/instagram.png",
                      width: 30,
                    ),
              label: "",
              backgroundColor: Color(0XFF388E3C),
            ),
            BottomNavigationBarItem(
              icon: hasInternets
                  ? CachedNetworkImage(
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/terminos-y-condiciones.png?alt=media&token=767424c1-ce99-49ef-9c73-de69d0e517fas",
                      width: 30,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error))
                  : Image.asset(
                      "assets/images/terminos-y-condiciones.png",
                      width: 30,
                    ),
              label: "",
            ),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
              print(_page);
              if(_page == 3){
                showDialog(
                    context: context,
                    builder: (context) =>
                     CustomDialogsAlert(
                      title: "Terminos y Condiciones",
                      description:
                      widget.terminos!,
                      //imagen: "assets/images/mudo.png",
                    ));
              }else if(_page == 1){
                if(widget.facebook!.isNotEmpty){
                  _launchURL(widget.facebook!);
                }
              }else if(_page == 2){
                if(widget.instagram!.isNotEmpty){
                  _launchURL(widget.instagram!);
                }
              }else if(_page == 0){
                FlutterPhoneDirectCaller.callNumber(widget.cel!);
              }

            });
          },
        ),
        body: CustomScrollView(
            slivers: [

          SliverAppBar(
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                  margin: EdgeInsets.only(right: 20),
                  width: size.width,
                  child: Text(
                    widget.nombre!,
                    style: TextStyle(
                        fontFamily: "Schyler", fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
              background: CachedNetworkImage(
                imageUrl:widget.urlflyer!,
                imageBuilder: (context,
                    imageProvider) => Container(
                  decoration:
                  BoxDecoration(
                    color: Colors.white,
                    image:
                    DecorationImage(
                      image:
                      imageProvider,
                      fit:
                      BoxFit.cover,
                    ),
                  ),
              ), placeholder: (context, url) => Container(
                decoration: const BoxDecoration(
                          image:
                          DecorationImage(
                            image:
                            AssetImage("assets/images/122840-image.gif"),
                            fit:
                            BoxFit.fill,
                          ),
                ),
              ),),
            ),
            leading: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Transform.translate(
                offset: const Offset(0, 0),
                child: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
                  onPressed: (){
                    Navigator.pop (context, false);
                  },
                ),
              ),
            ),
            expandedHeight: size.height * 0.40,
          ),
          SliverList(
            key: centerKey,
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Container(padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),  boxShadow: [
                      BoxShadow(color: Colors.black, blurRadius: 10, offset: const Offset(0,-10)),

                    ]),
                    height: size.height*0.1, width: size.width,child: Container(width: size.width * 0.8,child: Row(children: [
                  Icon(Icons.pin_drop, color: kPrimaryColor,),
                  Text("Dirección: ", style: TextStyle(color:kPrimaryColor, fontWeight: FontWeight.bold),),
                  SizedBox(width: 10,),
                  Container( width: size.width*0.65,child: Text(widget.direccion!, style: TextStyle(color:Colors.black, fontWeight: FontWeight.bold),))
                ],)));
              },
              childCount: 1,
            ),
          ),
        /*Container(height: size.height*0.1, width: size.width,child: Row(children: [
                Icon(Icons.pin_drop, color: kPrimaryColor,),
                Text("Dirección: ")
              ],)),*/
          SliverList(

              delegate: SliverChildBuilderDelegate(

                childCount: promociones.length,
                      (BuildContext context, int index){
            return Container(
              color: Colors.white,
                child: Column(
              children: [
                 GestureDetector(

                                  child:  Container(
                                          height: size.height / 6.5,
                                          width: size.width,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10.0)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.29),
                                                    blurRadius: 10.0,
                                                    offset: Offset(-0, 0)),
                                              ]),
                                          child: Row(
                                            children: [
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: hasInternets ||
                                                          hasInternet
                                                      ? CachedNetworkImage(
                                                          imageUrl:
                                                          promociones[index]
                                                                  ["foto"],
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            width: size.width /2.3,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: const BorderRadius
                                                                      .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10.0),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10.0)),
                                                              color: const Color(
                                                                      0xFF0000000)
                                                                  .withOpacity(
                                                                      0),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5,
                                                                    bottom: 5),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: const <Widget>[
                                                                 Text("",
                                                                    style:  TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            "Schyler"))
                                                              ],
                                                            ),
                                                          ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              Container(
                                                                width: size.width /2.3,
                                                                decoration:
                                                                BoxDecoration(
                                                                  borderRadius: const BorderRadius
                                                                      .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                          10.0),
                                                                      bottomLeft: Radius
                                                                          .circular(
                                                                          10.0)),
                                                                  color: const Color(
                                                                      0xFF0000000)
                                                                      .withOpacity(
                                                                      0),
                                                                  image:
                                                                  DecorationImage(
                                                                    image:AssetImage("assets/images/122840-image.gif"),
                                                                    fit:
                                                                    BoxFit.fill,
                                                                  ),
                                                                ),
                                                                padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 5,
                                                                    bottom: 5),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  children: const <Widget>[
                                                                    Text("",
                                                                        style:  TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                            fontFamily:
                                                                            "Schyler"))
                                                                  ],
                                                                ),
                                                              ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        )
                                                      : CircularProgressIndicator()),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: size.width / 2.5,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10.0)),
                                                    color:
                                                        const Color(0xFF0000000)
                                                            .withOpacity(0),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          bottom: 5,
                                                          left: 2),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        margin:EdgeInsets.only(left: 8),
                                                          child: Text(
                                                              promociones[index]
                                                                  ["nombre"],
                                                             // maxLines: 2,
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      "Schyler",
                                                                  fontSize:
                                                                      16))),
                                                      SizedBox(height: 5,),
                                                      Container(
                                                        margin: EdgeInsets.only(left: 20),
                                                          child: Text(
                                                              promociones[index]
                                                              ["promocion"],
                                                              //maxLines: 2,
                                                              textAlign:
                                                              TextAlign
                                                                  .left,
                                                              style: const TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontFamily:
                                                                  "Schyler",
                                                                  fontSize:
                                                                  13)))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )))
              ],
            ));
  }))
        ]));
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
             /* Image.asset(
                imagen!,
                width: 64,
                height: 64,
              ),*/
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
                textAlign: TextAlign.justify,
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

