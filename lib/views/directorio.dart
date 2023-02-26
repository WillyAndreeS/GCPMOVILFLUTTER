
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp/whatsapp.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sliding_sheet/sliding_sheet.dart';



class DirectorioPage extends StatefulWidget {
  List? trabajadores;
  String? areacol;
  DirectorioPage({Key? key, this.trabajadores, this.areacol}) ;

  @override
  DirectorioPageState createState() => DirectorioPageState();
}

class DirectorioPageState extends State<DirectorioPage> {
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;
  late FocusNode focusCol;
  String nombrecol = "";
  String celular = "";
  String correo = "";
  String cargo = "";
  String cumple = "";
  String area = "";
  String foto = "";

  final myControllerCol = TextEditingController();

  Future<String?> RecibirDatos(String area, String persona) async {

    widget.trabajadores!.clear();
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var response = await http.post(
          Uri.parse("${url_base}acpmovil/controlador/usuario.php"),
          body: {"accion": "grupo_trabajo_buscar", "area": area, "persona": persona});
      // if (mounted) {
      setState(() {
        var extraerData = json.decode(response.body);
        widget.trabajadores = extraerData["resultado"];
        print("REST: "+widget.trabajadores.toString());
      });

    }
  }


  @override
  void initState(){
    super.initState();
    focusCol = FocusNode();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() => this.result = result);
    });
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });
    controller.addListener(() {

      double value = controller.offset/119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
   // RecibirDatos();
    //print("FOTO: "+widget.trabajadores![0]["FOTO"].toString().substring(21));
    changeOpacity();

  }


  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  //final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  double opacity = 1.0;

  List<Widget> itemsData = [];

  /*@override
  void dispose(){
    internetSubscription.cancel();
    subscription.cancel();
    super.dispose();
  }*/

  void _launchURL(String url) async => await canLaunch(url) ? await launch(url) : throw 'Coult not launch $url';

  @override
  Widget build(BuildContext context) {
    final iskeyboard = MediaQuery.of(context).viewInsets.bottom !=  0;
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height*0.30;
    return Scaffold(
        resizeToAvoidBottomInset : false,
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Agenda", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),
        body: Container(
          // padding: const EdgeInsets.only(top: 40),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_gcp.png",),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: const Color.fromRGBO(255,255, 255, 0.7),
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            child: const Text("COLABORADORES", style: TextStyle(color: Colors.black, fontSize: 22,fontFamily: "Schyler"))
                        ),
                        const SizedBox(height: 15,),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 40),
                            child:  Text(widget.areacol!, style: TextStyle(color: Colors.grey[600], fontSize: 14,fontFamily: "Schyler"))
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          width:
                          MediaQuery.of(context).size.width / 1.2,
                          //height: 50.0,
                          padding: const EdgeInsets.only(
                              top: 0.0,
                              bottom: 0.0,
                              left: 10.0,
                              right: 10.0),
                          decoration:  BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                              color: const Color(0xFFFFFFFF),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 10.0)
                              ]),
                          child: TextField(
                            focusNode: focusCol,
                            //autofocus: true,
                            controller: myControllerCol,
                            cursorColor: Colors.black,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none,
                                hintText: 'Buscar colaborador',
                                hintStyle: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black45,
                                    fontSize: 15)),
                            onChanged: (text){
                              RecibirDatos("005",text);
                              //buscarAreas(text);
                            },
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          height: size.height * 0.68,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child:
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: widget.trabajadores!.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: (){
                                setState((){
                                  nombrecol = widget.trabajadores![index]["NOMBRES"];
                                  cumple = widget.trabajadores![index]["CUMPLE"];
                                  celular = widget.trabajadores![index]["CELULAR"];
                                  correo = widget.trabajadores![index]["EMAIL"];
                                  cargo = widget.trabajadores![index]["CARGO"];
                                  area = widget.trabajadores![index]["AREA"];
                                  foto = widget.trabajadores![index]["FOTO"];
                                  print("FOTOOOO URL: "+widget.trabajadores![index]["FOTO"].toString().substring(21,29));
                                  showSheet();
                                });

                              },
                                child:Container(
                            width: size.width,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), color: Colors.white, boxShadow: [
                              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),

                            ]),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0XFfF00AB74),
                                  radius: 30,
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      //http://web.acpagro.com/app-gcp/index.php/Imagenfacial/examinarFotoAcpLocation/$dni
                                      imageUrl:'http://web.acpagro.com/app-gcp/index.php/Imagenfacial/examinarFotoAcpLocation/'+widget.trabajadores![index]["FOTO"].toString().substring(21,29),placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                 Center(
                                child: Container(
                                  alignment: Alignment.center,
                                    child:
                                Column(

                                  children:  [
                                    Container(
                                      width: size.width * 0.5,
                                      child:
                                  Text(widget.trabajadores![index]["NOMBRES"], style: TextStyle(color: Colors.black, fontSize: 12,fontFamily: "Schyler"), textAlign: TextAlign.center),),
                                  Align(
                                    alignment: Alignment.center,
                                    child:
                                    Container(
                                      alignment: Alignment.center,
                                      width: 30,
                                      child: Divider(thickness: 3,color: Colors.black,),
                                    ),),
                                    Container(
                                      width: size.width * 0.5,
                                      child:
                                  Text("CARGO: "+widget.trabajadores![index]["CARGO"], style: TextStyle(color: kPrimaryColor, fontSize: 11,fontFamily: "Schyler"), textAlign: TextAlign.center)),
                                ],)),),

                              ],)
                        ));}),),
                      ]
                  ),
              ],

            ),
          ),
        )
    );
  }
  Future showSheet()=> showSlidingBottomSheet(
    context,
    builder: (context) => SlidingSheetDialog(
      cornerRadius: 25,
      snapSpec: SnapSpec(
        initialSnap: 0.5,
        snappings: [0.5, 0.9],
      ),
      builder:buildSheet,
        headerBuilder:buildHeader,

    )
  );

  Widget buildSheet(context, state)=> Material(
    child: Container(
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: const BorderRadius.only(bottomLeft:  Radius.circular(25.0), bottomRight: Radius.circular(25))),
        child: Column(
      children: [
        const SizedBox(height: 20,),
        GestureDetector(
          onTap: (){
            setState((){
              print("FOTOOOOO +"+foto.substring(21));
              final urlImages = [
                //http://web.acpagro.com/app-gcp/index.php/Imagenfacial/examinarFotoAcpLocation/
                'http://web.acpagro.com/app-gcp/index.php/Imagenfacial/examinarFotoAcpLocation/'+foto.substring(21,29)
              ];

              openGallery(urlImages);
            });

          },
          child: CachedNetworkImage(
          imageUrl:'http://web.acpagro.com/app-gcp/index.php/Imagenfacial/examinarFotoAcpLocation/'+foto.substring(21,29),
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundColor: const Color(0XFF00AB74),
            radius: 80,
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          width: 120,
          height: 120,
          fit: BoxFit.fill,
        ),),


        const SizedBox(height: 20,),
        ListView(
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.only(top: 16),
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Datos generales", textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold, color: Colors.grey) ),
            ),
            SizedBox(height: 5,),
            Container(
                color: Colors.white,

              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                Text("Nombre completo", textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold) ),
                Text(nombrecol, textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler")),
                    Divider(height: 10, thickness: 2,),
                SizedBox(height: 10,),
                    Text("Cumpleaños", textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold)),
                    Text(cumple, textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler")),
                    Divider(height: 10, thickness: 2,),
                    SizedBox(height: 10,),
                    Text("Celular", textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold)),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text(celular, textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler")),
                      Row(children: [
                        GestureDetector(onTap:()async{ FlutterPhoneDirectCaller.callNumber(celular);}, child: Image.asset("assets/images/telefono.png", width: 25,)),
                        SizedBox(width: 20,),
                        GestureDetector(onTap: () async {
                          String url;
                          if(int.parse(celular) > 9){
                             url = "https://api.whatsapp.com/send?phone=51"+celular;
                          }else{
                             url = "https://api.whatsapp.com/send?phone=51"+celular;
                          }

                           _launchURL(url);

                        }, child: Image.asset("assets/images/whatsapp.png", width: 25,)),

                      ],)

                    ],),

                    Divider(height: 10, thickness: 2,),
                    SizedBox(height: 10,),
                    Text("Correo", textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text(correo, textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler")),
                ])
              ]
            )),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Información extra", textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold, color: Colors.grey) ),
            ),
            SizedBox(height: 5,),
            Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Area", textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold)),
                      Text(area, textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler")),
                      Divider(height: 10, thickness: 2,),
                      SizedBox(height: 10,),
                      Text("Cargo", textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold)),
                      Text(cargo, textAlign: TextAlign.left,style: TextStyle(fontFamily: "Schyler")),
                    ]
                )),


          ],
        )
      ],
    ))
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

  void openGallery(List<String> urlImages) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => GalleryWidget(
    urlImages: urlImages,
  )));

  changeOpacity() {
    Future.delayed(
        const Duration(milliseconds: 100),
            () => setState(() {
          opacity = opacity == 0.0 ? 1.0 : 0.0;
          //changeOpacity();
        }));
  }
}

class GalleryWidget extends StatefulWidget{
  final List<String> urlImages;

  GalleryWidget({
    required this.urlImages,
});

  @override
  State<StatefulWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget>{
  @override
  Widget build(BuildContext context) => Scaffold(
    body: PhotoViewGallery.builder(itemCount: widget.urlImages.length, builder: (context, index){
      final urlImage  = widget.urlImages[index];
      return PhotoViewGalleryPageOptions(imageProvider: NetworkImage(urlImage));
    })
  );
}

