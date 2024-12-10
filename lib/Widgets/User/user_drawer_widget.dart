import 'package:ai_english_learning/Animation/tile_animation.dart';
import 'package:ai_english_learning/Animation/background_gradient_animation.dart';
import 'package:ai_english_learning/Controllers/animation_controller.dart';
import 'package:ai_english_learning/Screen/User/personal_data.dart';
import 'package:ai_english_learning/Widgets/User/settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_english_learning/Controllers/fire_controller.dart';
import 'package:ai_english_learning/Widgets/dialog_box.dart';

class UserDrawerWidget extends StatefulWidget {
  final String userUid, accountName, accountEmail;

  const UserDrawerWidget({
    super.key,
    required this.userUid,
    required this.accountName,
    required this.accountEmail,
  });

  @override
  State<UserDrawerWidget> createState() => _UserDrawerWidgetState();
}

class _UserDrawerWidgetState extends State<UserDrawerWidget> {
  final FireController fireController = Get.put(FireController());
  final AnimateController animateController = Get.put(AnimateController());

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
    return Drawer(
      shadowColor: const Color.fromARGB(255, 0, 0, 0),
      elevation: 50,
      child: BackgroundGradientAnimation(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Color.fromARGB(255, 236, 236, 230),
                    Color.fromARGB(255, 180, 182, 179),
                  ],
                ),
              ),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  if (fireController.userData["profilePic"] != null) {
                    animateController.showSecondPage(
                      "Profile Picture",
                      fireController.userData["profilePic"] ??
                          'assets/images/profilePlaceHolder.jpg',
                      context,
                    );
                  }
                },
                child: Hero(
                  tag: "Profile Picture",
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.cyan,
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: const Color.fromARGB(255, 245, 222, 224),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      image: DecorationImage(
                        image: fireController.userData["profilePic"] != null
                            ? CachedNetworkImageProvider(
                                fireController.userData["profilePic"])
                            : const AssetImage(
                                    'assets/images/profilePlaceHolder.jpg')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              accountName: Text(
                widget.accountName,
                style: const TextStyle(fontWeight: FontWeight.bold, shadows: [
                  BoxShadow(
                      color: Color.fromARGB(115, 24, 255, 255),
                      blurRadius: 3,
                      spreadRadius: 3)
                ]),
              ),
              accountEmail: Text(
                widget.accountEmail,
                style: const TextStyle(fontWeight: FontWeight.bold, shadows: [
                  BoxShadow(
                      color: Color.fromARGB(115, 24, 255, 255),
                      blurRadius: 3,
                      spreadRadius: 3)
                ]),
              ),
            ),
            ..._buildSlidingTiles(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSlidingTiles() {
    final tiles = [
      {
        'icon': Icons.person_rounded,
        'title': "Personal Data",
        "onPress": () => Get.to(
              UserPersonalData(
                imageUrl: fireController.userData["profilePic"] ?? '',
                userName: fireController.userData["userName"],
                userUid: widget.userUid,
                gender: fireController.userData["userGender"],
                contact: fireController.userData["userContact"],
                dob: fireController.userData["dateOfBirth"],
                address: fireController.userData["userAddress"],
                userEmail: fireController.userData["userEmail"],
              ),
            )
      },
      {
        'icon': Icons.settings,
        'title': "Settings",
        "onPress": () => Get.to(const SpeechSettingsPage())
            
      },
      {
        'icon': Icons.logout,
        'title': "Log Out",
        "onPress": () =>
            showConfirmationDialog(context, () => fireController.logOut())
      },
    ];

    return List.generate(tiles.length, (index) {
      return SlidingTileAnimation(
        index: index,
        child: ListTile(
          leading: Icon(
            tiles[index]['icon'] as IconData,
            color: const Color.fromARGB(255, 21, 49, 71),
          ),
          title: Text(
            tiles[index]['title'] as String,
            style: const TextStyle(
                color: Color.fromARGB(255, 21, 49, 71),
                fontWeight: FontWeight.bold,
                shadows: [
                  BoxShadow(color: Colors.cyan, blurRadius: 2, spreadRadius: 2)
                ]),
          ),
          onTap: tiles[index]['onPress'] as Function(),
        ),
      );
    });
  }
}
