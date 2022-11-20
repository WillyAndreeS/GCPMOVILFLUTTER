
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/principalpage.dart';
import 'package:acpmovil/views/screen_home.dart';
import 'package:acpmovil/views/somosacp2.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';


class MyMenuPage extends StatefulWidget {
   MyMenuPage({Key? key}) : super(key: key);

  @override
  MyMenuPageState createState() => MyMenuPageState();
}

class MyMenuPageState extends State<MyMenuPage> {
  List<ScreenHiddenDrawer> _pages = [];

  final selectstyle =  const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color:Colors.white
  );

  final defaultstyle =  const TextStyle(
    //  fontWeight: FontWeight.bold,
      fontSize: 14,
      color:Colors.white
  );

  @override
  void initState(){
    super.initState();

    _pages = [

      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: '¿Quiénes somos?',
          baseStyle: defaultstyle,
          selectedStyle: selectstyle,
          colorLineSelected:MenuColor,
        ),
        Somosacp(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'GCP Mundo',
          baseStyle: defaultstyle,
          selectedStyle: selectstyle,
          colorLineSelected:MenuColor,
        ),
        Somosacp(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'ACP Club',
          baseStyle: defaultstyle,
          selectedStyle: selectstyle,
          colorLineSelected:MenuColor,
        ),
        Somosacp(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'ACP Go',
          baseStyle: defaultstyle,
          selectedStyle: selectstyle,
          colorLineSelected:MenuColor,
        ),
        Somosacp(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Galería',
          baseStyle: defaultstyle,
          selectedStyle: selectstyle,
          colorLineSelected:MenuColor,
        ),
        Somosacp(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Radio GCP',
          baseStyle: defaultstyle,
          selectedStyle: selectstyle,
          colorLineSelected:MenuColor,
        ),
        Somosacp(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Contactos emergencia',
          baseStyle: defaultstyle,
          selectedStyle: selectstyle,
          colorLineSelected:MenuColor,
        ),
         MyPrincipalPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Cerrar Sesión',
          baseStyle: defaultstyle,
          selectedStyle: selectstyle,
          colorLineSelected:MenuColor,
        ),
        ScreenHome(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
      return HiddenDrawerMenu(
        backgroundColorMenu: kDarkPrimaryColor,
        screens: _pages,
        initPositionSelected: 0,
        slidePercent: 50,
        contentCornerRadius: 30,
      );
  }
}