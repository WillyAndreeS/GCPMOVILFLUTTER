import 'dart:convert';
import 'dart:io';
import 'package:acpmovil/views/acpclub_flyer.dart';
import 'package:acpmovil/views/acpclub_lonuevo.dart';
import 'package:acpmovil/views/acpclub_promociones.dart';
import 'package:acpmovil/views/beneficios_internos_acpclub.dart';
import 'package:acpmovil/views/miscanjes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/ver_estrellas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:lottie/lottie.dart';

import 'acpclub_quees.dart';
import 'categorias_acpclub.dart';

class AcpClub extends StatefulWidget {
  const AcpClub({Key? key}) : super(key: key);

  @override
  _AcpClubState createState() => _AcpClubState();
}

class _AcpClubState extends State<AcpClub> {
  late final AnimationController _controller;
  List estrellas = [];
  double suma = 0;
  double resta = 0;
  double horas = 0;
  double horas2 = 0;
  String? IDCEL;
  int _current = 0;
  List locales = [];
  List lista = ["","",""];
  int? estado_anim = 0;
  int? estado_anim2 = 0;
  int? estado_anim3 = 0;
  int? estado_anim4 = 0;

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      IDCEL = iosDeviceInfo.identifierForVendor.toString();
      print("IDCEL: "+IDCEL.toString());
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      IDCEL = androidDeviceInfo.androidId.toString();
      print("IDCEL: "+IDCEL.toString());
      return androidDeviceInfo.androidId; // unique ID on Android

    }
  }



  Future<void> getLocales() async{
    locales.clear();
    var menus = FirebaseFirestore.instance.collection("acpclub").doc("locales").collection("salud").orderBy("fecharegistro", descending: true).limit(5);
    QuerySnapshot menu = await menus.get();
    setState((){
      if(menu.docs.isNotEmpty){
        for(var doc in menu.docs){
          print("DATOS: "+doc.id.toString());
          locales.add(doc.data());
        }
        print("GERENTE: "+locales[3]["foto"]);

      }
    });


  }

  Future SaveVisita() async{
    await _getId();
    if(mounted) {
      setState(() {

        final DateTime now = DateTime.now();
        final docUser = FirebaseFirestore.instance.collection("visitas");

        final json = {
          'fecha': now.toString(),
          'idinterfaz': "ACP CLUB",
          'idusuario':  dniUsuario,
          'imagen': "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/gift%20cosechando.gif?alt=media&token=0a5832e2-dca5-4893-95bb-6af7747d6551",
          'icono': "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/estrella-fugaz.gif?alt=media&token=41e52063-b008-43ae-97af-90b03fca9c0e",
          'color': "0XFF3B5977"
        };
        docUser.add(json);
      });
    }
  }

  @override
  void initState() {

    super.initState();
    getLocales();
    SaveVisita();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            child: Container(
                width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(top: 5),
              color: Colors.white.withOpacity(0.7),
              child: Column(children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Container(
                    height: size.height/3,
                    width: size.width,
                    margin: const EdgeInsets.only( top: 10),
                    child:  Row(children: [
                      Container(
                          height: size.height/3,
                          width: size.width,
                          child: Container(
                            height: size.height/1.5,
                            width: size.width,

                            child: CarouselSlider.builder(
                                itemCount: 3,
                                options: CarouselOptions(
                                    autoPlayCurve: Curves.easeInCirc,
                                    enlargeCenterPage: false,
                                    viewportFraction: 0.9,
                                    aspectRatio: 2.0,
                                    initialPage: 0,
                                    autoPlay: true),
                                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                                GestureDetector(
                                  onTap: (){
                                    if(itemIndex == 0){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  AcpClubDetail()));
                                    }else if(itemIndex == 2){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  BeneficiosInternos()));
                                    }

                                  },
                                  child:
                                    Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 10),

                                        height: size.height/5,
                                        width: size.width/1.1,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), image:  DecorationImage(
                                          image: AssetImage( itemIndex == 0 ? "assets/images/APC-240123V2-15.png" : itemIndex == 1 ? "assets/images/Tarjeta-GCP---Beneficios-externos.png": "assets/images/Tarjeta-GCP---Beneficios-internos.png"),
                                          fit: BoxFit.cover,
                                        ) , boxShadow: [
                                          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(-5,10)),

                                        ]),
                                        child: Row (
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                          Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                            Container(width: size.width/2.5,margin: EdgeInsets.only(left: 25, bottom: 25), child: Text( itemIndex == 0 ? "Es un programa de beneficios (internos y externos) exclusivos que ofrece Cerro Prieto.": itemIndex == 2 ? "Brindar la oportunidad a los colaboradores activos y nuevos de conocer diferentes áreas y lugares de la empresa." : "Programa de beneficios externos a partir de un convenio con otras empresas.", style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler"),textAlign: TextAlign.left,),),
                                            //Container(width: size.width/3,padding: EdgeInsets.only( left: 5, top: 5), child: Image.asset("assets/images/explorador.png", height: size.height*0.09,),),
                                          ]),
                                          //Container(width: size.width/4,padding: EdgeInsets.only(top: 5), margin: EdgeInsets.only(left: 5, right: 10), child: Image.asset(itemIndex == 0 ? "assets/images/cupon.png" : itemIndex == 1 ? "assets/images/creativo.png": "assets/images/billete.png", height: size.width*0.5,),),
                                        ],)
                                    ),)
                              ),

                          ))



                    ],),
                  ),



                ],),
                Container(
                  width: size.width,
                  margin: EdgeInsets.only(top: 5, left: 30),
                  child: Text("Categorías", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: "Schyler"),textAlign: TextAlign.left,),
                ),
                SizedBox(height: 30,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    GestureDetector(
                      onTap:() async{
                        setState((){

                          estado_anim =1;

                        });
                        await Future.delayed(const Duration(seconds: 2));
                        setState((){

                          estado_anim =0;

                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  CategoriaAcpClub(categoriadet: "restaurante",)));
                        print("ESTADO: "+estado_anim.toString());


                    },
                      child: Column( children: [
                        Container(
                      margin: EdgeInsets.only(left: 10),
                          child:
                        CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 34,
                      child: ClipOval(

                        child: estado_anim == 0 ?CachedNetworkImage(
                          //color: Colors.green[700],
                          imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/Restaurantes.png?alt=media&token=b8c43705-3782-4f77-980d-712e237e554a',placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ): Center(child:CircularProgressIndicator(strokeWidth: 2.8,)),
                      ),
                    ),),
                        SizedBox(height: 10,),
                        Container(margin: EdgeInsets.only(left: 10),child: Text("Restaurantes", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey),))
                      ]),),
                    SizedBox(width: 30,),
              GestureDetector(
                onTap:() async{
                  setState((){

                    estado_anim2 =1;

                  });
                  await Future.delayed(const Duration(seconds: 2));
                  setState((){

                    estado_anim2 =0;

                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  CategoriaAcpClub(categoriadet: "diversion",)));
                  print("ESTADO: "+estado_anim2.toString());


                },
                child:Column( children: [
                  Container(
                  margin: EdgeInsets.only(left: 10),
                  child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 34,
                      child: ClipOval(
                        child: estado_anim2 == 0 ?CachedNetworkImage(
                          //color: Colors.green[700],
                          imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/Diversio%CC%81n.png?alt=media&token=6459884f-1d39-4efb-a3d4-a6dcc63a00c3',placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ): Center(child:CircularProgressIndicator(strokeWidth: 2.8,)),
                      ),
                    ),),
                  SizedBox(height: 10,),
                  Container(margin: EdgeInsets.only(left: 10),child: Text("Diversión", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey),))
                ])),
                    SizedBox(width: 30,),
              GestureDetector(
                onTap:() async{
                  setState((){

                    estado_anim3 =1;

                  });
                  await Future.delayed(const Duration(seconds: 2));
                  setState((){

                    estado_anim3 =0;

                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  CategoriaAcpClub(categoriadet: "home",)));
                  print("ESTADO: "+estado_anim3.toString());


                },
                child:Column( children: [
                    Container(
                    margin: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 34,
                      child: ClipOval(

                        child:  estado_anim3 == 0 ?CachedNetworkImage(
                          //color: Colors.green[700],
                          imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/Hogar.png?alt=media&token=a3f21d85-ac25-45f0-a6cf-747047aa410b',placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ): Center(child:CircularProgressIndicator(strokeWidth: 2.8,)),
                      ),
                    )),
                  SizedBox(height: 10,),
                  Container(margin: EdgeInsets.only(left: 10),child: Text("Hogar", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey),))
                ])),
                    SizedBox(width: 30,),
              GestureDetector(
                onTap:() async{
                  setState((){

                    estado_anim4 =1;

                  });
                  await Future.delayed(const Duration(seconds: 2));
                  setState((){

                    estado_anim4 =0;

                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  CategoriaAcpClub(categoriadet: "salud",)));
                  print("ESTADO: "+estado_anim4.toString());


                },
                child:Column( children: [
                  Container(
                  margin: EdgeInsets.only(left: 10),
                  child:
                  CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 34,
                      child: ClipOval(

                        child:  estado_anim4 == 0 ?CachedNetworkImage(
                         // color: Colors.green[700],
                          imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/Salud.png?alt=media&token=9100843a-5394-45d8-b4ce-eaea5337ce76',placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ): Center(child:CircularProgressIndicator(strokeWidth: 2.8))
                      ),
                    )),
                  SizedBox(height: 10,),
                  Container(margin: EdgeInsets.only(left: 10),child: Text("Salud", style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey),))
                ]))
                  ],),
                ),
                SizedBox(height: 20,),
                Container(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 30),
                        child: Text("Lo nuevo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: "Schyler"),textAlign: TextAlign.left,),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  AcpClubLonuevo()));
                        },
                        child:Container(
                          margin: EdgeInsets.only(top: 5, right: 15),
                          child: Text("Ver todos >", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kPrimaryColor, fontFamily: "Schyler"),textAlign: TextAlign.left,),
                        )
                      ),
                    ],)
                ),
                Container(
                  height: size.height/4.5,
                  width: size.width,
                  margin: EdgeInsets.only( top: 10),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    Container(
                        height: size.height/4,
                        width: size.width,
                        child: Container(
                          height: size.height/1.5,
                          width: size.width,

                          child: CarouselSlider.builder(
                            itemCount: locales.length,
                            options: CarouselOptions(
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false,
                                viewportFraction: 0.7,
                                aspectRatio: 3.0,
                                initialPage: 1,
                                autoPlay: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }),
                            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                                GestureDetector(
                                  onTap: (){
                                    print("ENLACE: "+locales[itemIndex]["foto"]);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  AcpClubPromo(urlflyer: locales[itemIndex]["foto"], nombre: locales[itemIndex]["nombre"], terminos: locales[itemIndex]["terminos"], idlocal: locales[itemIndex]["idlocal"], cel: locales[itemIndex]["cel"], facebook: locales[itemIndex]["facebook"], instagram:  locales[itemIndex]["instagram"],direccion: locales[itemIndex]["direccion"],)));
                                  },
                                child: CachedNetworkImage(imageUrl: locales[itemIndex]["foto"], imageBuilder: (context, imageProvider) =>  Container(

                                    height: size.height/7,
                                    width: size.width/1.5,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white,image:  DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ), boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(-5,10)),

                                    ]),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                      Row (
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                           // margin: EdgeInsets.only(top:5),
                                            padding: EdgeInsets.only(left: 5),
                                            width: size.width/4,height: size.height/17, decoration: BoxDecoration( borderRadius: BorderRadius.only(topLeft: Radius.circular(25)), image:DecorationImage(
                                  image: AssetImage("assets/images/Tarjeta-de-descuento.png",),fit: BoxFit.fill,) ),
                                  child: Container(alignment: Alignment.centerLeft,margin: EdgeInsets.only(right: 10, left: 5),child: Text(locales[itemIndex]["promocion"], style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),textAlign: TextAlign.left, ),),)

                                        ],),

                                    ],)
                                ), placeholder: (context, url) => Container(

                                    height: size.height/7,
                                    width: size.width/1.5,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white,image:  DecorationImage(
                                      image: AssetImage("assets/images/122840-image.gif"),
                                      fit: BoxFit.cover,
                                    ), boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(-5,10)),

                                    ]),
                                ),),),
                          ),

                        ))



                  ],),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: locales.map((itemCarousel) {
                    int index = locales.indexOf(itemCarousel);
                    return Container(
                      width: 7.0,
                      height: 7.0,
                      margin:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index ? Colors.black : Colors.grey,
                      ),
                    );
                  }).toList(),
                ),



              ])
              /*child: Stack(children: [

                Container(width: size.width, height: size.height/5,decoration: const BoxDecoration( image:  DecorationImage(
                  image: AssetImage("assets/images/carpa2.png"),
                  fit: BoxFit.fill,
                ),)),
                Positioned(
                    top: size.height/5,
                    right: size.width * 0.35,
                    child: Container(padding:EdgeInsets.all(10),
                        child:Image.asset("assets/images/regalo.png",  width: 85,))),
                Positioned(
                    top: size.height/3.3,
                    left: size.width * 0.01,
                    child: Container(padding:EdgeInsets.all(10),
                        child:Image.asset("assets/images/camisa-polo.png",  width: 85,))),
                Positioned(
                    top: size.height/3.3,
                    right: size.width * 0.01,
                    child: Container(padding:EdgeInsets.all(10),
                        child:Image.asset("assets/images/cupon.png",  width: 85,))),
                Positioned(
                    top: size.height/2,
                    left: size.width * 0.15,
                    child: Container(padding:EdgeInsets.all(10),
                        child:Image.asset("assets/images/hamburguesa-con-queso (1).png",  width: 85,))),
                Positioned(
                    top: size.height/2,
                    right: size.width * 0.15,
                    child: Container(padding:EdgeInsets.all(10),
                        child:Image.asset("assets/images/audifonos-inalambricos.png",  width: 85,))),
                Positioned(
                    top: size.height/1.7,
                    right: size.width * 0.15,
                    child: Container(padding:EdgeInsets.all(10),
                        child:Image.asset("assets/images/carro-de-la-carretilla (1).png",  width: 250,))),
                Positioned(
                  //alignment: Alignment.bottomRight,
                    top: size.height/3,
                    right: size.width / 3.5,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10.0,
                                    offset: Offset(0.0, 10.0),
                                  )
                                ]),
                            child: ClipOval(
                                child: Container(
                                  width: size.width/3,
                                    color: kPrimaryColor,
                                    //margin: EdgeInsets.only(top: 45),
                                    padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
                                    child: const Text("DESCRUBRE MAS AQUÍ", style: TextStyle(color: Colors.white,fontFamily: "Schyler", fontWeight: FontWeight.bold, fontSize: 12),textAlign: TextAlign.center,))),
                          ),
                          onTap: () async {
                          },
                        ),
                      ],
                    )),
              ],)*/
            )
          ),
        );
  }
}
