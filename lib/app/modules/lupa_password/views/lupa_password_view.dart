import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ta/app/routes/app_pages.dart';
import 'package:ta/utils/main.dart';

import '../../../api/api_services.dart';
import '../../../konstanta/colors.dart';
import '../controllers/lupa_password_controller.dart';

class LupaPasswordView extends GetView<LupaPasswordController> {
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
                    height: 250,
                    child: Column(
                      children: [
                        Text(
                          "Lupa password",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 24),
                        ),
                        SizedBox(height: 32),
                        // email
                        TextFormField(
                          textInputAction: TextInputAction.done,
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
                        // text button
                        Container(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            child: Text("Masuk kembali"),
                            onPressed: () => Get.offAllNamed(Routes.LOGIN),
                          ),
                        ),
                        // kirim button
                        SizedBox(
                          height: 28,
                        ),
                        Container(
                          width: double.infinity,
                          height: 47,
                          child: Obx(
                            () => ApiService.isLoading.value
                                ? LoadingScreen(color: Colors.brown)
                                : ElevatedButton(
                                    child: Text("Kirim"),
                                    onPressed: () async {
                                      controller.validateEmail(
                                              controller.emailC.text)
                                          ? await ApiService.forgotPassword(
                                              controller.emailC.text)
                                          : DialogBokInformasi.showAlertDialog(
                                              context,
                                              "Email tidak sesuai format");
                                    }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
