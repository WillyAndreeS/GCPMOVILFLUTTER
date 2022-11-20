import 'dart:convert';

import 'package:flutter/material.dart';

List eventost = [];
var ddData = [];
//String eventost = "";

class AddCard extends StatefulWidget {
  const AddCard({
    Key? key,
  }) : super(key: key);

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            "VENTAS DEL DIA",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(height: 30),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: ddData.length,
            itemBuilder: (BuildContext context, i) {
              //     setState(() {

              //  });
              if (ddData.isEmpty) {
                return const Center(
                    child: Text("No ha creado eventos hoy",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)));
              } else {
                print("HOLA: " + ddData[i]["IDEVENTO"].toString());
                return GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                        //color: Colors.black,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 10, left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset.zero)
                            ]),
                        child: Column(
                          children: [
                            Container(
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        ClipOval(
                                          child: Image.asset(
                                              (ddData[i]["IDCULTIVO"] == '0021'
                                                  ? 'assets/images/' +
                                                      ddData[i]["IDCULTIVO"] +
                                                      '.png'
                                                  : ddData[i]["IDCULTIVO"] ==
                                                          '0006'
                                                      ? 'assets/images/' +
                                                          ddData[i]
                                                              ["IDCULTIVO"] +
                                                          '.png'
                                                      : 'assets/images/0000.png'),
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(ddData[i]["DESCRIPCION"],
                                              style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                          const SizedBox(height: 2),
                                          const Divider(),
                                          const SizedBox(height: 15),
                                          Row(children: <Widget>[
                                            const Icon(Icons.workspaces_filled),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                                'STOCK: ' +
                                                    double.parse(
                                                            ddData[i]["STOCK"])
                                                        .toStringAsFixed(2)
                                                        .toString() +
                                                    ' ' +
                                                    ddData[i]["UMEDIDA"],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14))
                                          ]),
                                          const SizedBox(height: 2),
                                          Row(children: <Widget>[
                                            const Icon(Icons.monetization_on),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                                'Precio unit.: s/.' +
                                                    ddData[i]["PRECIO"]
                                                        .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14))
                                          ]),
                                          Container(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                      ddData[i]["FECHA"]
                                                          .substring(0, 16),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontStyle: FontStyle
                                                              .italic)))),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        )));
              }
              //return Container();
            }),
        const SizedBox(height: 50),
        FloatingActionButton(
          onPressed: () {

          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.add, size: 50, color: Colors.green),
        ),
      ],
    );
  }
}
