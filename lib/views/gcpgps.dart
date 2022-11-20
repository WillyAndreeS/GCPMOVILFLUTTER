import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/vista_panoramica.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class GCP_GPS extends StatefulWidget {
  List<LatLng>? areaempresa;
   GCP_GPS({Key? key, this.areaempresa}) : super(key: key);

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




  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _setMarkerIcon();
    setSourceAndDestinationIcons();
    cargarAreaACPIni();
    cargarCultivosACP();
    cargarLugaresACP();
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

  Future<void>mostrarLugares() async{


    if(lugarseleccionado == "todo"){
      _markers.removeWhere((m) => m.markerId.value.isNotEmpty);
      myPolygons.removeWhere((m) => m.polygonId.value.isNotEmpty);
      myPolygons.clear();
      cargarAreaACP();
      CameraPosition cPosition = CameraPosition(
        zoom:  12,
        tilt:  90,
        target:
        LatLng(currentLocationes!.latitude!, currentLocationes!.longitude!),
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
                      markerId: MarkerId(mod.get("descripcion")),
                      infoWindow: InfoWindow(title: mod.get("descripcion")),
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
              markerId: MarkerId(lugarseleccionado+""+mod.get("descripcion")),
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
    _mapController = controller;
    _controller.complete(controller);

   // setState(()  {
      _markers.add(
        Marker(
            markerId: const MarkerId("sourcePin"),
            position: LatLng(latinicial!, longinicial!),
            icon: await MarkerIcon.downloadResizePictureCircle(
                "http://web.acpagro.com/acp/fotosColaboradores/"+dniUsuario!+".jpg",
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
            "http://web.acpagro.com/acp/fotosColaboradores/"+dniUsuario!+".jpg",
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
      var imagenicon = await MarkerIcon.downloadResizePictureCircle(
          "http://web.acpagro.com/acp/fotosColaboradores/"+dniUsuario!+".jpg",
          size: 100,
          addBorder: true,
          borderColor: iconMenu,
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("GPS ACP", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),
      body: GoogleMap(
        mapType: MapType.satellite,
        compassEnabled: true,
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
            )

          ],
        )
    );
  }
}
