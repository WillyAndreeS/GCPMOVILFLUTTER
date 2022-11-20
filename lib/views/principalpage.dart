
import 'dart:async';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:overlay_support/overlay_support.dart';



class MyPrincipalPage extends DrawerContent {
   MyPrincipalPage({Key? key}) ;

  @override
  MyPrincipalPageState createState() => MyPrincipalPageState();
}

class MyPrincipalPageState extends State<MyPrincipalPage> {
  bool mostrar = false;
  bool mostrar1 = false;
  bool mostrar2 = false;
  bool mostrar3 = false;
  bool mostrar4 = false;
  bool mostrar5 = false;
  bool mostrar6 = false;
  bool mostrar7 = false;
  bool mostrar8 = false;
  bool mostrar9 = false;
  bool latencia = true;
  bool latencia1 = false;
  bool latencia2 = false;
  bool latencia3 = false;
  bool latencia4 = false;
  bool latencia5 = false;
  bool latencia6 = false;
  bool latencia7 = false;
  bool latencia8= false;
  bool latencia9 = false;
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
    getPostsData();
    controller.addListener(() {

      double value = controller.offset/119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
    //print("Estado intenet"+ hasInternet.toString() + " otro inter: "+ result.toString());

  }

  /*@override
  void dispose(){
    internetSubscription.cancel();
    subscription.cancel();
    super.dispose();
  }*/


  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  //final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];
  //int internet_status = 0;



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
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final double categoryHeight = size.height*0.30;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("¿Quiénes somos?",style:TextStyle(fontFamily: "Schyler")),
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
          items:  <Widget>[
            hasInternets ? CachedNetworkImage(imageUrl: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/logoacp.png?alt=media&token=0a69ff5a-42ba-40f0-9228-0cafe89571aa", width: 30,placeholder: (context, url) => CircularProgressIndicator(),
    errorWidget: (context, url, error) => Icon(Icons.error),):
            Image.asset("assets/images/logoacp.png", width: 30,),
            hasInternets ? CachedNetworkImage(imageUrl:"https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/locations.png?alt=media&token=61817749-1fd7-42c2-9189-b9842dfc1298",width: 30,placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)):
            Image.asset("assets/images/locations.png", width: 30,),
            hasInternets ? CachedNetworkImage(imageUrl:"https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/blanco-de-tiro.png?alt=media&token=2940378e-c67a-40e3-a1ae-5823f04bd7da",width: 30,placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error)):
            Image.asset("assets/images/blanco-de-tiro.png", width: 30,)
            ,
            /*Icon(Icons.history, size: 30, color: Colors.white),
            Icon(Icons.book, size: 30, color: Colors.white),*/
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
              image: AssetImage("assets/images/img_fondo_nuestra_empresa.jpeg",),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: const Color.fromRGBO(0,0, 0, 0.4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: const Text("Nuestra Empresa", style: TextStyle(color: Colors.white, fontSize: 22,fontFamily: "Schyler"))
                  ),
                    const SizedBox(height: 20,),
                    Container(
                        padding: const EdgeInsets.all(40),
                        alignment: Alignment.center,
                        child: const Text("En ACP producimos frutos frescos y saludables para el mundo. Nos sentimos orgullosos que nuestras paltas, uvas de mesa, espárrago verde y arándanos estén presentes en  mercados internacionales "
                            "gracias a la pasión por hacer las cosas bien de todo nuestro equipo.\n"
                            "Actualmente, contamos con 4660 hectáreas de terreno agrícola que son producto de desarrollo de una irrigación 100% privada, "
                            "siendo establecidas de agua mediante un canal de 27 km de longitud proveniente del reservorio Gallito Ciego, uno de los más grandes del Perú.", style: TextStyle(color: Colors.white, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.justify)
                    ),
                  ]
                ),),
              ],

            ),
          ),
        ) : _page == 1 ? Container(child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/img_fondo_nuestra_empresa.jpeg",),
                fit: BoxFit.cover,
              ),
            ),
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.only(  bottom: 40),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child:Column(
              children: <Widget>[
                Container(
                  width: size.width,
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  child: const Center( child: Text("¡Esto lo hicimos juntos!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20,fontFamily: "Schyler"),)),
                ),
                SizedBox(
                  width: size.width ,
                child: GestureDetector(
                  onTap: (){
                    setState((){
                      mostrar = !mostrar;
                      latencia = false;
                      latencia1 = true;
                    });
                    print("FUNCIONA TAP: "+mostrar.toString());
                  },
                    child: TimelineTile(
                  alignment: TimelineAlign.center,
               //   startChild: Align(alignment: Alignment.centerRight, child: Container( padding: EdgeInsets.only(right: 10), child: Text("1999", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Schyler"),),)),
                  endChild: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                     // height: size.height/3,
                      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0),), border: Border.all(
                        color: Colors.black.withOpacity(0),
                        width: 3,
                      ), ),
                      child: Align(alignment: Alignment.topCenter, child:Container(
                        decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0),)),

                        padding: const EdgeInsets.all(5),
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  <Widget>[
                            const Align(alignment: Alignment.center,child:
                             Text("1999",  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Schyler"),)),
                            const SizedBox(height: 3,),
                            const Align(alignment: Alignment.topLeft,child:
                            Text("Adquirimos nuevas tierras", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "Schyler"),textAlign: TextAlign.center,)),
                            const SizedBox(height: 5,),
                            AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            width: mostrar == true ? size.width: 0,
                            height: mostrar == true ? size.height/3: 0,
                            child: const Align(alignment: Alignment.topCenter,child:
                             Text("Adquirimos nuevas tierras en una zona desértica, ubicada entre los valles de los rios Jequetepeque y Zaña, pertenecientes a la provincia de Chepen, La Libertad.\n"+"Tras mucho esfuerzo y dedicación, se logró que los terrenos adquiridos se transformaran en prósperos campos de cultivo.", style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12,fontFamily: "Schyler"),textAlign: TextAlign.start, )))
                          ],
                        ),

                      ),),
                    ),
                  isFirst: false,
                  afterLineStyle: const LineStyle(color:amarilloacp, thickness: 9),
                  beforeLineStyle: const LineStyle(color:iconMenu, thickness: 9),
                  indicatorStyle: IndicatorStyle(color: iconMenu, width: 35,
                    height: 60,
                   // padding: const EdgeInsets.symmetric(horizontal: 2),
                    indicator: latencia == true ? Image.asset('assets/images/pulse7.gif',): const Icon(Icons.circle, color: Colors.white, size: 12,),),
            ))),
          SizedBox(
              width: size.width,
              child: GestureDetector(
                  onTap: (){
                    setState((){
                      mostrar1 = !mostrar1;
                      latencia1 = false;
                      latencia2 = true;
                    });
                    print("FUNCIONA TAP: "+mostrar1.toString());
                  },
                  child:TimelineTile(
                alignment: TimelineAlign.center,
              //   endChild:  Align(alignment: Alignment.centerLeft, child: Container( padding: EdgeInsets.only(left: 10), child: Text("2007", style: TextStyle(color: iconMenu, fontWeight: FontWeight.bold, fontSize: 20,fontFamily: "Schyler" ),),)),
                startChild: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)), border: Border.all(
                    color: Colors.black.withOpacity(0),
                    width: 3,
                  ), ),
                  child: Align(alignment: Alignment.topCenter, child:Container(
                    decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)),),

                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:  <Widget>[
                        const Align(alignment: Alignment.center,child:
                        Text("2007", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Schyler"),)),
                        const SizedBox(height: 3,),
                        const Align(alignment: Alignment.topRight,child:
                        Text("Iniciamos operaciones en base a un plan expansivo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "Schyler"),textAlign: TextAlign.center,)),
                        const SizedBox(height: 5,),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      width: mostrar1 == true ? size.width: 0,
                      height: mostrar1 == true ? size.height/3: 0,
                      child: const Align(alignment: Alignment.topCenter,child:
                        Text("Iniciamos operaciones en base a un plan expansivo de crecimiento y desarrollo de una agricultura sostenible y generadora de puestos de trabajo.", style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12,fontFamily: "Schyler"), textAlign: TextAlign.start,)))
                        
                      ],
                    ),

                  ),),
                ),
                isFirst: false,
                afterLineStyle: const LineStyle(color:kAccentColor, thickness: 9),
                beforeLineStyle: const LineStyle(color:amarilloacp, thickness: 9),
                      indicatorStyle: IndicatorStyle(color: iconMenu, width: 35,
                        height: 60,
                        // padding: const EdgeInsets.symmetric(horizontal: 2),
                        indicator: latencia1 == true ? Image.asset('assets/images/pulse7.gif',): const Icon(Icons.circle, color: Colors.white, size: 12,),),
              ))),
          SizedBox(
              width: size.width,
              child:GestureDetector(
                  onTap: (){
                    setState((){
                      mostrar2 = !mostrar2;
                      latencia2 = false;
                      latencia3 = true;
                    });
                    print("FUNCIONA TAP: "+mostrar2.toString());
                  },
                  child:TimelineTile(
                alignment: TimelineAlign.center,
              //  startChild: Align(alignment: Alignment.centerRight, child: Container( padding: EdgeInsets.only(right: 10), child: Text("2010", style: TextStyle(color: kArandano, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: "Schyler"),),)),
                endChild: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)), border: Border.all(
                    color: Colors.black.withOpacity(0),
                    width: 3,
                  ), ),
                  child: Align(alignment: Alignment.topCenter, child:Container(
                    decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)),),

                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:  <Widget>[
                       const Align(alignment: Alignment.center,child:
                        Text("2010", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Schyler"),)),
                        const SizedBox(height: 3,),
                        const Align(alignment: Alignment.topLeft,child:
                        Text("Determinamos priorizar los cultivos permanentes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "Schyler"),textAlign: TextAlign.center,)),
                        const SizedBox(height: 5,),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      width: mostrar2 == true ? size.width: 0,
                      height: mostrar2 == true ? 0: 0,
                      child: const Align(alignment: Alignment.topCenter,child:
                        Text("", style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12,fontFamily: "Schyler"),textAlign: TextAlign.start, )))

                      ],
                    ),

                  ),),
                ),
                isFirst: false,
                afterLineStyle: const LineStyle(color:kArandano, thickness: 9),
                beforeLineStyle: const LineStyle(color:kAccentColor, thickness: 9),
                    indicatorStyle: IndicatorStyle(color: iconMenu, width: 35,
                      height: 60,
                      // padding: const EdgeInsets.symmetric(horizontal: 2),
                      indicator: latencia2 == true ? Image.asset('assets/images/pulse7.gif',): const Icon(Icons.circle, color: Colors.white, size: 12,),),
                    ))),
                SizedBox(
                    width: size.width,
                    child:GestureDetector(
                        onTap: (){
                          setState((){
                            mostrar3 = !mostrar3;
                            latencia3 = false;
                            latencia4 = true;
                          });
                          print("FUNCIONA TAP: "+mostrar3.toString());
                        },
                        child:TimelineTile(
                      alignment: TimelineAlign.center,
                     // endChild: Align(alignment: Alignment.centerLeft, child: Container( padding: EdgeInsets.only(left: 10), child: Text("2012", style: TextStyle(color: kAccentColor, fontWeight: FontWeight.bold, fontSize: 18,fontFamily: "Schyler"),),)),
                      startChild: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)), border: Border.all(
                          color: Colors.black.withOpacity(0),
                          width: 3,
                        ), ),
                        child: Align(alignment: Alignment.topCenter, child:Container(
                          decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)),),

                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              const Align(alignment: Alignment.center,child:
                              Text("2012", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Schyler"),)),
                              const SizedBox(height: 3,),
                              const Align(alignment: Alignment.topRight,child:
                              Text("Ingresamos al negocio de algodón fibra", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "Schyler"),textAlign: TextAlign.center,)),
                              const SizedBox(height: 5,),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            width: mostrar3 == true ? size.width: 0,
                            height: mostrar3 == true ? size.height/5: 0,
                            child: const Align(alignment: Alignment.topCenter,child:
                              Text("Ingresamos al negocio de algodón fibra e incrementamos nuestro nivel de exportación de palta." ,style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12,fontFamily: "Schyler"),textAlign: TextAlign.start, )))

                            ],
                          ),

                        ),),
                      ),
                      isFirst: false,
                      afterLineStyle: const LineStyle(color:kPanetone, thickness: 9),
                      beforeLineStyle: const LineStyle(color:kArandano, thickness: 9),
                          indicatorStyle: IndicatorStyle(color: iconMenu, width: 35,
                            height: 60,
                            // padding: const EdgeInsets.symmetric(horizontal: 2),
                            indicator: latencia3 == true ? Image.asset('assets/images/pulse7.gif',): const Icon(Icons.circle, color: Colors.white, size: 12,),),
                    ))),
                SizedBox(
                    width: size.width,
                    child: GestureDetector(
                        onTap: (){
                          setState((){
                            mostrar4 = !mostrar4;
                            latencia4 = false;
                            latencia5 = true;
                          });
                          print("FUNCIONA TAP: "+mostrar4.toString());
                        },
                        child:TimelineTile(
                      alignment: TimelineAlign.center,
                      //startChild: Align(alignment: Alignment.centerRight, child: Container( padding: EdgeInsets.only(right: 10), child: Text("2014", style: TextStyle(color: iconMenu, fontWeight: FontWeight.bold, fontSize: 18,fontFamily: "Schyler"),),)),
                      endChild: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)), border: Border.all(
                          color: Colors.black.withOpacity(0),
                          width: 3,
                        ), ),
                        child: Align(alignment: Alignment.topCenter, child:Container(
                          decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)),),

                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  <Widget>[
                              const Align(alignment: Alignment.center,child:
                              Text("2014", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Schyler"),)),
                              const SizedBox(height: 3,),
                              const Align(alignment: Alignment.topLeft,child:
                              Text("Inauguramos nueva planta de empaque", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "Schyler"),textAlign: TextAlign.center,)),
                              const SizedBox(height: 5,),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            width: mostrar4 == true ? size.width: 0,
                            height: mostrar4 == true ? size.height/6: 0,
                            child: const Align(alignment: Alignment.topCenter,child:
                              Text( "Inauguramos nueva planta de empaque, además, logramos alinear la estrategia y los principales procesos de negocio.", style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12,fontFamily: "Schyler"),textAlign: TextAlign.start, )))

                            ],
                          ),

                        ),),
                      ),
                      isFirst: false,
                      afterLineStyle: const LineStyle(color:moradoacp, thickness: 9),
                      beforeLineStyle: const LineStyle(color:kPanetone, thickness: 9),
                          indicatorStyle: IndicatorStyle(color: iconMenu, width: 35,
                            height: 60,
                            // padding: const EdgeInsets.symmetric(horizontal: 2),
                            indicator: latencia4 == true ? Image.asset('assets/images/pulse7.gif',): const Icon(Icons.circle, color: Colors.white, size: 12,),),
                    ))),
                SizedBox(
                    width: size.width,
                    child:GestureDetector(
                        onTap: (){
                          setState((){
                            mostrar5 = !mostrar5;
                            latencia5 = false;
                            latencia6 = true;
                          });
                          print("FUNCIONA TAP: "+mostrar5.toString());
                        },
                        child: TimelineTile(
                      alignment: TimelineAlign.center,
                     // endChild: Align(alignment: Alignment.centerLeft, child: Container( padding: EdgeInsets.only(left: 10), child: Text("2015", style: TextStyle(color: moradoacp, fontWeight: FontWeight.bold, fontSize: 18,fontFamily: "Schyler"),),)),
                      startChild: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)), border: Border.all(
                          color: Colors.black.withOpacity(0),
                          width: 3,
                        ), ),
                        child: Align(alignment: Alignment.topCenter, child:Container(
                          decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)),),

                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  <Widget>[
                              const Align(alignment: Alignment.center,child:
                              Text("2015", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Schyler"),)),
                              const SizedBox(height: 3,),
                              const Align(alignment: Alignment.topRight,child:
                              Text("Realizamos por primera vez el proceso de packing", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "Schyler"),textAlign: TextAlign.center,)),
                              const SizedBox(height: 5,),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            width: mostrar5 == true ? size.width: 0,
                            height: mostrar5 == true ? size.height/5: 0,
                            child: const Align(alignment: Alignment.topCenter,child:
                              Text("En ese mismo año, sembramos 87 hectareas de uva y 45 de arándano. Además, nos iniciamos en la agricultura orgánica.", style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12,fontFamily: "Schyler"),textAlign: TextAlign.start, )))

                            ],
                          ),

                        ),),
                      ),
                      isFirst: false,
                      afterLineStyle: const LineStyle(color:kDarkSecondaryColor, thickness: 9),
                      beforeLineStyle: const LineStyle(color:moradoacp, thickness: 9),
                          indicatorStyle: IndicatorStyle(color: iconMenu, width: 35,
                            height: 60,
                            // padding: const EdgeInsets.symmetric(horizontal: 2),
                            indicator: latencia5 == true ? Image.asset('assets/images/pulse7.gif',): const Icon(Icons.circle, color: Colors.white, size: 12,),),
                    ))),
                SizedBox(
                    width: size.width,
                    child:GestureDetector(
                        onTap: (){
                          setState((){
                            mostrar6 = !mostrar6;
                            latencia6 = false;
                            latencia7 = true;
                          });
                          print("FUNCIONA TAP: "+mostrar6.toString());
                        },
                        child:TimelineTile(
                      alignment: TimelineAlign.center,
                    //  startChild: Align(alignment: Alignment.centerRight, child: Container( padding: EdgeInsets.only(right: 10), child: Text("2016", style: TextStyle(color: azulacp, fontWeight: FontWeight.bold, fontSize: 18,fontFamily: "Schyler"),),)),
                      endChild: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)), border: Border.all(
                          color: Colors.black.withOpacity(0),
                          width: 3,
                        ), ),
                        child: Align(alignment: Alignment.topCenter, child:Container(
                          decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)),),

                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  <Widget>[
                              const Align(alignment: Alignment.center,child:
                              Text("2016", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Schyler"),)),
                              const SizedBox(height: 3,),
                              const Align(alignment: Alignment.topLeft,child:
                              Text("Invertimos 1.8 millones de dólares", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "Schyler"),textAlign: TextAlign.center,)),
                              const SizedBox(height: 5,),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            width: mostrar6 == true ? size.width: 0,
                            height: mostrar6 == true ? size.height/5: 0,
                            child: const Align(alignment: Alignment.topCenter,child:
                              Text("Invertimos 1.8 millones de dólares para mejoras en planta procesadora. Exportamos mas de 2,000 contenedores y nos consolidamos con 2,752 ha de cultivos.", style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12,fontFamily: "Schyler"), textAlign: TextAlign.start,)))

                            ],
                          ),

                        ),),
                      ),
                      isFirst: false,
                      afterLineStyle: const LineStyle(color:azulacp, thickness: 9),
                      beforeLineStyle: const LineStyle(color:kDarkSecondaryColor, thickness: 9),
                          indicatorStyle: IndicatorStyle(color: iconMenu, width: 35,
                            height: 60,
                            // padding: const EdgeInsets.symmetric(horizontal: 2),
                            indicator: latencia6 == true ? Image.asset('assets/images/pulse7.gif',): const Icon(Icons.circle, color: Colors.white, size: 12,),),
                    ))),
                SizedBox(
                    width: size.width,
                    child:GestureDetector(
                        onTap: (){
                          setState((){
                            mostrar7 = !mostrar7;
                            latencia7 = false;
                            latencia8 = true;
                          });
                          print("FUNCIONA TAP: "+mostrar7.toString());
                        },
                        child:TimelineTile(
                      alignment: TimelineAlign.center,
                    //  endChild: Align(alignment: Alignment.centerLeft, child: Container( padding: EdgeInsets.only(left: 10), child: Text("2017", style: TextStyle(color: amarilloacp, fontWeight: FontWeight.bold, fontSize: 18,fontFamily: "Schyler"),),)),
                      startChild: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)), border: Border.all(
                          color: Colors.black.withOpacity(0),
                          width: 3,
                        ), ),
                        child: Align(alignment: Alignment.topCenter, child:Container(
                          decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)),),

                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children:  <Widget>[
                              const Align(alignment: Alignment.center,child:
                              Text("2017", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Schyler"),)),
                              const SizedBox(height: 3,),
                              const Align(alignment: Alignment.topRight,child:
                              Text("Nos proyectamos a alcanzar la cantidad de 628 hectáreas", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "Schyler"),textAlign: TextAlign.center,)),
                              const SizedBox(height: 5,),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            width: mostrar7 == true ? size.width: 0,
                            height: mostrar7 == true ? size.height/4: 0,
                            child: const Align(alignment: Alignment.topCenter,child:
                              Text("Nos proyectamos a alcanzar la cantidad de 628 hectáreas de cultivos adicionales distribuidos entre palta (197 has.), uva (115 has), espárrago (212 has.) y arándano (100 has)." , style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12,fontFamily: "Schyler"), textAlign: TextAlign.start,)))

                            ],
                          ),

                        ),),
                      ),
                      isFirst: false,
                      afterLineStyle: const LineStyle(color:kPrimaryColor, thickness: 9),
                      beforeLineStyle: const LineStyle(color:azulacp, thickness: 9),
                          indicatorStyle: IndicatorStyle(color: iconMenu, width: 35,
                            height: 60,
                            // padding: const EdgeInsets.symmetric(horizontal: 2),
                            indicator: latencia7 == true ? Image.asset('assets/images/pulse7.gif',): const Icon(Icons.circle, color: Colors.white, size: 12,),),
                    ))),
                SizedBox(
                    width: size.width,
                    child: GestureDetector(
                        onTap: (){
                          setState((){
                            mostrar8 = !mostrar8;
                            latencia8 = false;
                            latencia9 = true;
                          });
                          print("FUNCIONA TAP: "+mostrar8.toString());
                        },
                        child:TimelineTile(
                      alignment: TimelineAlign.center,
                    //  startChild: Align(alignment: Alignment.centerRight, child: Container( padding: EdgeInsets.only(right: 10), child: Text("2018", style: TextStyle(color: kDarkPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18,fontFamily: "Schyler"),),)),
                      endChild: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)), border: Border.all(
                          color: Colors.black.withOpacity(0),
                          width: 3,
                        ), ),
                        child: Align(alignment: Alignment.topCenter, child:Container(
                          decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)),),

                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const Align(alignment: Alignment.center,child:
                              Text("2018", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Schyler"),)),
                              const SizedBox(height: 3,),
                              const Align(alignment: Alignment.topLeft,child:
                              Text("Exportamos más de 2.000 contenedores", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "Schyler"),textAlign: TextAlign.center,)),
                              const SizedBox(height: 5,),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            width: mostrar8 == true ? size.width: 0,
                            height: mostrar8 == true ? size.height/5: 0,
                            child: const Align(alignment: Alignment.topCenter,child:
                              Text("Exportamos más de 2.000 contenedores y nos consolidamos con 2.752 ha de cultivos. - Iniciamos la certificación azul (huella hídrica).", style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12,fontFamily: "Schyler"),textAlign: TextAlign.start, )))

                            ],
                          ),

                        ),),
                      ),
                      isFirst: false,
                      afterLineStyle: const LineStyle(color:iconMenu, thickness: 9),
                      beforeLineStyle: const LineStyle(color:kPrimaryColor, thickness: 9),
                          indicatorStyle: IndicatorStyle(color: iconMenu, width: 35,
                            height: 60,
                            // padding: const EdgeInsets.symmetric(horizontal: 2),
                            indicator: latencia8 == true ? Image.asset('assets/images/pulse7.gif',): const Icon(Icons.circle, color: Colors.white, size: 12,),),
                    )),),
                SizedBox(
                    width: size.width,
                    child:GestureDetector(
                        onTap: (){
                          setState((){
                            mostrar9 = !mostrar9;
                            latencia9 = false;
                          });
                          print("FUNCIONA TAP: "+mostrar9.toString());
                        },
                        child:TimelineTile(
                      alignment: TimelineAlign.center,
                    //  endChild: Align(alignment: Alignment.centerLeft, child: Container( padding: EdgeInsets.only(left: 10), child: Text("2019", style: TextStyle(color: iconMenu, fontWeight: FontWeight.bold,fontFamily: "Schyler", fontSize: 18),),)),
                      startChild: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)), border: Border.all(
                          color: Colors.black.withOpacity(0),
                          width: 3,
                        ), ),
                        child: Align(alignment: Alignment.topCenter, child:Container(
                          decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)),),

                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              const Align(alignment: Alignment.center,child:
                              Text("2019", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Schyler"),textAlign: TextAlign.center)),
                              const SizedBox(height: 3,),
                              const Align(alignment: Alignment.topRight,child:
                              Text("Iniciamos operaciones en Cerro Prieto Colombia", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: "Schyler"),textAlign: TextAlign.center,)),
                              const SizedBox(height: 5,),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            width: mostrar9 == true ? size.width: 0,
                            height: mostrar9 == true ? size.height/3: 0,
                            child: const Align(alignment: Alignment.topCenter,child:
                              Text("Iniciamos operaciones en Cerro Prieto Colombia. Cerro Prieto construye su primer colegio en Nueva Esperanza, bajo la modalidad de obra por impuestos. Compra de 160 ha adicionales en las pampas de Mocupe (Agrícola Hoja Redonda)", style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12,fontFamily: "Schyler"),textAlign: TextAlign.start, )))
                              
                            ],
                          ),

                        ),),
                      ),
                      isLast: true,
                      beforeLineStyle: const LineStyle(color:iconMenu, thickness: 9),
                          indicatorStyle: IndicatorStyle(color: iconMenu, width: 35,
                            height: 60,
                            // padding: const EdgeInsets.symmetric(horizontal: 2),
                            indicator: latencia9 == true ? Image.asset('assets/images/pulse7.gif',): const Icon(Icons.circle, color: Colors.white, size: 12,),),
                    ))),
                //const SizedBox(height: 30,),
                /*Container(

                  width: size.width,
                  padding: const EdgeInsets.only(top: 50, bottom: 50),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0,0, 0, 0.5),
                  image: DecorationImage(
                    image: AssetImage("assets/images/background_productos_palta.jpg",),
                    fit: BoxFit.cover,
                  ),
                ),
                  child: const Center(child: Text("¡Esto lo hicimos juntos!", style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),),),),
                const SizedBox(height: 20,),
                Expanded(
                    child: ListView.builder(
                        controller: controller,
                        itemCount: itemsData.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          double scale = 1.0;
                          if (topContainer > 0.5) {
                            scale = index + 0.5 - topContainer;
                            if (scale < 0) {
                              scale = 0;
                            } else if (scale > 1) {
                              scale = 1;
                            }
                          }
                          return Opacity(
                            opacity: scale,
                            child: Transform(
                              transform:  Matrix4.identity()..scale(scale,scale),
                              alignment: Alignment.bottomCenter,
                              child: Align(
                                  heightFactor: 0.7,
                                  alignment: Alignment.topCenter,
                                  child: itemsData[index]),
                            ),
                          );
                        })),*/
              ],
            )),),
          ),
        ),) : Container( decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_estrategia_paisaje.jpeg",),
            fit: BoxFit.cover,
          ),
        ), child: Container(
        color: const Color.fromRGBO(0,0, 0, 0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: const Text("Estrategia", style: TextStyle(color: Colors.white, fontSize: 22,fontFamily: "Schyler"))
                  ),
                  const SizedBox(height: 20,),
                  Container(
                      padding: const EdgeInsets.all(40),
                      alignment: Alignment.center,
                      child: const Text("Consolidar la operación agrícola potenciando los procesos de soporte y de gestión, con el objetivo de contar con bases sólidas que nos permiten  "
                          "disponer, en el tiempo, de una cartera de cultivos de calidad y equilibrada en rentabilidad y riesgo. "
                          "Ser el exportador de paltas mas competitivo del Perú.", style: TextStyle(color: Colors.white, fontSize: 16,fontFamily: "Schyler"), textAlign: TextAlign.justify)
                  ),
                ]
            ),),
        ],

      ),
    ),),
    );
  }
}
