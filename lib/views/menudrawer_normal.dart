import 'dart:async';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:acpmovil/views/galeria.dart';
import 'package:acpmovil/views/gcpgps.dart';
import 'package:acpmovil/views/grupo_cerro_prieto.dart';
import 'package:acpmovil/views/juego.dart';
import 'package:acpmovil/views/login.dart';
import 'package:acpmovil/views/page2.dart';
import 'package:acpmovil/views/radio_nativa.dart';
import 'package:acpmovil/views/radio_web.dart';
import 'package:acpmovil/views/screen_acp_club.dart';
import 'package:acpmovil/views/screen_cosechando_estrellas.dart';
import 'package:acpmovil/views/screen_home.dart';
import 'package:acpmovil/views/screen_linea_emergencia.dart';
import 'package:acpmovil/views/screen_revistas_boletines.dart';
import 'package:acpmovil/views/somosacp2.dart';
import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MenuDrawerNormal extends StatefulWidget {
  const MenuDrawerNormal({Key? key, this.menu}) : super(key: key);
  final List? menu;

  @override
  _MenuDrawerNormalState createState() => _MenuDrawerNormalState();
}

class _MenuDrawerNormalState extends State<MenuDrawerNormal> {
  VoidCallback? onMenuPressed;
  int _selectDrawerItem = 0;
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  List<LatLng> polylineareaEmpresa = [];
  List menus_ocultos = [];
  String? estado_menu1;
  ConnectivityResult result = ConnectivityResult.none;


  Future<void> getMenusO() async{
    menus_ocultos.clear();
    var menus = FirebaseFirestore.instance.collection("menus_ocultos").where("menu", isEqualTo: "drawer");
    QuerySnapshot menu = await menus.get();
    setState((){
      if(menu.docs.isNotEmpty){
        for(var doc in menu.docs){
          print("DATOS: "+doc.id.toString());
          menus_ocultos.add(doc.data());
        }

        print("GERENTE: "+menus_ocultos[0]["estado"]);
        estado_menu1 = menus_ocultos[0]["estado"];

      }
    });


  }

  _getDrawerItemWidgetAdministrador(int pos) {
    switch (pos) {
      case 0:
        return Somosacp();
      case 1:
        return RevistasBoletines();
      case 2:
        return AcpClub();
      case 3:
        return Galeria();
      case 4:
        return GCP_GPS(barra: 1,);
      case 5:
        return RadioWidget();
      case 6:
        return LineaEmergencia();
    }
  }

  _getDrawerItemWidgetApple(int pos) {
    switch (pos) {
      case 0:
        return Somosacp();
      case 1:
        return AcpClub();
      case 2:
        return ConstanciaBoleta();
      case 3:
        return LineaEmergencia();
    }
  }

  _getDrawerItemWidgetGerencia(int pos) {
    switch (pos) {
      case 0:
        return GrupoACP();
      case 1:
        return RevistasBoletines();
      case 2:
        return AcpClub();
      case 3:
        return GCP_GPS(barra: 1,);
      case 4:
        return Galeria();
      case 5:
        return RadioWidget();
      case 6:
        return LineaEmergencia();
    }
  }

  _getDrawerItemWidgetObreros(int pos) {
    if(estado_menu1 == "1"){
      switch (pos) {
        case 0:
          return Somosacp();
        case 1:
          return RevistasBoletines();
        case 2:
          return CosechandoEstrellas();
        case 3:
          return AcpClub();
        case 4:
          return ConstanciaBoleta();
        case 5:
          return RadioWidget();
        case 6:
          return LineaEmergencia();
      }
    }else{
      switch (pos) {
        case 0:
          return Somosacp();
        case 1:
          return AcpClub();
        case 2:
          return ConstanciaBoleta();
        case 3:
          return LineaEmergencia();
      }
    }

  }

  _getDrawerItemWidgetInvitados(int pos) {
    switch (pos) {
      case 0:
        return GrupoACP();
      case 1:
        return Somosacp();
      case 2:
        return RevistasBoletines();
      case 3:
        return GCP_GPS(barra: 1,);
      case 4:
        return Galeria();
      case 5:
        return RadioWidget();
      case 6:
        return LineaEmergencia();
    }
  }

