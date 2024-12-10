import 'package:ai_english_learning/Animation/background_gradient_animation.dart';
import 'package:ai_english_learning/Controllers/animation_controller.dart';
import 'package:ai_english_learning/Controllers/business_controller.dart';
import 'package:ai_english_learning/Widgets/Admin/admin_class_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassData extends StatefulWidget {
  final String userUid, userName, userEmail, profilePicture;

  const ClassData(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<ClassData> createState() => _ClassDataState();
}

class _ClassDataState extends State<ClassData> {
  TextEditingController dishNameController = TextEditingController();
  TextEditingController dishPriceController = TextEditingController();
  var businessController = Get.put(BusinessController());
  var animateController = Get.put(AnimateController());

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
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          "View Levels",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 21, 49, 71),
      ),
      body: Stack(
        children: [
          BackgroundGradientAnimation(child: Container()),
          GetBuilder<BusinessController>(
            builder: (businessController) {
              return businessController.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 21, 49, 71),
                    ))
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 80,
                          ),
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: businessController.allLevels.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      businessController.allLevels[index]
                                                  ["selected"] ==
                                              true
                                          ? ElevatedButton(
                                              style: const ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Color.fromARGB(255, 21, 49, 71))),
                                              onPressed: () {
                                                businessController.getClassesViaLevels(
                                                  index,
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.add_box,
                                                      color: Colors.cyan,shadows: [BoxShadow(blurRadius: 3,spreadRadius: 3,color: Colors.black)],),
                                                  Text(
                                                    businessController
                                                            .allLevels[index]
                                                        ["name"],
                                                    style: const TextStyle(
                                                        color: Colors.cyan,shadows: [BoxShadow(blurRadius: 3,spreadRadius: 3,color: Colors.black)]),
                                                  )
                                                ],
                                              ))
                                          : ElevatedButton(
                                              style: const ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.white)),
                                              onPressed: () {
                                                businessController.getClassesViaLevels(
                                                  index,
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.add_box,
                                                      color: Color.fromARGB(255, 21, 49, 71)),
                                                  Text(
                                                    businessController
                                                            .allLevels[index]
                                                        ["name"],
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(255, 21, 49, 71)),
                                                  )
                                                ],
                                              )),
                                    ],
                                  );
                                }),
                          ),
                          businessController.selectedClasses.isEmpty
                              ? SizedBox(
                                  height: MediaQuery.of(context).size.height * .7,
                                  child: const Center(
                                    child: Text(
                                      "No Levels Available",
                                      style: TextStyle(color: Color.fromARGB(255, 21, 49, 71)),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      businessController.selectedClasses.length,
                                  itemBuilder: (context, index) {
                                    return AdminClassCard(
                                      className: businessController
                                          .selectedClasses[index]["className"],
                                      description: businessController
                                          .selectedClasses[index]["description"],
                                      imageUrl: businessController
                                          .selectedClasses[index]["classPic"],
                                      index: index,
                                      classKey: businessController
                                          .selectedClasses[index]["classKey"],
                                      levelKey: businessController.selectedClasses[index]["levelKey"],
                                      userUid: widget.userUid,
                                      userName: widget.userName,
                                      userEmail: widget.userEmail,
                                    );
                                  })
                        ],
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
