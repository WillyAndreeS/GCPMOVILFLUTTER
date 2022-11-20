import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:acpmovil/constants.dart';
import 'package:acpmovil/views/bank_card_model.dart';
import 'package:acpmovil/views/add_card.dart';
import 'package:acpmovil/views/bank_card.dart';
import 'package:acpmovil/views/drawer.dart';

var ddDataEventos = [];
var ddDataStock = [];

class PrincipalPage extends DrawerContent {
   PrincipalPage({Key? key}) ;

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  final PageController _pg = PageController(
    viewportFraction: .8,
    initialPage: 0,

  );

  String nombre = "USER";
  String dni = "00000000";

  _obtenerUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombre = (prefs.get("name") ?? "USER") as String;
      dni = (prefs.get("dni") ?? "00000000") as String;
    });
  }

  double page = 0;
  double pageClamp = 1;

  late Size size;

  double verPos = 0.0;

  Duration defaultDuration = const Duration(milliseconds: 300);

  void pageListener() {
    setState(() {
      page = _pg.page!;
      pageClamp = page.clamp(0, 1);
    });
  }

  void onVerticalDrad(DragUpdateDetails details) {
    setState(() {
      verPos += details.primaryDelta!;
      verPos = verPos.clamp(0, double.infinity);
    });
  }

  void onVerticalDradEnds(DragEndDetails details) {
    setState(() {
      if (details.primaryVelocity! > 500 || verPos > size.height / 2) {
        verPos = size.height - 40;
      }
      if (details.primaryVelocity! < -500 || verPos < size.height / 2) {
        verPos = 0;
      }
    });
  }


  @override
  void initState() {
    _pg.addListener(pageListener);
    super.initState();
    _obtenerUsuario();
    getPostsData();
    //_showDialog();

  }


  Future<void> showAutoDisposeDialog() async {
    const displayTime = Duration(seconds: 2);

    try {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(child:Container(child: Image.asset("assets/images/swipe.gif")));
          })
          .timeout(displayTime);

    } on TimeoutException { // import 'dart:async';
      Navigator.of(context).pop();
    }
  }

  _showDialog() async {
    await Future.delayed(const Duration(seconds: 3));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(child:Container(child: Image.asset("assets/images/swipe.gif")));
        });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _pg.removeListener(pageListener);
    super.dispose();
  }

  List<Widget> itemsData = [];

  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  void getPostsData() {
    List<dynamic> responseList = FOOD_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: kDarkPrimaryColor, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          ]),
          child: Container(
            height: 75,
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30.0)), color: kDarkPrimaryColor,
              ),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.green,
                    ),
                    child: Image.asset(
                      "assets/images/${post["image"]}",
                        fit: BoxFit.cover,)
                ),
                SizedBox(
                    width: 100,

                    child: Text(
                      post["brand"],
                      style: const TextStyle(fontSize: 13, color: Colors.black,),
                    )),


              ],
            )),
          ));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    print(page);
    return WillPopScope(
        onWillPop: () {
      print("No puedes ir atras");
      // ignore: null_check_always_fails
      return null!;
    },
    child:  Scaffold(


      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Image.asset('assets/images/gcp_movil_001.png', scale: 5),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onMenuPressed
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.map_sharp),
            onPressed: () {},
          ),

        ],


      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_gcp.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(

        children: [
          Container(
            margin: const EdgeInsets.only(top: 50, bottom: 10 ),
           child: Expanded(
              child: ListView.builder(
                  controller: controller,
                  itemCount: itemsData.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    /*if (topContainer > 0.5) {
                      scale = index + 0.5 - topContainer;
                      if (scale < 0) {
                        scale = 0;
                      } else if (scale > 1) {
                        scale = 1;
                      }
                    }*/
                    return Align(
                            heightFactor: 1,
                            alignment: Alignment.topCenter,
                            child: itemsData[index]);
                  }))),
          // Add card background

          // Add card

          // cards list
          /*Positioned(
            top: page == -1 ? 0 : (size.height * .15) + verPos,
            bottom: page == -1 ? 0 : size.height * .20 - verPos,
            left: 0,
            right: 0,
            child: PageView(
              controller: _pg,
              children: cards
                  .map(
                    (e) => e == null
                        ? const SizedBox.shrink()
                        : Transform.translate(
                            offset: Offset(
                              page < 0 ? (1 - pageClamp) * 50 : 0,
                              0,
                            ),
                            child: BankCard(
                              bankCard: e,
                            ),
                          ),
                  )
                  .toList(),
            ),
          ),
      Positioned(
        top: 500,
        bottom: 0,
        left: 0,
        right: 0,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cards.map((itemCarousel) {
              int index = cards.indexOf(itemCarousel);
              return Container(
                width: 15.0,
                height: 15.0,
                margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: page == index ? Colors.black : Colors.black26,
                ),
              );
            }).toList(),
          ),),*/
        ],
      ),),

    ));
  }
}

