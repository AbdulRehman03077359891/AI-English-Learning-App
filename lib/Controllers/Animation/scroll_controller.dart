import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScrollingTextController extends GetxController {
  final textController = TextEditingController(); // Text controller
  final scrollController = ScrollController(); // Scroll controller

  void addText(String newText) {
    textController.text += newText; // Append new text
    Future.delayed(Duration(milliseconds: 50), () {
      scrollToBottom(); // Ensure it scrolls to the bottom
    });
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
