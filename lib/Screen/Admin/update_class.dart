import 'package:ai_english_learning/Animation/background_gradient_animation.dart';
import 'package:ai_english_learning/Controllers/business_controller.dart';
import 'package:ai_english_learning/Widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateClass extends StatefulWidget {
  final String userUid, userName, userEmail;
  final String classKey;

  const UpdateClass(
      {super.key,
      required this.classKey,
      required this.userUid,
      required this.userName,
      required this.userEmail});

  @override
  State<UpdateClass> createState() => _UpdateClassState();
}

class _UpdateClassState extends State<UpdateClass> {
  TextEditingController classNameController = TextEditingController();
  TextEditingController classDescriptionController = TextEditingController();
  var businessController = Get.put(BusinessController());
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      businessController.getClassData(widget.classKey).then((_) {
        var classData = businessController.selectedClass;
        classNameController.text = classData['className'];
        classDescriptionController.text = classData['description'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Update Class",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 21, 49, 71),
      ),
      body: BackgroundGradientAnimation(
        child: GetBuilder<BusinessController>(
          builder: (businessController) {
            return businessController.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 75,
                          ),
                          TextFieldWidget(
                            textCapitalization: TextCapitalization.sentences,
                            focusBorderColor:
                                const Color.fromARGB(255, 21, 49, 71),
                            controller: classNameController,
                            fillColor: const Color.fromARGB(68, 255, 255, 255),
                            labelText: "Class Name",
                            errorBorderColor: Colors.red,
                            labelColor: const Color.fromARGB(255, 21, 49, 71),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 400,
                            child: TextFieldWidget(
                              focusBorderColor:
                                  const Color.fromARGB(255, 21, 49, 71),
                              controller: classDescriptionController,
                              fillColor:
                                  const Color.fromARGB(68, 255, 255, 255),
                              labelText: "Description",
                              errorBorderColor: Colors.red,
                              labelColor: const Color.fromARGB(255, 21, 49, 71),
                              lines: 15,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const ContinuousRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 21, 49, 71),
                              foregroundColor: Colors.cyan,
                            ),
                            onPressed: () {
                              // Call the update method
                              businessController.updateClass(
                                  widget.classKey,
                                  classNameController.text,
                                  classDescriptionController.text,
                                  widget.userUid,
                                  widget.userName,
                                  widget.userEmail,
                                  DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()));
                            },
                            child: const Text(
                              "Update Class",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
