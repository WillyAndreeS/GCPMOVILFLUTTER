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



class QuejasReclamosPadres extends StatefulWidget {
  final List? tipoQuejas;
  final List? quejasDetalle;
  final List? grupotrabajo;
  final List? bono;
  final List? anioutilidades;
  QuejasReclamosPadres({Key? key, this.tipoQuejas, this.quejasDetalle, this.grupotrabajo, this.bono, this.anioutilidades}) ;

  @override
  _QuejasReclamosPadresState createState() => _QuejasReclamosPadresState();
}

class _QuejasReclamosPadresState extends State<QuejasReclamosPadres> {

  late Size size;
  List reclamosF = [];
  final myControllerUser = TextEditingController();
  late FocusNode focusUser;
  @override
  void initState() {
    super.initState();
    focusUser = FocusNode();
    //_showDialog();

  }


  Future<void> getReclamos(int idpadre) async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    print("HOLITAAAA");
    reclamosF.clear();
    var reclamos = FirebaseFirestore.instance.collection("quejassugerencias").where("idpadre_reclamo", isEqualTo: idpadre );
    QuerySnapshot reclamo = await reclamos.get();
    setState((){
      if(reclamo.docs.isNotEmpty){
        for(var doc in reclamo.docs){
          print("DATOS: "+doc.id.toString());
          reclamosF.add(doc.data());
        }
        print("TITULO: "+reclamosF[0]["descripcion"]);

      }
    });
    Navigator.pop(context);
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
        SliverAppBar( flexibleSpace: FlexibleSpaceBar( title: Text("Quejas y Sugerencias", style: TextStyle(fontFamily: "Schyler")), background: Image.asset("assets/images/img_background_hectareas.png"),
        ),expandedHeight: size.height*0.25,),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              width: size.width,
                height: size.height/1.5,
                child: Container( color: Colors.grey[100],child:
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
                    itemCount: widget.tipoQuejas!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector( onTap: () async{
                        print("ID: "+widget.tipoQuejas![index]["IDTIPORECLAMO"]);
                        await getReclamos(int.parse(widget.tipoQuejas![index]["IDTIPORECLAMO"]));
                        setState((){
                          reclamosF.isNotEmpty?
                          showDialog(
                              context: context,
                              builder: (context) =>  CustomDialogsAlert(
                                title: widget.tipoQuejas![index]["DESCRIPCION"],
                                reclamos: reclamosF,
                                reclamospadre: widget.quejasDetalle,
                                idpadre: int.parse(widget.tipoQuejas![index]["IDTIPORECLAMO"]),
                                grupotrabajo: widget.grupotrabajo!,
                                anioutilidades: widget.anioutilidades!,
                                bono: widget.bono!,
                              )): Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  RegistroReclamo(quejasDetalle: reclamosF, reclamospadre: widget.quejasDetalle, idpadre: int.parse(widget.tipoQuejas![index]["IDTIPORECLAMO"]),grupotrabajo: widget.grupotrabajo!, bono: widget.bono!, anioutilidades: widget.anioutilidades!,idtiporeclamo: int.parse(widget.tipoQuejas![index]["IDTIPORECLAMO"]))));
                        });

                      }, child: Container( margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12), width: size.width,
                          decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(15.0)), color: Colors.white, boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.29),offset:
                            const Offset(-5,5), blurRadius: 5),

                          ]),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:[ Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                child: CircleAvatar(
                                  radius: 18,
                                  child: ClipOval( child: Text(""+(index+1).toString())),

                                ),
                              ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(width: size.width/1.8, margin: EdgeInsets.symmetric(horizontal: 10), child: Text(widget.tipoQuejas![index]["DESCRIPCION"], textAlign: TextAlign.left, style: TextStyle(fontFamily: "Schyler"),),
                                    ),
                                    Container(width: size.width/1.8, margin: EdgeInsets.symmetric(horizontal: 10),child: Text("Registrar Reclamo", textAlign: TextAlign.left, style: TextStyle(fontFamily: "Schyler", fontSize: 12, color: Colors.grey),))
                                  ],)

                              ] )));
                    }
                ))
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