  _onSelectItem(int pos) {
    Navigator.of(context).pop();
    setState(() {
      _selectDrawerItem = pos;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("TIPO USUARIO: "+tipoUsuario.toString());
    print("ESTADO INTERNET: "+hasInternets.toString());
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() => this.result = result);
    });
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });
    getMenusO();
   // late MiAplicacion _miAplicacion = MiAplicacion();
   // _miSesion = _miAplicacion.getSesionPreferencias();
  }

  Future<void> cargarAreaACPIni() async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    var area =  await FirebaseFirestore.instance.collection("areaacp").orderBy("id");
    QuerySnapshot areaacp = await area.get();
    if(areaacp.docs.isNotEmpty) {
      for (var doc in areaacp.docs) {
        polylineareaEmpresa.add(LatLng(doc.get("latitud"), doc.get("longitud")));
        print("GEO: "+doc.get("latitud").toString()+" , "+doc.get("longitud").toString());
      }


    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

      //HA INICIADO SESI??N
      return WillPopScope(
          child: Scaffold(
                    drawer: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(45),
                          bottomRight: Radius.circular(45)),
                      child: Drawer(
                        elevation: 20,
                        child: tipoUsuario== 'invitado' ? _getNavBarListItemsUserInvitador(context) : _getNavBarListItemsUserAdministrador(context,nombreUsuario!,dniUsuario!),
                      ),
                    ),
                    appBar: AppBar(
                      backgroundColor: Colors.green[700],
                      //backgroundColor: const Color(0XFF00AB74),
                      title: Row(
                        children: [
                          isPlaying == false ? Image.asset(
                            'assets/images/gcp_movil_001.png',
                            height: 40,
                            fit: BoxFit.cover,
                          ): Row( children: [ FadeInLeft( child: Text("Sintonizando Radio Cerro Prieto", style: TextStyle(fontSize: 13, fontFamily: "Schyler"),)),
                          SizedBox(width: 15,),
                          GestureDetector(onTap:() async{
                            setState((){
                              isPlaying = false;
                            });
                            await audioPlayer.pause();
                            //await audioPlayer.pause();
                          },child: Image.asset(
                            'assets/images/pausa (1).png',
                            height: 20,
                            fit: BoxFit.cover,
                          ))])
                        ],
                      ),
                      actions: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.map_sharp),
                          onPressed: () async{
                            await cargarAreaACPIni();
                            setState((){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => GCP_GPS(areaempresa: polylineareaEmpresa,)));
                            });

                          },
                        ),

                      ],
                    ),
                    body: tipoUsuario=="gerente"? _getDrawerItemWidgetGerencia(_selectDrawerItem) : tipoUsuario =="obrero" ? _getDrawerItemWidgetObreros(_selectDrawerItem): tipoUsuario == "empleado" ? _getDrawerItemWidgetAdministrador(_selectDrawerItem): tipoUsuario == "apple" ? _getDrawerItemWidgetApple(_selectDrawerItem): _getDrawerItemWidgetInvitados(_selectDrawerItem),
                  ),

          onWillPop: () async => false);
  }



  _getColor(int posicion) {
    Color c;
    posicion == _selectDrawerItem
        //? c = const Color(0XFF00AB74)
        ? c = Colors.white
        : c = const Color(0XFF000000);
    return c;
  }

  _getItem(int posicion, String seccion, String icono) {
    if (posicion == _selectDrawerItem) {
      return Container(
        padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
        decoration: const BoxDecoration(
            /*boxShadow: [
              BoxShadow(
                  color: Colors.black45, blurRadius: 10, offset: Offset(0, 3))
            ],*/
            color: Color(0X3000AB74),
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Row(
          children: [
            CachedNetworkImage(imageUrl: icono,width: 20,placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)),
            const SizedBox(
              width: 25,
            ),
            Text(
              seccion,
              style: const TextStyle(
                  color: Color(0XFF00796B), fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
        child: Row(
          children: [
            CachedNetworkImage(imageUrl: icono, width: 20,color: Colors.black87,placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)),
            const SizedBox(
              width: 25,
            ),
            Text(
              seccion,
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
    }
  }

  _getNavBarListItemsUserInvitador(context) {
    return ListTileTheme(
      style: ListTileStyle.drawer,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(""),
            accountEmail: Text(''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: const Color(0XFF00AB74),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/ic_colaborador_sf_holder_pg.png?alt=media&token=751befa6-3774-4fae-a937-4e1ecff16d13',placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 67,
                  height: 67,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    image: AssetImage('assets/images/nav_002.png'),
                    fit: BoxFit.cover)),
          ),
          for(int i = 0; i < widget.menu!.length; i++)
            ListTile(
              title: _getItem(i, widget.menu![i]["descripcion"], hasInternets || hasInternet ? widget.menu![i]["icono"]:   "assets/images/gcp_005.png"),
              selected: (i == _selectDrawerItem),
              onTap: () {
                _onSelectItem(i);
              },
            ),
          const Divider(),
          ListTile(
            selected: (7 == _selectDrawerItem),
            title: _getItem(7, "Salir",  "https://web.acpagro.com/acpmovil/vista/imagenes/cerrar-sesion.png"),
            onTap: () {

              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()));
            },
          ),
        ],
      ),
    );
  }

  _getNavBarListItemsUserAdministrador(context, String nombre, String dni) {
    return ListTileTheme(
      style: ListTileStyle.drawer,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(nombre),
            accountEmail: Text('web.acpagro.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: const Color(0XFF00AB74),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: estado_menu1 == "1"?'http://web.acpagro.com/app-gcp/index.php/Imagenfacial/examinarFotoAcpLocation/$dni':'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/ic_colaborador_sf_holder_pg.png?alt=media&token=751befa6-3774-4fae-a937-4e1ecff16d13',placeholder: (context, url) => CircularProgressIndicator(),
                  //imageUrl: estado_menu1 == "1"?'http://web.acpagro.com/acp/fotosColaboradores/$dni.jpg':'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/ic_colaborador_sf_holder_pg.png?alt=media&token=751befa6-3774-4fae-a937-4e1ecff16d13',placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 67,
                  height: 67,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    image: AssetImage('assets/images/nav_002.png'),
                    fit: BoxFit.cover)),
          ),
          for(int i = 0; i < widget.menu!.length; i++)
          ListTile(
            title: _getItem(i, widget.menu![i]["descripcion"], hasInternets || hasInternet ? widget.menu![i]["icono"]:   "assets/images/gcp_005.png"),
            selected: (i == _selectDrawerItem),
            onTap: () {
              _onSelectItem(i);
            },
          ),
          const Divider(),
          ListTile(
            selected: (7 == _selectDrawerItem),
            title: _getItem(7, "Salir",  "https://web.acpagro.com/acpmovil/vista/imagenes/cerrar-sesion.png"),
            onTap: () {

              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()));
            },
          ),
        ],
      ),
    );
  }
}

