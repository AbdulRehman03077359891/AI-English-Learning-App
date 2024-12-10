import 'package:ai_english_learning/Animation/background_gradient_animation.dart';
import 'package:ai_english_learning/Controllers/business_controller.dart';
import 'package:ai_english_learning/Controllers/fire_controller.dart';
import 'package:ai_english_learning/Widgets/notification_message.dart';
import 'package:ai_english_learning/Widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddClasses extends StatefulWidget {
  final String userUid, userName, userEmail, profilePicture;

  const AddClasses(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<AddClasses> createState() => _AddClassesState();
}

class _AddClassesState extends State<AddClasses> {
  var businessController = Get.put(BusinessController());
  final FireController fireController = Get.put(FireController());
  TextEditingController classNameController = TextEditingController();
  TextEditingController classDescriptionController = TextEditingController();

  showBottomSheet() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 60,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        if (await businessController
                                .requestPermission(Permission.camera) ==
                            true) {
                          businessController.pickAndCropImage(
                              ImageSource.camera, context);
                          notify(
                              "success", "permission for storage is granted");
                        } else {
                          notify(
                              "error", "permission for storage is not granted");
                        }
                      },
                      icon: const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 21, 49, 71),
                        child: Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                      )),
                  IconButton(
                    onPressed: () async {
                      if (await businessController
                              .requestPermission(Permission.storage) ==
                          true) {
                        businessController.pickAndCropImage(
                            ImageSource.gallery, context);
                        notify("success", "permission for storage is granted");
                      } else {
                        notify(
                            "error", "permission for storage is not granted");
                      }
                    },
                    icon: const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 21, 49, 71),
                      child: Icon(
                        Icons.photo,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllLevels();
    });
  }

  getAllLevels() {
    businessController.getLevels(widget.userUid);
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
          "Add Class",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 21, 49, 71),
      ),
      body: BackgroundGradientAnimation(
        child: GetBuilder<BusinessController>(
          builder: (businessController) {
            return businessController.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 21, 49, 71),
                  ))
                : SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            height: 80,
                          ),
                          GestureDetector(
                            onTap: () {
                              showBottomSheet();
                            },
                            child:
                                businessController.pickedImageFile.value == null
                                    ? Card(
                                        elevation: 10,
                                        child: Container(
                                          height: 200,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/postPlaceHolder.jpeg"),
                                                  fit: BoxFit.cover)),
                                        ))
                                    : Card(
                                        elevation: 10,
                                        child: Container(
                                          height: 200,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: FileImage(
                                                      businessController
                                                          .pickedImageFile
                                                          .value!),
                                                  fit: BoxFit.cover)),
                                        )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget(
                            fillColor: const Color.fromARGB(120, 255, 255, 255),
                            textCapitalization: TextCapitalization.sentences,
                            prefixIcon: const Icon(
                              Icons.class_,
                              color: Color.fromARGB(255, 21, 49, 71),
                            ),
                            lines: 1,
                            width: MediaQuery.of(context).size.width * 0.95,
                            controller: classNameController,
                            focusBorderColor:
                                const Color.fromARGB(255, 21, 49, 71),
                            hintText: "Enter your Class Name",
                            errorBorderColor: Colors.red,
                          ),
                          TextFieldWidget(
                            fillColor: const Color.fromARGB(120, 255, 255, 255),
                            lines: 8,
                            width: MediaQuery.of(context).size.width * 0.95,
                            controller: classDescriptionController,
                            focusBorderColor:
                                const Color.fromARGB(255, 21, 49, 71),
                            hintText: "Enter your Class Description",
                            errorBorderColor: Colors.red,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                                    hint: businessController.dropDownLevelValue == ""
                                        ? const Text(
                                            "Select Level",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : Text(
                                            businessController.dropDownLevelValue
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                    isExpanded: true,
                                    dropdownColor:
                                        const Color.fromARGB(255, 21, 49, 71),
                                    iconEnabledColor: Colors.white,
                                    // value: businessController.dropDownValue,
                                    items: businessController.allLevels
                                        .map((items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items["name"],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        businessController
                                            .setDropDownLevelValue(newValue);
                                      });
                                    }),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                                businessController.addClass(
                                    classNameController.text,
                                    classDescriptionController.text,
                                    widget.userUid,
                                    widget.userName,
                                    widget.userEmail,
                                    widget.profilePicture);
                                classNameController.clear();
                                classDescriptionController.clear();
                                businessController.pickedImageFile.value ==
                                    null;
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.add_box, color: Colors.white),
                                  Text(
                                    "Add Class",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              )),
                          const SizedBox(
                            height: 10,
                          )
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
