import 'dart:async';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:acpmovil/views/login.dart';
import 'package:acpmovil/views/menudrawer_normal.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:video_player/video_player.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

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

class ScreenHome extends DrawerContent {
  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  late VideoPlayerController _controller;
  List usuarios= [];
  int _current = 0;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;



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
          SafeArea(child: _getContent())
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
          children: const [
            FloatingActionButton(
              mini: true,
              elevation: 16,
              backgroundColor: Colors.black38,
              onPressed: null,
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
                MaterialPageRoute(builder: (context) =>  Login()),
              );
              //Navigator.pushNamed(context, "/login");
              //Navigator.push(context, MaterialPageRoute(builder: (context) => Splash()));
            },
            child: const Text('COLABORADOR', style: TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 16),
          const Text("O también puedes acceder como",
              style: TextStyle(fontSize: 12, color: Colors.white)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width / 1.3, 46),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 16,
                primary: const Color(0XFF00796B)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  MenuDrawerNormal()),
              );
              //Navigator.pushReplacementNamed(context, "/menudrawer_normal");
              //Navigator.pushNamed(context, "/menudrawer_normal");
            },
            child: const Text('INVITADO', style: TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 20),
          _getCarouselText(),
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _controller =
        VideoPlayerController.asset("assets/video/video_acp_2019.mp4");
    _controller.initialize().then((_) {
      _controller.play();
      _controller.setVolume(0.0);
      _controller.setLooping(true);
      setState(() {});
    });
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
