import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/galeriaBar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class RadioWidget extends StatefulWidget {
  final ScrollController? controller;
  RadioWidget({Key? key,this.controller});

  @override
  _RadioWidgetState createState() => _RadioWidgetState();

}

class _RadioWidgetState extends State<RadioWidget> {


  String currentsong = "";
  String imageStream = "assets/images/playradio.png";

  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      if(mounted){
        setState((){

          isPlaying = state == PlayerState.PLAYING;

        });
      }

    });
  }


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      //  extendBodyBehindAppBar: true,
        body: Container(height: MediaQuery
            .of(context)
            .size
            .height,
            decoration: BoxDecoration(color: Colors.white,),
            child: Container(
              decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
              ), child: Column(
             // mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 40),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: [
                      Center(child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.9,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.40,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/rcp.png"),
                              fit: BoxFit.fitWidth,
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(16)),
                            color: Color(0xFFFFFFFF),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10.0)
                            ]),

                      )),
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.02,
                        margin: EdgeInsets.only(top: 15, left: 40),

                        child: Text("RADIO CERRO PRIETO", style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: "Schyler"), textAlign: TextAlign.left,),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.02,
                        margin: EdgeInsets.only(top: 10, left: 40),

                        child: Text("Conexión Cerro Prieto", style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                            fontFamily: "Schyler"), textAlign: TextAlign.left,),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.02,
                        margin: EdgeInsets.only( left: 40),

                        child: Text("04:30 p.m. - 05:30 p.m.", style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: "Schyler"), textAlign: TextAlign.left,),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.02,
                        margin: EdgeInsets.only( left: 40),

                        child: Text("Carlos Alvarado", style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: "Schyler"), textAlign: TextAlign.left,),
                      ),
                      SizedBox(height: 20,),
                      GestureDetector(onTap: () async {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  RadioWebBar()));*/
                        //https://stream-57.zeno.fm/1p6rkv8szc9uv?zs=FJnBQ5fURICNVFMMSpq_kg
                        if (isPlaying) {
                          imageStream = "assets/images/playradio.png";
                          await audioPlayer.pause();
                          setState(() {
                            isPlaying = false;
                            print("isplaying" + isPlaying.toString());
                          });
                        } else {
                          String url = "https://stream-57.zeno.fm/1p6rkv8szc9uv?zs=FJnBQ5fURICNVFMMSpq_kg";
                          imageStream = "assets/images/pausa.png";
                          await audioPlayer.play(url);
                          setState(() {
                            isPlaying = true;
                            print("isplaying" + isPlaying.toString());
                          });
                        }
                      }, child: Container(width: MediaQuery
                          .of(context)
                          .size
                          .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.15,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset( imageStream),

                      ),),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 25),
                              child: Column(children: [
                                IconButton(icon: Icon(
                                  Icons.add_box, color: Colors.grey, size: 40,),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                        const CustomDialogsAlertMultimedia(
                                          title: "Multimedia",
                                          description:
                                          "",
                                          imagen: "assets/images/multimedia.png",
                                        ));
                                  },),
                                Container(width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.20,
                                    child: Text("Contenido multimedia.",
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,))
                              ],)
                          ),
                          /*Container(
                              margin: EdgeInsets.only(right: 25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(icon: Icon(
                                    Icons.list, color: Colors.grey, size: 40,),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                          const CustomDialogsAlert(
                                            title: "Offline",
                                            description:
                                            "Aún no iniciamos la transmisión",
                                            imagen: "assets/images/mudo.png",
                                          ));
                                    },),
                                  Container(width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.20,
                                      child: Text("Chat en vivo.",
                                        style: TextStyle(fontSize: 12),
                                        textAlign: TextAlign.center,))
                                ],)
                          )*/
                        ],)
                      //      SizedBox(height: 20,),
                      /*       GestureDetector( /*onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  RadioWeb()));
                    }, */child: Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.07,margin: EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(color: kPrimaryColor,  boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, offset: const Offset(-3,3)),

                        ]), child: Container(margin: EdgeInsets.symmetric(horizontal: 15), padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.white, child: Center( child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.control_camera),
                                  SizedBox(width: 10,),
                                  Text("Juegos", style: TextStyle(fontFamily: "Schyler", fontSize: 16, color: Colors.black),textAlign: TextAlign.center,)])),),)),
                        SizedBox(height: 20,),*/
                      /*  GestureDetector(onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  GaleriaBar()));
                    }, child: Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.07,margin: EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(color: kPrimaryColor,  boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, offset: const Offset(-3,3)),

                        ]), child: Container(margin: EdgeInsets.symmetric(horizontal: 15), padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.white, child: Center( child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                               Icon(Icons.photo),
                               SizedBox(width: 10,),
                               Text("Galería", style: TextStyle(fontFamily: "Schyler", fontSize: 16, color: Colors.black),textAlign: TextAlign.center,)])),),)),*/
                    ],),
                  ),
                )
              ],
            ),))
    );
  }
/*aterial(
          child: Container(
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25))),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  ListView(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.only(top: 16),
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            "Datos generales", textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: "Schyler",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        color: Colors.white,

                        padding: EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),),
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            "Información extra", textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: "Schyler",
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ),
                      SizedBox(height: 5,),


                    ],
                  )
                ],
              ))
      );*/




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

class CustomDialogsAlertMultimedia extends StatelessWidget {
  final String? title, description, buttontext, imagen, nombre;
  final Image? image;

  const CustomDialogsAlertMultimedia(
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
          padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
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
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
              /* GestureDetector( /*onTap:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  RadioWeb()));
                    }, */child: Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.07,margin: EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(color: kPrimaryColor,  boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, offset: const Offset(-3,3)),

            ]), child: Container(margin: EdgeInsets.symmetric(horizontal: 15), padding: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white, child: Center( child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.control_camera),
                    SizedBox(width: 10,),
                    Text("Juegos", style: TextStyle(fontFamily: "Schyler", fontSize: 16, color: Colors.black),textAlign: TextAlign.center,)])),),)),*/
              SizedBox(height: 20,),
              GestureDetector(onTap:(){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  GaleriaBar()));
              }, child: Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.07,margin: EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(color: kPrimaryColor,  boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, offset: const Offset(-3,3)),

              ]), child: Container(margin: EdgeInsets.symmetric(horizontal: 15), padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white, child: Center( child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.photo),
                      SizedBox(width: 10,),
                      Text("Galería", style: TextStyle(fontFamily: "Schyler", fontSize: 16, color: Colors.black),textAlign: TextAlign.center,)])),),)),
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