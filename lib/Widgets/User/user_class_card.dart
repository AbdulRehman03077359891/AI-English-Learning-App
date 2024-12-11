import 'package:ai_english_learning/Controllers/animation_controller.dart';
import 'package:ai_english_learning/Screen/User/user_learning_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserClassCard extends StatelessWidget {
  final String className,
      description,
      imageUrl,
      classKey,
      levelName,
      levelKey,
      adminUid;
  final int index;
  final String userUid, userName, userEmail;

  const UserClassCard({
    super.key,
    required this.className,
    required this.description,
    required this.imageUrl,
    required this.index,
    required this.classKey,
    required this.levelKey,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.levelName,
    required this.adminUid,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnimateController>(builder: (animateController) {
      return Card(
        color: Colors.white,
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 236, 236, 230),
                Color.fromARGB(255, 180, 182, 179)
              ],
            ),
          ),
          child: Row(
            children: [
              // Class Image on the left side
              GestureDetector(
                onTap: () => animateController.showSecondPage(
                    "$index", imageUrl, context),
                child: Hero(
                  tag: "$index",
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15)),
                    child: CachedNetworkImage(
                      height: 160,
                      width: 120,
                      fit: BoxFit.cover,
                      imageUrl: imageUrl,
                    ),
                  ),
                ),
              ),
              // Text Information on the right side
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Get.to(EnglishLearningScreen(
                        text: description,
                        className: className,
                        classKey: classKey,
                        userUid: userUid,
                        levelKey: levelKey,
                      ));
                      // Get.to(() => ClassDetailScreen(
                      //       className: className,
                      //       description: description,
                      //       imageUrl: imageUrl,
                      //       userUid: userUid,
                      //       userName: userName,
                      //       userEmail: userEmail,
                      //       classKey: classKey,
                      //       levelName: levelName,
                      //       levelKey: levelKey,
                      //       adminUid: adminUid,
                      //       index: index,
                      //     ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // class Name
                        Text(
                          className,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 21, 49, 71)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        // Description with tap functionality
                        Text(
                          description,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
