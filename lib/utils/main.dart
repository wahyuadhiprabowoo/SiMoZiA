import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../app/konstanta/colors.dart';

class Utils {
  static void showMySnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      backgroundColor: Color(AppColors.secondary),
      content: Text(message),
      duration: Duration(seconds: 4),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class LoadingScreen extends StatelessWidget {
  final Color color;
  final double? size;
  const LoadingScreen({required this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitPulse(
        color: color,
        size: size ?? 100,
      ),
    );
  }
}
