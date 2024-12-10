import 'package:flutter/material.dart';
import 'package:get/get.dart';

void notify(err, message) {
    Get.snackbar(
      err,
      message,
      
      dismissDirection: DismissDirection.up,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      borderWidth: 3,
        backgroundColor: Colors.transparent,
      borderColor: err == "error" ? Colors.red : Colors.green,
    );
  }