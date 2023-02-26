import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:acpmovil/views/login.dart';
import 'package:acpmovil/views/menudrawer_normal.dart';
import 'package:acpmovil/views/screen_trabaja_nosotros.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

final List<String> imgListFotos = [];

final List<ItemCarousel> list = [
  ItemCarousel(
      titulo: "Bienvenid@",
      descripcion:
          "GCP Móvil te da la bienvenida, disfruta de todas sus funcionalidades."),
  ItemCarousel(
      titulo: "Información",
      descripcion:
          "Ten al alcance información de nuestros productos, certificaciones y más."),
  ItemCarousel(
      titulo: "Geolocalización",
      descripcion:
          "Accede activando tu gps, para ubicar lugares de referencia, rutas y más."),
  ItemCarousel(
      titulo: "Multimedia",
      descripcion: "Visualiza fotos, vídeos presentados en nuestra galería."),
  ItemCarousel(
      titulo: "Agenda GCP",
      descripcion:
          "Si eres nuestro colaborador, obtén acceso a la agenda GCP, y sus funcionalidades extras."),
];

final List<Widget> textSliders = list.map((item) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
          child: Text(
        item.titulo,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      )),
      const SizedBox(
        height: 8,
      ),
      Center(
        child: Text(
          item.descripcion,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      )
    ],
  );
}).toList();

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(item, fit: BoxFit.cover, width: 100.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        'No. ${imgList.indexOf(item)} image',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ))
    .toList();

final List<Widget> imageSlidersFotos = imgListFotos
    .map((item) => Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: item,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  //Image.network(item, fit: BoxFit.cover, width: 300,),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                  ),
                ],
              )),
        ))
    .toList();

class ScreenHome extends DrawerContent {
  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  late VideoPlayerController _controller;
  List usuarios = [];
  int _current = 0;
  List comunicados = [];
  bool tipomenu = false;
  List menu = [];
  final List<String> imgListCom = [];
  QuerySnapshot? menus;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  List menus_ocultos = [];
  String? estado_menu1;
  ConnectivityResult result = ConnectivityResult.none;

  Future<void> getMenusO() async {
    menus_ocultos.clear();
    var menus = FirebaseFirestore.instance
        .collection("menus_ocultos")
        .where("menu", isEqualTo: "drawer");
    QuerySnapshot menu = await menus.get();
    setState(() {
      if (menu.docs.isNotEmpty) {
        for (var doc in menu.docs) {
          print("DATOS: " + doc.id.toString());
          menus_ocultos.add(doc.data());
        }

        print("GERENTE: " + menus_ocultos[0]["estado"]);
        estado_menu1 = menus_ocultos[0]["estado"];
      }
    });
  }

  Future<void> getMenus() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    var usuariosF = FirebaseFirestore.instance
        .collection("menu")
        .doc("ACP")
        .collection("invitado");
    menus = await usuariosF.get();

