import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding/data/colors.dart';
import 'package:wedding/data/strings.dart';
import 'package:wedding/pages/mobile/auth_page.dart';
import 'package:wedding/pages/mobile/root_page.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    check();
  }

  Future<void> check() async {
    await Future.delayed(Duration(seconds: 3));
    var preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey(accessTokenKey))
      Get.off(() => RootPage());
    else
      Get.off(() => AuthPage());
  }
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _ = Get.put(SplashController());
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Text('매칭 브릿지', style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center),
          Image.asset('assets/splash.png')
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      )
    );
  }
}