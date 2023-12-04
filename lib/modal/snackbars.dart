import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBars {
  void showSnackBar(String title, String contentText) {
    Get.snackbar(title, contentText,
        colorText: Colors.white70,
        backgroundColor: Colors.black38,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        maxWidth: 500,
        icon: Icon(
          Icons.info_outlined,
          color: Colors.white54,
        ),
        borderColor: Colors.white60,
        borderWidth: 1);
  }
}
