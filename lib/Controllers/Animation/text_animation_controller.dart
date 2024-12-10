import 'package:ai_english_learning/manager/ticker.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class TextAnimationController extends GetxController {
  final displayedText = "".obs;
  AnimationController? animationController; // Make nullable
  late Animation<int> textAnimation;
  final totalDurationInSeconds = 0.0.obs;

  static const double charDurationInSeconds = 0.1; // Fixed duration per character

  // Use the CustomTickerProvider
  late final CustomTickerProvider tickerProvider = CustomTickerProvider();

  // Initialize the animation controller and animations
  void initializeAnimation(String text) {
    // Dispose the existing animation controller, if any
    animationController?.dispose();

    // Clean the text by removing non-alphabetical characters
    String cleanedText = text.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    // Calculate the total duration based on fixed speed per character
    totalDurationInSeconds.value = charDurationInSeconds * cleanedText.length;

    // Create a new AnimationController
    animationController = AnimationController(
      vsync: tickerProvider,
      duration: Duration(milliseconds: (totalDurationInSeconds.value * 1000).toInt()),
    );

    // StepTween to animate over the length of the text
    textAnimation = StepTween(begin: 0, end: text.length).animate(
      CurvedAnimation(parent: animationController!, curve: Curves.linear),
    )..addListener(() {
        // Update the displayed text at each step of the animation
        displayedText.value = text.substring(0, textAnimation.value);
      });

    playAnimation(); // Start the animation
  }

  // Reset and play the animation
  void playAnimation() {
    if (animationController == null) {
      throw Exception("AnimationController is not initialized. Call initializeAnimation first.");
    }
    animationController!.reset();
    animationController!.forward();
  }

  @override
  void onClose() {
    animationController?.dispose();
    tickerProvider.dispose();
    super.onClose();
  }
}
