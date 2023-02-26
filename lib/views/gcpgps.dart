import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/vista_panoramica.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/FormHelper.dart';



class GCP_GPS extends StatefulWidget {
  List<LatLng>? areaempresa;
  int? barra = 0;
   GCP_GPS({Key? key, this.areaempresa, this.barra}) : super(key: key);

  @override
  _GCP_GPSState createState() => _GCP_GPSState();
}

class _GCP_GPSState extends State<GCP_GPS> {
  final _initialCameraPosition =
      const CameraPosition(target: LatLng(-7.0701250, -79.5595940), zoom: 13);
  PolylinePoints? polylinePoints;
  final Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocationes;
  String googleAPIKey = 'AIzaSyAdmGQXzvbjhsnS4j56yA7tAW_rHJqUWe8';
  Location? location;
  final Set<Polyline> _polylines = {};
  final Set<Polygon> _polygons = HashSet<Polygon>();
  List listacultivos = [];
  List listalugares = [];
  Set<Marker> _markers = HashSet<Marker>();
  List<LatLng> sectoresara = [];
  List<LatLng> polylineLatLongs = [];
  List<Polygon> myPolygons = [];
  List<LatLng> polylineareaEmpresa = [];
  String cultivoseleccionado = "";
  String lugarseleccionado = "";
  Map<PolygonId, Polygon> mapsPolygons = <PolygonId, Polygon>{};
  double? longinicial = -79.5595940;
  BitmapDescriptor? _markerIcon;
  double? latinicial = -7.0701250;
  GoogleMapController? _mapController;
  BitmapDescriptor? sourceIcones;
  List data1 = [];
  final myControllerLugar = TextEditingController();
  String? distancia;
  String? idpuntopartida;
  List lugares = [];
  List<String> lugaresdescripcion = [];
  String? alias;
  String? latidesdito, longidestino;
  String? IDCEL;
  List menus_ocultos = [];
  List ppartido = [];
  String? estado_menu1;

  Future<void> getMenusO() async{
    menus_ocultos.clear();
    var menus = FirebaseFirestore.instance.collection("menus_ocultos").where("menu", isEqualTo: "gps");
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

  Future SaveVisita() async{
    await _getId();
    if(mounted) {
      setState(() {

        final DateTime now = DateTime.now();
        final docUser = FirebaseFirestore.instance.collection("visitas");

        final json = {
          'fecha': now.toString(),
          'idinterfaz': "GPS GCP",
          'idusuario':  tipoUsuario.toString().toUpperCase() == "INVITADO" ? IDCEL.toString() : dniUsuario,
          'imagen': "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/mapa%20(1).png?alt=media&token=50f01105-2fef-40c1-a256-ec90d4b01173",
          'icono': "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/mapa.png?alt=media&token=edbced2d-aa72-4e65-a8dc-3a59e4589788",
          'color': "0xFFE0C354"
        };
        docUser.add(json);
      });
    }
  }




  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    getMenusO();
    _setMarkerIcon();
    setSourceAndDestinationIcons();
    cargarAreaACPIni();
    cargarCultivosACP();
    cargarLugaresACP();
    SaveVisita();
    location = Location();
    polylinePoints = PolylinePoints();
    location!.onLocationChanged.listen((LocationData cLoc) {
      currentLocationes = cLoc;
      updatePinOnMap();
    });

    setInitialLocation();
  }

  void setInitialLocation() async {
    currentLocationes = await location!.getLocation();
  }

  Future<String?> RecibirDatosLugares() async {
    lugaresdescripcion.clear();
    lugares.clear();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await http.post(
            Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
            body: {"accion": "lugares"});
        // if (mounted) {
        setState(() {
          var extraerData = json.decode(response.body);
          lugares = extraerData["resultado"];
          print("REST: "+lugares.toString());
          for(int i = 0; i<lugares.length; i++){
            lugaresdescripcion.add(lugares[i]["DESCRIPCION"].toString());
          }
        });


      }
      //Navigator.pop(context);
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

