import 'package:ai_english_learning/Animation/background_gradient_animation.dart';
import 'package:ai_english_learning/Controllers/business_controller.dart';
import 'package:ai_english_learning/Controllers/fire_controller.dart';
import 'package:ai_english_learning/Widgets/blood_type.dart';
import 'package:ai_english_learning/Widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AddExams extends StatefulWidget {
  final String userUid, userName, userEmail, profilePicture;
  const AddExams(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<AddExams> createState() => _AddExamsState();
}

class _AddExamsState extends State<AddExams> {
  FireController fireController = Get.put(FireController());
  BusinessController businessController = Get.put(BusinessController());
  final TextEditingController question1Controller = TextEditingController();
  final TextEditingController question2Controller = TextEditingController();
  final TextEditingController question3Controller = TextEditingController();
  final TextEditingController question4Controller = TextEditingController();
  final TextEditingController question5Controller = TextEditingController();
  final TextEditingController answer1Controller = TextEditingController();
  final TextEditingController answer2Controller = TextEditingController();
  final TextEditingController options3Controller = TextEditingController();
  final TextEditingController answer3Controller = TextEditingController();
  final TextEditingController options4Controller = TextEditingController();
  final TextEditingController answer4Controller = TextEditingController();
  final TextEditingController answer5Controller = TextEditingController();
  final GlobalKey<FormState> _goodToGo = GlobalKey<FormState>();
  String? _selectedTrueFalse;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllClasses();
    });
  }

  getAllClasses() {
    businessController.getClasses(widget.userUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
            fireController.setLoading(false);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          "Add Exam",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 21, 49, 71),
      ),
      body: Obx( () {
          return Stack(
            children: [
              BackgroundGradientAnimation(child: Container()),
              Form(
                key: _goodToGo,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 80,),
                        const Text("Question Answers",style: TextStyle(fontWeight: FontWeight.bold,color: Color.fromARGB(255, 21, 49, 71),fontSize: 20),),
                        TextFieldWidget(
                          validate: (value) {
                            if (value.isEmpty){
                              return "Question Required";
                            }else{
                              return null;
                            }
                          },
                          fillColor: const Color.fromARGB(120, 255, 255, 255),
                          textCapitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.q,
                            color: Color.fromARGB(255, 21, 49, 71),
                          ),
                          lines: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: question1Controller,
                          focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                          hintText: "Enter your 1st Question",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(height: 10,),
                        TextFieldWidget(
                          validate: (value) {
                            if (value.isEmpty){
                              return "Answer Required";
                            }else{
                              return null;
                            }
                          },
                          fillColor: const Color.fromARGB(120, 255, 255, 255),
                          textCapitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.a,
                            color: Color.fromARGB(255, 21, 49, 71),
                          ),
                          lines: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: answer1Controller,
                          focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                          hintText: "Enter your 1st Question's Answer",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(height: 40,),
                        TextFieldWidget(
                          validate: (value) {
                            if (value.isEmpty){
                              return "Question Required";
                            }else{
                              return null;
                            }
                          },
                          fillColor: const Color.fromARGB(120, 255, 255, 255),
                          textCapitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.q,
                            color: Color.fromARGB(255, 21, 49, 71),
                          ),
                          lines: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: question2Controller,
                          focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                          hintText: "Enter your 2nd Question",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(height: 10,),
                        TextFieldWidget(
                          validate: (value) {
                            if (value.isEmpty){
                              return "Answer Required";
                            }else{
                              return null;
                            }
                          },
                          fillColor: const Color.fromARGB(120, 255, 255, 255),
                          textCapitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.a,
                            color: Color.fromARGB(255, 21, 49, 71),
                          ),
                          lines: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: answer2Controller,
                          focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                          hintText: "Enter your 2nd Question's Answer",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(height: 40,),
                        const Text("MCQs",style: TextStyle(fontWeight: FontWeight.bold,color: Color.fromARGB(255, 21, 49, 71),fontSize: 20),),
                        TextFieldWidget(
                          validate: (value) {
                            if (value.isEmpty){
                              return "Question Required";
                            }else{
                              return null;
                            }
                          },
                          fillColor: const Color.fromARGB(120, 255, 255, 255),
                          textCapitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.q,
                            color: Color.fromARGB(255, 21, 49, 71),
                          ),
                          lines: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: question3Controller,
                          focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                          hintText: "Enter your 3rd Question",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(height: 10,),
                        TextFieldWidget(
                          validate: (value) {
                            final commaCount = value.split(',').length -1;
                            if (commaCount > 3){
                              return "You can only input up to 4 values and last value must end without comma";
                            }else if (commaCount < 3){
                              return "You can only input up to 4 values and last value must end without comma";
                            }else if (value.isEmpty){
                              return "option Required";
                            } else{
                              return null;
                            }
                          },
                          fillColor: const Color.fromARGB(120, 255, 255, 255),
                          textCapitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.o,
                            color: Color.fromARGB(255, 21, 49, 71),
                          ),
                          lines: 4,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: options3Controller,
                          focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                          hintText: "Enter your 3rd Question's Options\nRemember only 4 Options separated by ' , ' (coma)",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(height: 10,),
                        TextFieldWidget(
                          validate: (value) {
                            if (value.isEmpty){
                              return "Answer Required";
                            }else{
                              return null;
                            }
                          },
                          fillColor: const Color.fromARGB(120, 255, 255, 255),
                          textCapitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.a,
                            color: Color.fromARGB(255, 21, 49, 71),
                          ),
                          lines: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: answer3Controller,
                          focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                          hintText: "Enter your 3rd Question's Answer",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(height: 40,),
                        TextFieldWidget(
                          validate: (value) {
                            if (value.isEmpty){
                              return "Question Required";
                            }else{
                              return null;
                            }
                          },
                          fillColor: const Color.fromARGB(120, 255, 255, 255),
                          textCapitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.q,
                            color: Color.fromARGB(255, 21, 49, 71),
                          ),
                          lines: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: question4Controller,
                          focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                          hintText: "Enter your 4th Question",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(height: 10,),
                        TextFieldWidget(
                          validate: (value) {
                            final commaCount = value.split(',').length -1;
                            if (commaCount > 3){
                              return "You can only input up to 4 values and last value must end without comma";
                            }else if (commaCount < 3){
                              return "You can only input up to 4 values and last value must end without comma";
                            }else if (value.isEmpty){
                              return "option Required";
                            }else{
                              return null;
                            }
                          },
                          
                          fillColor: const Color.fromARGB(120, 255, 255, 255),
                          textCapitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.o,
                            color: Color.fromARGB(255, 21, 49, 71),
                          ),
                          lines: 4,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: options4Controller,
                          focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                          hintText: "Enter your 4th Question's Options\nRemember only 4 Options separated by ' , ' (coma)",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(height: 10,),
                        TextFieldWidget(
                          validate: (value) {
                            if (value.isEmpty){
                              return "Answer Required";
                            }else{
                              return null;
                            }
                          },
                          fillColor: const Color.fromARGB(120, 255, 255, 255),
                          textCapitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.a,
                            color: Color.fromARGB(255, 21, 49, 71),
                          ),
                          lines: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: answer4Controller,
                          focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                          hintText: "Enter your 4th Question's Answer",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(height: 40,),
                        const Text("True/False",style: TextStyle(fontWeight: FontWeight.bold,color: Color.fromARGB(255, 21, 49, 71),fontSize: 20),),
                        TextFieldWidget(
                          validate: (value) {
                            if (value.isEmpty){
                              return "Question Required";
                            }else{
                              return null;
                            }
                          },
                          fillColor: const Color.fromARGB(120, 255, 255, 255),
                          textCapitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.q,
                            color: Color.fromARGB(255, 21, 49, 71),
                          ),
                          lines: 1,
                          width: MediaQuery.of(context).size.width * 0.95,
                          controller: question5Controller,
                          focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                          hintText: "Enter your 5th Question",
                          errorBorderColor: Colors.red,
                        ),
                        const SizedBox(height: 10,),
                        TrueFalseChoose(
                          validate: (value) {
                            if (value!="true" || value!="false"){
                              return "Answer Required";
                            }else{
                              return null;
                            }
                          },
                          width: MediaQuery.of(context).size.width*.95,
                          fillColor: const Color.fromARGB(120, 255, 255, 255),
                            controller: answer5Controller,
                            selectedTrueFalse: _selectedTrueFalse,
                            onChange: (value) {
                              setState(() {
                                _selectedTrueFalse = value;
                                answer5Controller.text = value!;
                              });
                            },
                            prefixIcon: FontAwesomeIcons.o,
                            focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                            errorBorderColor: Colors.red
                          ),
                          const SizedBox(height: 20,),
                          Container(
                                margin: const EdgeInsets.only(left: 5, right: 5),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Color.fromARGB(255, 21, 49, 71),
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 16, right: 8),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        hint: businessController.dropDownClassValue == ""
                                            ? const Text(
                                                "Select Class",
                                                style:
                                                    TextStyle(color: Colors.white),
                                              )
                                            : Text(
                                                businessController.dropDownClassValue
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                        isExpanded: true,
                                        dropdownColor:
                                            const Color.fromARGB(255, 21, 49, 71),
                                        iconEnabledColor: Colors.white,
                                        // value: businessController.dropDownValue,
                                        items: businessController.allClasses
                                            .map((items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(
                                              items["className"],
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            businessController
                                                .setDropDownClassValue(newValue);
                                          });
                                        }),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 40,),
                        ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    maximumSize: const Size.fromWidth(180),
                                    shape: const ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                    backgroundColor:
                                        const Color.fromARGB(255, 21, 49, 71),
                                    shadowColor: Colors.black,
                                    elevation: 10,
                                  ),
                                  onPressed: () {
                                    if(_goodToGo.currentState!.validate()){
                                      businessController.addExam(
                                        question1Controller.text,
                                        answer1Controller.text,
                                        question2Controller.text,
                                        answer2Controller.text,
                                        question3Controller.text,
                                        options3Controller.text,
                                        answer3Controller.text,
                                        question4Controller.text,
                                        options4Controller.text,
                                        answer4Controller.text,
                                        question5Controller.text,
                                        answer5Controller.text,
                                        widget.userUid,
                                        widget.userName,
                                        widget.userEmail,
                                        widget.profilePicture);
                                    businessController.pickedImageFile.value ==
                                        null;
                                    }
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(Icons.add_box, color: Colors.white),
                                      Text(
                                        "Add Exam",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  )),
                                  const SizedBox(height: 40,)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
