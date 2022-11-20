
import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:acpmovil/constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';



class RadioWeb extends StatefulWidget {
  String? url, titulo;
  RadioWeb({Key? key, this.url, this.titulo}) ;

  @override
  _RadioWebState createState() => _RadioWebState();
}

class _RadioWebState extends State<RadioWeb> {
  late Size size;
  final bool showsnipper = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(

      body: Builder(builder: (BuildContext context) {
        return ModalProgressHUD(inAsyncCall: showsnipper, child: InAppWebView(
          initialUrlRequest: URLRequest(
              url: Uri.parse("https://radiocerroprieto.com/radio/")
          ),

          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            print(challenge);
            return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
          },
        ));
      }),);
    }
  }