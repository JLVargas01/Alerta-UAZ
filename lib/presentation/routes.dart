import 'package:alerta_uaz/presentation/pages/login_page.dart';
import 'package:alerta_uaz/presentation/pages/main_page.dart';
import 'package:flutter/widgets.dart';

Map<String, WidgetBuilder> routes = {
  "/": (_) => const LoginPage(),
  "/main": (_) => const MainPage(),
};
