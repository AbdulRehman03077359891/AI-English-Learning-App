import 'package:ai_english_learning/Controllers/user_dashboard_controller.dart';
import 'package:ai_english_learning/Widgets/e1_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamController extends GetxController {
  final questions = <Map<String, dynamic>>[].obs;
  final currentQuestionIndex = 0.obs;
  final userAnswers = <String, dynamic>{}.obs;
  final totalMarks = 0.obs;
  final userScore = 0.obs;
  final isLoading = true.obs;
  final currentAnswer = RxnString();

  // Fetch exam data from Firestore
  Future<void> fetchExamData(String classKey) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection("Exams")
          .where("classKey", isEqualTo: classKey)
          .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        questions.value = [
          {
            "question": data["q1"],
            "type": "descriptive",
            "answerKey": "a1",
            "correctAnswer": data["a1"],
            "options": null,
            "marks": 2,
          },
          {
            "question": data["q2"],
            "type": "descriptive",
            "answerKey": "a2",
            "correctAnswer": data["a2"],
            "options": null,
            "marks": 2,
          },
          {
            "question": data["q3"],
            "type": "multiple-choice",
            "answerKey": "a3",
            "correctAnswer": data["a3"],
            "options": data["o3"].split(","), // Split options by comma
            "marks": 3,
          },
          {
            "question": data["q4"],
            "type": "multiple-choice",
            "answerKey": "a4",
            "correctAnswer": data["a4"],
            "options": data["o4"].split(","), // Split options by comma
            "marks": 3,
          },
          {
            "question": data["q5"],
            "type": "boolean",
            "answerKey": "a5",
            "correctAnswer": data["a5"].toString(),
            "options": ["True", "False"],
            "marks": 1,
          },
        ];
        totalMarks.value = questions.fold(
          0,
          (sum, q) => sum + (q["marks"] as int),
        );
      } else {
        Get.snackbar(
          "Error",
          "No exam data found for this classKey.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error fetching exam data: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateAnswer(String value) {
    currentAnswer.value = value;
    update(); // Notify listeners to refresh UI
  }

  // Handle the next question or show results
  void handleNext(BuildContext context, userId, levelKey, classKey) {
    if (currentAnswer.value == null || currentAnswer.value!.isEmpty) {
      Get.snackbar(
        "Incomplete",
        "Please provide an answer before proceeding.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final currentQuestion = questions[currentQuestionIndex.value];

    // Check the answer and award marks
    if (currentAnswer.value!.trim().toLowerCase() ==
        currentQuestion["correctAnswer"].toString().trim().toLowerCase()) {
      userScore.value += (currentQuestion["marks"] as int);
    }

    // Save the user's answer
    userAnswers[currentQuestion["answerKey"]] = currentAnswer.value;
    currentAnswer.value = null;

    // Move to the next question or show results
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      currentAnswer.value = '';
    } else {
      showExamResult(context, userId, levelKey, classKey);
    }
  }

  // Show the exam result
  void showExamResult(BuildContext context, userId, levelKey, classKey) {
    final UserDashboardController userDashboardController = Get.put(UserDashboardController());
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
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
          child: AlertDialog(
            title: const Text("Exam Completed"),
            content: Text(
              "Your Score: ${userScore.value}/${totalMarks.value}\n"
              "Thank you for taking the exam!",
            ),
            actions: [
          E1Button(
            backColor: const Color.fromARGB(255, 21, 49, 71),
            text: "Finish",
            textColor: Colors.cyan,
            onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Go back to the previous screen
                  Navigator.of(context).pop();
                  // Check if userScore is >= 80% of totalMarks
              if (userScore.value >= (0.8 * totalMarks.value)) {
                userDashboardController.markClassAsCompleted(userId, levelKey, classKey); // Execute unlockClass
              }
                },
          )
            ],
          ),
        );
      },
    );
  }
}
