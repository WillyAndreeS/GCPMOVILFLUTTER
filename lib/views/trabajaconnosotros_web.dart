
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



class TrabajaNosotrosWeb extends StatefulWidget {
  String? url, titulo;
  TrabajaNosotrosWeb({Key? key, this.url, this.titulo}) ;

  @override
  _TrabajaNosotrosWebState createState() => _TrabajaNosotrosWebState();
}

class _TrabajaNosotrosWebState extends State<TrabajaNosotrosWeb> {
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
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: Text(widget.titulo!, style: TextStyle(fontFamily: "Schyler"),),
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
                    URLRequest(url: Uri.parse(widget.url!)),
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
          ])));
    }
  }