import 'package:ai_english_learning/Animation/background_gradient_animation.dart';
import 'package:ai_english_learning/Controllers/Animation/text_animation_controller.dart';
import 'package:ai_english_learning/Controllers/exam_controller.dart';
import 'package:ai_english_learning/Controllers/user_dashboard_controller.dart';
import 'package:ai_english_learning/Widgets/e1_button.dart';
import 'package:ai_english_learning/Widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamScreen extends StatefulWidget {
  final String classKey, userUid, levelKey;
  const ExamScreen(
      {super.key,
      required this.classKey,
      required this.userUid,
      required this.levelKey});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final ExamController examController = Get.put(ExamController());
  final TextAnimationController textAnimationController =
      Get.put(TextAnimationController());
  final TextEditingController _answerController = TextEditingController();
  final UserDashboardController userDashboardController =
      UserDashboardController();

  @override
  void initState() {
    super.initState();
    examController.fetchExamData(widget.classKey);
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 21, 49, 71),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          "Exam Screen",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BackgroundGradientAnimation(
        child: Obx(() {
          // Loading state handling
          if (examController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // No questions available
          if (examController.questions.isEmpty) {
            return const Center(child: Text("No questions available."));
          }

          // Exam content
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 75,
                ),
                _buildQuestionHeader(),
                const SizedBox(height: 16),
                _buildQuestionText(),
                const SizedBox(height: 16),
                _buildAnswerOptions(),
                const Spacer(),
                _buildNextButton(
                    context, widget.userUid, widget.levelKey, widget.classKey),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuestionHeader() {
    return Obx(() {
      return Text(
        "Question ${examController.currentQuestionIndex.value + 1}/${examController.questions.length}",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    });
  }

  Widget _buildQuestionText() {
    final currentQuestion =
        examController.questions[examController.currentQuestionIndex.value];
    textAnimationController.initializeAnimation(currentQuestion["question"]);

    return Obx(() {
      return Text(
        textAnimationController.displayedText.value,
        style: const TextStyle(fontSize: 16),
      );
    });
  }

  Widget _buildAnswerOptions() {
    final currentQuestion =
        examController.questions[examController.currentQuestionIndex.value];
    final questionType = currentQuestion["type"];

    if (questionType == "descriptive") {
      return TextFieldWidget(
        focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
        fillColor: const Color.fromARGB(115, 255, 255, 255),
        labelColor: Colors.cyan,
        errorBorderColor: Colors.red,
        controller: _answerController,
        onchange: (value) => examController.updateAnswer(value),
        labelText: "Your Answer",
      );
    } else if (questionType == "multiple-choice") {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: currentQuestion["options"].length,
        itemBuilder: (context, index) {
          String option = currentQuestion["options"][index].trim();
          return ListTile(
            title: Text(option),
            leading: Obx(() {
              return Radio<String>(
                value: option,
                groupValue: examController.currentAnswer.value,
                onChanged: (value) {
                  examController.updateAnswer(value!);
                },
              );
            }),
          );
        },
      );
    } else if (questionType == "boolean") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(() {
            return E1Button(
              backColor: examController.currentAnswer.value == "True"
                  ? Colors.cyan // Highlighted color
                  : const Color.fromARGB(255, 21, 49, 71), // Default color
              text: "True",
              textColor: examController.currentAnswer.value == "True"
                  ? const Color.fromARGB(
                      255, 21, 49, 71) // Highlighted text color
                  : Colors.cyan, // Default text color
              onPressed: () {
                examController.updateAnswer("True");
              },
            );
          }),
          Obx(() {
            return E1Button(
              backColor: examController.currentAnswer.value == "False"
                  ? Colors.cyan // Highlighted color
                  : const Color.fromARGB(255, 21, 49, 71), // Default color
              text: "False",
              textColor: examController.currentAnswer.value == "False"
                  ? const Color.fromARGB(
                      255, 21, 49, 71) // Highlighted text color
                  : Colors.cyan, // Default text color
              onPressed: () {
                examController.updateAnswer("False");
              },
            );
          }),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildNextButton(
      BuildContext context, String userId, String levelKey, String classKey) {
    return Obx(() {
      return E1Button(
          backColor: const Color.fromARGB(255, 21, 49, 71),
          text: examController.currentQuestionIndex.value <
                  examController.questions.length - 1
              ? "Next"
              : "Finish",
          textColor: Colors.cyan,
          onPressed: () {
            examController.handleNext(
                context,
                userId, levelKey, classKey);
            _answerController.clear();
          });
    });
  }
}
