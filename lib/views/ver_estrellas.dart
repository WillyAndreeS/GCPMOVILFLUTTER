import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:acpmovil/constants.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:charts_flutter/flutter.dart' as charts;



class Estrellas extends StatefulWidget {
  Estrellas({Key? key}) ;

  @override
  _EstrellasState createState() => _EstrellasState();
}

class _EstrellasState extends State<Estrellas> {
  late Size size;
  List estrellas = [];
  List estrellasSemana = [];
  double suma = 0;
  double resta = 0;
  List<Expenses> data = [];
  String? pointAmount;
  String? pointerWeek;
  bool hasInternet = false;
  List<charts.Series<Expenses, int>> series = [];
  late StreamSubscription internetSubscription;
  late StreamSubscription subscription;
  ConnectivityResult result = ConnectivityResult.none;

  Future<String?> RecibirMisEstrellas() async {
    estrellas.clear();
    Color? colores = Color(0xFF00AB74);
    estrellasSemana.clear();
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var response = await http.post(
          Uri.parse("${url_base}acpmovil/controlador/datos-controlador.php"),
          body: {"accion": "get_recompensas_v4","dni": dniUsuario});
       if (mounted) {
         setState(() {
           var extraerData = json.decode(response.body);

           estrellas = extraerData["resultado"];
           for (int i = 0; i < estrellas.length; i++) {
             if (estrellas[i]["TIPO"] == "SEMANA" ||
                 estrellas[i]["TIPO"] == "CANJE") {
               estrellasSemana.add({
                 "IDCAMPANHA": estrellas[i]["IDCAMPANHA"],
                 "FECHA": estrellas[i]["FECHA"],
                 "SEMANA": estrellas[i]["SEMANA"],
                 "PUNTOS_SEMANA": estrellas[i]["PUNTOS_SEMANA"],
                 "DIASCOSECHA": estrellas[i]["DIASCOSECHA"],
                 "DIASTRABAJADOS": estrellas[i]["DIASTRABAJADOS"],
                 "PUNTOS_ADICIONAL": estrellas[i]["PUNTOS_ADICIONAL"],
                 "PUNTOS_EXTRA": estrellas[i]["PUNTOS_EXTRA"],
                 "PUNTOS_EXTRA_TOTAL_DIA": estrellas[i]["PUNTOS_EXTRA_TOTAL_DIA"],
                 "HORAS_SEMANA": estrellas[i]["HORAS_SEMANA"]
               });
               print("estrellas: " + estrellas[i]["IDCAMPANHA"]);


             }

             if (estrellas[i]["TIPO"] == "SEMANA" ) {
               suma = suma + (double.parse(estrellas[i]["PUNTOS_SEMANA"]) +
                   double.parse(estrellas[i]["PUNTOS_ADICIONAL"]) +
                   double.parse(estrellas[i]["PUNTOS_EXTRA"]) +
                   double.parse(estrellas[i]["PUNTOS_EXTRA_TOTAL_DIA"]));

             }
             if (estrellas[i]["TIPO"] == "SEMANA" && int.parse(estrellas[i]["SEMANA"]) > 1 ) {

               data.add(Expenses((double.parse(estrellas[i]["PUNTOS_SEMANA"]) +
                   double.parse(estrellas[i]["PUNTOS_ADICIONAL"]) +
                   double.parse(estrellas[i]["PUNTOS_EXTRA"]) +
                   double.parse(estrellas[i]["PUNTOS_EXTRA_TOTAL_DIA"])), int.parse(estrellas[i]["SEMANA"])));
               print("REST: " + int.parse(estrellas[i]["SEMANA"]).toString());

             }
             if (estrellas[i]["TIPO"] == "CANJE") {
               resta = resta + double.parse(estrellas[i]["PUNTOS_SEMANA"] == null ? "0" : estrellas[i]["PUNTOS_SEMANA"]);
             }
           }
           series = [
             charts.Series<Expenses, int>(
               id: 'Lineal',
               domainFn: (v,i) => v.semana,
               measureFn: (v,i) => v.puntos,
               data: data
             )
           ];


         });
       }
    }
  }



  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() => this.result = result);
    });
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });
    print("ESTADO INTERNET "+hasInternets.toString());
    RecibirMisEstrellas();

  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Ver estrellas", style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),
        bottom: const TabBar(
          tabs: [
            Tab(text: "RESUMEN",icon: Icon(Icons.edit_note, size: 20,),),
            Tab(text:"INDICADORES",icon: Icon(Icons.pie_chart, size: 20,),)
          ],
        ),

      ),

      body: estrellas.isEmpty ? Center(child: CircularProgressIndicator()): TabBarView(children: [Container(
        padding: const EdgeInsets.only(top: 1),
    child: RefreshIndicator( onRefresh: ()async{ await RecibirMisEstrellas();} , child: Column( children: [
      Container(width: size.width,
        child: Container(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(width: size.width*0.33,padding: EdgeInsets.only(left: 5, right: 5, bottom: 15, top: 15),color: Colors.grey[300],child:Text("SEMANA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontFamily: "Schyler"),textAlign: TextAlign.center,)),
          Container(width: size.width*0.33,padding: EdgeInsets.only(left: 5, right: 5, bottom: 15, top: 15),color: Colors.grey[300],child:Text("DÍAS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontFamily: "Schyler"),textAlign: TextAlign.center,)),
          Container(width: size.width*0.33,padding: EdgeInsets.only(left: 5, right: 5, bottom: 15, top: 15),color: Colors.grey[300],child:Text("HORAS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontFamily: "Schyler"),textAlign: TextAlign.center,)),
        ],)),
      ),
      Container(width: size.width, height: size.height/1.5, child:
      ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal:8,vertical: 8),
    itemCount: estrellasSemana.length,
    itemBuilder: (BuildContext context, int index) {
      return estrellasSemana.isNotEmpty ? GestureDetector(
          onTap: (){
          },
          child: Container(
              height: size.height/10,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(20.0)),  image:  DecorationImage(
                image: AssetImage("assets/images/background_recompensa_puntos.jpg"),
                fit: BoxFit.cover,
              ), boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, offset: const Offset(-5,5)),

              ]),
              child: int.parse(estrellasSemana[index]["SEMANA"])>1 ? Container( decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(20.0)), color: Colors.white.withOpacity(0.9)),child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween , children: [

                Column(
                  children: [
                  Container( padding:EdgeInsets.only(left: 20, top: 20), child: Text(
                      "Semana "+estrellasSemana[index]["SEMANA"],
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontFamily: "Schyler", fontSize: 14))),
                  Container( padding:EdgeInsets.only(left: 20, top: 5), child: Text(
                      (estrellasSemana[index]["PUNTOS_SEMANA"] == null ? "0": estrellasSemana[index]["PUNTOS_SEMANA"])+" Pts.",
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontFamily: "Schyler", fontSize: 14)))
                ],),
                SizedBox(width: 5,),
                Column(children: [
                  Container(  padding:EdgeInsets.only(top: 20), child: Text(
                      estrellasSemana[index]["DIASTRABAJADOS"]+"/"+estrellasSemana[index]["DIASCOSECHA"],
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontFamily: "Schyler", fontSize: 14))),
                  Container(  padding:EdgeInsets.only(top: 5), child: Text(
                      (estrellasSemana[index]["PUNTOS_ADICIONAL"] == null ? "0": estrellasSemana[index]["PUNTOS_ADICIONAL"])+" AD.",
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontFamily: "Schyler", fontSize: 14)))
                ],),
                SizedBox(width: 5,),
                Column(children: [
                  Container(padding:EdgeInsets.only(top: 20, right: 20), child: Text(
                      estrellasSemana[index]["HORAS_SEMANA"]+"Hrs.",
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontFamily: "Schyler", fontSize: 14))),
                  Container(padding:EdgeInsets.only(top: 5, right: 20), child: Text(
                      (estrellasSemana[index]["PUNTOS_SEMANA"] == null ? "0": (double.parse(estrellasSemana[index]["PUNTOS_SEMANA"])+double.parse(estrellasSemana[index]["PUNTOS_ADICIONAL"])+double.parse(estrellasSemana[index]["PUNTOS_EXTRA"])+double.parse(estrellasSemana[index]["PUNTOS_EXTRA_TOTAL_DIA"])).toString())+" Pts.",
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontFamily: "Schyler", fontSize: 14, fontWeight: FontWeight.bold)))
                ],)
              ],)): int.parse(estrellasSemana[index]["SEMANA"]) == 1 ? Container( decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(20.0)), color: estrellasSemana[index]["IDCAMPANHA"] == "006" ? Colors.green[800]: estrellasSemana[index]["IDCAMPANHA"] == "0021" ? Colors.deepPurple : Colors.green ),child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween , children: [
                Column(
                  children: [
                    Container( width: size.width/3.5,padding:EdgeInsets.only(left: 20, top: 20), child: Text(
                        estrellasSemana[index]["IDCAMPANHA"] == "0006" ? "PALTA": estrellasSemana[index]["IDCAMPANHA"] == "0021" ? "ARANDANO" : "ESPARRAGO" ,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.black,fontFamily: "Schyler",fontWeight: FontWeight.bold, fontSize: 14))),
                  ],),
                SizedBox(width: 5,),
                VerticalDivider(thickness: 2,color: Colors.white),
                SizedBox(width: 5,),
                Column(children: [
                  Container( width: size.width/8, padding:EdgeInsets.only(top: 20), child: Text(
                      estrellasSemana[index]["FECHA"],
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontFamily: "Schyler", fontWeight: FontWeight.bold, fontSize: 14))),
                ],),
                SizedBox(width: 5,),
                VerticalDivider(thickness: 2,color: Colors.white),
                SizedBox(width: 5,),
                Column(children: [
                  Container( width: size.width/4, padding:EdgeInsets.only(top: 20, right: 10), child: Text(
                      (estrellasSemana[index]["PUNTOS_SEMANA"] == null ? "0": (double.parse(estrellasSemana[index]["PUNTOS_SEMANA"])+double.parse(estrellasSemana[index]["PUNTOS_ADICIONAL"])+double.parse(estrellasSemana[index]["PUNTOS_EXTRA"])+double.parse(estrellasSemana[index]["PUNTOS_EXTRA_TOTAL_DIA"])).toString())+" Pts.",
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontFamily: "Schyler", fontSize: 14, fontWeight: FontWeight.bold)))
                ],)
              ],)): Container( decoration: BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(20.0)), color: Colors.red),child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween , children: [
                Column(
                  children: [
                    Container(width: size.width/3.5, padding:EdgeInsets.only(left: 20, top: 20), child: Text(
                        "CANJE",
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: "Schyler", fontSize: 14))),
                  ],),
                SizedBox(width: 5,),
                VerticalDivider(thickness: 2,color: Colors.white),
                SizedBox(width: 5,),
                Column(children: [
                  Container( width: size.width/8, padding:EdgeInsets.only(top: 20, right: 20), )
                ],),
                SizedBox(width: 5,),
                VerticalDivider(thickness: 2,color: Colors.white),
                SizedBox(width: 5,),
                Column(children: [
                  Container(width: size.width/4,  padding:EdgeInsets.only(top: 20, right: 10), child: Text(
                      (estrellasSemana[index]["PUNTOS_SEMANA"] == null ? "0": (double.parse(estrellasSemana[index]["PUNTOS_SEMANA"])+double.parse(estrellasSemana[index]["PUNTOS_ADICIONAL"])+double.parse(estrellasSemana[index]["PUNTOS_EXTRA"])+double.parse(estrellasSemana[index]["PUNTOS_EXTRA_TOTAL_DIA"])).toString())+" Pts.",
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black,fontFamily: "Schyler", fontSize: 14, fontWeight: FontWeight.bold)))
                ],)
              ],))


          )): Center(child: CircularProgressIndicator(),);}
    ))]))),
        Container(child: Container(width:size.width,height: size.height/1.3,child: data.isNotEmpty ? Column( children : [
          Container(margin: EdgeInsets.symmetric(vertical: 10),child: Text("SEMANA", style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold, fontSize: 16),)),
          Row(children: [
            Container(margin: EdgeInsets.symmetric(horizontal: 15), width: size.width*0.05,child: Text("PUNTOS", style: TextStyle(fontFamily: "Schyler", fontWeight: FontWeight.bold, fontSize: 16),)),
            Container(width:size.width/1.2,height: size.height/1.5,
                child:charts.LineChart(series,
                  selectionModels: [charts.SelectionModelConfig(changedListener: (charts.SelectionModel model){
                    if(model.hasDatumSelection){
                      pointAmount = model.selectedSeries[0].measureFn(model.selectedDatum[0].index)?.toStringAsFixed(2);
                      pointerWeek = model.selectedSeries[0].domainFn(model.selectedDatum[0].index)?.toString();
                    }
                  })],
                  /*behaviors: [
            charts.LinePointHighlighter(
              symbolRenderer: MySymbolRenderer()
            )
          ],*/
                ))
          ])

        ]):const Center( child:
        CircularProgressIndicator()))),
      ]),
      bottomNavigationBar: Container(width: size.width,
          child: Container(child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),width: size.width*0.75,color: Colors.grey[300],child:Text("TOTAL PUNTOS: ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontFamily: "Schyler"),textAlign: TextAlign.right,)),
            Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),width: size.width*0.25,color: Colors.grey[500],child:Text((((suma+resta).round()*100)/100).toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontFamily: "Schyler"),textAlign: TextAlign.right,)),
          ],)),
      ),
    ));
    }
  }


class Expenses{
  final double puntos;
  final int semana;

  Expenses(this.puntos, this.semana);
}

/*class MySymbolRenderer extends charts.CircleSymbolRenderer{

  @override
   void paint(
      charts.ChartCanvas canvas,
      Rectangle<num>bounds,
  {
    List<int>? dashPattern,
    charts.Color? fillColor,
    charts.FillPatternType? fillPattern,
    charts.Color? strokeColor,
    double? strokeWithPx
  }){
    super.paint(canvas, bounds, dashPattern: dashPattern, fillColor: fillColor, fillPattern: fillPattern, strokeColor: strokeColor, strokeWidthPx: strokeWithPx);
    canvas.drawRect(
      Rectangle(bounds.left -25, bounds.top -30, bounds.width +48, bounds.height +18),
      fill: charts.ColorUtil.fromDartColor(Colors.grey),
      stroke: charts.ColorUtil.fromDartColor(Colors.green),
      strokeWidthPx: 2,
    );
  }

}*/