import 'package:acpmovil/views/certificacionespage.dart';
import 'package:acpmovil/views/culturapage.dart';
import 'package:acpmovil/views/principal_page.dart';
import 'package:acpmovil/views/principalpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:acpmovil/views/bank_card_model.dart';
import 'package:acpmovil/constants.dart';
import 'package:flutter/material.dart';

String? _nombre = "";
String bank = "";
var ddData = [];
var ddDataEventos = [];

class BankCard extends StatefulWidget {
  const BankCard({
    Key? key,
    required this.bankCard,
  }) : super(key: key);

  final BankCardModel bankCard;

  @override
  _BankCardState createState() => _BankCardState();
}

class _BankCardState extends State<BankCard> {

  _obtenerUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombre = (prefs.get("name") ?? "USER") as String;
    });
  }

  @override
  void initState() {
    super.initState();
    _obtenerUsuario();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          if(widget.bankCard.icon.contains("Venta")){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  MyPrincipalPage()));
                }else if( widget.bankCard.icon.contains("Historial")){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  CulturaPage()));
                }else if(widget.bankCard.icon.contains("Graficos")){
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  CertificacionesPage()));
                }else{
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  PrincipalPage()));
                }
          },
        child: Container(
                margin:  const EdgeInsets.symmetric(
                  horizontal: Constants.padding,
                ),
                padding: const EdgeInsets.all(Constants.padding * 0.7),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.bankCard.icon.contains("Venta")
                        ? 'assets/images/img_quienes_somos.jpeg'
                        : widget.bankCard.icon.contains("Historial")
                            ? 'assets/images/img_mvv.jpeg'
                        : widget.bankCard.icon.contains("Graficos") ? 'assets/images/certificaciones2.jpeg' : 'assets/images/img_galeria_presentaciones.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(
                    Constants.radius,
                  ),
                ),
                child: Stack(
                    children: [
                      Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black38,
                                  shadowColor: Colors.black26,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),),

                              onPressed: null,

                              child:Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.transparent,
                              child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:  [
                                     Icon(
                                      widget.bankCard.icon.contains("Venta") ? Icons.business : widget.bankCard.icon.contains("Historial")
                                          ? Icons.accessibility_new_outlined
                                          : widget.bankCard.icon.contains("Graficos") ? Icons.document_scanner_rounded : Icons.backpack,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                     Text(
                                       widget.bankCard.icon.contains("Venta") ? '¿Quienes somos?' : widget.bankCard.icon.contains("Historial")
                                           ? 'Cultura'
                                           : widget.bankCard.icon.contains("Graficos")  ? 'Certificaciones' : 'Presentaciones',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ))),
                  ],),/*Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),

                    Text(
                      widget.bankCard.icon.contains("Venta") ? '¿Quienes somos?' : widget.bankCard.icon.contains("Historial")
                          ? 'Cultura'
                          : 'Contáctanos',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.white),
                    )
                  ],
                ),*/

              )
            );//);
  }
}
