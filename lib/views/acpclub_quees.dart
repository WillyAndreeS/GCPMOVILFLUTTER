
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



class AcpClubDetail extends StatefulWidget {
  AcpClubDetail({Key? key}) ;

  @override
  AcpClubDetailState createState() => AcpClubDetailState();
}

class AcpClubDetailState extends State<AcpClubDetail> {
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
    // getPostsData();
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
        title:  Text(_page == 0 ?"¿Qué es ACP Club?": _page==1 ? "¿Quienes se benefician?": "¿Como acceder?", style: TextStyle(fontFamily: "Schyler"),),
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
            hasInternets ? CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/ayudar.png?alt=media&token=22d60a69-94d3-40c6-afaa-d0b9a9606e07", width: 30,placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)):
            Image.asset("assets/images/bandera.png", width: 30,),
            hasInternets ? CachedNetworkImage(imageUrl:"https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/business-people.png?alt=media&token=f7dddbeb-fa41-41f3-a72f-88399fc4bc14",width: 30,placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)): Image.asset("assets/images/ICON-VISION.png", width: 30,),
            hasInternets ? CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/premio.png?alt=media&token=1f248d16-b6ba-486e-909b-a4cc4c58de6b",width: 30, placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)): Image.asset("assets/images/VALORES-IMG.png", width: 30,),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
              print(_page);
            });
          },
        ),
        body: _page == 0 ? CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/Adaptaciones-para-GCP-Mo%CC%81vil---Que%CC%81-es-ACP-Club.png?alt=media&token=79ae71dd-c12b-49f1-9767-135ad881925e", imageBuilder: (context, imageProvider) =>
            Container(
             // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ), placeholder: (context, url) => Center( child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Center(child:Icon(Icons.error)))
         : _page == 1 ? CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/Adaptaciones-para-GCP-Mo%CC%81vil---Beneficiarios-ACP-Club.png?alt=media&token=2c98a45f-6c97-4807-89e9-930a488f28b2", imageBuilder: (context, imageProvider) =>
            Container(
              // margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ), placeholder: (context, url) => Center( child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>Center(child:Icon(Icons.error))) : CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/Adaptaciones-para-GCP-Mo%CC%81vil---Requisitos-ACP-Club.png?alt=media&token=4a85d501-6d69-4230-a92e-6740fe3ba9ad", imageBuilder: (context, imageProvider) =>
            Container(
              // padding: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ), placeholder: (context, url) => Center( child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Center(child:Icon(Icons.error))));
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
