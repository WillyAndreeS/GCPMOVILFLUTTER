import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:acpmovil/views/beneficios.dart';
import 'package:acpmovil/views/detalle_utilidades.dart';
import 'package:acpmovil/views/quejasreclamos_padre.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:acpmovil/constants.dart';
import 'package:http/http.dart' as http;
import 'package:acpmovil/views/screen_gcpmundo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';



class QuejasReclamos extends StatefulWidget {
  QuejasReclamos({Key? key}) ;

  @override
  _QuejasReclamosState createState() => _QuejasReclamosState();
}

class _QuejasReclamosState extends State<QuejasReclamos> {

  late Size size;
  List quejaspadres = [];
  List tipoQuejas = [];
  List anioLiqui = [];
  List anioUtilidades = [];
  List reclamostodos = [];
  List bonos = [];
  List<String> bono = [];
  List grupoatrabajo = [];
  List datos = [];
  List datos1 = [];
  List datos2 = [];
  List datos3 = [];
  List datos4 = [];
  String? FILTRO = "TODOS";
  List <String> grupotrabajo = [];
  final myControllerUser = TextEditingController();
  late FocusNode focusUser;
  @override
  void initState() {
    super.initState();
    focusUser = FocusNode();
    RecibirMisReclamos(FILTRO!);
    //_showDialog();

  }


