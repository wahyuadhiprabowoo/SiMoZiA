import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ta/app/api/api_services.dart';
import 'package:ta/app/konstanta/colors.dart';
import 'package:ta/utils/main.dart';

import '../../../routes/app_pages.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final satu_empat = screenHeight * 0.3;
    return Scaffold(
      backgroundColor: Color(AppColors.secondary),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(children: [
            Container(
              height: satu_empat,
              alignment: Alignment.center,
              child: Text(
                "Buat Akun",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ),
            // nama
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              controller: controller.nameC,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                filled: true,
                fillColor: Color(AppColors.white),
                labelText: "Nama",
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(AppColors.accent)),
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
                labelText: "Email",
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(AppColors.accent)),
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
              () => TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                controller: controller.passC,
                obscureText: controller.isHidden.value == true ? true : false,
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
                      borderSide: BorderSide(color: Color(AppColors.accent)),
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
            SizedBox(height: 24),
            // Ulang password
            Obx(
              () => TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                controller: controller.passConfirmationC,
                obscureText:
                    controller.isHiddenconf.value == true ? true : false,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.key),
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.isHiddenconf.toggle();
                      },
                      icon: Icon(controller.isHiddenconf == true
                          ? Icons.visibility
                          : Icons.visibility_off_outlined)),
                  filled: true,
                  fillColor: Color(AppColors.white),
                  labelText: "Ulangi password",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(AppColors.accent)),
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
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 47,
              child: ElevatedButton(
                  onPressed: () async {
                    var register = {
                      'name': controller.nameC.text.trim(),
                      'email': controller.emailC.text.trim(),
                      'password': controller.passC.text.trim(),
                      'password_confirmation':
                          controller.passConfirmationC.text.trim()
                    };
                    await ApiService.register(register);
                  },
                  child: Text("Buat akun")),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Kembali ke",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(AppColors.white),
                    fontWeight: FontWeight.w600),
              ),
              TextButton(
                  onPressed: () {
                    Get.offNamed(Routes.LOGIN);
                  },
                  child: Text(
                    "Masuk",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ))
            ])
          ]),
        ),
      ),
    );
  }
}
