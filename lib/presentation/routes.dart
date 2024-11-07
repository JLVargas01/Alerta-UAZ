import 'package:alerta_uaz/presentation/pages/alert_page.dart';
import 'package:alerta_uaz/presentation/pages/login_page.dart';
import 'package:alerta_uaz/presentation/pages/main_page.dart';
import 'package:alerta_uaz/presentation/pages/map_page.dart';
import 'package:alerta_uaz/presentation/pages/request_phone_page.dart';
import 'package:flutter/widgets.dart';

Map<String, WidgetBuilder> routes = {
  "/alert": (_) => const AlertPage(),
  "/login": (_) => const LoginPage(),
  "/requestPhone": (_) => const RequestPhonePage(),
  "/main": (_) => const MainPage(),
  "/map": (_) => const MapPage(),
};
