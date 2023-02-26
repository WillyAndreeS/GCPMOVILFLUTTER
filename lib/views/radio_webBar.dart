
import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:acpmovil/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class RadioWebBar extends StatefulWidget {
  String? url, titulo;
  RadioWebBar({Key? key, this.url, this.titulo}) ;

  @override
  _RadioWebBarState createState() => _RadioWebBarState();
}

class _RadioWebBarState extends State<RadioWebBar> {
  late Size size;
  final bool showsnipper = false;
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  String? IDCEL;
  final urlController = TextEditingController();

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      IDCEL = iosDeviceInfo.identifierForVendor.toString();
      print("IDCEL: "+IDCEL.toString());
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      IDCEL = androidDeviceInfo.androidId.toString();
      print("IDCEL: "+IDCEL.toString());
      return androidDeviceInfo.androidId; // unique ID on Android

    }
  }

  Future SaveVisita() async{
    await _getId();
    if(mounted) {
      setState(() {

        final DateTime now = DateTime.now();
        final docUser = FirebaseFirestore.instance.collection("visitas");

        final json = {
          'fecha': now.toString(),
          'idinterfaz': "Sintoniza Radio Cerro Prieto",
          'idusuario': tipoUsuario.toString().toUpperCase() == "INVITADO" ? IDCEL.toString() : dniUsuario,
          'imagen': "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/escuchando%20(1).png?alt=media&token=2404378b-017d-4514-8e77-a1f8603566db",
          'icono': "https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/radio%20(1).png?alt=media&token=8ecac6bd-24c7-4694-bfce-63283b89b963",
          'color': "0XFF7B4480"
        };
        docUser.add(json);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
    SaveVisita();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text("Sintoniza Radio Cerro Prieto", style: TextStyle(fontFamily: "Schyler"),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop (context, false);
            },
          ),

        ),
//url: Uri.parse("https://radiocerroprieto.com/radio/")
      body: SafeArea(
          child: Column(children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest:
                    URLRequest(url: Uri.parse("https://radiocerroprieto.com/radio/")),
                    initialOptions: options,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    androidOnPermissionRequest: (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading: (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;

                      if (![ "http", "https", "file", "chrome",
                        "data", "javascript", "about"].contains(uri.scheme)) {
                        if (await canLaunch(url)) {
                          // Launch the App
                          await launch(
                            url,
                          );
                          // and cancel the request
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController.endRefreshing();
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onLoadError: (controller, url, code, message) {
                      pullToRefreshController.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = this.url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  ),
                  progress < 1.0
                      ? Center(child: CircularProgressIndicator(value: progress))
                      : Container(),
                ],
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    webViewController?.goBack();
                  },
                ),
                ElevatedButton(
                  child: Icon(Icons.arrow_forward),
                  onPressed: () {
                    webViewController?.goForward();
                  },
                ),
                ElevatedButton(
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    webViewController?.reload();
                  },
                ),
              ],
            ),
          ])));
    }
  }