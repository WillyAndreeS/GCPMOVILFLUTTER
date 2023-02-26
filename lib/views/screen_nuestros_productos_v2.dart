import 'dart:async';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/models/producto.dart';
import 'package:acpmovil/views/Nuestros_productos_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _duration = Duration(milliseconds: 300);
const _initialPage = 0.0;

class NuestrosProductosV2 extends StatefulWidget {
  const NuestrosProductosV2({Key? key}) : super(key: key);

  @override
  _NuestrosProductosV2State createState() => _NuestrosProductosV2State();
}

class _NuestrosProductosV2State extends State<NuestrosProductosV2> {
  final _pageProductController =
      PageController(viewportFraction: 0.35, initialPage: _initialPage.toInt());
  final _pageTextController = PageController(initialPage: _initialPage.toInt());
  List<Producto> productos = [];
  List menus_ocultos = [];
  String? estado_menu1;

  double _currentPage = _initialPage;
  double _textPage = _initialPage;

  void _productScrollListener() {
    setState(() {
      _currentPage = _pageProductController.page!;
    });
  }


  /*void showDialogWidget() {
    if (isdialogShown) {
      Future.delayed(Duration(seconds: 1), () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(child:Container(child: Image.asset("assets/images/93447-swipe-up.gif")));
            });
      });
      isdialogShown = true;
      _prefs!.setBool('dialog_open',isdialogShown);
    }
  }*/

  bool isdialogShown = true;
  SharedPreferences? _prefs;

  void _textControllerListener() {
    _textPage = _currentPage;
  }

