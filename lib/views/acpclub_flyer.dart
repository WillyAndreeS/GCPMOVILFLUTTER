
import 'dart:async';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:linkable/constants.dart';
import 'package:path_provider/path_provider.dart';



class AcpClubFlyer extends StatefulWidget {
  String? flyer, empresa;
  AcpClubFlyer({Key? key, this.flyer, this.empresa}) ;

  @override
  AcpClubFlyerState createState() => AcpClubFlyerState();
}

class AcpClubFlyerState extends State<AcpClubFlyer> {
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
  String? _localFile;

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
        title:  Text(widget.empresa!, style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),
        body: CachedNetworkImage(imageUrl: widget.flyer!, imageBuilder: (context, imageProvider) =>
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ), placeholder: (context, url) => Center( child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Center(child:Icon(Icons.error)))
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