  Future<String?> RecibirMisReclamos(String filtro) async {
    reclamostodos.clear();
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var response = await http.post(
          Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
          body: {"accion": "get_mrAKJKLSD00981","IDCODIGOGENERAL": dniUsuario, "EMPRESA": empresaUsuario, "FILTRO": filtro});
      // if (mounted) {
      setState(() {
        var extraerData = json.decode(response.body);
        reclamostodos = extraerData["resultado"];
        print("REST: "+reclamostodos.toString());


      });
    }
  }

  Future<String?> RecibirDatos() async {
    quejaspadres.clear();
    tipoQuejas.clear();
    anioLiqui.clear();
    anioUtilidades.clear();
    bonos.clear();
    bono.clear();
    grupoatrabajo.clear();
    grupotrabajo.clear();
    datos.clear();
    datos1.clear();
    datos2.clear();
    datos3.clear();
    datos4.clear();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var response = await http.post(
          Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
          body: {"accion": "_5WMQMNJJO2SYFQ_RCL", "empresa": empresaUsuario});
      // if (mounted) {
      setState(() {
        var extraerData = json.decode(response.body);
        datos = extraerData["tipo_reclamos"];
        datos1 = extraerData["anio_liquidacion"];
        datos2 = extraerData["anio_utilidades"];
        datos3 = extraerData["bonos"];
        datos4 = extraerData["grupo_trabajo"];
        print("REST: "+datos.toString());
        for(int i = 0; i < datos.length; i++){
          tipoQuejas.add({"IDTIPORECLAMO":datos[i]["IDTIPORECLAMO"],"DESCRIPCION": datos[i]["DESCRIPCION"], "IDRECLAMO_PADRE": datos[i]["IDRECLAMO_PADRE"]});
          if(datos[i]["IDRECLAMO_PADRE"] == "0" && !(
              datos[i]["IDTIPORECLAMO"]== "25" ||
                  datos[i]["IDTIPORECLAMO"] =="26" ||
                  datos[i]["IDTIPORECLAMO"] =="28" ||
                  datos[i]["IDTIPORECLAMO"] == "29" ||
                  datos[i]["IDTIPORECLAMO"] == "30" ||
                  datos[i]["IDTIPORECLAMO"] == "31" ||
                  datos[i]["IDTIPORECLAMO"] == "35" ||
                  datos[i]["IDTIPORECLAMO"] == "38"
          )){
            quejaspadres.add({"IDTIPORECLAMO":datos[i]["IDTIPORECLAMO"],"DESCRIPCION": datos[i]["DESCRIPCION"], "IDRECLAMO_PADRE": datos[i]["IDRECLAMO_PADRE"]});
          }
        }
        for(int i = 0; i < datos1.length; i++) {
          anioLiqui.add({"ANIO_LIQUIDACION":datos1[i]["ANIO_LIQUIDACION"]});
        }

        for(int i = 0; i < datos2.length; i++) {//Anio utilidades
          anioUtilidades.add({"ANIO_UTILIDADES":datos2[i]["ANIO_UTILIDADES"]});
        }

        for(int i = 0; i < datos3.length; i++) {//Bonos
          bonos.add({"IDCONCEPTO":datos[i]["CONCEPTO"],
              "DESCRIPCION":datos3[i]["DESCRIPCION"],
              "DESCR_CORTA":datos3[i]["DESCR_CORTA"],
              "CODIGO_RTPS":datos3[i]["CODIGO_RTPS"],}
          );
          bono.add(datos3[i]["DESCRIPCION"]);
        }

        for(int i = 0; i < datos4.length; i++) {//Bonos
          grupoatrabajo.add({"IDGRUPOTRABAJO":datos4[i]["IDGRUPOTRABAJO"],
              "DESCRIPCION":datos4[i]["DESCRIPCION"]}
          );
          grupotrabajo.add(datos4[i]["DESCRIPCION"]);
        }

        if(tipoQuejas.length!=0){
          print("-------------------------------");
          print("TIPO QUEJAS0: "+tipoQuejas.toString());
          print("-------------------------------");
          print("TIPO QUEJAS: "+quejaspadres.toString());
          print("-------------------------------");
          print("TIPO QUEJAS1: "+datos1.toString());
          print("-------------------------------");
          print("TIPO QUEJAS2: "+datos2.toString());
          print("-------------------------------");
          print("TIPO QUEJAS3: "+datos3.toString());
          print("-------------------------------");
          print("TIPO QUEJAS4: "+datos4.toString());
          print("-------------------------------");
         // startActivity(new Intent(MisReclamos.this, GestionHumanaListaReclamosTipo.class));
        }else{
          showDialog(
              context: context,
              builder: (context) =>  const CustomDialogsAlert(
                title: "Información",
                description: "Imposible obtener lista de reclamos, inténtalo en un momento",
                imagen: "assets/images/advertencia.png",
              ));

        }
        Navigator.pop(context);

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    size = MediaQuery.of(context).size;
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text("Mis Quejas y Sugerencias", style: TextStyle(fontFamily: "Schyler"),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop (context, false);
            },
          ),

        ),
      body: Container(

          decoration:  BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/images/background_gcp.png",),
          fit: BoxFit.fill,
        ),
    ), child: Container( color: Color.fromRGBO(255, 255, 255, 0.8),child: reclamostodos.isEmpty ? Column( mainAxisAlignment: MainAxisAlignment.center, children: [

      Container( margin: EdgeInsets.symmetric(horizontal: 20), width: size.width, child: Column(children: [
        Container(child: Image.asset("assets/images/88554-no-content.gif"), width: 120,),
        Text("Aún no ha registrados quejas o sugerencias", textAlign: TextAlign.center, style: TextStyle(fontFamily: "Schyler"),)
      ],))
    ]):Column( children: [
        Container( margin: EdgeInsets.symmetric(horizontal: 20), width: size.width, height: size.height/ 1.2, child: RefreshIndicator( onRefresh: ()async{ await RecibirMisReclamos(FILTRO!);} ,child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
    itemCount: reclamostodos.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
          height: size.height/3,

          margin: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(10.0)), color: Colors.white,boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

          ]),
          child: Column(children: [
            Align(alignment: Alignment.topCenter, child:Container(
              width: size.width,
              height: size.height/15,
              decoration:  BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)), color: reclamostodos[index]["ESTADO"] == "PENDIENTE" ? Colors.amber: Colors.green,),
              padding: const EdgeInsets.only(top:5, bottom: 5, left: 2 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container( padding: EdgeInsets.symmetric(horizontal: 10), child: Icon(Icons.text_snippet, color: Colors.white,)),
                  Container(
                      child: Text(
                          reclamostodos[index]["ESTADO"],
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Schyler", fontSize: 18))),

                ],
              ),

            ),),
            SizedBox(height: 20,),
            Align(alignment: Alignment.center, child:Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: size.width,
              decoration: const BoxDecoration(borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(children: [
                    Container( child: Icon(Icons.document_scanner_rounded),),
                    SizedBox(width: 10,),
                    Container(
                      child: Text(reclamostodos[index]["TIPORECLAMO"], style: TextStyle(fontSize: 15,fontFamily: "Schyler"),),),

                  ],),
                  SizedBox(height: 20,),
                  Row(children: [
                    Container( child: Icon(Icons.groups),),
                    SizedBox(width: 10,),
                    Container(
                      child: Text("Grupo: "+ reclamostodos[index]["GRUPOTRABAJO"], style: TextStyle(fontSize: 15,fontFamily: "Schyler")),),

                  ],),
                  SizedBox(height: 20,),
                  Row(children: [
                    Container( child: Icon(Icons.phone_android),),
                    SizedBox(width: 10,),
                    Container(
                      child: Text( reclamostodos[index]["11"]),),

                  ],),

                  SizedBox(height: 20,),
                  Row(children: [
                    Container( child: Icon(Icons.text_snippet_rounded),),
                    SizedBox(width: 10,),
                    Container(
                      child: Text( reclamostodos[index]["OBSERVACION"], style: TextStyle(fontSize: 15,fontFamily: "Schyler")),),

                  ],),
                  SizedBox(height: 10,),
                  Divider(thickness: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    Container(
                      child: Text( reclamostodos[index]["FECHAREGISTRO"], style:
                        TextStyle(color: Colors.grey,fontSize: 15,fontFamily: "Schyler"),),),

                  ],),


                ],
              ),

            ),),
          ],)


      );
    })),)
      ])),),floatingActionButton: SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: kDarkPrimaryColor,
      overlayColor: Colors.black,
      overlayOpacity: 0.4,
      children: [
        SpeedDialChild(
            child: Icon(Icons.add_comment),
            label: 'Nuevo Reclamo',
            onTap: () async {
              await RecibirDatos();
              setState((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  QuejasReclamosPadres(tipoQuejas: quejaspadres,quejasDetalle: tipoQuejas, grupotrabajo: grupoatrabajo, bono: bonos,anioutilidades: anioUtilidades,)));
              });

            }),
        SpeedDialChild(
            child: Icon(Icons.timelapse_outlined),
            label: 'Mostrar Reclamos Pendientes',
            onTap: ()async{
              FILTRO = "PENDIENTE";
              await RecibirMisReclamos(FILTRO!);
            }
        ),
        SpeedDialChild(
            child: Icon(Icons.check_circle),
            label: 'Mostrar Reclamos Atendidos',
            onTap: () async{
              FILTRO = "ATENDIDOS";
              await RecibirMisReclamos(FILTRO!);
            }
        ),
        SpeedDialChild(
            child: Icon(Icons.clear_all),
            label: 'Mostrar Todos',
            onTap: () async{
              FILTRO = "TODOS";
              await RecibirMisReclamos(FILTRO!);
            }
        ),

      ],
    ));
    }
  }



class CustomDialogsAlert extends StatelessWidget {
  final String? title, description, buttontext, imagen, nombre;
  final List? utilidades;

  const CustomDialogsAlert(
      {Key? key,
        this.title,
        this.description,
        this.buttontext,
        this.imagen,
        this.nombre,
      this.utilidades})
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
                width: 64,
                height: 64,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            "Cancelar",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  DetalleUtilidades(dataUtilidades: utilidades,)));
                          },
                          child: const Text(
                            "PROCESAR SOLICITUD",
                            style: TextStyle(color: Colors.white, fontSize: 12),
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

class CustomDialogsAlertError extends StatelessWidget {
  final String? title, description, buttontext, imagen, nombre;
  final List? utilidades;

  const CustomDialogsAlertError(
      {Key? key,
        this.title,
        this.description,
        this.buttontext,
        this.imagen,
        this.nombre,
        this.utilidades})
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
                width: 64,
                height: 64,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            style: TextStyle(color: Colors.white, fontSize: 12),
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