  Future<void> getMenusO() async{
    menus_ocultos.clear();
    var menus = FirebaseFirestore.instance.collection("menus_ocultos").where("menu", isEqualTo: "nuestros_productos");
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

  @override
  void initState() {
    _currentPage = _initialPage;
    _textPage = _initialPage;
    productos = listaProductos();
    _pageProductController.addListener(_productScrollListener);
    _pageTextController.addListener(_textControllerListener);
    super.initState();
    getMenusO();
    /*SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      isdialogShown = prefs.getBool('dialog_open') ?? false;
      setState(() {});
    });*/
  }

  @override
  void dispose() {
    _pageProductController.removeListener(_productScrollListener);
    _pageProductController.dispose();
    _pageTextController.removeListener(_textControllerListener);
    _pageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //showDialogWidget();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Nuestros Productos", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),
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
        Positioned(
            left: 20,
            right: 20,
            bottom: -size.height * 0.22,
            height: size.height * 0.3,
            child: const DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                    color: Colors.black38,
                    blurRadius: 90,
                    //offset: Offset.zero,
                    spreadRadius: 45)
              ]),
            )),
        Transform.scale(
          scale: 2.5, //1.6
          alignment: Alignment.bottomCenter,
          child: PageView.builder(
              controller: _pageProductController,
              scrollDirection: Axis.vertical,
              itemCount: productos.length + 1, //+1
              onPageChanged: (value) {
                print(value);
                if (value < productos.length) {
                  _pageTextController.animateToPage(
                    value,
                    duration: _duration,
                    curve: Curves.easeOut,
                  );
                }
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const SizedBox.shrink();
                }
                print("index {$index}");
                //final product = productos[index - 1];
                //final result = _currentPage - index + 1;
                //print("currentPage {$_currentPage}/index {$index}");
                final product = productos[index - 1];
                final result = _currentPage - index + 1;
                final value =
                    -0.5 * result + 1; //angulo vision elementos detras
                final opacity = value.clamp(0.0, 1.0);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..translate(0.0, size.height / 2.6 * (1 - value).abs())
                      ..scale(value),
                    child: Opacity(
                      opacity: opacity,
                      child: Column(children: [
                       /* Align(alignment: Alignment.topCenter, child: index<4 ? IconButton(onPressed: (){Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  NuestroProductosWeb(titulo: index == 1 ? "Palta": index == 2 ? "Esparrago": "Arandano",url: index == 1 ? "https://web.acpagro.com/acpmovil/vista/para_productos/producto_palta.php": index == 2 ? "https://web.acpagro.com/acpmovil/vista/para_productos/producto_esparrago.php":"https://web.acpagro.com/acpmovil/vista/para_productos/producto_arandano.php",)));}, icon: Icon(Icons.text_snippet_rounded), color: kPrimaryColor,): Container()),*/
                        SizedBox(height: 30,),
                        Hero(
                          tag: Text(product.nombre, style: TextStyle(fontFamily: "Schyler")),
                          child: Image.asset(product.imagen,
                              fit: BoxFit.fitHeight, width: 110, //fitHeight
                              )),
                        Align(alignment: Alignment.bottomCenter, child: index<3 ? Image.asset("assets/images/swipeup.gif", width: 50,): Container()),
                      ],)
                    ),
                  ),
                );
              }),
        ),

        Positioned(
            left: 20,
            top: 30,
            right: 20,
            height: size.height/5.5,
            child: Column(
              children: [
                Expanded(
                    child: PageView.builder(
                        itemCount: productos.length,
                        controller: _pageTextController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final opacity =
                              (1 - (index - _textPage).abs()).clamp(0.0, 1.0);
                          return Opacity(
                            opacity: opacity,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 0),

                              //padding: const EdgeInsets.all(0),
                              child: Text(
                                productos[index].nombre,
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,fontFamily: "Schyler"
                                ),
                              ),
                            ),
                          );
                        })),
                Expanded( child:
                AnimatedSwitcher(
                  duration: _duration,
                  child: Text(
                    //'\S/. ${productos[_currentPage.toInt()].descripcion.toStringAsFixed(2)}',
                    //productos[_currentPage.toInt()].descripcion,
                    textoDescripcion(_currentPage.toInt()),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                        fontFamily: "Schyler"
                    ),
                    //key: Key(productos[_currentPage.toInt()].nombre),
                    key: Key(keyName(_currentPage.toInt())),
                  ),
                ),),
                SizedBox(height: 5,),
                estado_menu1 == '1' ?
                AnimatedSwitcher(
                  duration: _duration,
                  child: Container(width: size.width/3, child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                            MediaQuery.of(context).size.width /
                                1.3,
                            20),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20)),
                        elevation: 10,
                        primary: const Color(0XFF00AB74)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  NuestroProductosWeb(titulo: _currentPage.toInt() == 0 ? "Palta": _currentPage.toInt() == 1 ? "Espárrago": "Arándano",url: _currentPage.toInt() == 0 ? "https://web.acpagro.com/acpmovil/vista/para_productos/producto_palta.php": _currentPage.toInt() == 1 ? "https://web.acpagro.com/acpmovil/vista/para_productos/producto_esparrago.php":"https://web.acpagro.com/acpmovil/vista/para_productos/producto_arandano.php",)));
                    },
                    child: const Text('Ver mas...'),
                  ),),
                ): Container()
              ],
            )),

        //Container()
      ],
    ));
  }

  String textoDescripcion(int page) {
    if (page > 2) {
      return productos[page - 1].descripcion;
    } else {
      return productos[page].descripcion;
    }
  }

  String keyName(int page) {
    if (page > 2) {
      return productos[page - 1].nombre;
    } else {
      return productos[page].nombre;
    }
  }

  List<Producto> listaProductos() {
    List<Producto> listaProductos = [];
    listaProductos.add(Producto(
        nombre: 'Palta',
        descripcion:
            'Somos fanáticos de la palta y como fanáticos, somos exigentes.',
        imagen: 'assets/images/cultivo_0006_2.png',
        link: 'www.web.acpagro.com/palta'));
    listaProductos.add(Producto(
        nombre: 'Espárrago',
        descripcion:
            'Con cuidado y dedicación nuestros espárragos crecen ricos y saludables.',
        imagen: 'assets/images/cultivo_0020_2.png',
        link: 'www.web.acpagro.com/esparrago'));
    listaProductos.add(Producto(
        nombre: 'Arándano',
        descripcion:
            'Si alguna vez te preguntaste ¿dónde están los mejores arándanos? Están aquí.',
        imagen: 'assets/images/cultivo_0021_2.png',
        link: 'www.web.acpagro.com/arandano'));

    return listaProductos;
  }
}