    //print("NAME: " + data[0]['TRANSPNAME']);
  }

  Future<void>mostrarLugares() async{


    if(lugarseleccionado == "todo"){
      _markers.removeWhere((m) => m.markerId.value.isNotEmpty);
      myPolygons.removeWhere((m) => m.polygonId.value.isNotEmpty);
      myPolygons.clear();
      cargarAreaACP();
      CameraPosition cPosition = const CameraPosition(
        zoom:  12,
        tilt:  90,
        target:
        LatLng(-7.044523721070196, -79.54406250797966),
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            final size = MediaQuery.of(context).size;
            return AlertDialog(
                backgroundColor: Colors.white.withOpacity(0),
                content:Container(
                    width: size.width * 0.8,
                    height: size.height / 6,
                    decoration: const BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(30.0)), color: Colors.white,),
                    child: Column( children: [
                      const SizedBox(height: 10,),
                      Center(
                        child: Image.asset("assets/images/camino.gif",width: 50,),
                      ),
                      const SizedBox(height: 10,),
                      Container(child:Text("MOSTRANDO LUGARES..."))])));
          });
      var lugar =   FirebaseFirestore.instance.collection("lugaresacp");
      QuerySnapshot lugares = await lugar.get();
      if(lugares.docs.isNotEmpty){
        for(var doc in lugares.docs){

          final docRef =  FirebaseFirestore.instance.collection("lugaresacp").doc(doc.id).collection("geolocalizacion");
          QuerySnapshot marcador = await docRef.get();

          for(var mod in marcador.docs){
            print("LUGARES: "+mod.get("descripcion"));
              _markers.add(
                  Marker(
                      markerId: MarkerId(mod.get("descripcion").toString().contains("PARADERO") ? mod.get("descripcion")+""+mod.get("cultivo"):  mod.get("descripcion")),
                      infoWindow: InfoWindow(title: mod.get("descripcion").toString().contains("PARADERO") ? mod.get("descripcion")+" - Cultivo: " +mod.get("cultivo"):mod.get("descripcion") ),
                      position: LatLng(mod.get("latitud"), mod.get("longitud")),
                      icon: await MarkerIcon.downloadResizePicture(
                  url: mod.get("icono"), imageSize: 70),),
              );
          }
        }
      }
      Navigator.pop(context);
    }else{
      _markers.removeWhere((m) => m.markerId.value.isNotEmpty);
      myPolygons.removeWhere((m) => m.polygonId.value.isNotEmpty);
      myPolygons.clear();
      cargarAreaACP();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            final size = MediaQuery.of(context).size;
            return AlertDialog(
                backgroundColor: Colors.white.withOpacity(0),
                content:Container(
                    width: size.width * 0.8,
                    height: size.height / 6,
                    decoration: const BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(30.0)), color: Colors.white,),
                    child: Column( children: [
                      const SizedBox(height: 10,),
                      Center(
                        child: Image.asset("assets/images/camino.gif",width: 50,),
                      ),
                      const SizedBox(height: 10,),
                      Container(child:Text("MOSTRANDO "+lugarseleccionado.toUpperCase()+"..."))])));
          });

      final docRef =  FirebaseFirestore.instance.collection("lugaresacp").doc(lugarseleccionado).collection("geolocalizacion");
      QuerySnapshot modulos = await docRef.get();

      for(var mod in modulos.docs){
          print("LUGARES: "+mod.get("descripcion"));
          _markers.add(
            Marker(
              markerId: MarkerId(mod.get("descripcion").toString().contains("PARADERO") ? lugarseleccionado+""+mod.get("descripcion")+""+mod.get("cultivo"): lugarseleccionado+""+mod.get("descripcion")),
              infoWindow: InfoWindow(title: mod.get("descripcion").toString().contains("PARADERO") ? mod.get("descripcion")+" "+mod.get("cultivo").toString().toUpperCase() : mod.get("descripcion")),
              position: LatLng(mod.get("latitud"), mod.get("longitud")),
              icon: await MarkerIcon.downloadResizePicture(
                  url: mod.get("icono"), imageSize: 70),),
          );
      }
      Navigator.pop(context);
    }


  }


  Future<void>mostrarCultivos() async{

    if(cultivoseleccionado == "todos"){
      _markers.removeWhere((m) => m.markerId.value.isNotEmpty);
      myPolygons.removeWhere((m) => m.polygonId.value.isNotEmpty);
      myPolygons.clear();
      cargarAreaACP();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            final size = MediaQuery.of(context).size;
            return AlertDialog(
                backgroundColor: Colors.white.withOpacity(0),
                content:Container(
                    width: size.width * 0.8,
                    height: size.height / 6,
                    decoration: const BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(30.0)), color: Colors.white,),
                    child: Column( children: [
                      const SizedBox(height: 10,),
                      Center(
                        child: Image.asset("assets/images/camino.gif",width: 50,),
                      ),
                      const SizedBox(height: 10,),
                      Container(child:Text("MOSTRANDO CULTIVOS..."))])));
          });
      String colorcultivo ="";
      List data = [];
      var objeto;
      var cultivoF =   FirebaseFirestore.instance.collection("cultivo");
      QuerySnapshot cultivos = await cultivoF.get();
      if(cultivos.docs.isNotEmpty){
        for(var doc in cultivos.docs){

          final docRef =  FirebaseFirestore.instance.collection("cultivo").doc(doc.id).collection("modulos");
          QuerySnapshot modulos = await docRef.get();
          final recursos =  FirebaseFirestore.instance.collection("cultivo").doc(doc.id).collection("recursos");
          QuerySnapshot colorlinea = await recursos.get();
          for(var color in colorlinea.docs){
            colorcultivo = color.get("color");
          }
          for(var mod in modulos.docs){
            final puntos =  FirebaseFirestore.instance.collection("cultivo").doc(doc.id).collection("modulos").doc(mod.id).collection("geolocalizacion").orderBy("id");
            QuerySnapshot geo = await puntos.get();

            for(var pgeo in geo.docs){
              objeto = {
                "ID": doc.id+""+mod.id,
                "GEO": LatLng(pgeo.get("latitud"),pgeo.get("longitud"))
              };
              data.add(objeto);

            }
            final areas =  FirebaseFirestore.instance.collection("cultivo").doc(doc.id).collection("modulos").doc(mod.id).collection("area");
            QuerySnapshot area = await areas.get();
            for(var areacampo in area.docs){
              _markers.add(
                Marker(
                  markerId: MarkerId(doc.id+""+areacampo.id),
                  position: LatLng(areacampo.get("latitud"), areacampo.get("longitud")),
                  icon: await MarkerIcon.downloadResizePicture(
                      url: areacampo.get("icono"), imageSize: 80),),
              );
            }
            setState((){
              List<LatLng> coordsToAdd = [];

              for( int i = 0; i<data.length; i++ ){
                if(doc.id+""+mod.id == data[i]["ID"]){
                  coordsToAdd.add(data[i]["GEO"]);
                }
              }
              myPolygons.add(
                  Polygon(
                    // given polygonId
                    polygonId: PolygonId(
                        doc.id + "" + mod.id),
                    // initialize the list of points to display polygon
                    points: coordsToAdd,
                    // given color to polygon
                    fillColor: Color(int.parse(colorcultivo)).withOpacity(0.3),
                    // given border color to polygon
                    strokeColor: Color(int.parse(colorcultivo)),
                    //  geodesic: true,
                    // given width of border
                    strokeWidth: 4,
                  )
              );
            });
          }
        }
      }
      Navigator.pop(context);
    }else if(cultivoseleccionado == ""){
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            final size = MediaQuery.of(context).size;
            return AlertDialog(
                backgroundColor: Colors.white.withOpacity(0),
                content:Container(
                    width: size.width * 0.8,
                    height: size.height / 6,
                    decoration: const BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(30.0)),),
                    child:
                      Center(
                        child: CircularProgressIndicator(),
                      ),));
          });
      var area =   FirebaseFirestore.instance.collection("areaacp").orderBy("id");
      QuerySnapshot areaacp = await area.get();
      if(areaacp.docs.isNotEmpty) {
        for (var doc in areaacp.docs) {
          polylineareaEmpresa.add(LatLng(doc.get("latitud"), doc.get("longitud")));
          print("GEO: "+doc.get("latitud").toString()+" , "+doc.get("longitud").toString());
        }
        myPolygons.add(
            Polygon(
              // given polygonId
              polygonId: PolygonId("areaGcp"),
              // initialize the list of points to display polygon
              points: polylineareaEmpresa,
              // given color to polygon
              fillColor: kPrimaryColor.withOpacity(0.1),
              // given border color to polygon
              strokeColor: kPrimaryColor,
              //  geodesic: true,
              // given width of border
              strokeWidth: 4,
            )
        );

      }
      Navigator.pop(context);
    }else{
      _markers.removeWhere((m) => m.markerId.value.isNotEmpty);
      myPolygons.removeWhere((m) => m.polygonId.value.isNotEmpty);
      myPolygons.clear();
      cargarAreaACP();

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            final size = MediaQuery.of(context).size;
            return AlertDialog(
                backgroundColor: Colors.white.withOpacity(0),
                content:Container(
                    width: size.width * 0.8,
                    height: size.height / 6,
                    decoration: const BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(30.0)), color: Colors.white,),
                    child: Column( children: [
                      const SizedBox(height: 10,),
                      Center(
                        child: Image.asset("assets/images/"+cultivoseleccionado+".gif",width: 50,),
                      ),
                      const SizedBox(height: 10,),
                      Container(child:Text("MOSTRANDO "+cultivoseleccionado.toUpperCase()+"..."))])));
          });
      String colorcultivo ="";
      List data = [];
      var objeto;
      final docRef =  FirebaseFirestore.instance.collection("cultivo").doc(cultivoseleccionado).collection("modulos");
      QuerySnapshot modulos = await docRef.get();
      final recursos =  FirebaseFirestore.instance.collection("cultivo").doc(cultivoseleccionado).collection("recursos");
      QuerySnapshot colorlinea = await recursos.get();
      for(var color in colorlinea.docs){
        colorcultivo = color.get("color");
      }
      for(var mod in modulos.docs){
        final puntos =  FirebaseFirestore.instance.collection("cultivo").doc(cultivoseleccionado).collection("modulos").doc(mod.id).collection("geolocalizacion").orderBy("id");
        QuerySnapshot geo = await puntos.get();

        for(var pgeo in geo.docs){
          objeto = {
            "ID": cultivoseleccionado+""+mod.id,
            "GEO": LatLng(pgeo.get("latitud"),pgeo.get("longitud"))
          };
          data.add(objeto);

        }
        final areas =  FirebaseFirestore.instance.collection("cultivo").doc(cultivoseleccionado).collection("modulos").doc(mod.id).collection("area");
        QuerySnapshot area = await areas.get();
        for(var areacampo in area.docs){
          _markers.add(
            Marker(
              markerId: MarkerId(cultivoseleccionado+""+areacampo.id),
              position: LatLng(areacampo.get("latitud"), areacampo.get("longitud")),
              icon: await MarkerIcon.downloadResizePicture(
                  url: areacampo.get("icono"), imageSize: 80),),
          );
        }
        if(mounted){
          setState((){
            List<LatLng> coordsToAdd = [];


            for( int i = 0; i<data.length; i++ ){
              if(cultivoseleccionado+""+mod.id == data[i]["ID"]){
                coordsToAdd.add(data[i]["GEO"]);
              }
            }
            print("ID: "+cultivoseleccionado + "" + mod.id);

            myPolygons.add(
                Polygon(
                  // given polygonId
                  polygonId: PolygonId(
                      cultivoseleccionado + "" + mod.id),
                  // initialize the list of points to display polygon
                  points: coordsToAdd,
                  // given color to polygon
                  fillColor: Color(int.parse(colorcultivo)).withOpacity(0.3),
                  // given border color to polygon
                  strokeColor: Color(int.parse(colorcultivo)),
                  //  geodesic: true,
                  // given width of border
                  strokeWidth: 4,
                )
            );
          });}
      }
      Navigator.pop(context);
    }


  }

  Future<void> cargarAreaACPIni() async{
      setState((){
        if(widget.areaempresa!.isNotEmpty ){
          myPolygons.add(
              Polygon(
                // given polygonId
                polygonId: PolygonId("areaGcp"),
                // initialize the list of points to display polygon
                points: widget.areaempresa!,
                // given color to polygon
                fillColor: kPrimaryColor.withOpacity(0),
                // given border color to polygon
                strokeColor: kPrimaryColor,
                //  geodesic: true,
                // given width of border
                strokeWidth: 4,
              )
          );
        }

      });

  }

  void cargarAreaACP() async{

    var area =   FirebaseFirestore.instance.collection("areaacp").orderBy("id");
    QuerySnapshot areaacp = await area.get();
    if(areaacp.docs.isNotEmpty) {
      for (var doc in areaacp.docs) {
        polylineareaEmpresa.add(LatLng(doc.get("latitud"), doc.get("longitud")));
        print("GEO: "+doc.get("latitud").toString()+" , "+doc.get("longitud").toString());
      }
      myPolygons.add(
          Polygon(
            // given polygonId
            polygonId: PolygonId("areaGcp"),
            // initialize the list of points to display polygon
            points: polylineareaEmpresa,
            // given color to polygon
            fillColor: kPrimaryColor.withOpacity(0),
            // given border color to polygon
            strokeColor: kPrimaryColor,
            //  geodesic: true,
            // given width of border
            strokeWidth: 4,
          )
      );

    }
  }

  Future<void> cargarCultivosACP() async{
    listacultivos.clear();
    var cultivo =   FirebaseFirestore.instance.collection("cultivo");
    QuerySnapshot cultivos = await cultivo.get();
    if(cultivos.docs.isNotEmpty) {
      var objeto;
      for (var doc in cultivos.docs) {
         objeto = {
          "CULTIVO": doc.id
        };
        print("CULTIVO: "+doc.id);
         listacultivos.add(objeto);
      }


    }
  }
  Future<void> mostrarRuta(String inicio, String alias) async{
    var ddData = [];
    var objeto = {"ALIAS": alias};
    ddData.add(objeto);
    //var inicio = "V38";
    var fin = json.encode(ddData);
    print("ALIAS INICIO$inicio");
    print("ALIAS FINAL$fin");
    var responses = await http.post(
        Uri.parse(
            "${url_base}acp/index.php/optimizacionrutapp/returnShortestPath"),
        body: {"puntoInicio": inicio, "destinosAgregados": fin});
    if (mounted) {
      setState(() {
        print("RESPUESTA1: ${responses.body}");
        // ignore: unnecessary_null_comparison
        if (responses.body.toString() != null ||
            responses.body.toString() != "") {
          final extraerData =
          Map<String, dynamic>.from(json.decode(responses.body));
          data1 = extraerData["datos"]["coordenadas"];
          List<LatLng> polylineLatLongs = [];
          print("distancia: ................${extraerData["datos"]["costo"]}");
          distancia = extraerData["datos"]["costo"].toString();
          for (var i = 0; i < data1.length; i++) {
            polylineLatLongs.add(LatLng(double.parse(data1[i]["latitud"]),
                double.parse(data1[i]["longitud"])));
            _polylines.add(
              Polyline(
                polylineId: const PolylineId("0"),
                points: polylineLatLongs,
                color: iconMenu,
                width: 7,
              ),
            );
          }

        } else {
          print("error en ruta");
        }
      });
    }
    _markers.removeWhere((m) => m.markerId.value == 'RUTA');
    _markers.removeWhere((m) => m.markerId.value == 'RUTA2');
    double? lati;
    double? long;
    if(idpuntopartida == "V70"){
      lati = -7.066769;
      long = -79.558876;
    }else{
      lati = -7.0452529865306595;
      long = -79.54342790708667;

    }
    print("PARTIDA: "+idpuntopartida.toString());
    _markers.add(
      Marker(
        markerId: MarkerId("RUTA"),
        position: LatLng(double.parse(latidesdito!),double.parse(longidestino!) ),
        icon: await MarkerIcon.downloadResizePicture(
            url: "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/flag.png?alt=media&token=a59780b4-bff1-4d30-bbec-c7ddaeb55675", imageSize: 80),),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId("RUTA2"),
        position: LatLng(lati,	long),
        icon: await MarkerIcon.downloadResizePictureCircle(
            "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/gps.png?alt=media&token=6ec8136e-d7a1-46a6-a12b-2b02b0d9005d",
            size: 100,
            addBorder: false,
            borderColor: Colors.white,
            borderSize: 12),),
    );
    CameraPosition cPosition = CameraPosition(
      zoom:  14,
      tilt:  50,
      target:
      LatLng(currentLocationes!.latitude!, currentLocationes!.longitude!),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    setState((){
      var pinPosition =
      LatLng(currentLocationes!.latitude!, currentLocationes!.longitude!);


    });
  }

  Future<void> cargarLugaresACP() async{
    listalugares.clear();
    var lugar =   FirebaseFirestore.instance.collection("lugaresacp");
    QuerySnapshot lugares = await lugar.get();
    if(lugares.docs.isNotEmpty) {
      var objeto;
      for (var doc in lugares.docs) {
        objeto = {
          "LUGARES": doc.id
        };
        print("LUGARES: "+doc.id);
        listalugares.add(objeto);
      }


    }
  }

  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size:Size(30, 30)), 'assets/images/ic_colaborador_sf_holder_pg.png',);
  }

  void _onMapCreated(GoogleMapController controller) async{
    String imagen = tipoUsuario =="invitado"?"00000000":dniUsuario.toString();
    _mapController = controller;
    _controller.complete(controller);

   // setState(()  {
      _markers.add(
        Marker(
            markerId: const MarkerId("sourcePin"),
            position: LatLng(latinicial!, longinicial!),
            icon: await MarkerIcon.downloadResizePictureCircle(
                "http://web.acpagro.com/app-gcp/index.php/Imagenfacial/examinarFotoAcpLocation/"+imagen,
                size: 100,
                addBorder: true,
                borderColor: Colors.white,
                borderSize: 12),),
      );
    setState(()  {
      showPinsOnMap();

    });
  }

  Future<void> _listaCultivos() async {

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('CULTIVOS'),
            content: Container(
              width: double.minPositive,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
                  itemCount: listacultivos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: ()async {
                          if(listacultivos[index]["CULTIVO"].toString() == "todos"){
                            cultivoseleccionado = "todos";
                            print("DATA: "+cultivoseleccionado);
                            Navigator.pop(context);
                            await mostrarCultivos();

                          }else{
                            cultivoseleccionado = listacultivos[index]["CULTIVO"].toString();
                            print("DATA: "+cultivoseleccionado);
                            Navigator.pop(context);
                            await mostrarCultivos();

                          }

                        },
                        child: Column(children: [
                          const Divider(),
                          const SizedBox(height: 10.0),
                          Container(
                              child: Text(listacultivos[index]["CULTIVO"].toString().toUpperCase()))
                        ]
                        )

                    );}),
            ),
          );
        });
  }

  Future<void> _listaLugares() async {

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('LUGARES ACP'),
            content: Container(
              width: double.minPositive,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
                  itemCount: listalugares.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: ()async {
                          if(listalugares[index]["LUGARES"].toString() == "todo"){
                            lugarseleccionado = "todo";
                            print("DATA: "+lugarseleccionado);
                            Navigator.pop(context);
                            await mostrarLugares();

                          }else{
                           lugarseleccionado = listalugares[index]["LUGARES"].toString();
                            print("DATA: "+lugarseleccionado);
                            Navigator.pop(context);
                            await mostrarLugares();

                          }

                        },
                        child: Column(children: [
                          const Divider(),
                          const SizedBox(height: 10.0),
                          Container(
                              child: Text(listalugares[index]["LUGARES"].toString().toUpperCase()))
                        ]
                        )

                    );}),
            ),
          );
        });
  }

  void showPinsOnMap() async{
    var pinPosition = LatLng(latinicial!, longinicial!);
    String imagen = tipoUsuario =="invitado"?"00000000":dniUsuario.toString();
    _markers.add(Marker(
        markerId: const MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          setState(() {
            /* currentlySelectedPin = sourcePinInfo!;
            pinPillPosition = 0;*/
          });
        },
        icon: await MarkerIcon.downloadResizePictureCircle(
            "http://web.acpagro.com/app-gcp/index.php/Imagenfacial/examinarFotoAcpLocation/"+imagen,
            size: 100,
            addBorder: true,
            borderColor: Colors.white,
            borderSize: 12)));
  }

  void mostrarPosicion() async {

     CameraPosition cPosition = CameraPosition(
      zoom:  13,
      tilt:  90,
      target:
      LatLng(currentLocationes!.latitude!, currentLocationes!.longitude!),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    setState((){
      var pinPosition =
      LatLng(currentLocationes!.latitude!, currentLocationes!.longitude!);


    });
  }

  void updatePinOnMap() async {
    String imagen = tipoUsuario =="invitado"?"00000000":dniUsuario.toString();
    _markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size:Size(30, 30)), 'assets/images/flages.png',);
      var imagenicon = await MarkerIcon.downloadResizePictureCircle(
          "http://web.acpagro.com/app-gcp/index.php/Imagenfacial/examinarFotoAcpLocation/$imagen",
          size: 100,
          addBorder: true,
          borderColor: Colors.white,
          borderSize: 12);
    /* CameraPosition cPosition = CameraPosition(
      zoom:  13,
      tilt:  90,
      target:
      LatLng(currentLocationes!.latitude!, currentLocationes!.longitude!),
    );*/
    final GoogleMapController controller = await _controller.future;
    //controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
      if(mounted){
    setState((){
      var pinPosition =
      LatLng(currentLocationes!.latitude!, currentLocationes!.longitude!);
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: const MarkerId('sourcePin'),

          position: pinPosition,
          icon: imagenicon,
          ));

    });}
  }


  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.0, size:Size(24, 24)),
        'assets/images/ic_colaborador_sf_holder_pg.png')
        .then((onValue) {
      sourceIcones = onValue;
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: widget.barra == 1 ? null : AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("GPS ACP", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),
      body: Stack(
        children: <Widget>[ GoogleMap(
        mapType: MapType.satellite,
        compassEnabled: false,
        myLocationButtonEnabled: false,
        tiltGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(target: LatLng(-7.0701250, -79.5595940), zoom: 13,
          tilt:  90,),
        zoomControlsEnabled: false,
        onTap: (posicion) {
          print(posicion);
        },
        markers: _markers,
        polylines: _polylines,
          polygons: Set<Polygon>.of(myPolygons),
        onLongPress: (posicion) {
          print(posicion);
        },
      ),
          estado_menu1 == "1" ? Positioned(
            //alignment: Alignment.bottomRight,
              top: size.height*0.02,
              right: size.width * 0.02,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: iconMenu,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: Offset(0.0, 10.0),
                            )
                          ]),
                      child: ClipOval(
                          child: Container(
                              color: iconMenu,
                              //margin: EdgeInsets.only(top: 45),
                              padding: const EdgeInsets.all(10),
                              child: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 36,
                              ))),
                    ),
                    onTap: () async {
                      await RecibirDatosLugares();
                      setState((){
                        getPuntosPartida();
                        showSheet();
                      });
                    },
                  ),
                ],
              )): Container(),
        ]),

        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: kDarkPrimaryColor,
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          children: [
            SpeedDialChild(
              child: Image.asset("assets/images/planta.png", width: 30,),
              label: 'Cultivos',
              onTap: () async {
                await cargarCultivosACP();
                await _listaCultivos();
              }),
            SpeedDialChild(
                child: Icon(Icons.place),
                label: 'Lugares',
                onTap: ()async{
                  listalugares.clear();
                  await cargarLugaresACP();
                  await _listaLugares();
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.gamepad_outlined),
                label: 'Vista 360º',
              onTap: (){
                Navigator.push(
                    context,
                MaterialPageRoute(builder: (context) =>  Vistapanoramica()));
              }
            ),
            SpeedDialChild(
                child: Icon(Icons.cleaning_services),
                label: 'Limpiar mapa',
                onTap: (){
                  _markers.removeWhere((m) => m.markerId.value.isNotEmpty);
                  myPolygons.removeWhere((m) => m.polygonId.value.isNotEmpty);
                  myPolygons.clear();
                  cargarAreaACP();
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.location_history),
                label: 'Mi ubicación',
              onTap: (){
                mostrarPosicion();
              }
            ),
            /*SpeedDialChild(
                child: Icon(Icons.search),
                label: 'Buscar',
                onTap: (){
                  showSheet();
                }
            )*/

          ],
        )
    );
  }

  Future<void> getPuntosPartida() async{
ppartido.clear();
    var pp = FirebaseFirestore.instance.collection("puntos_patida_gps").orderBy("DESCRIPCION");
    QuerySnapshot ppartida = await pp.get();
    setState((){
      if(ppartida.docs.isNotEmpty){
        for(var doc in ppartida.docs){
          print("DATOS: "+doc.id.toString());
          ppartido.add(doc.data());
        }
        print("TITULO: "+ppartido[0]["DESCRIPCION"]);

      }
    });

  }

 // List ppartido = [{"IDPUNTO":"V70", "DESCRIPCION":"PACKING"},{"IDPUNTO":"V150", "DESCRIPCION":"FUNDO"}];
  Future showSheet()=> showSlidingBottomSheet(
      context,
      builder: (context) => SlidingSheetDialog(
        cornerRadius: 25,
        snapSpec: SnapSpec(
          initialSnap: 0.6,
          snappings: [0.6, 0.9],
        ),
        builder:buildSheet,
        headerBuilder:buildHeader,

      )
  );

  Widget buildSheet(context, state)=> Material(
      child: SingleChildScrollView( scrollDirection: Axis.vertical,child: Container(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: const BorderRadius.only(bottomLeft:  Radius.circular(25.0), bottomRight: Radius.circular(25))),
          child: Column(
            children: [

              const SizedBox(height: 10,),
              ListView(
                shrinkWrap: true,
                primary: false,
                padding: EdgeInsets.only(top: 16),
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("¿Cómo llegar?", textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold, color: Colors.grey) ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                      color: Colors.white,

                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("Desde:", textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold) ),
                            Container( child: FormHelper.dropDownWidget(context, "SELECCIONAR PUNTO PARTIDA", "", ppartido, (onChangedVal){
                              setState((){
                                idpuntopartida = onChangedVal;
                                //idbonoseleccionado = onChangedVal;
                              });

                            }, (onValidateVal){
                              if(onValidateVal == null){
                                return "Por favor selecciona un punto de partida";
                              }
                              return null;
                            },
                                borderColor: Colors.white,
                                borderFocusColor: Colors.white,
                                borderRadius: 20,
                                borderWidth: 0,
                                focusedBorderWidth: 0,
                                enabledBorderWidth: 0,
                                optionValue: "IDPUNTO",
                                optionLabel: "DESCRIPCION"

                            )),
                            Divider(height: 10, thickness: 2,),
                            SizedBox(height: 10,),
                            Text("A Donde:", textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold)),
                            SizedBox(height: 10,),
                            DropdownSearch<String>(
                              dropdownSearchBaseStyle: TextStyle(fontSize: 14,fontFamily: "Schyler"),
                              mode: Mode.BOTTOM_SHEET,
                              showSearchBox: true,
                              searchFieldProps: const TextFieldProps(
                                style: TextStyle(fontSize: 14,fontFamily: "Schyler" ),
                                cursorColor: kPrimaryColor
                              ),
                              items: lugaresdescripcion,
                                dropdownSearchDecoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  labelText: "Destino",
                                  hintText: "Ejm: Sector 06 Modulo 03 Turno 01",
                                ),
                              onChanged: (print){
                                setState((){
                                  for(int i = 0; i< lugares.length; i++){
                                    if(lugares[i]["DESCRIPCION"] == print){
                                      alias = lugares[i]["ALIAS"];
                                      latidesdito = lugares[i]["LATITUD"];
                                      longidestino = lugares[i]["LONGITUD"];

                                    }
                                  }

                                });

                              },

                              //selectedItem: "Brazil",
                            ),
                            /*Container(
                              width:
                              MediaQuery.of(context).size.width,
                              //height: 50.0,
                              padding: const EdgeInsets.only(
                                  top: 0.0,
                                  bottom: 0.0,
                                  left: 16.0,
                                  right: 16.0),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                                  color: Color(0xFFFFFFFF),),
                              child: TextField(
                                //autofocus: true,
                                controller: myControllerLugar,
                                cursorColor: const Color(0xFFC41A3B),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Sector 9 Módulo 7 Turno 2 Válvula 1',
                                    hintStyle: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black45,
                                        fontSize: 15)),
                              ),
                            ),*/
                            SizedBox(height: 20,),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width,
                                      48),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30)),
                                  elevation: 10,
                                  primary: const Color(0XFF00796B)),
                              onPressed: () {
                                mostrarRuta(idpuntopartida!, alias!);
                                print("ALIAS: "+alias!);

                                Navigator.pop(context);

                              },
                              child: const Text('Mostrar Ruta'),
                            ),
                            SizedBox(height: 10,),
                          ]
                      )),
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Historial", textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold, color: Colors.grey) ),
                  ),
                  SizedBox(height: 5,),


                ],
              )
            ],
          )))
  );

  Widget buildHeader(BuildContext context, SheetState state) => Material(
      child: Container( decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
          child:Container(decoration: BoxDecoration(color: kDarkPrimaryColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight:Radius.circular(25.0) )),child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16,),
              Center( child:
              Container(
                width: 32,
                height: 8,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25.0))),
              )),
              SizedBox(height: 16,)
            ],
          ),))
  );
}
