import 'package:ai_english_learning/Controllers/admin_controller.dart';
import 'package:ai_english_learning/Controllers/fire_controller.dart';
// import 'package:ai_english_learning/Widgets/Admin/Level_type.dart';
import 'package:ai_english_learning/Widgets/notification_message.dart';
import 'package:ai_english_learning/Widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddLevel extends StatefulWidget {
  final String userName, userEmail, profilePicture;
  const AddLevel(
      {super.key,
      required this.userName,
      required this.userEmail,
      required this.profilePicture});

  @override
  State<AddLevel> createState() => _AddLevelState();
}

class _AddLevelState extends State<AddLevel> {
  var adminController = Get.put(AdminController());
  final FireController fireController = Get.put(FireController());
  TextEditingController editingNameController = TextEditingController();
  // TextEditingController editingTypeController = TextEditingController();
  // TextEditingController editingAddressController = TextEditingController();
  late int selectedIndex;

  TextEditingController levelController = TextEditingController();
  // final TextEditingController _type = TextEditingController();
  // TextEditingController addressController = TextEditingController();
  // String? _selectedType;

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
                        if (await adminController
                                .requestPermission(Permission.camera) ==
                            true) {
                          adminController.pickAndCropImage(
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
                      if (await adminController
                              .requestPermission(Permission.storage) ==
                          true) {
                        adminController.pickAndCropImage(
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
    getAllLevels();
  }

  getAllLevels() {
    adminController.getLevelsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
            fireController.setLoading(false);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: const Text(
          "Levels",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 180, 184, 185),
        foregroundColor: const Color.fromARGB(255, 21, 49, 71),
      ),
      body: GetBuilder<AdminController>(builder: (adminController) {
        return Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                Color.fromARGB(255, 236, 236, 230),
                Color.fromARGB(255, 180, 182, 179)
              ])),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    showBottomSheet();
                  },
                  child: adminController.pickedImageFile.value == null
                      ? Card(
                          elevation: 10,
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/postPlaceHolder.jpeg"),
                                    fit: BoxFit.cover)),
                          ))
                      : Card(
                          elevation: 10,
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: FileImage(
                                        adminController.pickedImageFile.value!),
                                    fit: BoxFit.cover)),
                          )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldWidget(
                    controller: levelController,
                    focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                    hintText: "Enter your Level",
                    errorBorderColor: Colors.red,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: HospitalTypeChoose(
                //     controller: _type,
                //     selectedType: _selectedType,
                //     onChange: (value) {
                //       setState(() {
                //         _selectedType = value;
                //         _type.text = value!;
                //       });
                //     },
                //     width: MediaQuery.of(context).size.width,
                //     fillColor: Colors.white,
                //     labelColor: const Color.fromARGB(255, 21, 49, 71),
                //     focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                //     errorBorderColor: Colors.red,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextFieldWidget(
                //     controller: addressController,
                //     focusBorderColor: const Color.fromARGB(255, 21, 49, 71),
                //     hintText: "Enter level's Address",
                //     errorBorderColor: Colors.red,
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                adminController.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 21, 49, 71),
                        ),
                      )
                    : ElevatedButton(
                        style: const ButtonStyle(
                            fixedSize:
                                MaterialStatePropertyAll<Size>(Size(160, 20)),
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 21, 49, 71))),
                        onPressed: () {
                          adminController.addLevel(
                            levelController.text,
                            // _type.text, addressController.text
                          );
                          levelController.clear();
                          // _type.clear();
                          // addressController.clear();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.add_box, color: Colors.white),
                            Text(
                              "Add Level",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      const Center(
                          child: Text(
                        'All Levels',
                        style: TextStyle(
                            color: Color.fromARGB(255, 21, 49, 71),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )),
                      DataTable(
                        headingRowColor: const MaterialStatePropertyAll(
                            Color.fromARGB(255, 21, 49, 71)),
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(
                              label: Text('S.NO',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Level',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Type',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                          DataColumn(
                              label: Text('Action',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                        ],
                        rows: List.generate(adminController.levelList.length,
                            (index) {
                          return DataRow(cells: [
                            DataCell(Text((index + 1).toString())),
                            DataCell(
                                Text(adminController.levelList[index]["name"])),
                            DataCell(Row(
                              children: [
                                adminController.levelList[index]["status"]
                                    ? GestureDetector(
                                        onTap: () {
                                          adminController
                                              .updateLevelStatus(index);
                                        },
                                        child: const Icon(
                                            Icons.check_box_outlined))
                                    : GestureDetector(
                                        onTap: () {
                                          adminController
                                              .updateLevelStatus(index);
                                        },
                                        child: const Icon(Icons
                                            .check_box_outline_blank_outlined),
                                      ),
                                Text(adminController.levelList[index]["status"]
                                    .toString()),
                              ],
                            )),
                            DataCell(Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: const Text(
                                                  "Are you sure?",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                      style: const ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          21,
                                                                          49,
                                                                          71))),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                  ElevatedButton(
                                                      style: const ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          21,
                                                                          49,
                                                                          71))),
                                                      onPressed: () {
                                                        adminController
                                                            .deleteLevel(index);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                ],
                                              ));
                                    },
                                    icon: const Icon(Icons.delete)),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedIndex = index;
                                        editingNameController.text =
                                            adminController.levelList[index]
                                                    ["name"]
                                                .toString();
                                        // editingTypeController.text =
                                        //     adminController.levelList[index]
                                        //             ["type"].toString();
                                        //             editingAddressController.text = adminController.levelList[index]["address"].toString();
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: Column(
                                                  children: [
                                                    GestureDetector(onTap: () {
                                                      showBottomSheet();
                                                    }, child: Obx(() {
                                                      return adminController
                                                                  .pickedImageFile
                                                                  .value ==
                                                              null
                                                          ? Card(
                                                              elevation: 10,
                                                              child: Container(
                                                                height: 200,
                                                                width: 200,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    image: const DecorationImage(
                                                                        image: AssetImage(
                                                                            "assets/images/postPlaceHolder.jpeg"),
                                                                        fit: BoxFit
                                                                            .cover)),
                                                              ))
                                                          : Card(
                                                              elevation: 10,
                                                              child: Container(
                                                                height: 200,
                                                                width: 200,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    image: DecorationImage(
                                                                        image: FileImage(adminController
                                                                            .pickedImageFile
                                                                            .value!),
                                                                        fit: BoxFit
                                                                            .cover)),
                                                              ));
                                                    })),
                                                    TextField(
                                                      controller:
                                                          editingNameController,
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                      style: const ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          21,
                                                                          49,
                                                                          71))),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                  ElevatedButton(
                                                      style: const ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          21,
                                                                          49,
                                                                          71))),
                                                      onPressed: () {
                                                        adminController
                                                            .updateLevelData(
                                                          index,
                                                          editingNameController
                                                              .text,
                                                          // editingTypeController
                                                          //     .text,
                                                          // editingAddressController
                                                          //     .text
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Update",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                ],
                                              ));
                                    },
                                    icon: const Icon(Icons.edit))
                              ],
                            ))
                          ]);
                        }),
                      ),
                    ])
              ],
            ),
          ),
        );
      }),
    );
  }
}
