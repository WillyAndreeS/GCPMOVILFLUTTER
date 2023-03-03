import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:linkable/linkable.dart';

class ConocenosContactanos extends StatefulWidget {
  const ConocenosContactanos({Key? key}) : super(key: key);

  @override
  _ConocenosContactanosState createState() => _ConocenosContactanosState();
}

class _ConocenosContactanosState extends State<ConocenosContactanos> {

  void _launchURL(String url) async => await canLaunch(url) ? await launch(url) : throw 'Coult not launch $url';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF00AB74),
        title: const Text('Contáctanos'),
      ),
      body: Stack(
        children: [
          CachedNetworkImage(
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => Container(
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0XFF00796B),
                ),
              ),
            ),
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/background_foto_arandanos.jpg?alt=media&token=de57d08f-d041-4e7e-896e-3ff88b33f5a4',
          ),
          Container(
            color: Colors.black38,
            height: double.infinity,
            width: double.infinity,
          ),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 1.0, end: 0.0),
                      curve: Curves.decelerate,
                      child: const Text(
                        'OFICINAS',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Schyler",
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                      duration: const Duration(milliseconds: 700),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0.0, -200 * value),
                          child: child,
                        );
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 1.0, end: 0.0),
                      curve: Curves.decelerate,
                      child: const Text(
                        'Calle Dean Valdivia NRO. 111 INT. 1002, URB. JARDÍN SAN ISIDRO - LIMA - PERÚ',
                        style: TextStyle(color: Colors.white, fontSize: 15,fontFamily: "Schyler"),
                        textAlign: TextAlign.center,
                      ),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0.0, -200 * value),
                          child: child,
                        );
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: 0.0),
                    curve: Curves.decelerate,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          primary: const Color(0XFF00AB74)),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: const Icon(
                          Icons.apartment,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    duration: const Duration(milliseconds: 400),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0.0, -200 * value),
                        child: child,
                      );
                    }),
                const SizedBox(
                  height: 10,
                ),
                _animacion(
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Central Telefónica: ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                        Linkable(
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15,fontFamily: "Schyler"),
                          linkColor: Colors.greenAccent,
                          text: "+51016193900",
                        )
                      ],
                    ),
                    const Duration(milliseconds: 300),
                    Curves.decelerate),
                const SizedBox(
                  height: 5,
                ),
                _animacion(
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Informes y Ventas: ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15,fontFamily: "Schyler")),
                        Linkable(
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15,fontFamily: "Schyler"),
                          linkColor: Colors.greenAccent,
                          text: "info@acpagro.com",
                        )
                      ],
                    ),
                    const Duration(milliseconds: 300),
                    Curves.decelerate),
                const SizedBox(
                  height: 30,
                ),
                _animacion(
                    const Text(
                      'FUNDO',
                      style: TextStyle(
                          fontFamily: "Schyler",
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    const Duration(milliseconds: 300),
                    Curves.decelerate),
                _animacion(
                    const Text(
                      'Carretera Panamericana Norte Km. 733 - Pacanga Chepén La Libertad, Perú.',
                      style: TextStyle(fontFamily: "Schyler",color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const Duration(milliseconds: 300),
                    Curves.decelerate),
                const SizedBox(
                  height: 10,
                ),
                _animacion(
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          primary: const Color(0XFF00AB74)),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: const Icon(
                          Icons.terrain,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const Duration(milliseconds: 250),
                    Curves.decelerate),
                const SizedBox(
                  height: 20,
                ),
                _animacion_2(
                    const Text(
                      'Síguenos en',
                      style: TextStyle(
                          fontFamily: "Schyler",
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const Duration(milliseconds: 400),
                    Curves.decelerate),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _animacion_2(
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              primary: const Color(0XFF00AB74)),
                          child: Container(
                            width: 35,
                            height: 45,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: const Icon(
                              Icons.facebook,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            _launchURL("https://www.facebook.com/AgricolaCerroPrietoSA/?locale=es_LA");
                          },
                        ),
                        const Duration(milliseconds: 500),
                        Curves.decelerate),
                    _animacion_2(
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              primary: const Color(0XFF00AB74)),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            width: 35,
                            height: 45,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: SvgPicture.asset(
                                'assets/images/instagram.svg',
                                color: Colors.white,
                                semanticsLabel: 'Instagram'),
                          ),
                          onPressed: () {
                            _launchURL("https://www.instagram.com/acpagro/?hl=es");
                          },
                        ),
                        const Duration(milliseconds: 600),
                        Curves.decelerate),
                    _animacion_2(
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              primary: const Color(0XFF00AB74)),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            width: 35,
                            height: 45,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: SvgPicture.asset('assets/images/youtube.svg',
                                color: Colors.white, semanticsLabel: 'Youtube'),
                          ),
                          onPressed: () {
                            _launchURL("https://www.youtube.com/@agricolacerroprieto8162");
                          },
                        ),
                        const Duration(milliseconds: 700),
                        Curves.decelerate),
                    _animacion_2(
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              primary: const Color(0XFF00AB74)),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            width: 35,
                            height: 45,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: SvgPicture.asset(
                                'assets/images/linkedin.svg',
                                color: Colors.white,
                                semanticsLabel: 'Linkedin'),
                          ),
                          onPressed: () {
                            _launchURL("https://pe.linkedin.com/company/acpagrooficial");
                          },
                        ),
                        const Duration(milliseconds: 800),
                        Curves.decelerate),
                  ],
                )

                /*Linkable(
                  text:
                      "Hi!\nI'm Anup.\n\nYou can email me at 1anuppanwar@gmail.com.\nOr just whatsapp me @ +91-8968894728.\n\nFor more info visit: \ngithub.com/anupkumarpanwar \nor\nhttps://www.linkedin.com/in/anupkumarpanwar/",
                )*/
              ],
            ),
          ))
        ],
      ),
    );
  }

  _animacion(Widget widget, Duration duration, Curve curves) {
    return TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 0.0),
        curve: curves,
        child: widget,
        duration: duration,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0.0, -200 * value),
            child: child,
          );
        });
  }

  _animacion_2(Widget widget, Duration duration, Curve curves) {
    return TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 0.0),
        curve: curves,
        child: widget,
        duration: duration,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0.0, 200 * value),
            child: child,
          );
        });
  }
}
