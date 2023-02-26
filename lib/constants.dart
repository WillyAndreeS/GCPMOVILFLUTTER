import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

const kTextColor = Color(0xFF3C4046);
const kBackgroundColor = Color(0xFFF9F8FD);

// ignore: constant_identifier_names
const url_base = "https://190.223.54.4/";
//const url_base = "https://web.acpagro.com/";

const double kDefaultPadding = 20.0;

const kSpacingUnit = 10;


class Constants {
  static const radius = 35.0;
  static const padding = 15.0;
}
const kPrimaryColor = Color(0xFF00AB74);
const kDarkPrimaryColor = Color(0xFF00AB74);
const kArandano = Color(0xFF455AB4);
const kDarkSecondaryColor = Color(0xFF757A63);
const kPanetone = Color(0xFF4FB75A);
const kLightPrimaryColor = Color(0xFFFFFFFF);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFFFC107);
const MenuColor = Color(0XFF107512);
const MenuPrincipal = Color(0XFF7FC880);
const iconMenu = Color(0XFF89AA4E);
const moradoacp = Color(0XFF7B4480);
const azulacp = Color(0XFF3B5977);
const amarilloacp = Color(0xFFE0C354);
bool isPlaying = false;

String? nombreUsuario = "";
String? dniUsuario;
String? empresaUsuario = "";
String? tipoUsuario = "";
String? fnacimiento = "";
bool hasInternets = false;
List menusgcp = [];
final audioPlayer = AudioPlayer();
String? titulomenu = "";
String? imagenmenu = "";

final ttok1 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9";
final ttok2 = "eyJpc3MiOiJodHRwczpcL1wvd2ViLmFjcGFncm8uY29tXC9tYXF1aW5hcmlhIiwic3ViIjoiMjA0NjE2NDI3MDYiLCJhdWQiOiJhcGlfdGtfZ2NwIiwiaWF0IjoxNjczOTI5MzE2LCJqdGkiOiIwMDgifQ";
final ttok3 = "sost2KnRWTh4ZHXhn3dP1MyGz53MoYyoTY9xEdQdhME";

const FOOD_DATA = [
  {
    "name":"Adquirimos nuevas tierras en una zona desértica, ubicada entre los valles de los rios Jequetepeque y Zaña.",
    "leer": "[Leer mas...]",
    "brand":"1999",
    "price":2.99,
    "image":"img_vista_fundo360.JPG"
  },{
    "name":"Iniciamos operaciones en base a un plab expansivo de crecimiento y desarrollo",
    "leer": "[Leer mas...]",
    "brand":"2007",
    "price":4.99,
    "image":"img_reservorios360.jpg"
  },
  {
    "name":"Determinamos priorizar los cultivos permanentes.",
    "leer": "[Leer mas...]",
    "brand":"2010",
    "price":1.49,
    "image":"background_esparrago_campo.jpg"
  },
  {
    "name":"Ingresamos al negocio de algodón fibra e incrementamos",
    "leer": "[Leer mas...]",
    "brand":"2012",
    "price":2.99,
    "image":"cotton.png"
  },
  {
    "name":"Inauguramos nueva planta de empaque, además, logramos alinear la estratégia",
    "leer": "[Leer mas...]",
    "brand":"2014",
    "price":9.49,
    "image":"paltas.png"
  },
  {
    "name":"Realizamos por primera vez el proceso de packing para el cultivo de palta.",
    "leer": "[Leer mas...]",
    "brand":"2015",
    "price":4.49,
    "image":"background_foto_packing.png"
  },
  {
    "name":"Invertimos 1.8 millones de dólares para mejoras en planta procesadora.",
    "leer": "[Leer mas...]",
    "brand":"2016",
    "price":17.99,
    "image":"Apreton-de-manos.png"
  },
  {
    "name":"Nos proyectamos a alcanzar la cantidad de 628 hectáreas de cultivos adicionales distribuidos",
    "leer": "[Leer mas...]",
    "brand":"2017",
    "price":2.99,
    "image":"background_conocenos_acpmundo.jpg"
  },
  {
    "name":"Exportamos más de 2.000 contenedores y nos consolidamos con 2.752 ha de cultivos.",
    "leer": "[Leer mas...]",
    "brand":"2018",
    "price":6.99,
    "image":"background_arandanos_morados.jpg"
  },
  {
    "name":"Iniciamos operaciones en Cerro Prieto Colombia. Cerro Prieto construye su primer colegio en Nueva Esperanza.",
    "leer": "[Leer mas...]",
    "brand":"2019",
    "price":6.99,
    "image":"background_acp_en_mundo.jpg"
  }
];



final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SFProText',
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  backgroundColor: kDarkSecondaryColor,
  iconTheme: ThemeData.dark().iconTheme.copyWith(
    color: kLightSecondaryColor,
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    fontFamily: 'SFProText',
    bodyColor: kLightSecondaryColor,
    displayColor: kLightSecondaryColor,
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kAccentColor),
);

final kLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'SFProText',
  primaryColor: kLightPrimaryColor,
  canvasColor: kLightPrimaryColor,
  backgroundColor: kLightSecondaryColor,
  iconTheme: ThemeData.light().iconTheme.copyWith(
    color: kDarkSecondaryColor,
  ),
  textTheme: ThemeData.light().textTheme.apply(
    fontFamily: 'SFProText',
    bodyColor: kDarkSecondaryColor,
    displayColor: kDarkSecondaryColor,
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kAccentColor),
);
