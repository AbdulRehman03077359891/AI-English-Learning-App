
import 'package:ai_english_learning/Controllers/business_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateClass extends StatefulWidget {
  final String userUid, userName, userEmail;
  final String classKey;

  const UpdateClass({super.key, required this.classKey, required this.userUid, required this.userName, required this.userEmail});

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
      appBar: AppBar(
        title: const Text(
          "Update Class",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 245, 222, 224),
        foregroundColor: const Color(0xFFE63946),
      ),
      body: GetBuilder<BusinessController>(
        builder: (businessController) {
          return businessController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: classNameController,
                          decoration: const InputDecoration(labelText: "Class Name"),
                        ),
                        SizedBox(
                          height: 400,
                          child: TextField(
                            controller: classDescriptionController,
                            decoration: const InputDecoration(labelText: "Description"),
                            maxLines: 15,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const ContinuousRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFE63946),
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
                              DateFormat('yyyy-MM-dd').format(DateTime.now())
                            );
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
    );
  }
}
