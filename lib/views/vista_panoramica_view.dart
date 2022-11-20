
import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:acpmovil/constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class VistapanoramicaWeb extends StatefulWidget {
  String? url, titulo;
  VistapanoramicaWeb({Key? key, this.url, this.titulo}) ;

  @override
  _VistapanoramicaWebState createState() => _VistapanoramicaWebState();
}

class _VistapanoramicaWebState extends State<VistapanoramicaWeb> {
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
              url: Uri.parse(widget.url!)
          ),
          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            print(challenge);
            return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
          },
        );
      }),);
    }
  }