import 'package:flutter/cupertino.dart';

String idcultivo = "0000",
    stock = "0",
    umedida = "UM",
    descripcion = "Ventas sin registrar";

class BankCardModel {
  String image;
  String icon;
  String number;
  String balance;
  List<ExpenseModel> expenses;

  BankCardModel({
    required this.image,
    required this.icon,
    required this.number,
    required this.balance,
    this.expenses = const [],
  });
}

class ExpenseModel {
  String image;
  String title;
  String description;
  String amount;

  ExpenseModel({
    required this.image,
    required this.title,
    required this.description,
    required this.amount,
  });
}

final cards = [
  BankCardModel(
    image: 'assets/images/' + idcultivo + '_grande.jpg',
    icon: 'Venta',
    number: stock + " " + umedida,
    balance: "0.00",
    expenses: [
      ExpenseModel(
          image: 'assets/images/' + idcultivo + '.png',
          title: "Venta",
          description: "Stock actual",
          amount: '0 UM')
    ],
  ),
  BankCardModel(
    image: 'assets/images/archivo01.jpg',
    icon: 'Historial',
    number: "28 eventos",
    balance: "",
    expenses: [
      ExpenseModel(
        image: 'assets/images/reembolso.png',
        title: "Historial",
        description: "datos de ventas",
        amount: '28 eventos',
      )
    ],
  ),
  BankCardModel(
    image: 'assets/images/grafics.jpg',
    icon: 'Graficos',
    number: "Gráficos",
    balance: "",
    expenses: [
      ExpenseModel(
        image: 'assets/images/report.png',
        title: "Reportes",
        description: "Gráficos de ventas",
        amount: '',
      )
    ],
  ),

  BankCardModel(
    image: 'assets/images/grafics.jpg',
    icon: 'Presentaciones',
    number: "Presentaciones",
    balance: "",
    expenses: [
      ExpenseModel(
        image: 'assets/images/report.png',
        title: "Presentaciones",
        description: "Gráficos de ventas",
        amount: '',
      )
    ],
  ),

];

// bg_1 : https://unsplash.com/photos/5LOhydOtTKU?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// bg_2 : https://unsplash.com/photos/5LOhydOtTKU?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink