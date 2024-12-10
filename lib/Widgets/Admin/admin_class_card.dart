import 'package:ai_english_learning/Controllers/animation_controller.dart';
import 'package:ai_english_learning/Controllers/business_controller.dart';
import 'package:ai_english_learning/Screen/Admin/update_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminClassCard extends StatelessWidget {
  final String className, description, imageUrl, classKey, levelKey;
  final int index;
  final String userUid, userName, userEmail;

  const AdminClassCard({
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
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnimateController>(builder: (animateController) {
      return Card(
        shadowColor: const Color.fromARGB(136, 0, 187, 212),
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
                      // Show a dialog with the full description
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(className),
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.4, // Set max height
                              child: SingleChildScrollView(
                                child: Text(description),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.to(() => UpdateClass(
                                        classKey: classKey,
                                        userUid: userUid,
                                        userName: userName,
                                        userEmail: userEmail,
                                      ));
                                },
                                child: const Text("Update"),
                              ),
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text(
                                        "Are you sure?",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                              Color.fromARGB(255, 21, 49, 71),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Cancel",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                              Color.fromARGB(255, 21, 49, 71),
                                            ),
                                          ),
                                          onPressed: () {
                                            final businessController =
                                                Get.put(BusinessController());
                                            businessController.deleteClassAndShiftPositions(
                                                classKey,
                                                levelKey,
                                                userUid,
                                                userName,
                                                userEmail);
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Delete",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text("Delete"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Close"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Class Name
                        Text(
                          className,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
