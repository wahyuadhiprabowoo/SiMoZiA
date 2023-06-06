import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ta/app/routes/app_pages.dart';

import '../../../konstanta/colors.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 4),
      () => Get.offAllNamed(Routes.LOGIN),
    );
    return Scaffold(
      body: Center(
        child: AvatarGlow(
            glowColor: Color(AppColors.primary),
            endRadius: 150.0,
            duration: Duration(milliseconds: 1000),
            animate: true,
            repeat: true,
            showTwoGlows: true,
            repeatPauseDuration: Duration(milliseconds: 500),
            child: Image(
              image: AssetImage('assets/img/logo-dengan-tulisan.png'),
            )),
      ),
    );
  }
}
