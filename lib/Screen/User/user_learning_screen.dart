import 'package:ai_english_learning/Animation/background_gradient_animation.dart';
import 'package:ai_english_learning/Controllers/Animation/text_animation_controller.dart';
import 'package:ai_english_learning/Screen/User/exam_screen.dart';
import 'package:ai_english_learning/Widgets/e1_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnglishLearningScreen extends StatefulWidget {
  final String text; // Accept the text as a parameter
  final String className;
  final String classKey;

  const EnglishLearningScreen(
      {Key? key, required this.text, required this.className, required this.classKey})
      : super(key: key);

  @override
  _EnglishLearningScreenState createState() => _EnglishLearningScreenState();
}

class _EnglishLearningScreenState extends State<EnglishLearningScreen> {
  late List<String> topics; // List to hold parsed topics
  int currentIndex = 0;

  // Instantiate the TextAnimationController
  final textAnimationController = Get.put(TextAnimationController());

  @override
  void initState() {
    super.initState();
    topics = _parseText(widget.text); // Parse the text into topics
    textAnimationController.initializeAnimation(topics[currentIndex]);
    textAnimationController.playAnimation();
  }

  @override
  void dispose() {
    Get.delete<TextAnimationController>(); // Dispose of the controller
    super.dispose();
  }

  // Function to parse the text into topics
  List<String> _parseText(String text) {
  // Add ### before "step" and before any sentence containing ":"
  String formattedText = text
      // .replaceAll(RegExp(r'\bstep\b', caseSensitive: false), '### step')
      .replaceAllMapped(
          RegExp(r'([^#\n]*:.*)'), // Match lines containing ":"
          (match) => "### ${match.group(1)}");

  // Split into topics
  List<String> splitTopics =
      formattedText.split('###').map((e) => e.trim()).toList();

  // Ensure all topics are prefixed with "###"
  return splitTopics
      .where((topic) => topic.isNotEmpty)
      .map((topic) => topic.startsWith("###") ? topic : "### $topic")
      .toList();
}

  // Navigate to the previous topic
  void _goToPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      textAnimationController.initializeAnimation(topics[currentIndex]);
    }
  }

  // Navigate to the next topic
  void _goToNext() {
    if (currentIndex < topics.length - 1) {
      setState(() {
        currentIndex++;
      });
      textAnimationController.initializeAnimation(topics[currentIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 21, 49, 71),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(widget.className,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BackgroundGradientAnimation(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Image.asset("assets/images/AI1.png", scale: 2),
              Obx(() => Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromARGB(255, 236, 236, 230),
                            Color.fromARGB(255, 180, 182, 179)
                          ],
                        ),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .4),
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              textAnimationController.displayedText.value,
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  E1Button(
                    backColor: const Color.fromARGB(255, 21, 49, 71),
                    text: "Previous",
                    textColor: Colors.cyan,
                    onPressed: currentIndex > 0 ? _goToPrevious : null,
                  ),
                  currentIndex == topics.length - 1
                      ? E1Button(
                          backColor: const Color.fromARGB(255, 21, 49, 71),
                          text: "Take Exam",
                          textColor: Colors.cyan,
                          onPressed: () {
                            Get.off(ExamScreen(classKey: widget.classKey,));
                          })
                      : E1Button(
                          backColor: const Color.fromARGB(255, 21, 49, 71),
                          text: "Next",
                          textColor: Colors.cyan,
                          onPressed: currentIndex < topics.length - 1
                              ? _goToNext
                              : null,
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
