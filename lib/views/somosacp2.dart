import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:acpmovil/main.dart';
import 'package:intl/intl.dart';
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/models/Menu.dart';
import 'package:acpmovil/views/beneficios.dart';
import 'package:acpmovil/views/certificacionespage.dart';
import 'package:acpmovil/views/comunicados.dart';
import 'package:acpmovil/views/conocenos.dart';
import 'package:acpmovil/views/culturapage.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:acpmovil/views/gcpgps.dart';
import 'package:acpmovil/views/page2.dart';
import 'package:acpmovil/views/principalpage.dart';
import 'package:acpmovil/views/screen_contactanos.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:acpmovil/views/screen_gcpmundo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

final List<String> imgListFotos2 = [];

final List<Widget> imageSlidersFotos = imgListFotos2
    .map((item) => Container(
  margin: const EdgeInsets.all(5.0),
  child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: item,
            imageBuilder: (context, imageProvider) =>Container(
              width: 300,
              decoration:  BoxDecoration( image: DecorationImage(
                image:  imageProvider, fit: BoxFit.cover, ),),
            ),
            placeholder: (context, url) => Center(child:CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
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
                  horizontal: 20.0),

            ),
          ),
        ],
      )),
))
    .toList();

String? estado_menu2 = "0";

class Somosacp extends StatefulWidget {
  int? menu = 0;
  Somosacp({Key? key, this.menu}) ;

  @override
  _SomosacpState createState() => _SomosacpState();
}

class _SomosacpState extends State<Somosacp> {
  String nombre = "USER";
  String dni = "00000000";
  late Size size;
  Timer? _timer;
  String? IDCEL;
  bool fullsize = false;
  List menus_ocultos = [];
  String? estado_menu1;
  int indice = 0;
  bool encuestadisponible = false;
  List<LatLng> polylineareaEmpresa = [];
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;



  _obtenerUsuario() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombre = (prefs.get("name") ?? "USER") as String;
      dni = (prefs.get("dni") ?? "00000000") as String;

    });

  }



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

  Future<void> getMenus1() async {
    menus_ocultos.clear();
    var menus1 = FirebaseFirestore.instance
        .collection("menus_ocultos")
        .where("menu", isEqualTo: "comunicados");
    QuerySnapshot menu1 = await menus1.get();


    setState(() {
      if (menu1.docs.isNotEmpty) {
        for (var doc in menu1.docs) {
          print("DATOS: " + doc.id.toString());
          menus_ocultos.add(doc.data());
        }

        print("GERENTE: " + menus_ocultos[0]["estado"]);
        estado_menu2 = menus_ocultos[0]["estado"];
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
            'idinterfaz': "Agricola Cerro Prieto",
            'idusuario': tipoUsuario.toString().toUpperCase() == "INVITADO" ? IDCEL.toString() : dniUsuario,
            'imagen': "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/campo.png?alt=media&token=3c6e181a-ffc7-4d26-97af-9250fbd49917",
            'icono': "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/logoacp.png?alt=media&token=0a69ff5a-42ba-40f0-9228-0cafe89571aa",
            'color' : "0xFF00AB74"
          };
          docUser.add(json);
        });
      }
  }

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((result) {
      if(mounted){
        setState(() => this.result = result);
      }

    });
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      if(mounted){
      setState(() => this.hasInternet = hasInternet);}
    });
    print("ESTADO INTERNET "+hasInternets.toString());
    _obtenerUsuario();
    getMenus1();
    SaveVisita();
    RecibirDatosEncuesta();


  }
