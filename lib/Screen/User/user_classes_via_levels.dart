
import 'package:ai_english_learning/Animation/background_gradient_animation.dart';
import 'package:ai_english_learning/Controllers/animation_controller.dart';
import 'package:ai_english_learning/Controllers/user_dashboard_controller.dart';
import 'package:ai_english_learning/Widgets/User/user_class_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserClassViaLevels extends StatefulWidget {
  final String userUid, userName, userEmail, pageName;

  final int index;
  const UserClassViaLevels(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.index,
      required this.pageName});

  @override
  State<UserClassViaLevels> createState() => _UserClassViaLevelsState();
}

class _UserClassViaLevelsState extends State<UserClassViaLevels> {
  var animateController = Get.put(AnimateController());
  final UserDashboardController userDashboardController  =
      Get.put(UserDashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllLevels();
    });
  }

  getAllLevels() {
    userDashboardController.fetchUnlockedClasses(widget.userUid, userDashboardController.level[widget.index]["levelKey"]);
    // userDashboardController.getClass(widget.index);
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
            Future.delayed(const Duration(milliseconds:500 ), () {
              userDashboardController.selectedClass.clear();
            });
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          widget.pageName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 21, 49, 71),
      ),
      body: Stack(
        children: [
          BackgroundGradientAnimation(child: Container()),
          Obx(
            () {
              return userDashboardController.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 21, 49, 71),
                    ))
                  : userDashboardController.selectedClass.isEmpty? Center(child: Text("No Classes available for ${widget.pageName}",style: const TextStyle(color: Color.fromARGB(255, 21, 49, 71),fontWeight: FontWeight.w400),),):  SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  userDashboardController.selectedClass.length,
                              itemBuilder: (context, index) {
                                return  UserClassCard(
                                      className: userDashboardController
                                      .selectedClass[index]["className"],
                                      description: userDashboardController
                                      .selectedClass[index]["description"],
                                      imageUrl: userDashboardController
                                      .selectedClass[index]["classPic"],
                                      index: index,
                                      classKey: userDashboardController
                                      .selectedClass[index]["classKey"],
                                      levelName: userDashboardController
                                      .selectedClass[index]["level"],
                                      levelKey: userDashboardController
                                      .selectedClass[index]["levelKey"],
                                      adminUid: userDashboardController.selectedClass[index]["userUid"],
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
