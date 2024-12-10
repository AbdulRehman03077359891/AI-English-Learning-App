import 'package:ai_english_learning/Controllers/Animation/text_animation_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamScreen extends StatefulWidget {
  final String classKey;
  const ExamScreen({super.key, required this.classKey});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  TextAnimationController textAnimationController = Get.put(TextAnimationController());
  
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  Map<String, dynamic> userAnswers = {};
  int totalMarks = 0;
  int userScore = 0;
  bool isLoading = true;
  String? currentAnswer;

  @override
  void initState() {
    super.initState();
    fetchExamData();
  }

  Future<void> fetchExamData() async {
    try {
      final query = await FirebaseFirestore.instance
          .collection("Exams")
          .where("classKey", isEqualTo: widget.classKey)
          .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        setState(() {
          questions = [
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
              "options": data["o3"].split(","),  // Split options by comma
              "marks": 3,
            },
            {
              "question": data["q4"],
              "type": "multiple-choice",
              "answerKey": "a4",
              "correctAnswer": data["a4"],
              "options": data["o4"].split(","),  // Split options by comma
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
          totalMarks = questions.fold(0, (sum, q) => sum + (q["marks"] as int));
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No exam data found for this classKey.")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching exam data: $e")));
      
    }
  }

  void handleNext() {
    if (currentAnswer == null || currentAnswer!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide an answer before proceeding.")),
      );
      return;
    }

    final currentQuestion = questions[currentQuestionIndex];

    // Check answer and award marks
    if (currentAnswer!.trim().toLowerCase() ==
        currentQuestion["correctAnswer"].toString().trim().toLowerCase()) {
      userScore += (currentQuestion["marks"] as num).toInt();
    }

    userAnswers[currentQuestion["answerKey"]] = currentAnswer;
    currentAnswer = null;

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Exam completed
      showExamResult();
    }
  }

  void showExamResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Exam Completed"),
          content: Text(
            "Your Score: $userScore/$totalMarks\n"
            "Thank you for taking the exam!",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.of(context).pop(); // Go back to previous screen
              },
              child: Text("Finish"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Exam")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Exam")),
        body: Center(child: Text("No questions available.")),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Exam")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Question ${currentQuestionIndex + 1}/${questions.length}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              currentQuestion["question"],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            if (currentQuestion["type"] == "descriptive") ...[
              TextField(
                decoration: InputDecoration(
                  labelText: "Your Answer",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => currentAnswer = value,
              ),
            ]else if (currentQuestion["type"] == "multiple-choice") ...[
  // Use ListView to show all options in a list with radio-style buttons
  ListView.builder(
    shrinkWrap: true, // Prevent ListView from taking the whole available space
    itemCount: currentQuestion["options"].length, // Number of options
    itemBuilder: (context, index) {
      String option = currentQuestion["options"][index].trim();
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          title: Text(option),
          leading: Radio<String>(
            value: option,
            groupValue: currentAnswer,
            onChanged: (value) {
              setState(() {
                currentAnswer = value; // Set selected answer
              });
            },
            activeColor: Colors.blue, // Change active color to blue (or any color you prefer)
          ),
        ),
      );
    },
  ),
] else if (currentQuestion["type"] == "boolean") ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentAnswer = "True";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentAnswer == "True"
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    child: Text("True"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentAnswer = "False";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentAnswer == "False"
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    child: Text("False"),
                  ),
                ],
              ),
            ],
            Spacer(),
            ElevatedButton(
              onPressed: handleNext,
              child: Text(currentQuestionIndex < questions.length - 1
                  ? "Next"
                  : "Finish"),
            ),
          ],
        ),
      ),
    );
  }
}