//final List<String> titles = ['¿Quiénes Somos?', 'Cultura', 'Certificaciones', 'Contáctanos', 'ACP en el mundo', 'GPS ACP'];

  /*@override
  void dispose(){
    internetSubscription.cancel();
    subscription.cancel();
    super.dispose();
  }*/

  Future<String?> RecibirDatosEncuesta() async {
    List resultado_encuesta = [];
    List encuesta_activa = [];
        var response = await http.post(
            Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
            body: {"accion": "get_encuesta_comunicacionnew", "DNI": dniUsuario, "TIPOUSUARIO": tipoUsuario, "EMPRESA": empresaUsuario});
        // if (mounted) {
        setState(() {
          var extraerData = json.decode(response.body);
          resultado_encuesta = extraerData["resultadoEncuesta"];
          encuesta_activa = extraerData["resultado"];
          print("REST: "+ resultado_encuesta[0]["RESPONDIO_ENCUESTA"].toString());
          if(resultado_encuesta[0]["RESPONDIO_ENCUESTA"].toString() == 'SI' || encuesta_activa.isEmpty){
            encuestadisponible = false;
          }else{
            encuestadisponible = true;
          }

            if(tipoUsuario != "invitado"){
              DateTime now = DateTime.now();
              final DateFormat formatter = DateFormat('MMdd');
              final String formatted = formatter.format(now);
              final String formatted2;

              if(tipoUsuario == "obrero"){
                formatted2 = formatter.format(DateTime.parse(fnacimiento.toString()));
              }else{
                formatted2 = fnacimiento.toString();
              }
              //final String formatted2 = formatter.format(DateTime.parse(fnacimiento.toString()));
              //print("NOW: "+formatted+" -NOW2: "+formatted2.toString());
              print("ENCUESTA: "+encuestadisponible.toString());
              if(formatted2 == formatted){
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) =>
                    const CustomDialogsAlertCumple()));
              }else{
                if(encuestadisponible == true){
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) =>
                          CustomDialogsAlertEncuesta()));
                }else{
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) =>
                      const CustomDialogsAlertIni()));
                }

              }




            }
        });
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

    size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        print("No puedes ir atras");
        // ignore: null_check_always_fails
        return null!;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: widget.menu == 1 ? AppBar(
          backgroundColor: Colors.green[700],
          title: const Text("Conócenos", style: TextStyle(fontFamily: "Schyler"),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop (context, false);
            },
          ),

        ): null,
      body: Container(
        margin: const EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/images/background_gcp.png",),
          fit: BoxFit.cover,
        ),
    ),
    child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.7)
        ),
        child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
    itemCount: menusgcp.length,
    itemBuilder: (BuildContext context, int index) {
      return GestureDetector(
          onTap: ()async {
          if(menusgcp[index]["titulo"] == "GPS ACP") {
            var area = await FirebaseFirestore.instance.collection("areaacp")
                .orderBy("id");
            QuerySnapshot areaacp = await area.get();
            if (areaacp.docs.isNotEmpty) {
              for (var doc in areaacp.docs) {
                polylineareaEmpresa.add(LatLng(
                    doc.get("latitud"), doc.get("longitud")));
                print("GEO: " + doc.get("latitud").toString() + " , " + doc.get(
                    "longitud").toString());
              }
            }
          }
            setState((){
              fullsize = !fullsize;
              print("Full: "+fullsize.toString()+""+index.toString());
              indice = index;
              _timer = Timer (const Duration (milliseconds: 500), () {

                fullsize = false;

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  menusgcp[index]["titulo"] == 'Conócenos' ?Conocenos(): menusgcp[index]["titulo"] == 'Beneficios y líneas de apoyo' ? Beneficios() : menusgcp[index]["titulo"] == 'Certificaciones' ? CertificacionesPage() : menusgcp[index]["titulo"] == 'Contáctanos' ? ConocenosContactanos() : menusgcp[index]["titulo"] == 'Comunicados' ? Comunicado() : GCP_GPS(areaempresa: polylineareaEmpresa,)));
              }


              );
            });

          },
          child: Visibility(
            visible: tipoUsuario == 'invitado' && menusgcp[index]["titulo"] == 'Comunicados' ? false: true,
          child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: indice==index ? fullsize == true ? size.height/6.5 : size.height/7 : size.height/7 ,
        width: fullsize == true ? size.width : size.width,
        margin: EdgeInsets.symmetric(horizontal: indice==index ? fullsize == true ? 10 : 20: 20, vertical: 15),
        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)),/* image: DecorationImage(
          image:  NetworkImage(
            menusgcp[index]["imagen"],
          ), fit: BoxFit.cover, ),*/ color: Colors.green, boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.29), blurRadius: 10.0, offset: Offset(-10,10)),

        ]),
        child: Row(children: [
          Align(alignment: Alignment.center, child: hasInternets || hasInternet ?CachedNetworkImage(
            imageUrl: menusgcp[index]["imagen"],
            imageBuilder: (context, imageProvider) =>Container(
            width: fullsize == true ? size.width/2.3  : size.width / 2.3,
            decoration:  BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)), color:const Color(0xFF0000000).withOpacity(0),image: DecorationImage(
              image:  imageProvider, fit: BoxFit.fill, ),),

            padding: const EdgeInsets.only(top:5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler"))
              ],
            ),
          ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ): CircularProgressIndicator()),
          Align(alignment: Alignment.center, child:Container(
            width: fullsize == true ? size.width/2.5 : size.width/2.5,
            decoration:  BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)), color:const Color(0xFF0000000).withOpacity(0),),
            padding: const EdgeInsets.only(top:5, bottom: 5, left: 2 ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(child: Text(
                menusgcp[index]["titulo"],
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontFamily: "Schyler", fontSize: 19)))
              ],
            ),

          ),),
        ],)
      )));}
    ))/*GridView.builder(
        itemCount: menusgcp.isNotEmpty ? menusgcp.length: 0,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index){
      return menusgcp.isEmpty ? CircularProgressIndicator() :GestureDetector(
          onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  menusgcp[index]["titulo"] == '¿Quiénes somos?' ?MyPrincipalPage(): menusgcp[index]["titulo"] == 'Cultura' ? CulturaPage() : menusgcp[index]["titulo"] == 'Certificaciones' ? CertificacionesPage() : menusgcp[index]["titulo"] == 'Contáctanos' ? ConocenosContactanos() : menusgcp[index]["titulo"] == 'ACP en el mundo' ? GCPMundo() : Page2()));
      },
        child: hasInternets || hasInternet ? Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)), image: DecorationImage(
            image:  NetworkImage(
              menusgcp[index]["imagen"],
            ), fit: BoxFit.cover, ), color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

          ]),
          child: Align(alignment: AlignmentDirectional(0,1), child:Container(
            height: 30,
            width: 200,
            decoration:  BoxDecoration(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)), color:const Color(0xFF0000000).withOpacity(0.5),),

            padding: const EdgeInsets.only(top:5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(menusgcp[index]["titulo"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler"))
              ],
            ),

          ),),
        ) :Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20.0)), image: DecorationImage(
            image:  AssetImage(
              "assets/images/loader.gif",
            ), fit: BoxFit.cover, ), color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

          ]),
          child: Align(alignment: AlignmentDirectional(0,1), child:Container(
            height: 30,
            width: 200,
            decoration:  BoxDecoration(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)), color:const Color(0xFF0000000).withOpacity(0.5),),

            padding: const EdgeInsets.only(top:5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(menusgcp[index]["titulo"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler"))
              ],
            ),

          ),),
        ));
        })*/),));
    }
  }

