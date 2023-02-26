import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  PanelWidget({Key? key, required this.controller});

  @override
  _PanelWidgetState createState() => _PanelWidgetState();

}

class _PanelWidgetState extends State<PanelWidget> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentsong = "";
  String imageStream = "assets/images/playradio.png";

  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState((){
        isPlaying = state == PlayerState.PLAYING;
      });
    });
  }


  @override

  Widget build(BuildContext context) =>

      Material(
          child: Container(height: MediaQuery.of(context).size.height * 0.10,
              decoration: BoxDecoration(color: Colors.white,),
              child: Container(
                decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)),
                ), child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20,),
                  Center(child:
                  Container(
                    width: 32,
                    height: 8,
                    decoration: BoxDecoration(color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.05,
                    margin: EdgeInsets.only(top: 10, left: 30),

                    child: Text("Sintoniza Radio Cerro Prieto", style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: "Schyler"), textAlign: TextAlign.left,),
                  ),
                  Divider(),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        Center( child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.22,
                          decoration:  const BoxDecoration(
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
                        GestureDetector( onTap:() async{
                          /* Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  RadioWebBar()));*/
                          //https://stream-57.zeno.fm/1p6rkv8szc9uv?zs=FJnBQ5fURICNVFMMSpq_kg
                          if(isPlaying){
                            imageStream = "assets/images/playradio.png";
                            await audioPlayer.pause();
                          }else{
                            String url = "https://stream-57.zeno.fm/1p6rkv8szc9uv?zs=FJnBQ5fURICNVFMMSpq_kg";
                            imageStream = "assets/images/pausa.png";
                            await audioPlayer.play(url);
                          }
                        },child: Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.1,margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Image.asset(imageStream),

                        ),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 25),
                                child: Column(children: [
                                  IconButton(icon: Icon(Icons.add_box,color: Colors.grey,size: 40,),
                                    onPressed: (){
                                      print("HOLA");
                                    } ,),
                                  Container(width: MediaQuery.of(context).size.width* 0.20, child: Text("Contenido multimedia.", style: TextStyle(fontSize: 12),textAlign: TextAlign.center,))
                                ],)
                            ),
                            Container(
                                margin: EdgeInsets.only(right: 25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(icon: Icon(Icons.list,color: Colors.grey,size: 40,),
                                      onPressed: (){
                                        print("HOLA");
                                      } ,),
                                    Container(width: MediaQuery.of(context).size.width* 0.20, child: Text("Chat en vivo.", style: TextStyle(fontSize: 12),textAlign: TextAlign.center,))
                                  ],)
                            )
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