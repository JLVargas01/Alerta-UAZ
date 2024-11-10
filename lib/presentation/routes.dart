import 'package:alerta_uaz/presentation/pages/alert_page.dart';
import 'package:alerta_uaz/presentation/pages/login_page.dart';
import 'package:alerta_uaz/presentation/pages/main_page.dart';
import 'package:alerta_uaz/presentation/pages/map_page.dart';
import 'package:alerta_uaz/presentation/pages/splash_page.dart';
import 'package:flutter/widgets.dart';

Map<String, WidgetBuilder> routes = {
  "/alert": (_) => const AlertPage(),
  "/login": (_) => const LoginPage(),
  "/main": (_) => const MainPage(),
  "/map": (_) => const MapPage(),
  "/splash": (_) => const SplashPage(),
};
