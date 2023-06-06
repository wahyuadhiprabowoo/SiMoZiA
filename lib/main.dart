import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Si MoZiA",
      theme: ThemeData(fontFamily: 'Roboto', primarySwatch: Colors.brown),
      initialRoute: Routes.SPLASH_SCREEN,
      getPages: AppPages.routes,
    ),
  );
}
