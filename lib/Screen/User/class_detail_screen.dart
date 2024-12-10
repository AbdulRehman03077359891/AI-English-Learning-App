
import 'package:ai_english_learning/Animation/background_gradient_animation.dart';
import 'package:ai_english_learning/Controllers/fire_controller.dart';
import 'package:ai_english_learning/Controllers/user_dashboard_controller.dart';
// import 'package:ai_english_learning/Screen/User/apply_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassDetailScreen extends StatefulWidget {
  final String className,
      description,
      imageUrl,
      classKey,
      levelName,
      levelKey,
      adminUid;
  final int index;
  final String userUid, userName, userEmail;

  const ClassDetailScreen({
    super.key,
    required this.className,
    required this.description,
    required this.imageUrl,
    required this.userUid,
    required this.userName,
    required this.userEmail,
    required this.classKey,
    required this.index, required this.levelName, required this.levelKey, required this.adminUid,
  });

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  final FireController fireController = Get.put(FireController());
  final UserDashboardController userDashboardController = Get.put(UserDashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    await fireController.fireBaseDataFetch(context, widget.userUid, "go");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
        title: Text(
          widget.className,
          style: const TextStyle(fontWeight: FontWeight.bold),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 21, 49, 71),
      ),
      body: BackgroundGradientAnimation(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80,),
                // Display the Class image
                Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Details",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 21, 49, 71)),
                  ),
                ),
                const Divider(),
                buildDetailRow('Class Name:', widget.className),
                const SizedBox(height: 20),
                const Divider(),
        
                const SizedBox(height: 16),
                // Display the Class description
                const Text(
                  "Description",
                  style: TextStyle(
                      color: Color.fromARGB(255, 21, 49, 71),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Text(
                  widget.description,
                  style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
        
                // Button to apply
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      userDashboardController.markClassAsCompleted(widget.userUid, widget.levelKey, widget.classKey);
                      // // Handle apply button functionality here
                      // Get.to((FormApplication(
                      //   userName: fireController.userData["userName"],
                      //   userUid: widget.userUid,
                      //   gender: fireController.userData["userGender"],
                      //   contact: fireController.userData["userContact"],
                      //   dob: fireController.userData["dateOfBirth"],
                      //   userEmail: fireController.userData["userEmail"],
                      //   userPic: fireController.userData["profilePic"],
                      //   classKey: widget.classKey,
                      //   classPic: widget.imageUrl,
                      //   className: widget.className,
                      //   levelName: widget.levelName,
                      //   adminUid: widget.adminUid,
                      // )));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 21, 49, 71),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Apply Now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
