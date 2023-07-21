import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ta/app/api/api_services.dart';
import 'package:ta/app/konstanta/colors.dart';
import 'package:ta/app/routes/app_pages.dart';
import 'package:ta/utils/main.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.9;
    return Scaffold(
      backgroundColor: Color(AppColors.secondary),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 570,
                  color: Color(AppColors.secondary),
                ),
                Container(
                  height: 315,
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Image.asset(
                          "assets/img/logo.png",
                          height: 148,
                        ),
                      ),
                      Text("Si MoZiA",
                          style: TextStyle(
                              fontSize: 30,
                              color: Color(AppColors.white),
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Positioned(
                  top: 255,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      width: containerWidth,
                      height: 275,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color(AppColors.primary),
                              blurStyle: BlurStyle.inner,
                              blurRadius: 10,
                              offset: Offset(0, 6))
                        ],
                        color: Color(AppColors.accent),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 300,
                  left: 48,
                  right: 48,
                  child: Container(
                    width: containerWidth,
                    height: 300,
                    child: Column(
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 32),
                        ),
                        SizedBox(height: 24),
                        // email
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: controller.emailC,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Color(AppColors.white),
                            labelText: "email",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(AppColors.secondary)),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.brown),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        SizedBox(height: 24),
                        // password
                        Obx(
                          () => Container(
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              controller: controller.passC,
                              obscureText: controller.isHidden.value == true
                                  ? true
                                  : false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.key),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.isHidden.toggle();
                                    },
                                    icon: Icon(controller.isHidden == true
                                        ? Icons.visibility
                                        : Icons.visibility_off_outlined)),
                                filled: true,
                                fillColor: Color(AppColors.white),
                                labelText: "Password",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(AppColors.secondary)),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.brown),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // text button
                        Container(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            child: Text("Lupa password?"),
                            onPressed: () => Get.offNamed(Routes.LUPA_PASSWORD),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24,
                top: 24,
              ),
              child: Container(
                  width: double.infinity,
                  height: 47,
                  child: Obx(
                    () {
                      return ApiService.isLoading.value
                          ? LoadingScreen(
                              color: Colors.white,
                            )
                          : ElevatedButton(
                              child: Text("Masuk"),
                              onPressed: () async {
                                if (controller.passC.text.length < 8 &&
                                    controller.validateEmail(
                                            controller.emailC.text) ==
                                        false) {
                                  DialogBokInformasi.showAlertDialog(context,
                                      "Email dan password harus benar!");
                                } else if (controller.passC.text.length < 8) {
                                  DialogBokInformasi.showAlertDialog(
                                      context, "Password minimal 8");
                                } else if (controller.validateEmail(
                                        controller.emailC.text) ==
                                    false) {
                                  DialogBokInformasi.showAlertDialog(
                                      context, "Email anda salah!");
                                } else {
                                  // send data to api
                                  var body = {
                                    "email": controller.emailC.text.trim(),
                                    "password": controller.passC.text.trim()
                                  };
                                  await ApiService.login(body);
                                }
                              });
                    },
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tidak memiliki akun?",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(AppColors.white),
                        fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.offAllNamed(Routes.REGISTER);
                      },
                      child: Text(
                        "Buat akun",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