class CustomDialogsAlertIni extends StatefulWidget {


  const  CustomDialogsAlertIni(
      {Key? key})
      : super(key: key);

  @override
  _CustomDialogsAlertIniState createState() => _CustomDialogsAlertIniState();
}
class _CustomDialogsAlertIniState extends State<CustomDialogsAlertIni> {
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
    imgListFotos2.clear();
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
     /* if(estado_menu2 == "1"){
        var response = await http.post(
            Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
            body: {"accion": "getComunidados_inicio_empresa", "empresa": empresaUsuario});
        if (mounted) {
          setState(() {
            var extraerData = json.decode(response.body);
            comunicados = extraerData["resultado"];
            print("REST: " + comunicados.toString());
            for(int i = 0; i< comunicados.length; i++){
              print("IMG: "+comunicados.length.toString());
              imgListFotos2.add(comunicados[i]["URL_IMG_PREVIA"]);
            }
          });
        }

      }else{*/
      var comunicado = FirebaseFirestore.instance.collection("comunicados").where("EMPRESA",isEqualTo: empresaUsuario).where("ESTADO", isEqualTo: "1").orderBy("FECHAREGISTRO", descending: false);
      QuerySnapshot com = await comunicado.get();
      setState((){
        if(com.docs.isNotEmpty){
          for(var doc in com.docs){
            print("DATOS: "+doc.id.toString());
            comunicados.add(doc.data());
          }
          for(int i = 0; i< comunicados.length; i++){
            print("IMG: "+comunicados.length.toString());
            imgListFotos2.add(comunicados[i]["URL_IMG_PREVIA"]);
          }
        }
      });

