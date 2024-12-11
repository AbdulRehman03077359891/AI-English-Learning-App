
import 'package:ai_english_learning/Controllers/fire_controller.dart';
import 'package:ai_english_learning/Screen/Firebase/sign_up.dart';
import 'package:ai_english_learning/Widgets/text_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  //Password Settings-------------------------------------------------------------
  var _checkCapital = false;
  var _checkSmall = false;
  var _checkNumbers = false;
  var _checkSpecial = false;

  bool _hidePassword = true;
  var _passwordIcon = FontAwesomeIcons.eyeSlash;

  // is Form Filled---------------------------------------------------------------
  final GlobalKey<FormState> _goodToGo = GlobalKey<FormState>();

  //User Data---------------------------------------------------------------------
  final fireController = Get.put(FireController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        // backgroundColor: const Color.fromARGB(255, 214, 213, 208),
        body: Container(
          decoration:const BoxDecoration(gradient:LinearGradient(begin: Alignment.topRight,end: Alignment.centerLeft,colors: [Color.fromARGB(255, 213, 212, 207),Color.fromARGB(255, 180, 184, 185)]) ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _goodToGo,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .3,
                          child: Image.asset(
                              'assets/images/Logo.png')),
                      const Text(
                        "Login to your account.",
                        style: TextStyle(
                            color: Color.fromARGB(255, 21, 49, 71),
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Please signin in to your account",
                                style: TextStyle(color: Colors.black54),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Email Address",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              )
                            ],
                          )
                        ],
                      ),
                      TextFieldWidget(
                        validate: (value) {
                          if (!value!.endsWith("@gmail.com")) {
                            return "Invalid email";
                          } else if (value.isEmpty) {
                            return "email required";
                          } else {
                            return null;
                          }
                        },
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Enter your email",
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 21, 49, 71),
                        ),
                        fillColor: Colors.white,
                        focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                        errorBorderColor: Colors.red,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Text(
                            "Password",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      TextFieldWidget(
                        validate: (value) {
                          for (var i = 0; i < value!.length; i++) {
                            debugPrint(value[i]);
                            if (value.codeUnitAt(i) >= 65 &&
                                value.codeUnitAt(i) <= 90) {
                              _checkCapital = true;
                            }
                            if (value.codeUnitAt(i) >= 97 &&
                                value.codeUnitAt(i) <= 122) {
                              _checkSmall = true;
                            }
                            if (value.codeUnitAt(i) >= 48 &&
                                value.codeUnitAt(i) <= 57) {
                              _checkNumbers = true;
                            }
                            if (value.codeUnitAt(i) >= 33 &&
                                    value.codeUnitAt(i) <= 47 ||
                                value.codeUnitAt(i) >= 58 &&
                                    value.codeUnitAt(i) <= 64) {
                              _checkSpecial = true;
                            }
                          }
                          if (value.isEmpty) {
                            return "Password Required";
                          } else if (!_checkCapital) {
                            return "Capital Letter Required";
                          } else if (!_checkSmall) {
                            return "Small Letter Required";
                          } else if (!_checkNumbers) {
                            return "Number Required";
                          } else if (!_checkSpecial) {
                            return "Special Character Required";
                          } else if (value.length < 8) {
                            return "At least 8 characters Required";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.visiblePassword,
                        hidePassword: _hidePassword,
                        controller: _password,
                        hintText: "Enter your password",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _hidePassword = !_hidePassword;
                            if (_passwordIcon == FontAwesomeIcons.eyeSlash) {
                              _passwordIcon = FontAwesomeIcons.eye;
                            } else {
                              _passwordIcon = FontAwesomeIcons.eyeSlash;
                            }
                            setState(() {});
                          },
                          child: Icon(_passwordIcon),
                        ),
                        suffixIconColor: const Color.fromARGB(255, 21, 49, 71),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 21, 49, 71),
                        ),
                        fillColor: Colors.white,
                        focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                        errorBorderColor: Colors.red,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 21, 49, 71)),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      fireController.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Color.fromARGB(255, 21, 49, 71),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const ContinuousRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30))),
                                  backgroundColor:
                                      const Color.fromARGB(255, 21, 49, 71),
                                  shadowColor: Colors.black,
                                  elevation: 10),
                              onPressed: () {
                                if (_goodToGo.currentState!.validate()) {
                                  fireController.logInUser(
                                      _email.text, _password.text, context, '');
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                        color: Colors.cyanAccent, fontSize: 18, shadows: [BoxShadow(blurRadius: 8,spreadRadius: 8)]),
                                ),
                              )),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                          text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                              text: "Register",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 21, 49, 71),
                                  fontWeight: FontWeight.w500),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(const SignUpPage(
                                    userType: 'User',
                                  ));
                                })
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
