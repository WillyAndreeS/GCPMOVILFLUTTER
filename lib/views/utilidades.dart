import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:acpmovil/views/detalle_utilidades.dart';
import 'package:acpmovil/views/directorio.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
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



class Utilidades extends StatefulWidget {
  Utilidades({Key? key}) ;

  @override
  _UtilidadesState createState() => _UtilidadesState();
}

class _UtilidadesState extends State<Utilidades> {

  late Size size;
  List comunicados = [];
  final myControllerUser = TextEditingController();
  late FocusNode focusUser;
  @override
  void initState() {
    super.initState();
    focusUser = FocusNode();
    //_showDialog();

  }

  void MostrarMensaje() async{
    if(comunicados[0]["ACTIVO"] == "1"){
      if(double.parse(comunicados[0]["PAGO_TRANSITORIO"]) > 0){
        if(double.parse(comunicados[0]["NETO_PAGADO"]) > 0){
          showDialog(
              context: context,
              builder: (context) =>  CustomDialogsAlert(
                title: "1/3 Consultar",
                description: comunicados[0]["MENSAJE"].toString().replaceAll("<b>", "").replaceAll("</b>", ""),
                imagen: "assets/images/advertencia.png",
                utilidades: comunicados,
              ));
        }else{
          showDialog(
              context: context,
              builder: (context) =>  CustomDialogsAlert(
                title: "MENSAJE",
                description: comunicados[0]["MENSAJE"].toString().replaceAll("<b>", "").replaceAll("</b>", ""),
                imagen: "assets/images/advertencia.png",
                utilidades: comunicados,
              ));
        }
      }else{
        showDialog(
            context: context,
            builder: (context) =>  CustomDialogsAlert(
              title: "1/3 Consultar",
              description: comunicados[0]["MENSAJE"].toString().replaceAll("<b>", "").replaceAll("</b>", ""),
              imagen: "assets/images/advertencia.png",
              utilidades: comunicados,
            ));
      }
    }else if(comunicados[0]["ACTIVO"] == "0"){
      if(double.parse(comunicados[0]["PAGO_TRANSITORIO"]) > 0) {
        if (double.parse(comunicados[0]["NETO_PAGADO"]) > 0) {
          List<String> partes = comunicados[0]["MENSAJE"].toString().replaceAll("<b>", "").replaceAll("</b>", "").split("\\|");
          showDialog(
              context: context,
              builder: (context) =>  CustomDialogsAlert(
                title: "1/3 Consultar",
                description: partes[0].toString(),
                imagen: "assets/images/advertencia.png",
                utilidades: comunicados,
              ));
        }else{
          showDialog(
              context: context,
              builder: (context) =>  CustomDialogsAlert(
                title: "MENSAJE",
                description: comunicados[0]["MENSAJE"].toString().replaceAll("<b>", "").replaceAll("</b>", ""),
                imagen: "assets/images/advertencia.png",
                utilidades: comunicados,
              ));
        }
      }else{
        showDialog(
            context: context,
            builder: (context) =>  CustomDialogsAlert(
              title: "1/3 Consultar",
              description:comunicados[0]["MENSAJE"].toString().replaceAll("<b>", "").replaceAll("</b>", ""),
              imagen: "assets/images/advertencia.png",
              utilidades: comunicados,
            ));
      }

    }
  }

  Future<String?> RecibirDatos() async {
    comunicados.clear();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    final DateTime now = DateTime.now();
    int anioactual = now.year;
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var response = await http.post(
          Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
          body: {"accion": "consultar_uti_id_anio", "IDCODIGOGENERAL": dniUsuario, "ANIO": anioactual.toString()});
      // if (mounted) {
      setState(() {
        var extraerData = json.decode(response.body);
        comunicados = extraerData["resultado"];
        print("REST: "+comunicados.toString());
        if(comunicados[0]["RESPUESTA"].toString().toUpperCase() == "TRUE"){
          if(comunicados[0]["EMPRESA"].toString().toUpperCase() == "ACP"){
            if(comunicados[0]["MOSTRAR_ENCUESTA"].toString().toUpperCase() == "SI"){
              if(comunicados[0]["ESPONDIO_ENCUESTA"].toString().toUpperCase() == "NO"){
                Navigator.pop(context);
                //MostrarMensaje();
              }else{
                Navigator.pop(context);
                MostrarMensaje();
              }
            }else{
              Navigator.pop(context);
              MostrarMensaje();
            }

          }else{
            Navigator.pop(context);
            MostrarMensaje();
          }
        }else if(comunicados[0]["RESPUESTA"].toString().toUpperCase() == "FALSE"){
          Navigator.pop(context);
          if(comunicados[0]["ID_SOLICITUD_EXISTENTE"].toString().trim().length != 0){
            showDialog(
                context: context,
                builder: (context) =>  CustomDialogsAlert(
                  title: "1/3 Consultar",
                  description: comunicados[0]["MENSAJE"].toString().replaceAll("<b>", "").replaceAll("</b>", ""),
                  imagen: "assets/images/advertencia.png",
                  utilidades: comunicados,
                ));
          }else{
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (context) =>  CustomDialogsAlertError(
                  title: "Lo sentimos...",
                  description:comunicados[0]["MENSAJE"].toString().replaceAll("<b>", "").replaceAll("</b>", ""),
                  imagen: "assets/images/advertencia.png",
                  utilidades: comunicados,
                ));
          }
        }
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    size = MediaQuery.of(context).size;
    int anioactual = now.year - 1;
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text("Utilidades", style: TextStyle(fontFamily: "Schyler"),),
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
          image: AssetImage("assets/images/background_cambiar_clave.jpg",),
          fit: BoxFit.cover,
        ),
    ),
    child: Container( padding: const EdgeInsets.only(top: 20), color: const Color.fromRGBO(0,0, 0, 0.4),child: Column( children: [
    Container(
    width: size.width,
    child: Text(now.year.toString()+"|Utilidades", style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "Schyler"), textAlign: TextAlign.center,)
    ),
      SizedBox(height: 40,),
      Container(
        width:
        MediaQuery.of(context).size.width / 1.3,
        //height: 50.0,
        padding: const EdgeInsets.only(
            top: 0.0,
            bottom: 0.0,
            left: 16.0,
            right: 16.0),
        decoration: const BoxDecoration(
            borderRadius:
            BorderRadius.all(Radius.circular(16)),
            color: Color(0xFFFFFFFF),
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 10.0)
            ]),
        child: TextField(
          focusNode: focusUser,
          controller: myControllerUser,
          cursorColor: const Color(0xFFC41A3B),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              icon: Icon(
                Icons.account_circle,
                color: kDarkPrimaryColor, size: 50,
              ),
              border: InputBorder.none,
              hintText: 'DNI',
              hintStyle: TextStyle(
                  fontStyle: FontStyle.normal,
                  color: Colors.black45,
                  fontSize: 15)),
        ),
      ),
      SizedBox(height: 20,),
      Container(
          width: size.width/1.3,
          child: Text("Ingresa tu Documento de Identidad (DNI) y pulsa en CONSULTAR, para verificar tus UTILIDADES "+anioactual.toString()+".", style: TextStyle(color: Colors.white,fontSize: 14,fontFamily: "Schyler"), textAlign: TextAlign.center,)
      ),
      SizedBox(height: 20,),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(
                MediaQuery.of(context).size.width /
                    1.3,
                48),
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(30)),
            elevation: 10,
            primary: const Color(0XFF00AB74)),
        onPressed: () {
          RecibirDatos();
        },
        child: const Text('CONSULTAR'),
      ),
    ])),));
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
