/*
// Mapa que contiene las rutas de navegacion en la aplicacion
*/
import 'package:alerta_uaz/presentation/pages/alert_page.dart';
import 'package:alerta_uaz/presentation/pages/login_page.dart';
import 'package:alerta_uaz/presentation/pages/home_page.dart';
import 'package:alerta_uaz/presentation/pages/map_page.dart';
import 'package:alerta_uaz/presentation/pages/request_phone_page.dart';
import 'package:alerta_uaz/presentation/pages/splash_page.dart';
import 'package:flutter/widgets.dart';

Map<String, WidgetBuilder> routes = {
  "/alert": (_) => const AlertPage(),
  "/login": (_) => const LoginPage(),
  "/requestPhone": (_) => const RequestPhonePage(),
  "/home": (_) => const HomePage(),
  "/map": (_) => const MapPage(),
  "/splash": (_) => const SplashPage(),
};
