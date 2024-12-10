import 'package:ai_english_learning/Animation/background_gradient_animation.dart';
import 'package:ai_english_learning/Controllers/admin_dashboard_controller.dart';
import 'package:ai_english_learning/Controllers/animation_controller.dart';
import 'package:ai_english_learning/Controllers/business_controller.dart';
import 'package:ai_english_learning/Widgets/Admin/admin_class_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LevelsViaCategories extends StatefulWidget {
  final String userUid, userName, userEmail, category;
  // profilePicture;
  final int index;
  const LevelsViaCategories(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.category,
      // required this.profilePicture,
      required this.index});

  @override
  State<LevelsViaCategories> createState() => _LevelsViaCategoriesState();
}

class _LevelsViaCategoriesState extends State<LevelsViaCategories> {
  var animateController = Get.put(AnimateController());
  var businessController = Get.put(BusinessController());
  final AdminDashboardController adminDashboardController =
      Get.put(AdminDashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      getAllClasses();
    });
  }

  getAllClasses() {
    adminDashboardController.getClass(widget.index);
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
              adminDashboardController.selectedClass.clear();
            });
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          "${widget.category}'s Category",
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
              return adminDashboardController.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 21, 49, 71),
                    ))
                  : adminDashboardController.selectedClass.isEmpty
                      ? Center(
                          child: Text(
                              "No Class available in this ${widget.category}"),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: adminDashboardController
                                      .selectedClass.length,
                                  itemBuilder: (context, index) {
                                    return AdminClassCard(
                                      className: adminDashboardController
                                          .selectedClass[index]["className"],
                                      description: adminDashboardController
                                          .selectedClass[index]["description"],
                                      imageUrl: adminDashboardController
                                          .selectedClass[index]["classPic"],
                                      index: index,
                                      classKey: adminDashboardController
                                          .selectedClass[index]["classKey"],
                                      levelKey: adminDashboardController
                                          .selectedClass[index]["levelKey"],
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
