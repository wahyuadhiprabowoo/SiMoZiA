import 'package:get/get.dart';

import 'package:ta/app/modules/add_balita/bindings/add_balita_binding.dart';
import 'package:ta/app/modules/add_balita/views/add_balita_view.dart';
import 'package:ta/app/modules/detail_balita/bindings/detail_balita_binding.dart';
import 'package:ta/app/modules/detail_balita/views/detail_balita_view.dart';
import 'package:ta/app/modules/detail_pengukuran_berat_badan/bindings/detail_pengukuran_berat_badan_binding.dart';
import 'package:ta/app/modules/detail_pengukuran_berat_badan/views/detail_pengukuran_berat_badan_view.dart';
import 'package:ta/app/modules/detail_pengukuran_detak_jantung/bindings/detail_pengukuran_detak_jantung_binding.dart';
import 'package:ta/app/modules/detail_pengukuran_detak_jantung/views/detail_pengukuran_detak_jantung_view.dart';
import 'package:ta/app/modules/detail_pengukuran_panjang_badan/bindings/detail_pengukuran_panjang_badan_binding.dart';
import 'package:ta/app/modules/detail_pengukuran_panjang_badan/views/detail_pengukuran_panjang_badan_view.dart';
import 'package:ta/app/modules/edit_balita/bindings/edit_balita_binding.dart';
import 'package:ta/app/modules/edit_balita/views/edit_balita_view.dart';
import 'package:ta/app/modules/edit_profile/bindings/edit_profile_binding.dart';
import 'package:ta/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:ta/app/modules/home/bindings/home_binding.dart';
import 'package:ta/app/modules/home/views/home_view.dart';
import 'package:ta/app/modules/login/bindings/login_binding.dart';
import 'package:ta/app/modules/login/views/login_view.dart';
import 'package:ta/app/modules/lupa_password/bindings/lupa_password_binding.dart';
import 'package:ta/app/modules/lupa_password/views/lupa_password_view.dart';
import 'package:ta/app/modules/register/bindings/register_binding.dart';
import 'package:ta/app/modules/register/views/register_view.dart';
import 'package:ta/app/modules/splash_screen/bindings/splash_screen_binding.dart';
import 'package:ta/app/modules/splash_screen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BALITA,
      page: () => AddBalitaView(),
      binding: AddBalitaBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_BALITA,
      binding: DetailBalitaBinding(),
      page: () => DetailBalitaView(),
    ),
    GetPage(
      name: _Paths.DETAIL_PENGUKURAN_BERAT_BADAN,
      page: () => DetailPengukuranBeratBadanView(),
      binding: DetailPengukuranBeratBadanBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PENGUKURAN_PANJANG_BADAN,
      page: () => DetailPengukuranPanjangBadanView(),
      binding: DetailPengukuranPanjangBadanBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PENGUKURAN_DETAK_JANTUNG,
      page: () => DetailPengukuranDetakJantungView(),
      binding: DetailPengukuranDetakJantungBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_BALITA,
      page: () => EditBalitaView(),
      binding: EditBalitaBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.LUPA_PASSWORD,
      page: () => LupaPasswordView(),
      binding: LupaPasswordBinding(),
    ),
  ];
}