    //  }
    }
   /* comunicados.clear();
    imgListFotos2.clear();
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var response = await http.post(
          Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
          body: {"accion": "getComunidados_inicio_empresa", "empresa": empresaUsuario});
      if (mounted) {
        setState(() {
          var extraerData = json.decode(response.body);
          comunicados = extraerData["resultado"];
          print("REST: " + comunicados.toString());
          for(int i = 0; i< comunicados.length; i++){
            print("IMG: "+comunicados.length.toString());
            imgListFotos2.add(comunicados[i]["URL_IMG_PREVIA"]);
          }
        });
      }
    }*/
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
            shape: BoxShape.rectangle,),
          child: Container(height: size.height/1.8, child:Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                comunicados.isNotEmpty? //_getCarouselImagenes():Center(child: Container())
                GestureDetector(onTap: (){
                  final urlImages = [
                    comunicados[_currents]["URL_IMG_PREVIA"].toString()
                  ];
                  openGallery(urlImages, comunicados[_currents]["TITULO"]);
                }, child: Container( height: size.height/2.2,child: CarouselSlider(
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
                ))): Center(child: CircularProgressIndicator()),
                Container(padding: EdgeInsets.symmetric(vertical: 20),color: kPrimaryColor,child:
                Column(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imgListFotos2.map((url) {
                        int index = imgListFotos2.indexOf(url);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric( horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currents == index
                                ? Color.fromRGBO(255, 255, 255, 0.9)
                                : Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                        );
                      }).toList(),
                    ),
                    GestureDetector(onTap: (){final urlImages = [
                      comunicados[_currents]["URL_IMG_PREVIA"].toString()
                    ];
                    openGallery(urlImages,comunicados[_currents]["TITULO"].toString());},child: Container(margin:EdgeInsets.only(top: 10, bottom: 0),child: Text("Ver mas...", style: TextStyle(fontSize: 16, fontFamily: "Schyler",color: Colors.white),textAlign: TextAlign.end,),),),

                  ],)
                ),
              ]),
          ),),
        Positioned(bottom: size.height/2,right: size.width/14,child: Container( child: FloatingActionButton(
          mini: true,
          elevation: 16,
          backgroundColor: Colors.black38,
          onPressed: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),)),
      ],
    );
  }
  void openGallery(List<String> urlImages, String titulo) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => GalleryWidget(
      urlImages: urlImages,titulo: titulo
  )));
}

class CustomDialogsAlertCumple extends StatefulWidget {


  const  CustomDialogsAlertCumple(
      {Key? key})
      : super(key: key);

  @override
  _CustomDialogsAlertCumpleIniState createState() => _CustomDialogsAlertCumpleIniState();
}
class _CustomDialogsAlertCumpleIniState extends State<CustomDialogsAlertCumple> {
  @override
  void initState() {
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 0,
      backgroundColor: Colors.white,
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
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(50),
              image:DecorationImage(
              image: AssetImage("assets/images/103110-confetti-pop.gif"),
              fit: BoxFit.fill,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Container(
            padding: EdgeInsets.only(top: 15),
            height: size.height * 0.50, child:Column(
              //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:  MainAxisAlignment.start,
              children: <Widget>[
                Container(alignment: Alignment.centerLeft,margin:EdgeInsets.symmetric(horizontal: 30),child: Image.asset(empresaUsuario! == "ACP"? "assets/images/acp_002_512.png": empresaUsuario! == "CPC" ? "assets/images/cpc_002_256.png": empresaUsuario! == "ICP" ? "assets/images/icp_002_256.png":"assets/images/qali_002_256.png",width: 30,color: kPrimaryColor,)),
                SizedBox(height: 5,),
                Container(margin:EdgeInsets.symmetric(horizontal: 20),child: Text("FELIZ CUMPLEAÑOS",style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold, fontSize: 25, color: kPrimaryColor),textAlign: TextAlign.left,)),
                Container(margin:EdgeInsets.symmetric(horizontal: 20),child: Text(nombreUsuario!,style: TextStyle(fontFamily: "Schyler",  fontSize: 14),textAlign: TextAlign.left,)),
                SizedBox(height: 10,),
                Container(
                  child:CircleAvatar(
                    backgroundColor: kPrimaryColor,
                    radius: 90,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: 'http://web.acpagro.com/app-gcp/index.php/Imagenfacial/examinarFotoAcpLocation/'+dniUsuario!,placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 170,
                        height: 170,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),),
                SizedBox(height: 20,),
                Container(margin:EdgeInsets.symmetric(horizontal: 20),child: Text("En este día tan especial, donde celebras un año mas de vida, queremos enviarte nuestros mejores deseos y expresar lo feliz que nos sentimos de que integres la familia Cerro Prieto. ¡Vive cada dia en armonía y mucha prosperidad!",style: TextStyle(fontFamily: "Schyler",fontWeight: FontWeight.bold),textAlign: TextAlign.justify,))

              ]),
          ),),
        Positioned(bottom: size.height/2.3,right: size.width/14,child: Container( child: FloatingActionButton(
          mini: true,
          elevation: 16,
          backgroundColor: Colors.black38,
          onPressed: (){
            Navigator.pop(context);
          },
          child:Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),)),
      ],
    );
  }
}

