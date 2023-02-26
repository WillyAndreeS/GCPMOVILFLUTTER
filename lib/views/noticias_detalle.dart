import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:acpmovil/views/detalle_utilidades.dart';
import 'package:acpmovil/views/registro_reclamo.dart';
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



class NoticiasDetalle extends StatefulWidget {
  final String? descripcion, titulo, urlimagen,fecha;
  NoticiasDetalle({Key? key, this.descripcion, this.titulo, this.urlimagen, this.fecha}) ;

  @override
  _NoticiasDetalleState createState() => _NoticiasDetalleState();
}

class _NoticiasDetalleState extends State<NoticiasDetalle> {

  late Size size;
  final myControllerUser = TextEditingController();
  late FocusNode focusUser;
  @override
  void initState() {
    super.initState();
    focusUser = FocusNode();
    //_showDialog();

  }



  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    size = MediaQuery.of(context).size;
    return  Scaffold(
       /* appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text("Quejas y Sugerencias", style: TextStyle(fontFamily: "Schyler"),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop (context, false);
            },
          ),

        ),*/
      body: CustomScrollView( slivers: [
        SliverAppBar( backgroundColor: Colors.black,flexibleSpace: FlexibleSpaceBar( title: Container( color: Colors.black.withOpacity(0.5), width: size.width,child: Text(widget.titulo!, style: TextStyle(fontFamily: "Schyler", fontSize: 15))),
          background: //Image.network(widget.urlimagen!),
          CachedNetworkImage(imageUrl: widget.urlimagen!, imageBuilder: (context, imageProvider) => Container(
                    decoration:  BoxDecoration(borderRadius:  BorderRadius.only(topLeft: Radius.circular(70.0), bottomRight:Radius.circular(70.0) ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),),
                  ),placeholder: (context, url) => Container(
            decoration:  BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/122840-image.gif"),
                fit: BoxFit.cover,
              ),),
          ),
            errorWidget: (context, url, error) => Icon(Icons.error),),
        ),expandedHeight: size.height*0.3,),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
                width: size.width/1.2,
                child: Container( width: size.width/1.2,color: Colors.white,
                  child: Text("Actualizado al "+widget.fecha!.substring(0,19),style: TextStyle(fontFamily: "Schyler", fontSize: 10), textAlign: TextAlign.left,),)
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              width: size.width/1.3,
                height: size.height/1.5,
                child: Container(width: size.width/1.2, color: Colors.white,
                child: Text(widget.descripcion!,style: TextStyle(fontFamily: "Schyler", fontSize: 14), textAlign: TextAlign.justify,),)
    )
          ]),
        )
      ] ,));
    }
  }



class CustomDialogsAlert extends StatelessWidget {
  final String? title, description, buttontext, nombre;
  final List? reclamos, reclamospadre, grupotrabajo, bono, anioutilidades;
  final int? idpadre;

  const CustomDialogsAlert(
      {Key? key,
        this.title,
        this.description,
        this.buttontext,
        this.nombre,
      this.reclamos,
      this.reclamospadre,
      this.idpadre,
        this.grupotrabajo,
        this.bono,
        this.anioutilidades})
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
    var size = MediaQuery.of(context).size;
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
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                    fontFamily: "Schyler"
                ),
              ),
              const Divider(),
              const SizedBox(height: 15.0),
              Container( width: size.width/1.2, height: size.height/4, child:
              ListView.builder(
                  itemCount: reclamos!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(  onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  RegistroReclamo(quejasDetalle: reclamos, reclamospadre: reclamospadre, idpadre: idpadre,grupotrabajo: grupotrabajo, bono: bono, anioutilidades: anioutilidades,idtiporeclamo: reclamos![index]["id"])));
                    },child: Container(padding: EdgeInsets.all(20),
                        child: Column( children: [
                          Text(reclamos![index]["descripcion"], style: TextStyle(fontFamily: "Schyler")),
                          Divider(thickness: 2,)
                        ],)
                    ));

                  }),),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
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
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "CANCELAR",
                            style: TextStyle(color: Colors.white, fontSize: 10),
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