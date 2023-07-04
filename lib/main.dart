import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ta/app/api/api_services.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String token = await ApiService.token();
  print("ini token main $token");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Si MoZiA",
      theme: ThemeData(fontFamily: 'Roboto', primarySwatch: Colors.brown),
      initialRoute: token.length == 0 ? Routes.SPLASH_SCREEN : Routes.HOME,
      // testing view
      // initialRoute: Routes.LUPA_PASSWORD,
      getPages: AppPages.routes,
    ),
  );
}
