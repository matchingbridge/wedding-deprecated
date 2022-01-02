import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wedding/pages/mobile/splash_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:wedding/pages/web/home_page.dart';

void main() => runApp(WeddingApp());

class WeddingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GetMaterialApp(
    home: kIsWeb ? HomePage() : SplashPage()
    // home: HomePage()
  );
}