class ValueModel {
  final String? id;
  final String? idpregunta;
  final String? name;
  bool? selected;

  ValueModel(
      this.id,
        this.idpregunta,
        this.name,
        this.selected);
}

class CustomDialogsAlertEncuesta extends StatefulWidget {

    CustomDialogsAlertEncuesta(
      {Key? key})
      : super(key: key);

  @override
  _CustomDialogsAlertEncuestaIniState createState() => _CustomDialogsAlertEncuestaIniState();
}
class _CustomDialogsAlertEncuestaIniState extends State<CustomDialogsAlertEncuesta> {
  List cabecera_pregunta = [];
  List detalle_pregunta = [];
  List encuesta = [];
  List<ValueModel> detalle_pregunta2 = [];
  int indice = 0;
  var gruporadio;
  String? pregunta;
  String ? alternativas = "";
  String ? alerta = "";
  final myControllerRpta = TextEditingController();



  String boton = "Siguiente";
  @override
  void initState() {
    super.initState();
    RecibirDatosEncuesta();
  }

  Future<void> CrearXML(List encuestas) async{
    try {

      StringBuffer xmlEncuesta = StringBuffer();
      String cabeceraXml =
          "<ENCUESTA>";
      String itemXml = "";
      if (encuestas.isNotEmpty) {
        for (var i = 0; i < encuestas.length; i++) {
          print("LISTA ENCUESTA: "+encuestas.toString());
            itemXml += "<Item IDENCUESTA=\""+encuestas[i]["IDENCUESTA"]+"\" DNI=\""+encuestas[i]["DNI"]+"\" PREGUNTA=\""+"P"+encuestas[i]["PREGUNTA"]+"\" RPTA_ALTERNATIVA=\""+encuestas[i]["RPTA_ALTERNATIVA"]+"\" />";
         // print("LISTA ENCUESTA: "+itemXml.toString());
            }
          }
        setState(() {
          String pieXml = "</ENCUESTA>";
          String xml2 = cabeceraXml + itemXml + pieXml;
          print("XML CARGADO$xml2");
          xmlEncuesta.write(xml2);
        });

        if(itemXml != ""){
          print("XML CARGADO"+xmlEncuesta.toString());
          await EnviarEncuesta(xmlEncuesta.toString());
          //saveBox(xmlViajesAcopio.toString(), ddData, widget.idviajeactual!);
        }

    } on Exception catch (e) {
      print('Error causador por: $e');
    }
  }

