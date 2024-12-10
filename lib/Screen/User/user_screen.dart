import 'package:ai_english_learning/Animation/background_gradient_animation.dart';
import 'package:ai_english_learning/Animation/custom_page_route.dart';
import 'package:ai_english_learning/Controllers/user_dashboard_controller.dart';
import 'package:ai_english_learning/Screen/User/user_classes_via_levels.dart';
import 'package:ai_english_learning/Widgets/User/user_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

class UserScreen extends StatefulWidget {
  final String userUid, userName, userEmail;

  const UserScreen({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserDashboardController userDashboardController =
      Get.put(UserDashboardController());

  @override
  void initState() {
    super.initState();
    userDashboardController.getDashBoardData();
  }

  List imagesList = [
    "assets/images/BeginnerLevel.png",
    "assets/images/IntermediateLevel.png",
    "assets/images/AdvanceLevel.png"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // backgroundColor: const Color.fromARGB(255, 245, 222, 224),
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          backgroundColor: Colors.transparent,
          // backgroundColor: const Color.fromARGB(255, 180, 184, 185),
          centerTitle: true,
          titleSpacing: 1,
          foregroundColor: const Color.fromARGB(255, 21, 49, 71),
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 55,
                  child: Image.asset('assets/images/Logo.png'),
                ),
              ),
              const Text(
                'AI English Course',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [BoxShadow(blurRadius: 5, spreadRadius: 10)],
                ),
              ),
            ],
          ),
        ),
        drawer: UserDrawerWidget(
          userUid: widget.userUid,
          accountName: widget.userName,
          accountEmail: widget.userEmail,
        ),
        body: BackgroundGradientAnimation(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Obx(() {
                    if (userDashboardController.level.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Container(
                      margin: const EdgeInsets.only(top: 60),
                      height: MediaQuery.of(context).size.height*.88,
                      child: CarouselSlider.builder(
                        itemCount: userDashboardController.level.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*.04),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color.fromARGB(255, 236, 236, 230),
                                        Color.fromARGB(255, 180, 182, 179)
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          right: 1,
                                          top: 0,
                                          bottom: 0,
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width*.6,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    _navigateToNextScreen(context,UserClassViaLevels(
                                                      userUid: widget.userUid,
                                                      userName: widget.userName,
                                                      userEmail: widget.userEmail,
                                                      index: itemIndex,
                                                      pageName: userDashboardController.level[itemIndex]["name"]
                                                    ));
                                                    
                                                  },
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        userDashboardController
                                                            .level[itemIndex]["name"],
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(255, 21, 49, 71),
                                                          fontWeight: FontWeight.bold,
                                                          shadows: [
                                                            BoxShadow(
                                                                blurRadius: 2,
                                                                spreadRadius: 2),
                                                          ],
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        '${userDashboardController.level[itemIndex]["classCount"] ?? 0} Classes',
                                                        style: TextStyle(
                                                          color: Colors.grey.shade600,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          bottom: 0,
                                          child: InkWell(
                                            child: SizedBox(height: 150,width: 150, child: Image.asset(imagesList[itemIndex])),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          enlargeFactor: .2,
                          scrollDirection: Axis.vertical,
                          viewportFraction: .31,
                          height: 110,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          autoPlayInterval: const Duration(seconds: 10),
                          autoPlayAnimationDuration: const Duration(seconds: 4),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _navigateToNextScreen(BuildContext context, nextScreen) {
  Navigator.of(context).push(
    CustomPageRoute.slideTransition(
      page: nextScreen, // Replace with your destination widget
      begin: const Offset(1.0, 0.0), // Slide in from the right
      curve: Curves.easeInOut, // Customize the animation curve
      duration: const Duration(milliseconds: 600), // Customize the duration
    ),
  );
}
}
