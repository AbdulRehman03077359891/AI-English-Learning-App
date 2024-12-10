
import 'package:ai_english_learning/Controllers/user_controller.dart';
// import 'package:ai_english_learning/Widgets/blood_type.dart';
import 'package:ai_english_learning/Widgets/gender_choose.dart';
import 'package:ai_english_learning/Widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FormApplication extends StatefulWidget {
  final String className;
  final String classPic;
  final String classKey;
  final String adminUid;
  final String levelName;
  final String userName;
  final String userUid;
  final String? gender;
  final String? contact;
  final String? dob;
  final String? address;
  final String userEmail;
  final String? userPic;
  const FormApplication(
      {super.key,
      required this.userName,
      required this.userUid,
      this.gender = "",
      this.contact = "",
      this.dob = "",
      required this.userEmail,
      required this.classKey,
      required this.classPic,
      required this.className,
      required this.levelName,
      required this.adminUid,
      required this.userPic,
      this.address = ""});

  @override
  State<FormApplication> createState() => _FormApplicationState();
}

class _FormApplicationState extends State<FormApplication> {
  // var controller = Get.put(FireController());
  final UserController userController = Get.put(UserController());
  @override
  void initState() {
    super.initState();
    _userName.text = widget.userName.isNotEmpty ? widget.userName : "";
    _address.text = widget.address ?? "";
    _dOB.text = widget.dob ?? "";
    _contact.text = widget.contact ?? "";
    _gender.text = widget.gender ?? "";
    if (widget.gender != null) {
      _selectedGender = widget.gender;
    }
  }

  final TextEditingController _userName = TextEditingController();
  final TextEditingController _dOB = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _cnic = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _bloodType = TextEditingController();
  final TextEditingController _address = TextEditingController();

  String? _selectedGender;
  // String? _selectedBloodType;

  // is Form Filled
  final GlobalKey<FormState> _goodToGo = GlobalKey<FormState>();

  String? _validateDOB(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your date of birth';
    }

    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parseStrict(value);

      // Check if the date is not in the future
      if (parsedDate.isAfter(DateTime.now())) {
        return 'Date of birth cannot be in the future';
      }

      // Check if the age is reasonable (e.g., not less than 0 or more than 120)
      int age = DateTime.now().year - parsedDate.year;
      if (age < 0 || age > 120) {
        return 'Please enter a valid age';
      }
    } catch (e) {
      return 'Please enter a valid date in the format dd/MM/yyyy';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 40,
            backgroundColor: const Color.fromARGB(255, 245, 222, 224),
            foregroundColor: const Color(0xFFE63946),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            title: const Text(
              "Booking Form",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _goodToGo,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldWidget(
                        keyboardType: TextInputType.name,
                        labelText: "User Name",
                        labelColor: const Color(0xFFE63946),
                        width: MediaQuery.of(context).size.width,
                        validate: (value) {
                          if (!value!.startsWith(RegExp(r'[A-Z][a-z]'))) {
                            return "Start with Capital letter";
                          } else if (value.isEmpty) {
                            return "username required";
                          } else {
                            return null;
                          }
                        },
                        controller: _userName,
                        fillColor: Colors.white,
                        focusBorderColor: const Color(0xFFE63946),
                        errorBorderColor: Colors.red,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        keyboardType: TextInputType.datetime,
                        width: MediaQuery.of(context).size.width,
                        labelText: "Date of birth",
                        labelColor: const Color(0xFFE63946),
                        validate: _validateDOB,
                        controller: _dOB,
                        hintText: "dd/MM/yyyy",
                        fillColor: Colors.white,
                        focusBorderColor: const Color(0xFFE63946),
                        errorBorderColor: Colors.red,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GenderChoose(
                        controller: _gender,
                        selectedGender: _selectedGender,
                        onChange: (value) {
                          setState(() {
                            _selectedGender = value;
                            _gender.text = value!;
                          });
                        },
                        width: MediaQuery.of(context).size.width,
                        fillColor: Colors.white,
                        labelColor: const Color(0xFFE63946),
                        focusBorderColor: const Color(0xFFE63946),
                        errorBorderColor: Colors.red,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // BloodTypeChoose(
                      //   controller: _bloodType,
                      //   selectedBloodType: _selectedBloodType,
                      //   onChange: (value) {
                      //     setState(() {
                      //       _selectedBloodType = value;
                      //       _bloodType.text = value!;
                      //     });
                      //   },
                      //   width: MediaQuery.of(context).size.width,
                      //   fillColor: Colors.white,
                      //   labelColor: const Color(0xFFE63946),
                      //   focusBorderColor: const Color(0xFFE63946),
                      //   errorBorderColor: Colors.red,
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        validate: (value) {
                          if (!value!.startsWith("03", 0)) {
                            return "Invalid Number";
                          } else if (value.length < 11) {
                            return "Invalid Number Length";
                          } else if (value.length > 11) {
                            return "Invalid Number Length";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        labelColor: const Color(0xFFE63946),
                        labelText: "Phone",
                        controller: _contact,
                        hintText: "03xxxxxxxxx",
                        fillColor: Colors.white,
                        focusBorderColor: const Color(0xFFE63946),
                        errorBorderColor: Colors.red,
                        suffixIconColor: const Color(0xFFE63946),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Invalid CNIC";
                          } else if (value.length < 13) {
                            return "Invalid Length";
                          } else if (value.length > 13) {
                            return "Invalid Length";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        labelColor: const Color(0xFFE63946),
                        labelText: "CNIC",
                        controller: _cnic,
                        hintText: "CNIC only numbers ",
                        fillColor: Colors.white,
                        focusBorderColor: const Color(0xFFE63946),
                        errorBorderColor: Colors.red,
                        suffixIconColor: const Color(0xFFE63946),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Invalid Address";
                          } else {
                            return null;
                          }
                        },
                        labelColor: const Color(0xFFE63946),
                        labelText: "Address",
                        controller: _address,
                        hintText: "address",
                        fillColor: Colors.white,
                        focusBorderColor: const Color(0xFFE63946),
                        errorBorderColor: Colors.red,
                        suffixIconColor: const Color(0xFFE63946),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      userController.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Color(0xFFE63946),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  backgroundColor: const Color(0xFFE63946),
                                  shadowColor: Colors.black,
                                  elevation: 10),
                              onPressed: () async {
                                if (_goodToGo.currentState!.validate()) {
                                  userController.formRequest(
                                      widget.userUid,
                                      _userName.text,
                                      widget.userEmail,
                                      widget.userPic,
                                      _contact.text,
                                      _cnic.text,
                                      _address.text,
                                      _gender.text,
                                      _bloodType.text,
                                      widget.classKey,
                                      widget.classPic,
                                      widget.className,
                                      widget.levelName,
                                      widget.adminUid);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