  Future<void> EnviarEncuesta(String xml) async {
    try {
      final resulte = await InternetAddress.lookup('google.com');
      if (resulte.isNotEmpty && resulte[0].rawAddress.isNotEmpty) {
        String results;
        HttpOverrides.global = MyHttpOverrides();
        var response = await http.post(
            Uri.parse("${url_base}acp/index.php/boleta/EnvioEncuesta"),
            body: {"Encuesta": xml});
        var extraerData = json.decode(response.body);
        results = extraerData["resultado"].toString();
        print("RES1: "+results);
        print("RES2: "+extraerData.toString());

        if (results.toString().contains("TRUE")) {
         // print("inserto....");

          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) =>
              const CustomDialogsAlert(
                title: "Encuesta",
                description:
                "Has terminado correctamente la encuesta",
                imagen: "assets/images/117473-correct.gif",
              ));
        }else{

          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) =>
              const CustomDialogsAlert(
                title: "Encuesta",
                description:
                "Ocurrió un error al registrar tus respuestas, vuelve a intentarlo",
                imagen: "assets/images/117473-correct.gif",
              ));
        }
        // mensaje = results.toString();
      }
    } on Exception catch (e) {
      print('Error causador por: $e');
    }
  }

  Future<String?> RecibirDatosEncuesta() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await http.post(
            Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
            body: {"accion": "get_encuesta_comunicacionnew", "DNI": dniUsuario, "TIPOUSUARIO": tipoUsuario, "EMPRESA": empresaUsuario});
        // if (mounted) {
        setState(() {
          var extraerData = json.decode(response.body);
          cabecera_pregunta = extraerData["resultado"];
          detalle_pregunta = extraerData["resultadoDetalle"];
          if(detalle_pregunta.isNotEmpty){
            for(int i = 0; i<detalle_pregunta.length; i++){
              detalle_pregunta2.add(ValueModel(detalle_pregunta[i]["NRO_ALTERNATIVA"].toString(),detalle_pregunta[i]["NRO_PREGUNTA"].toString(), detalle_pregunta[i]["DES_ALTERNATIVA"],false));
            }

          }
          print("CAB: " + cabecera_pregunta.toString());
          print("DET: " + detalle_pregunta.toString());
        });
      }
    } on SocketException catch (_) {
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
                child: AlertDialog(
                    content: const Text('Revisa tu conexión a internet'),
                    actions: [okButton]));
          });
      print('not connected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: cabecera_pregunta.isNotEmpty ? dialogContents(context):Center(child:CircularProgressIndicator()),
    );
  }

  dialogContents(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child:Container(
          height: size.height * 0.70,
          width: size.width * 0.9,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            padding: EdgeInsets.only(top: 15),
            //height: size.height * 0.8,
            child:Column(
            //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:  MainAxisAlignment.start,
              children: <Widget>[
                Container(alignment: Alignment.centerLeft,margin:EdgeInsets.symmetric(horizontal: 30),child: Image.asset(empresaUsuario! == "ACP"? "assets/images/acp_002_512.png": empresaUsuario! == "CPC" ? "assets/images/cpc_002_256.png": empresaUsuario! == "ICP" ? "assets/images/icp_002_256.png":"assets/images/qali_002_256.png",width: 30,color: kPrimaryColor,)),
                SizedBox(height: 10,),
                Container(margin:EdgeInsets.symmetric(horizontal: 20),child: Text(cabecera_pregunta[0]["TITULO"],style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold, fontSize: 22, color: kPrimaryColor),textAlign: TextAlign.center,)),

                SizedBox(height: 10,),
                Container(margin:EdgeInsets.symmetric(horizontal: 10),child: Text(cabecera_pregunta[indice]["DES_PREGUNTA"],style: TextStyle(fontFamily: "Schyler",  fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                SizedBox(height: 10,),
                Expanded(
                child: Container(
                  width: size.width * 0.9,
                  //height: size.height * 0.4,
                  child:cabecera_pregunta.isEmpty || detalle_pregunta2.isEmpty ? Center(child: CircularProgressIndicator()):ListView.builder(
                //padding: const EdgeInsets.symmetric(horizontal:8),
                itemCount: detalle_pregunta2.length,
                itemBuilder: (BuildContext context, int index) {
                  //print("CANTIDAD: "+detalle_pregunta.length.toString());

                    return Container( child: cabecera_pregunta[indice]["NRO_PREGUNTA"] == detalle_pregunta2[index].idpregunta ?
                    detalle_pregunta2[index].name == "" ?
                        Container(
                            width:
                            MediaQuery.of(context).size.width / 1.3,
                            //height: 10.0,
                            padding: const EdgeInsets.only(
                                top: 15.0,
                                bottom: 0.0,
                                left: 16.0,
                                right: 16.0),
                            decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(16)),
                                color: Color(0xFFFFFFFF),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10.0)
                                ]),
                     child:TextField(
                      maxLines: 7, //or null
                      controller: myControllerRpta,
                      decoration: const InputDecoration.collapsed(hintText: "Ingresa aquí tu respuesta"),
                    )):
                    ListTile(
                      //contentPadding: EdgeInsets.all(10),
                            title:  Text(detalle_pregunta2[index].name.toString(),style: TextStyle(fontFamily: "Schyler", fontSize: 16, color: Colors.black),),
                            leading: Radio<ValueModel>(
                            value: detalle_pregunta2[index],
                            groupValue: gruporadio,
                            onChanged: (value) {
                            setState(() {
                              alternativas = "-1";
                              pregunta = detalle_pregunta2[index].idpregunta;
                              gruporadio = value;
                            });
                          },
                        ),):Container(height: 1,));
                    //Text(detalle_pregunta[index]["DES_ALTERNATIVA"],style: TextStyle(fontFamily: "Schyler", fontSize: 18, color: Colors.black),textAlign: TextAlign.left,): null);
                }),
                ),),
              //  SizedBox(height: 10,),
                Divider(),
                Container(alignment: Alignment.center,margin:EdgeInsets.symmetric(horizontal: 10),child: Text("Pregunta "+(indice+1).toString()+" de "+cabecera_pregunta.length.toString())),

                Text(alerta!, style: TextStyle(color: Colors.red, fontSize: 12),),
                SizedBox(height: 5,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10.0,
                                    offset: Offset(0.0, 10.0),
                                  )
                                ]),
                            child: TextButton(
                              //color: kArandano,
                                onPressed: () {
                                  setState(() {
                                     //print("radio: "+gruporadio.id);
                                  //  if(myControllerRpta.text != "" && gruporadio != null){
                                    alerta = "";
                                    print("indice: "+indice.toString()+ " - "+cabecera_pregunta.length.toString());
                                    if(indice==cabecera_pregunta.length-2){

                                      if(alternativas == "-1"){
                                        if( gruporadio != null) {
                                          boton = "Terminar";
                                          //Navigator.pop(context);
                                          indice = indice+1;
                                          encuesta.add({
                                            "IDENCUESTA": cabecera_pregunta[0]["CODIGO_ENCUESTA"],
                                            "DNI": dniUsuario,
                                            "PREGUNTA": pregunta,
                                            "RPTA_ALTERNATIVA": gruporadio.id
                                          });
                                          //myControllerRpta.text = "";
                                          alternativas = "";
                                          //gruporadio = null;
                                          print("radio: " +
                                              alternativas.toString());
                                        }else{
                                          alerta = "*Debes responder a la pregunta para poder continuar";
                                        }
                                      }else{
                                        if( myControllerRpta.text != "") {
                                          boton = "Terminar";
                                          //Navigator.pop(context);
                                          indice = indice+1;
                                          pregunta = (int.parse(pregunta!) + 1)
                                              .toString();
                                          encuesta.add({
                                            "IDENCUESTA": cabecera_pregunta[0]["CODIGO_ENCUESTA"],
                                            "DNI": dniUsuario,
                                            "PREGUNTA": pregunta,
                                            "RPTA_ALTERNATIVA": myControllerRpta
                                                .text
                                          });
                                          myControllerRpta.text = "";
                                          // gruporadio = null;
                                        }else{
                                          alerta = "*Debes responder a la pregunta para poder continuar";
                                        }
                                      }

                                    }else if(indice==cabecera_pregunta.length-1){
                                      if(alternativas == "-1"){
                                        if( gruporadio != null) {
                                          encuesta.add({
                                            "IDENCUESTA": cabecera_pregunta[0]["CODIGO_ENCUESTA"],
                                            "DNI": dniUsuario,
                                            "PREGUNTA": pregunta,
                                            "RPTA_ALTERNATIVA": gruporadio.id
                                          });
                                          //myControllerRpta.text = "";
                                          alternativas = "";
                                          //gruporadio = null;
                                          print("radio: " +
                                              alternativas.toString());
                                        }else{
                                          alerta = "*Debes responder a la pregunta para poder continuar";
                                        }
                                      }else{
                                        if( myControllerRpta.text != "") {
                                          pregunta = (int.parse(pregunta!) + 1)
                                              .toString();
                                          encuesta.add({
                                            "IDENCUESTA": cabecera_pregunta[0]["CODIGO_ENCUESTA"],
                                            "DNI": dniUsuario,
                                            "PREGUNTA": pregunta,
                                            "RPTA_ALTERNATIVA": myControllerRpta
                                                .text
                                          });
                                          myControllerRpta.text = "";
                                          // gruporadio = null;
                                        }else{
                                          alerta = "*Debes responder a la pregunta para poder continuar";
                                        }
                                      }
                                      Navigator.pop(context);
                                      CrearXML(encuesta);

                                    }else{

                                      if(alternativas == "-1"){
                                        if( gruporadio != null) {
                                          boton = "Siguiente";
                                          indice = indice+1;
                                          encuesta.add({
                                            "IDENCUESTA": cabecera_pregunta[0]["CODIGO_ENCUESTA"],
                                            "DNI": dniUsuario,
                                            "PREGUNTA": pregunta,
                                            "RPTA_ALTERNATIVA": gruporadio.id
                                          });
                                          //myControllerRpta.text = "";
                                          alternativas = "";
                                          //gruporadio = null;
                                          print("radio: " +
                                              alternativas.toString());
                                        }else{
                                          alerta = "*Debes responder a la pregunta para poder continuar";
                                        }
                                      }else{
                                        if( myControllerRpta.text != "") {
                                          boton = "Siguiente";
                                          indice = indice+1;
                                          pregunta = (int.parse(pregunta!) + 1)
                                              .toString();
                                          encuesta.add({
                                            "IDENCUESTA": cabecera_pregunta[0]["CODIGO_ENCUESTA"],
                                            "DNI": dniUsuario,
                                            "PREGUNTA": pregunta,
                                            "RPTA_ALTERNATIVA": myControllerRpta
                                                .text
                                          });
                                          myControllerRpta.text = "";
                                          // gruporadio = null;
                                        }else{
                                          alerta = "*Debes responder a la pregunta para poder continuar";
                                        }
                                      }
                                      //print("Radio: "+gruporadio.id);

                                    }
                                  });
                                },
                                child: Text(
                                  boton,
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                        ],
                      )
                    ],
                  )

              ]),
          ),),)
      ],
    );
  }
}

