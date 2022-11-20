
import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:acpmovil/constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ConstanciaBoletaWeb extends StatefulWidget {
  String? url, titulo;
  ConstanciaBoletaWeb({Key? key, this.url, this.titulo}) ;

  @override
  _ConstanciaBoletaWebState createState() => _ConstanciaBoletaWebState();
}

class _ConstanciaBoletaWebState extends State<ConstanciaBoletaWeb> {
  late Size size;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title:  Text(widget.titulo!, style: TextStyle(fontFamily: "Schyler"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop (context, false);
          },
        ),

      ),

      body: Builder(builder: (BuildContext context) {
        return InAppWebView(
          initialUrlRequest: URLRequest(
              url: Uri.parse("https://web.acpagro.com/acp/index.php/boleta/pdf_boleta_final/"+dniUsuario.toString()+"/15/"+dniUsuario.toString())
          ),
          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            print(challenge);
            return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
          },
        );
      }),);
    }
  }