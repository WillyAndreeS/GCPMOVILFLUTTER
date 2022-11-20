import 'dart:core';

import 'package:acpmovil/views/certificacionespage.dart';
import 'package:acpmovil/views/culturapage.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:acpmovil/views/principalpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';


/*class Somosacp extends DrawerContent {
  @override
  _SomosacpState createState() => _SomosacpState();
}

class _SomosacpState extends State<Somosacp> {
@override

Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHomePage(),
    );
  }
}*/

class Somosacp extends DrawerContent {
  Somosacp({Key? key}) ;

  @override
  _SomosacpState createState() => _SomosacpState();
}

class _SomosacpState extends State<Somosacp> {
  String nombre = "USER";
  String dni = "00000000";
  late Size size;

  _obtenerUsuario() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombre = (prefs.get("name") ?? "USER") as String;
      dni = (prefs.get("dni") ?? "00000000") as String;
    });
  }

  @override
  void initState() {
    super.initState();
    _obtenerUsuario();
    //_showDialog();

  }
final List<String> titles = ['¿Quiénes Somos?', 'Cultura', 'Certificaciones', 'Contáctanos', 'ACP en el mundo', 'GPS ACP'];



  @override
  Widget build(BuildContext context) {
    final List<Widget> images = [
      //BuildContext context;
      GestureDetector(
        onTap: (){
          print("HOLAaaa");
           Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  MyPrincipalPage()));
        },
        child: Hero(
            tag: '¿Quiénes Somos?',
            child: GestureDetector(
                onTap: (){
                  print("HOLAaaa");
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  MyPrincipalPage()));
                },
                child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                'https://web.acpagro.com/acpmovil/vista/imagenes/img_quienes_somos.jpeg',
                fit: BoxFit.cover,
              ),
            ))),),
    GestureDetector(
      onTap: (){
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  CulturaPage()));
      },
      child:Hero(
          tag: 'Cultura',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              'https://web.acpagro.com/acpmovil/vista/imagenes/img_mvv.jpeg',
              fit: BoxFit.cover,
            ),
          )),),
            GestureDetector(
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  CertificacionesPage()));
              },
              child:Hero(
                    tag: const Text('Certificaciones', style: TextStyle(fontSize: 12),),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        'https://web.acpagro.com/acpmovil/vista/imagenes/certificaciones_planta_empaque.jpg',
                        fit: BoxFit.cover,
                      ),
                    )),),
      Hero(
          tag: 'Contáctanos',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              'https://web.acpagro.com/acpmovil/vista/imagenes/img_contactanos.jpeg',
              fit: BoxFit.cover,
            ),
          )),
      Hero(
          tag: 'ACP en el mundo',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              'https://web.acpagro.com/acpmovil/vista/imagenes/img_acp_mundo.jpg',
              fit: BoxFit.cover,
            ),
          )),
      Hero(
          tag: 'GPS ACP',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              'https://web.acpagro.com/acpmovil/vista/imagenes/img_acp_mundo_offline.jpg',
              fit: BoxFit.cover,
            ),
          )),
    ];
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        print("No puedes ir atras");
        // ignore: null_check_always_fails
        return null!;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: Image.asset('assets/images/gcp_movil_001.png', scale: 5),
          leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: widget.onMenuPressed
                  /*(){
                print("HOLA");
              }*/
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.map_sharp),
              onPressed: () {},
            ),

          ],


        ),
      body: Container(
          decoration: const BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/images/background_gcp.png"),
          fit: BoxFit.cover,
        ),
    ),
    child: SafeArea(
        child: Column(
          children: [
          SizedBox(
            height: 65,
            width: double.infinity,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              //child: Image.network('https://i1.wp.com/instructivetech.com/wp-content/uploads/2021/10/cropped-it.png?fit=250%2C166&amp;ssl=1'),
          ),
        ),
  Expanded(child: VerticalCardPager(
          titles: titles,
          images: images,
          textStyle: const TextStyle(color:  Colors.white, fontWeight: FontWeight.bold,fontSize: 12),
          initialPage: 0,
          align: ALIGN.CENTER,
        ))
      ],
    ),),),));
    }
  }