class CustomDialogsAlert extends StatelessWidget {
  final String? title, description, buttontext, imagen, nombre;
  final Image? image;

  const CustomDialogsAlert(
      {Key? key,
        this.title,
        this.description,
        this.buttontext,
        this.image,
        this.imagen,
        this.nombre})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: dialogContents(context),
    );
  }

  dialogContents(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(50),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                imagen!,
                width: 128,
                height: 128,
              ),
              const SizedBox(height: 20.0),
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Divider(),
              const SizedBox(height: 10.0),
              Text(
                description!,
                style: const TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: Offset(0.0, 10.0),
                            )
                          ]),
                      child: TextButton(
                        //color: kArandano,
                          onPressed: () {

                            Navigator.pop(context);
                          },
                          child: const Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class GalleryWidget extends StatefulWidget{
  final List<String> urlImages;
  final String? titulo;

  GalleryWidget({
    required this.urlImages,
    this.titulo
  });

  @override
  State<StatefulWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget>{
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.green[700],
      title: const Text("Comunicados", style: TextStyle(fontFamily: "Schyler"),),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pop (context, false);
        },
      ),

    ),
    body: PhotoViewGallery.builder(itemCount: widget.urlImages.length, builder: (context, index){
      final urlImage  = widget.urlImages[index];
      return PhotoViewGalleryPageOptions(imageProvider: NetworkImage(urlImage));
    }),
    bottomNavigationBar: Container(color: Colors.black.withOpacity(0.5),padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20) ,child: Text(widget.titulo!, style: TextStyle(fontFamily: "Schyler", fontSize: 16, color: Colors.white)),),
  );
}
