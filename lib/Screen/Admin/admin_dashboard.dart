import 'package:ai_english_learning/Animation/background_gradient_animation.dart';
import 'package:ai_english_learning/Controllers/admin_dashboard_controller.dart';
import 'package:ai_english_learning/Screen/Admin/admin_levels_categorized.dart';
import 'package:ai_english_learning/Widgets/Admin/admin_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatefulWidget {
  final String userUid, userName, userEmail;
  const AdminDashboard({
    super.key,
    required this.userUid,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  final AdminDashboardController adminDashboardController =
      Get.put(AdminDashboardController());

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      adminDashboardController.getDashBoardData();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          backgroundColor: const Color.fromARGB(255, 180, 184, 185),
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
        drawer: AdminDrawerWidget(
          userUid: widget.userUid,
          accountName: widget.userName,
          accountEmail: widget.userEmail,
        ),
        body: BackgroundGradientAnimation(
          child: Obx(
            () {
              if (adminDashboardController.level.isEmpty) {
                return const Center(
                  child: Text(
                    "No Level Available",
                    style: TextStyle(color: Color.fromARGB(255, 21, 49, 71)),
                  ),
                );
              } else {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: adminDashboardController.level.length,
                  itemBuilder: (context, index) {
                    final Animation<double> animation =
                        Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          (index / adminDashboardController.level.length),
                          1.0,
                          curve: Curves.easeInOut,
                        ),
                      ),
                    );
                    
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                              0, 50 * (1 - animation.value)), // Slide in from bottom
                          child: Transform.rotate(
                            angle: (1 - animation.value) * 0.2, // Slight rotation
                            child: Transform.scale(
                              scale: animation.value,
                              child: GestureDetector(
                                onTapDown: (_) => setState(() {}),
                                onTap: () {
                                  Get.to(
                                    LevelsViaCategories(
                                      userUid: widget.userUid,
                                      userName: widget.userName,
                                      userEmail: widget.userEmail,
                                      index: index,
                                      category:
                                          adminDashboardController.level[index]
                                              ["name"],
                                    ),
                                    transition: Transition.zoom,
                                  );
                                },
                                child: Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    splashColor: Colors.blue.withAlpha(30),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Color.fromARGB(
                                                  255, 236, 236, 230),
                                              Color.fromARGB(255, 180, 182, 179)
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                adminDashboardController
                                                        .level[index]["name"],
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 21, 49, 71),
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
                                                '${adminDashboardController.level[index]["classCount"] ?? 0} Classes',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
