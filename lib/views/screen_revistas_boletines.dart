import 'dart:convert';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:acpmovil/models/documento.dart';
import 'package:acpmovil/views/screen_boletines.dart';
import 'package:acpmovil/views/screen_revistas.dart';
import 'package:http/http.dart' as http;

class RevistasBoletines extends StatefulWidget {
  static List<Documento> listaRevistas = [];
  static List<Documento> listaBoletines = [];
  const RevistasBoletines({Key? key}) : super(key: key);

  @override
  _RevistasBoletinesState createState() => _RevistasBoletinesState();
}

class _RevistasBoletinesState extends State<RevistasBoletines> {
  late Future<List<Documento>> _listaTotalDocumentos;
  int selectedPage = 0;
  final _pageOptions = [const Revistas(), const Boletines()];

  @override
  void initState() {
    super.initState();
    _listaTotalDocumentos = _getListaTotalDocumentos();
  }

  _showDialog() async {
    await Future.delayed(const Duration(seconds: 3));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(child:Container(child: Image.asset("assets/images/swipe.gif")));
        });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    RevistasBoletines.listaRevistas.clear();
    RevistasBoletines.listaBoletines.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: _listaTotalDocumentos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //listaPublica = snapshot.data as List<Documento>;
              if (RevistasBoletines.listaRevistas.isNotEmpty) {
                return _construirVista();
              } else {
                return _ShowErrorActualizar("1");
              }
            } else if (snapshot.hasError) {
              return _ShowErrorActualizar("2");
            } else {
              return Stack(
                children: [
                  Positioned.fill(
                      child: Opacity(
                    opacity: 0.4,
                    child: Image.asset(
                      document_background,
                      fit: BoxFit.cover,
                    ),
                  ))
                ],
              );
            }

            //return _ShowErrorActualizar("3");
          },
        ),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: const Color(0XFF00AB74),
          style: TabStyle.react,
          items: const [
            TabItem(icon: Icons.library_books, title: 'Revistas'),
            TabItem(icon: Icons.book, title: 'Boletines')
          ],
          initialActiveIndex: 0,
          onTap: (int i) {
            //print("Posicion ${i}/ ${RevistasBoletines.listaRevistas.length} / ${listaPublica.length}");
            setState(() {
              selectedPage = i;
            });
          },
        ));
  }

  _construirVista() {
    //MuestraPantallaInicial Revistas
    return _pageOptions[selectedPage];
  }

  Future<List<Documento>> _getListaTotalDocumentos() async {
    EasyLoading.show(status: 'Cargando...');
    const urlservice = "https://web.acpagro.com/acpmovil/controlador/datos-controlador.php";
    List<Documento> documentos = [];

    try {
      final response = await http.post(Uri.parse(urlservice),
          body: {"accion": "getDocumentosComunicacion", "EMPRESA": "ACP"});
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      RevistasBoletines.listaRevistas.clear();
      RevistasBoletines.listaBoletines.clear();
      for (var item in jsonData["resultado"]) {
        if (item["IDCATEGORIA"] == '1') {
          //revista
          RevistasBoletines.listaRevistas.add(Documento(
              iddocumento: item["IDDOCUMENTO"],
              titulo: item["TITULO"],
              descripcion: item["DESCRIPCION"],
              anio: item["ANIO"],
              mes: item["MES"],
              autor_es: item["AUTOR_ES"],
              empresa: item["EMPRESA"],
              edicion: item["EDICION"],
              anio_doc: item["ANIO_DOC"],
              fecharegistro: item["FECHAREGISTRO"],
              idusuario_registra: item["IDUSUARIO_REGISTRA"],
              intent: item["INTENT"],
              extension: item["EXTENSION"],
              url_doc: item["URL_DOC"],
              idcategoria: item["IDCATEGORIA"],
              url_portada: item["URL_PORTADA"]));
        } else {
          //boleti
          RevistasBoletines.listaBoletines.add(Documento(
              iddocumento: item["IDDOCUMENTO"],
              titulo: item["TITULO"],
              descripcion: item["DESCRIPCION"],
              anio: item["ANIO"],
              mes: item["MES"],
              autor_es: item["AUTOR_ES"],
              empresa: item["EMPRESA"],
              edicion: item["EDICION"],
              anio_doc: item["ANIO_DOC"],
              fecharegistro: item["FECHAREGISTRO"],
              idusuario_registra: item["IDUSUARIO_REGISTRA"],
              intent: item["INTENT"],
              extension: item["EXTENSION"],
              url_doc: item["URL_DOC"],
              idcategoria: item["IDCATEGORIA"],
              url_portada: item["URL_PORTADA"]));
        }

        documentos.add(Documento(
            iddocumento: item["IDDOCUMENTO"],
            titulo: item["TITULO"],
            descripcion: item["DESCRIPCION"],
            anio: item["ANIO"],
            mes: item["MES"],
            autor_es: item["AUTOR_ES"],
            empresa: item["EMPRESA"],
            edicion: item["EDICION"],
            anio_doc: item["ANIO_DOC"],
            fecharegistro: item["FECHAREGISTRO"],
            idusuario_registra: item["IDUSUARIO_REGISTRA"],
            intent: item["INTENT"],
            extension: item["EXTENSION"],
            url_doc: item["URL_DOC"],
            idcategoria: item["IDCATEGORIA"],
            url_portada: item["URL_PORTADA"]));
      }
      EasyLoading.dismiss();
      return documentos;
    } catch (e) {
      EasyLoading.showError(
          'Ocurrió un error al conectar con el servidor, verifica tu conexión.');
      return documentos;
      //throw Exception(e.toString());
    }
  }

  _ShowErrorActualizar(numero) {
    print("Numero Actualizar ${numero}");
    return Stack(children: [
      Positioned.fill(
          child: Opacity(
        opacity: 0.4,
        child: Image.asset(
          document_background,
          fit: BoxFit.cover,
        ),
      )),
      Center(
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_outlined),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 10,
                      primary: Color(0XFF00796B)),
                  onPressed: () {
                    _listaTotalDocumentos = _getListaTotalDocumentos();
                    setState(() {});
                  },
                  child: const Text('¿Actualizar?'),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  getDataDocumentos() async {
    //configLoading();
    EasyLoading.show(status: 'Cargando...');
    //200--success, 400, 404, 500
    List<Documento> documentos = [];
    const urlservice =
        "https://web.acpagro.com/acpmovil/controlador/datos-controlador.php";
    try {
      var response = await http.post(Uri.parse(urlservice),
          body: {"accion": "getDocumentosComunicacion", "EMPRESA": "ACP"});

      //print(response.body);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);

        for (var item in jsonData["resultado"]) {
          documentos.add(Documento(
              iddocumento: item["IDDOCUMENTO"],
              titulo: item["TITULO"],
              descripcion: item["DESCRIPCION"],
              anio: item["ANIO"],
              mes: item["MES"],
              autor_es: item["AUTOR_ES"],
              empresa: item["EMPRESA"],
              edicion: item["EDICION"],
              anio_doc: item["ANIO_DOC"],
              fecharegistro: item["FECHAREGISTRO"],
              idusuario_registra: item["IDUSUARIO_REGISTRA"],
              intent: item["INTENT"],
              extension: item["EXTENSION"],
              url_doc: item["URL_DOC"],
              idcategoria: item["IDCATEGORIA"],
              url_portada: item["URL_PORTADA"]));
        }

        EasyLoading.dismiss();
      } else {
        EasyLoading.showError('Error service: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.showError(
          'Ocurrió un error al conectar con el servidor, verifica tu conexión.');
    }
  }
}
