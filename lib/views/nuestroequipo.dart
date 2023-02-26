
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/directorio.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';



class NuestroEquipoPage extends StatefulWidget {
  NuestroEquipoPage({Key? key}) ;

  @override
  NuestroEquipoPageState createState() => NuestroEquipoPageState();
}

class NuestroEquipoPageState extends State<NuestroEquipoPage> {
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;
  late FocusNode focusUser;
  List gerencias = [];
  List areas = [];
  List dataUser = [];

  @override
  void initState(){
    super.initState();
    focusUser = FocusNode();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() => this.result = result);
    });
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });
    getPostsData();
    controller.addListener(() {

      double value = controller.offset/119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
   // RecibirDatos();
    changeOpacity();
    getGerencias();
    getAreas();

  }

  Future<String?> RecibirDatos(String area) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
        dataUser.clear();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await http.post(
            Uri.parse("${url_base}acpmovil/controlador/usuario.php"),
            body: {"accion": "grupo_trabajo", "area": area});
        // if (mounted) {
        setState(() {
          var extraerData = json.decode(response.body);
          dataUser = extraerData["resultado"];
          print("REST: "+dataUser.toString());
        });

      }
    Navigator.pop(context);
  }


  Future<void> getGerencias() async{
    gerencias.clear();
    var gerenteF = FirebaseFirestore.instance.collection("gerencias");
    QuerySnapshot gerente = await gerenteF.get();
    setState((){
      if(gerente.docs.isNotEmpty){
        for(var doc in gerente.docs){
          print("DATOS: "+doc.id.toString());
          gerencias.add(doc.data());
        }
        print("GERENTE: "+gerencias[0]["nombres"]);

      }
    });


  }

  Future<void> getAreas() async{
    areas.clear();
    var areaF = FirebaseFirestore.instance.collection("areas").orderBy("id");
    QuerySnapshot area = await areaF.get();
    setState((){
      if(area.docs.isNotEmpty){
        for(var doc in area.docs){
          print("DATOS: "+doc.id.toString());
          areas.add(doc.data());
        }
        print("GERENTE: "+areas[0]["nombre"]);

      }
    });


  }

  Future<void> buscarAreas(String nombre) async{

    areas.clear();
    var areaF = FirebaseFirestore.instance.collection("areas").where("nombre",isGreaterThan: nombre.toUpperCase()).where('nombre', isLessThan: nombre.toUpperCase()+'\uf8ff');
    QuerySnapshot area = await areaF.get();
    setState((){
      if(area.docs.isNotEmpty){
        for(var doc in area.docs){
          print("DATOS: "+doc.id.toString());
          areas.add(doc.data());
        }
        print("GERENTE: "+areas.toString());

      }
    });


  }

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  //final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  final myControllerUser2 = TextEditingController();
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Nuestro Equipo", style: TextStyle(fontFamily: "Schyler"),),
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
            hasInternets ? CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/organigrama.png?alt=media&token=f1d91f3f-196d-4034-88bc-f27be0e494fb", width: 30,placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)):
            Image.asset("assets/images/organigrama.png", width: 30,),
            hasInternets ? CachedNetworkImage(imageUrl:"https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/directorio-telefonico.png?alt=media&token=b9498c0f-0523-4c47-a107-d933367120d4",width: 30,placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)): Image.asset("assets/images/directorio-telefonico.png", width: 30,),

          ],
          onTap: (index) {
            setState(() {
              _page = index;
              print(_page);
            });
          },
        ),
        body: _page == 0 ? Container(
         // padding: const EdgeInsets.only(top: 40),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_gcp.png",),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 30),
            color: const Color.fromRGBO(255,255, 255, 0.7),
             child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: const Text("ORGANIGRAMA", style: TextStyle(color: Colors.black, fontSize: 22,fontFamily: "Schyler"))
                  ),
                    const SizedBox(height: 40,),
                    Container(
                      width: size.width/2,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        //margin: const EdgeInsets.symmetric(horizontal: 20),
                     //   alignment: Alignment.centerLeft,
                        decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius:  BorderRadius.all(const Radius.circular(40.0),
                            )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          CircleAvatar(
                            backgroundColor: const Color(0XFF00AB74),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/acp_01.jpg?alt=media&token=4d855253-fdcc-4cdb-b439-1a67e6791ae2',placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                width: 67,
                                height: 67,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Column(children:  [
                             Text("BUSTAMANTE, ALFONSO", style: TextStyle(color: Colors.white, fontSize: 9.5,fontFamily: "Schyler"), textAlign: TextAlign.center),
                            Container(
                              width: 20,
                              child: Divider(thickness: 3,color: Colors.white,),
                            ),

                             Text("Presidente de Directorio", style: TextStyle(color: Colors.white, fontSize: 9.5,fontFamily: "Schyler"), textAlign: TextAlign.center),
                          ],)

                        ],)
                    ),
                    Container(
                      height: 50,
                      child: const VerticalDivider(color: kPrimaryColor,thickness: 4,)
                    ),
                    Container(
                      width: size.width/2,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius:  BorderRadius.all(const Radius.circular(40.0),
                            )
                        ),
                        child: Row(
                          children: [
                          CircleAvatar(
                            backgroundColor: const Color(0XFF00AB74),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/acp_02.jpg?alt=media&token=6781ab9f-72e4-40d3-a38d-7e1ecc068925',placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                width: 67,
                                height: 67,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Column(children:  [
                            const Text("ALFREDO LIRA", style: TextStyle(color: Colors.white, fontSize: 9.5,fontFamily: "Schyler"), textAlign: TextAlign.center),
                            Align(
                              alignment: Alignment.centerLeft,
                              child:
                            Container(
                              alignment: Alignment.centerLeft,
                              width: 30,
                              child: Divider(thickness: 3,color: Colors.white,),
                            ),),

                            const Text("Gerente General", style: TextStyle(color: Colors.white, fontSize: 9.5,fontFamily: "Schyler"), textAlign: TextAlign.center),
                          ],)

                        ],)
                    ),
                    Container(
                        height: 50,
                        width: 0,
                        child: const VerticalDivider(color: kPrimaryColor,thickness: 4,)
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                        width: size.width,
                        height: 0,
                        child: const Divider(color: kPrimaryColor,thickness: 4,)
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Container( height: size.height/6,
                          child:
                      ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: gerencias.length,
                          shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {

                      return Container( padding: const EdgeInsets.symmetric(horizontal: 5), child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              height: size.height/18,
                              width: 0,
                              child: const VerticalDivider(color: kPrimaryColor,thickness: 4,)
                          ),
                          Container(
                            width: size.width/2,
                              height: size.height/9,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius:  BorderRadius.all(const Radius.circular(40.0),
                                  )
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(0XFF00AB74),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl:gerencias[index]["dni"],placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                        width: 67,
                                        height: 67,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  Column(children:  [
                                    Container(
                                      width: size.width / 3.8,
                                      child: Text(gerencias[index]["nombres"], style: TextStyle(color: Colors.white, fontSize: 9.5,fontFamily: "Schyler"), textAlign: TextAlign.center),
                                    ),

                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child:
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: 30,
                                        child: Divider(thickness: 3,color: Colors.white,),
                                      ),),
                                      Container(
                                        width: size.width / 3.8,
                                        child: Text(gerencias[index]["puesto"], style: TextStyle(color: Colors.white, fontSize: 9.5,fontFamily: "Schyler"), textAlign: TextAlign.center),
                                      )

                                  ],)

                                ],)
                          ),
                        ],
                      ));}),),

                    ],),),
                    SizedBox(height: 25,),
                    Container(child: Image.asset("assets/images/swipe.gif", width: size.width/3,))
                  ]
                ),
              ],

            ),
          ),
        ) :  Container(
          // padding: const EdgeInsets.only(top: 40),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_gcp.png",),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: const Color.fromRGBO(255,255, 255, 0.7),
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            child: const Text("Directorio", style: TextStyle(color: Colors.black, fontSize: 22,fontFamily: "Schyler"))
                        ),
                        SizedBox(height: 20,),
                        Container(
                          width:
                          MediaQuery.of(context).size.width / 1.2,
                          //height: 50.0,
                          padding: const EdgeInsets.only(
                              top: 0.0,
                              bottom: 0.0,
                              left: 10.0,
                              right: 10.0),
                          decoration: const BoxDecoration(
                              borderRadius:
                               BorderRadius.all(Radius.circular(16)),
                              color: const Color(0xFFFFFFFF),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 10.0)
                              ]),
                          child: TextField(
                            focusNode: focusUser,
                            //autofocus: true,
                            controller: myControllerUser2,
                            cursorColor: Colors.black,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                                hintText: 'Buscar area',
                                hintStyle: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black45,
                                    fontSize: 15)),
                            onChanged: (text){
                              buscarAreas(text);
                            },
                          ),
                        ),

                        const SizedBox(height: 20,),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child:
                        Container(
                          height: size.height* 0.6,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child:
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: areas.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () async{
                              await RecibirDatos(areas[index]["id"]);
                              print("DATOS COLABORADORES: "+dataUser.toString());
                              setState((){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  DirectorioPage(trabajadores: dataUser,areacol: areas[index]["nombre"],)));

                              });

                            }, child: Container(
                            width: size.width,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), color: Colors.white, boxShadow: [
                              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

                            ]),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0XFF00AB74),
                                  radius: 30,
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl:'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/llamada.png?alt=media&token=fd9da296-2c07-4fbd-b696-46b609026439',placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                 Center(
                                child: Container(
                                  alignment: Alignment.center,
                                    child:
                                Column(

                                  children:  [
                                    Container(
                                      width: size.width * 0.5,
                                      child:
                                  Text(areas[index]["nombre"], style: TextStyle(color: Colors.black, fontSize: 12,fontFamily: "Schyler"), textAlign: TextAlign.center),),
                                  Align(
                                    alignment: Alignment.center,
                                    child:
                                    Container(
                                      alignment: Alignment.center,
                                      width: 30,
                                      child: Divider(thickness: 3,color: Colors.black,),
                                    ),),

                                  Text("Integrantes: "+areas[index]["integrantes"], style: TextStyle(color: kPrimaryColor, fontSize: 11,fontFamily: "Schyler"), textAlign: TextAlign.center),
                                ],)),),

                              ],)
                        ));}),),),
                      ]
                  ),
              ],

            ),
          ),
        )
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
