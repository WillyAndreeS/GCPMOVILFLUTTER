import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:acpmovil/models/documento.dart';
import 'package:acpmovil/views/screen_revistas_boletines.dart';
import 'package:url_launcher/url_launcher.dart';

class Revistas extends StatefulWidget {
  const Revistas({Key? key}) : super(key: key);

  @override
  _RevistasState createState() => _RevistasState();
}

class _RevistasState extends State<Revistas> {
  //late Future<List<Documento>> _listaTotalDocumentos;
  final _controller = PageController();
  final _notifierScroll = ValueNotifier(0.0);

  void _listener() {
    _notifierScroll.value = _controller.page!;
  }

  @override
  void initState() {
    _controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final documentoHeight = size.height * 0.45;
    final documentoWidth = size.width * 0.65;

    return Scaffold(
        body: _getViewPagerStack(size, documentoHeight, documentoWidth,
            RevistasBoletines.listaRevistas));
  }

  _getViewPagerStack2(
      size, documentoHeight, documentoWidth, List<Documento> data) {
    List<Widget> documentoss = [];
    for (var doc in data) {
      documentoss.add(Text(doc.titulo));
    }

    return ListView(
      children: documentoss,
    );
  }

  _getViewPagerStack(
      size, documentoHeight, documentoWidth, List<Documento> data) {
    return Stack(
      children: [
        Positioned.fill(
            child: Opacity(
          opacity: 0.4,
          child: Image.asset(
            document_background,
            fit: BoxFit.cover,
          ),
        )),
        ValueListenableBuilder<double>(
            valueListenable: _notifierScroll,
            builder: (context, value, _) {
              return PageView.builder(
                itemCount: data.length,
                controller: _controller,
                itemBuilder: (context, index) {
                  final documento = data[index];
                  final percentage = index - value;
                  final rotation = percentage.clamp(0.0, 1.0);
                  final fixRotation = pow(rotation, 0.35);
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                            child: Stack(
                          children: [
                            Container(
                              height: documentoHeight,
                              width: documentoWidth,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 20,
                                        offset: Offset(5.0, 5.0),
                                        spreadRadius: 10),
                                  ]),
                            ),
                            Transform(
                              alignment: Alignment.centerLeft,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.002)
                                ..rotateY(1.8 * fixRotation)
                                ..translate(-rotation * size.width * 0.8)
                                ..scale(1 + rotation),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: documentoWidth,
                                height: documentoHeight,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0XFF00796B),
                                  ),
                                ),
                                imageUrl: documento.url_portada,
                              ),
                            )
                          ],
                        )),
                        const SizedBox(
                          height: 20,
                        ),
                        Opacity(
                          opacity: 1 - rotation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '<  ${documento.titulo}  >',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${documento.descripcion} / Ed. ${documento.edicion} / ${documento.mes} ${documento.anio}',
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 1.0, end: 0.0),
                                  curve: Curves.decelerate,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        elevation: 6,
                                        primary: const Color(0XFF00796B)),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                      child: const Icon(
                                        Icons.auto_stories,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      _launchURL(documento.url_doc);
                                    },
                                  ),
                                  duration: const Duration(milliseconds: 600),
                                  builder: (context, value, child) {
                                    return Transform.translate(
                                      offset: Offset(0.0, 200 * value),
                                      child: child,
                                    );
                                  }),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            })
      ],
    );
  }

  _getViewPagerStack_bk(size, documentoHeight, documentoWidth) {
    return Stack(
      children: [
        Positioned.fill(
            child: Opacity(
          opacity: 0.4,
          child: Image.asset(
            document_background,
            fit: BoxFit.cover,
          ),
        )),
        ValueListenableBuilder<double>(
            valueListenable: _notifierScroll,
            builder: (context, value, _) {
              return PageView.builder(
                itemCount: documentos.length,
                controller: _controller,
                itemBuilder: (context, index) {
                  final documento = documentos[index];
                  final percentage = index - value;
                  final rotation = percentage.clamp(0.0, 1.0);
                  final fixRotation = pow(rotation, 0.35);
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                            child: Stack(
                          children: [
                            Container(
                              height: documentoHeight,
                              width: documentoWidth,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 20,
                                        offset: Offset(5.0, 5.0),
                                        spreadRadius: 10),
                                  ]),
                            ),
                            Transform(
                              alignment: Alignment.centerLeft,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.002)
                                ..rotateY(1.8 * fixRotation)
                                ..translate(-rotation * size.width * 0.8)
                                ..scale(1 + rotation),
                              child: Image.asset(
                                documento.url_portada,
                                fit: BoxFit.cover,
                                height: documentoHeight,
                                width: documentoWidth,
                              ),
                            )
                          ],
                        )),
                        const SizedBox(
                          height: 20,
                        ),
                        Opacity(
                          opacity: 1 - rotation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '<  ${documento.titulo}  >',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${documento.descripcion} / Ed. ${documento.edicion} / ${documento.mes} ${documento.anio}',
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 1.0, end: 0.0),
                                  curve: Curves.decelerate,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        elevation: 6,
                                        primary: const Color(0XFF00796B)),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                      child: const Icon(
                                        Icons.auto_stories,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      _launchURL(
                                          'https://web.acpagro.com/acpmovil/documentos/revista_2017.pdf');
                                    },
                                  ),
                                  duration: const Duration(milliseconds: 400),
                                  builder: (context, value, child) {
                                    return Transform.translate(
                                      offset: Offset(0.0, -200 * value),
                                      child: child,
                                    );
                                  }),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            })
      ],
    );
  }

  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
