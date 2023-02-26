import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linkable/linkable.dart';

class LineaEtica extends StatefulWidget {
  const LineaEtica({Key? key}) : super(key: key);

  @override
  _LineaEticaState createState() => _LineaEticaState();
}

class _LineaEticaState extends State<LineaEtica> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF00AB74),
        title: const Text('Línea Ética'),
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
                'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/img_esparrago_offline.jpg?alt=media&token=6ed26633-b9a0-4a57-beb8-716de61e4a9c',
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
                          Icons.help,
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
                        const Text('Correo Electrónico: ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                        Linkable(
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          linkColor: Colors.greenAccent,
                          text: "linea.etica@acpagro.com",
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
                        const Text('Celular o Whatsapp: ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                        Linkable(
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          linkColor: Colors.greenAccent,
                          text: "982848640",
                        )
                      ],
                    ),
                    const Duration(milliseconds: 300),
                    Curves.decelerate),
                const SizedBox(
                  height: 30,
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
                          Icons.handshake,
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
                _animacion(
                    const Text(
                      'Entrevista Personal',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const Duration(milliseconds: 300),
                    Curves.decelerate),
                _animacion(
                    const Text(
                      'Fundo: Oficial de cumplimiento normativo',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const Duration(milliseconds: 300),
                    Curves.decelerate),
                _animacion(
                    const Text(
                      'Lima: Dean Valdivia 111, Oficina 901, San Isidro',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const Duration(milliseconds: 300),
                    Curves.decelerate),
                const SizedBox(
                  height: 20,
                ),


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