    if (menus!.docs.isNotEmpty) {
      menu.clear();
      for (var doc in menus!.docs) {
        menu.add(doc.data());
      }
      tipomenu = true;
    } else {
      tipomenu = false;
    }
    print(menu.toString());
    Navigator.pop(context);
  }

  Future<void> getMenusgcp() async {
    menusgcp.clear();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    var menuF = FirebaseFirestore.instance.collection("menu_sgcp");
    QuerySnapshot menus = await menuF.get();

    if (menus.docs.isNotEmpty) {
      for (var doc in menus.docs) {
        print("DATOS: " + doc.id.toString());
        menusgcp.add(doc.data());
      }
      print("TITULO: " + menusgcp[0]["titulo"]);
      /*titulomenu = menusgcp[0]["titulo"];
      imagenmenu = menusgcp[0]["imagen"];*/
    }
    Navigator.pop(context);
  }

  Future<void> datosUsuario(nombre, dni, empresa, tipo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("name", nombre.toString());
      prefs.setString("dni", dni.toString());
      prefs.setString("empresa", empresa.toString());
      prefs.setString("tipo", tipo.toString());
      tipoUsuario = tipo.toString();
      dniUsuario = "00000000";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
            width: double.infinity,
            height: double.infinity,
          ),
          _getVideoBackground(context),
          SafeArea(child: _getFabTop()),
          SafeArea(child: _getContent()),
          //   estado_menu1 =="1"? SafeArea(child:  _getFabBottom()):Container()
        ],
      ),
    );
  }

  _getVideoBackground(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          //width: _controller.value.size?.width ?? 0,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }

  _getFabTop() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              mini: true,
              elevation: 16,
              backgroundColor: Colors.black38,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => const CustomDialogsAlert());
              },
              child: Icon(
                Icons.rss_feed,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getFabBottom() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.all(22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn2",
              mini: true,
              elevation: 24,
              backgroundColor: kPrimaryColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TrabajaNosotros()));
              },
              child: Icon(
                Icons.work_history_rounded,
                color: Colors.white,
              ),
            ),
            Text(
              "Trabaja con nosotros",
              style: TextStyle(fontFamily: "Schyler", fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  _getContent() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/logo_blanco_gcp.png",
                  width: 190,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _getIconsButton(),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width / 1.3, 46),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 16,
                primary: const Color(0XFF00AB74)), //Color(0XFF388340)
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
              //Navigator.pushNamed(context, "/login");
              //Navigator.push(context, MaterialPageRoute(builder: (context) => Splash()));
            },
            child: const Text('TRABAJADOR', style: TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 16),
          estado_menu1 == "1"
              ? const Text("O también puedes acceder como",
                  style: TextStyle(fontSize: 12, color: Colors.white))
              : Text(""),
          estado_menu1 == "1"
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.of(context).size.width / 1.3, 46),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 16,
                      primary: const Color(0XFF00796B)),
                  onPressed: () async {
                    await datosUsuario("", "00000000", "", "invitado");
                    await getMenus();
                    await getMenusgcp();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MenuDrawerNormal(menu: menu)),
                    );
                    //Navigator.pushReplacementNamed(context, "/menudrawer_normal");
                    //Navigator.pushNamed(context, "/menudrawer_normal");
                  },
                  child: const Text('INVITADO', style: TextStyle(fontSize: 14)),
                )
              : Container(),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _getCarouselText(),
              SizedBox(height: 50),
              estado_menu1 == "1"
                  ? GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  TrabajaNosotros()));
                },
                  child: Container(
                      margin: EdgeInsets.all(10),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                                  ),

                              /* heroTag: "btn2",
                    elevation: 70,
                    backgroundColor: Colors.black38,
                    onPressed: (){

                    },*/
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/animation_200_leddqzbt.gif",
                                    fit: BoxFit.cover,
                                    width: 84,
                                  ),
                                  const Text(
                                    "TRABAJA CON NOSTROS",
                                    style: TextStyle(
                                        fontFamily: "Schyler",
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ))
                  : Container(),
            ],
          )
        ],
      ),
    );
  }

  _getCarouselImagenes() {
    return Column(children: [
      CarouselSlider(
        items: imageSliders,
        options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imgList.map((url) {
          int index = imgList.indexOf(url);
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index
                  ? Color.fromRGBO(0, 0, 0, 0.9)
                  : Color.fromRGBO(0, 0, 0, 0.4),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  _getCarouselText() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              viewportFraction: 1,
              autoPlay: true,
              height: 90,
              autoPlayInterval: const Duration(seconds: 4),
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          items: textSliders,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: list.map((itemCarousel) {
            int index = list.indexOf(itemCarousel);
            return Container(
              width: 7.0,
              height: 7.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index ? Colors.white : Colors.white54,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  _getIconsButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Center(
            child: Image.asset(
              "assets/images/acp_002_512.png",
              width: 30,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Center(
            child: Image.asset("assets/images/icp_002_256.png", width: 30),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Center(
            child: Image.asset(
              "assets/images/cpc_002_256.png",
              width: 30,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Center(
            child: Image.asset(
              "assets/images/qali_002_256.png",
              width: 30,
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() => this.result = result);
    });
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => hasInternets = hasInternet);
    });
    getMenusO();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _controller =
        VideoPlayerController.asset("assets/video/video_acp_2019.mp4");
    _controller.initialize().then((_) {
      _controller.play();
      _controller.setVolume(0.0);
      _controller.setLooping(true);
    });
    print("FOTOS:" + imgListCom.toString());
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context, builder: (context) => CustomDialogsAlert()));
  }

  @override
  void dispose() {
    _controller.dispose();
    internetSubscription.cancel();
    subscription.cancel();
    super.dispose();
  }
}

class ItemCarousel {
  late String titulo, descripcion;
  ItemCarousel({required this.titulo, required this.descripcion});
}

class CustomDialogsAlert extends StatefulWidget {
  const CustomDialogsAlert({Key? key}) : super(key: key);

  @override
  _CustomDialogsAlertState createState() => _CustomDialogsAlertState();
}

class _CustomDialogsAlertState extends State<CustomDialogsAlert> {
  List comunicados = [];
  final List<String> imgListCom = [];
  int _currents = 0;
  @override
  void initState() {
    super.initState();
    RecibirDatos();
  }

  Future<String?> RecibirDatos() async {
    comunicados.clear();
    imgListFotos.clear();
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var comunicado = FirebaseFirestore.instance
          .collection("comunicados")
          .where("EMPRESA", isEqualTo: "GENERAL").where("ESTADO", isEqualTo: "1")
          .orderBy("FECHAREGISTRO", descending: false);
      QuerySnapshot com = await comunicado.get();
      setState(() {
        if (com.docs.isNotEmpty) {
          for (var doc in com.docs) {
            print("DATOS: " + doc.id.toString());
            comunicados.add(doc.data());
          }
          for (int i = 0; i < comunicados.length; i++) {
            print("IMG: " + comunicados.length.toString());
            imgListFotos.add(comunicados[i]["URL_IMG_PREVIA"]);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      elevation: 0,
      backgroundColor: Colors.black.withOpacity(0.2),
      child: dialogContents(context),
    );
  }

  dialogContents(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
          margin: const EdgeInsets.only(top: 0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            shape: BoxShape.rectangle,
          ),
          child: Container(
            height: size.height / 1.8,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              /* Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:  [
                      FloatingActionButton(
                        mini: true,
                        elevation: 16,
                        backgroundColor: Colors.black38,
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (context) =>
                              const CustomDialogsAlert(
                              ));
                        },
                        child: Icon(
                          Icons.rss_feed,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
              comunicados.isNotEmpty
                  ? //_getCarouselImagenes():Center(child: Container())
                  GestureDetector(
                      onTap: () {
                        final urlImages = [
                          comunicados[_currents]["URL_IMG_PREVIA"].toString()
                        ];
                        openGallery(
                            urlImages, comunicados[_currents]["TITULO"]);
                      },
                      child: Container(
                          height: size.height / 2.2,
                          child: CarouselSlider(
                            items: imageSlidersFotos,
                            options: CarouselOptions(
                                autoPlay: false,
                                enlargeCenterPage: true,
                                aspectRatio: 1.0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currents = index;
                                  });
                                }),
                          )))
                  : Center(child: CircularProgressIndicator()),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  color: kPrimaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imgListFotos.map((url) {
                          int index = imgListFotos.indexOf(url);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currents == index
                                  ? Color.fromRGBO(255, 255, 255, 0.9)
                                  : Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                        }).toList(),
                      ),
                      GestureDetector(
                        onTap: () {
                          final urlImages = [
                            comunicados[_currents]["URL_IMG_PREVIA"].toString()
                          ];
                          openGallery(urlImages,
                              comunicados[_currents]["TITULO"].toString());
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5, bottom: 0),
                          child: Text(
                            "Ver mas...",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Schyler",
                                color: Colors.white),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ],
                  )),
            ]),
          ),
        ),
        Positioned(
            bottom: size.height / 2,
            right: size.width / 14,
            child: Container(
              child: FloatingActionButton(
                mini: true,
                elevation: 16,
                backgroundColor: Colors.black38,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
              ),
            )),
      ],
    );
  }

  void openGallery(List<String> urlImages, String titulo) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => GalleryWidget(urlImages: urlImages, titulo: titulo)));
}

class GalleryWidget extends StatefulWidget {
  final List<String> urlImages;
  final String? titulo;

  GalleryWidget({required this.urlImages, this.titulo});

  @override
  State<StatefulWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text(
            "Comunicados",
            style: TextStyle(fontFamily: "Schyler"),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ),
        body: PhotoViewGallery.builder(
            itemCount: widget.urlImages.length,
            builder: (context, index) {
              final urlImage = widget.urlImages[index];
              return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(urlImage));
            }),
        bottomNavigationBar: Container(
          color: Colors.black.withOpacity(0.5),
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Text(widget.titulo!,
              style: TextStyle(
                  fontFamily: "Schyler", fontSize: 16, color: Colors.white)),
        ),
      );
}
