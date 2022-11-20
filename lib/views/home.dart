import 'dart:async';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/login.dart';
import 'package:acpmovil/views/principal_page.dart';
import 'package:acpmovil/views/principalpage.dart';
import 'package:acpmovil/views/screen_home.dart';
import 'package:acpmovil/views/somosacp2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:acpmovil/views/page2.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MainPage extends DrawerContent {
  MainPage({Key? key, this.title});
  final String? title;
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                  child: Material(
                    shadowColor: Colors.transparent,
                    color: Colors.transparent,
                    child: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: widget.onMenuPressed,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget.title!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  MainWidget({Key? key, this.title, this.menu}) : super(key: key);
  final String? title;
  final List? menu;

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  HiddenDrawerController? _drawerController;
  HiddenDrawerController? _drawerController_offline;
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;



  @override
  void initState() {
    super.initState();
    print("ESTADO INTERNET: "+hasInternets.toString());
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() => this.result = result);
    });
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });

   /* _drawerController = HiddenDrawerController(

      initialPage: Somosacp(),

      items: [
        for(int i = 0; i < widget.menu!.length; i++)
         DrawerItem(
          text: Text(widget.menu![i]["descripcion"],
              style: TextStyle(color: Colors.white, fontFamily: "Schyler")),
          image: Image.network(widget.menu![i]["icono"]) ,
          page: widget.menu![i]["descripcion"] == 'Agrícola Cerro Prieto'
              ? Somosacp()
              :
          widget.menu![i]["descripcion"] == 'Cerrar Sesión'
              ? ScreenHome()
              : Page2(),
        )

      ],
    );

    _drawerController_offline = HiddenDrawerController(

      initialPage: Somosacp(),

      items: [
        for(int i = 0; i < widget.menu!.length; i++)
          DrawerItem(
            text: Text(widget.menu![i]["descripcion"],
                style: TextStyle(color: Colors.white, fontFamily: "Schyler")),
            image:  Image.asset("assets/images/gcp_005.png") ,
            page: widget.menu![i]["descripcion"] == 'Agrícola Cerro Prieto'
                ? Somosacp()
                :
            widget.menu![i]["descripcion"] == 'Cerrar Sesión'
                ? ScreenHome()
                : Page2(),
          )

      ],
    );*/


  }
 @override
  void dispose(){
    internetSubscription.cancel();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: HiddenDrawer(
        controller: hasInternets || hasInternet ? _drawerController! : _drawerController_offline,
        header: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children:  <Widget>[
               Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 40,
                  child: ClipOval( child: hasInternets || hasInternet ?  Image.network(url_base+"acp/fotosColaboradores/"+dniUsuario!+".jpg",): Image.asset(
                      "assets/images/ic_colaborador_sf_holder_pg.png"
                  )),

                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
              child: Column(children:  <Widget>[

                 Text(
                  nombreUsuario!,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Text(
                  'www.acpagro.com',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],)

              ),
            ],
          ),
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [kDarkPrimaryColor, kDarkPrimaryColor, kDarkPrimaryColor,]
            // tileMode: TileMode.repeated,
          ),
        ),
      ),
    );
  }
}
