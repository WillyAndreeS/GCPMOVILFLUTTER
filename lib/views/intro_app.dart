import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroApp extends StatefulWidget {
  IntroApp({Key? key});

  @override
  _IntroAppState createState() => _IntroAppState();
}

class _IntroAppState extends State<IntroApp> {
  final introKey = GlobalKey<IntroductionScreenState>();
  String estadoIntro = "0";
  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  Widget _buildImageColor(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width, color: kPrimaryColor,);
  }

  void _onIntroEnd(context) async{
    await askGPSAccess();
    await PrefIntro("1");
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ScreenHome()),
    );
  }

  Future<void> PrefIntro(String estadointro) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("estadointro", estadointro);
    });
  }



  Future<void> askGPSAccess() async{
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse,
      Permission.photos
    ].request();
    print("Location Permission: ${statuses[Permission.location]},"
        "Location permission2: ${statuses[Permission.locationAlways]}"
        "Location permission3: ${statuses[Permission.locationWhenInUse]}"
        "storage permission: ${statuses[Permission.mediaLibrary]}");
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/images/background_cambiar_clave.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }


  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      //autoScrollDuration: 3000,
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            '¡Vamos ahora mismo!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Geolocalización",
          body:
          "Acepta los permisos y activa tu gps, para ubicar lugares de referencia, rutas y más.",
          image: _buildImage('localizacion (1).png'),
            decoration: pageDecoration.copyWith(
              //pageColor: Color.fromRGBO(0, 0, 0, 0.4),
                bodyTextStyle: TextStyle(color: Colors.black, fontSize: 19,fontFamily: "Schyler"),
                titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28,fontFamily: "Schyler" ),
                contentMargin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                imagePadding: EdgeInsets.only(top: 50))

        ),
        PageViewModel(
          title: "Archivos y contenido multimedia",
          body:
          "Acepta los permisos de archivos y multimedia para visualizar fotos y videos presentados en nuestra galería",
          image: _buildImage('campana-digital.png'),
            decoration: pageDecoration.copyWith(
              //pageColor: Color.fromRGBO(0, 0, 0, 0.4),
              bodyTextStyle: TextStyle(color: Colors.black, fontSize: 19,fontFamily: "Schyler"),
              titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28,fontFamily: "Schyler" ),
              contentMargin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              imagePadding: EdgeInsets.only(top: 50))

        ),
        PageViewModel(
          title: "Telefono",
          body:
          "Acepta los permisos de teléfono y si eres nuestro colaborador, obtén acceso a la agenda GCP y sus funcionalidades extra.",
          image: _buildImage('telefono (1).png'),
            decoration: pageDecoration.copyWith(
              //pageColor: Color.fromRGBO(0, 0, 0, 0.4),
                bodyTextStyle: TextStyle(color: Colors.black, fontSize: 19,fontFamily: "Schyler"),
                titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28,fontFamily: "Schyler" ),
                contentMargin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                imagePadding: EdgeInsets.only(top: 50))
        ),
        /*PageViewModel(
          title: "GCP",
          body:
          "Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          image: _buildFullscreenImage(),
          decoration: pageDecoration.copyWith(
            pageColor: Color.fromRGBO(0, 0, 0, 0.4),
              bodyTextStyle: TextStyle(color: Colors.white, fontSize: 18,fontFamily: "Schyler"),
              titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22,fontFamily: "Schyler" ),
              contentMargin: const EdgeInsets.symmetric(horizontal: 16),
              fullScreen: true,
              bodyFlex: 2,
              imageFlex: 3,
              safeArea: 100
          ),
        ),*/
        PageViewModel(
          title: "Ahora conoce más de nuestra empresa",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Presiona en 'LISTO' para iniciar ", style: bodyStyle),
              /*Icon(Icons.edit),
              Text(" to edit a post", style: bodyStyle),*/
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 3,
            imageFlex: 4,
              bodyTextStyle: TextStyle(color: Colors.black, fontSize: 19,fontFamily: "Schyler"),
              titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28,fontFamily: "Schyler" ),
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
            imagePadding: EdgeInsets.symmetric(vertical:30 )
          ),
          image: _buildImageColor('logo_blanco_gcp.png'),
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back_ios),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward_ios),
      done: const Text('LISTO', style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Schyler",fontSize: 16)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding:  const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.01),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
