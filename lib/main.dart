
import 'package:acpmovil/views/home.dart';
import 'package:acpmovil/views/intro_app.dart';
import 'package:acpmovil/views/screen_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'Dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  Firebase.initializeApp().then((value) {
    runApp( MyApp());
  });
  //SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp, DeviceOrientation.portraitDown ]);

}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String estadoIntro = "0";
  //const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  _obtenerPrefIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      estadoIntro = (prefs.get("estadointro") ?? "0") as String;
    });
  }

  @override
  void initState() {
    super.initState();
    _obtenerPrefIntro();
  }

  @override
  Widget build(BuildContext context) {
    HttpOverrides.global = MyHttpOverrides();
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: estadoIntro == "0" ? IntroApp(): ScreenHome(),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
