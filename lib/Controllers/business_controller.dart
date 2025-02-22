import 'dart:io';

import 'package:ai_english_learning/Screen/Admin/admin_dashboard.dart';
import 'package:ai_english_learning/Widgets/notification_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BusinessController extends GetxController {
  bool isLoading = false;
  var allLevels = [];
  RxList allClasses = [].obs;
  var dropDownClassValue = "";
  var selectDropDownClassKey = "";
  var dropDownLevelValue = "";
  var selectDropDownLevelKey = "";
  late String _imageLink = '';
  final pickedImageFile = Rx<File?>(null);
  var selectedClasses = [];
  var allOrders = [];
  RxList pendingOrders = [].obs;
  List acceptedOrders = [];
  List shippedOrders = [];
  List deliveredOrders = [];
  List cancelledOrders = [];
  RxInt dishesCount = 0.obs;
  RxList alOrders = [].obs;
  RxInt pOrders = 0.obs;
  RxInt aOrders = 0.obs;
  RxInt sOrders = 0.obs;
  RxInt dOrders = 0.obs;
  RxInt cOrders = 0.obs;
  var selectedClass = {}.obs;

// Setting Loading when processing ----------------------------------------
  setLoading(value) {
    isLoading = value;
    update();
  }

// getting Levels Data --------------------------------------------------
  getLevels(userUid) async {
    setLoading(true);
    CollectionReference levelsInst =
        FirebaseFirestore.instance.collection("Levels");
    levelsInst
        .where("status", isEqualTo: true)
        .snapshots()
        .listen((QuerySnapshot data) {
      allLevels = data.docs.map((doc) => doc.data()).toList();
      getClassesViaLevels(0);
    });
    setLoading(false);
    update();
  }

// Setting Drop Down Value ------------------------------------------------
  setDropDownLevelValue(value) {
    dropDownLevelValue = value["name"];
    selectDropDownLevelKey = value["levelKey"];
    update();
  }

// Check if we are good to go to add Dish ---------------------------------
  addClass(
      className, description, userUid, userName, userEmail, profilePicture) {
    if (className.isEmpty) {
      notify("error", "Please Enter DishName");
    } else if (description.isEmpty) {
      notify("error", "Please Enter Description");
    } else {
      imageStoreClassStorage(
          className, description, userUid, userName, userEmail, profilePicture);
    }
  }

//Storing Dish Image -----------------------------------------------
  imageStoreClassStorage(className, description, userUid, userName, userEmail,
      profilePicture) async {
    try {
      setLoading(true);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef =
          storage.ref().child("class/${pickedImageFile.value!.path}");
      UploadTask upLoad = storageRef.putFile(pickedImageFile.value as File);
      TaskSnapshot snapshot = await upLoad.whenComplete(() => ());
      String downloadUrl = await snapshot.ref.getDownloadURL();

      _imageLink = downloadUrl;
      update();
      fireStoreClassDBase(
          className, description, userUid, userName, userEmail, profilePicture);
    } catch (e) {
      setLoading(false);
      notify("error", "ImageStorages ${e.toString()}");
      update();
    }
  }

// Adding Dish ----------------------------------------------------------
  fireStoreClassDBase(className, description, userUid, userName, userEmail,
      profilePicture) async {
    try {
      CollectionReference classInst =
          FirebaseFirestore.instance.collection("Class");
      // Get all classes for the specified level, ordered by position
      final levelClassesSnapshot = await classInst
          .where("levelKey", isEqualTo: selectDropDownLevelKey)
          .orderBy("position")
          .get();
      var classKey = FirebaseDatabase.instance.ref("Levels").push().key;
      final classDocs = levelClassesSnapshot.docs;

      // Find the next available position (next highest position + 1)
      int nextPosition = classDocs.isEmpty ? 1 : classDocs.last["position"] + 1;

      var classObj = {
        "className": className,
        "level": dropDownLevelValue,
        "levelKey": selectDropDownLevelKey,
        "position": nextPosition,
        "classPic": _imageLink,
        "classKey": classKey,
        "userUid": userUid,
        "userName": userName,
        "userEmail": userEmail,
        "profilePicture": profilePicture,
        "description": description,
      };

      await classInst.doc(classKey).set(classObj);

      notify('Success', "Class Added Successfully");

      setLoading(false);
      dropDownLevelValue = "";
      selectDropDownLevelKey = "";
      pickedImageFile.value = null;
      update();
    } catch (e) {
      setLoading(false);
      notify("error", "Database ${e.toString()}");
      update();
    }
  }

  Future<void> deleteClassAndShiftPositions(
      String classKey, String levelKey, userUid, userName, userEmail) async {
    // Reference to the classes collection
    final classRef = FirebaseFirestore.instance.collection("Class");

    // Fetch the class to be deleted and its position
    final classSnapshot = await classRef.doc(classKey).get();
    final positionToDelete = classSnapshot["position"];

    // Delete the class
    await classRef.doc(classKey).delete();

    // Fetch all classes in the same level, ordered by position
    final levelClassesSnapshot = await classRef
        .where("levelKey", isEqualTo: levelKey)
        .orderBy("position")
        .get();

    final classDocs = levelClassesSnapshot.docs;

    // Shift the positions of the subsequent classes
    for (int i = 0; i < classDocs.length; i++) {
      if (classDocs[i]["position"] > positionToDelete) {
        final nextClassRef = classRef.doc(classDocs[i].id);
        await nextClassRef.update({"position": classDocs[i]["position"] - 1});
      }
    }
    Get.off(AdminDashboard(
        userUid: userUid, userName: userName, userEmail: userEmail));
  }

// Deleting Dish =========
  deleteClass1(classKey, userUid, userName, userEmail) async {
    CollectionReference dishInst =
        FirebaseFirestore.instance.collection("Class");
    await dishInst.doc(classKey).delete();
    // selectedClasses.removeAt(index);
    update();
    Get.off(AdminDashboard(
        userUid: userUid, userName: userName, userEmail: userEmail));
  }

  Future<void> getClassData(String classKey) async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection("Class")
          .doc(classKey)
          .get();
      selectedClass.value = document.data() as Map<String, dynamic>;
    } catch (e) {
      notify("error", "Failed to retrieve Class data: ${e.toString()}");
    }
  }

  updateClass(String classKey, String className, String description,
      String date, userUid, userName, userEmail) async {
    try {
      CollectionReference classRef =
          FirebaseFirestore.instance.collection("Class");
      await classRef.doc(classKey).update({
        "className": className,
        "description": description,
        "date": date,
      });
      notify("success", "Class updated successfully!");
      Get.off(AdminDashboard(
        userUid: userUid,
        userName: userName,
        userEmail: userEmail,
      ));
    } catch (e) {
      notify("error", "Failed to update Class: ${e.toString()}");
    }
  }

// Get Classes via Levels==========
  getClassesViaLevels(index) async {
    for (int i = 0; i < allLevels.length; i++) {
      allLevels[i]["selected"] = false;
    }
    allLevels[index]["selected"] = true;
    if (allLevels[index]["levelKey"] == "") {
      CollectionReference classInst =
          FirebaseFirestore.instance.collection("Class");
      classInst.snapshots().listen((QuerySnapshot data) {
        var selectedClassData = data.docs.map((doc) => doc.data()).toList();

        selectedClasses = selectedClassData;
        update();
      });
    } else {
      CollectionReference dishInst =
          FirebaseFirestore.instance.collection("Class");
      dishInst
          .where("levelKey", isEqualTo: allLevels[index]["levelKey"])
          .snapshots()
          .listen((QuerySnapshot data) {
        var selectedClassData = data.docs.map((doc) => doc.data()).toList();

        selectedClasses = selectedClassData;
        update();
      });
    }
  }

// Taking Permission from Phone ==============================
  Future<bool> requestPermission(Permission permission) async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

// Getting Dish Image via Gallery/Camera ===========================
  Future<void> pickAndCropImage(ImageSource source, context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        File? croppedFile = await _cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          pickedImageFile.value = croppedFile;
          update();
        } else {
          notify("error", "Image cropping was canceled or failed.");
        }
      } else {
        notify("error", "Image picking was canceled.");
      }
    } catch (e) {
      notify("error", "Failed to pick or crop image: $e");
    } finally {
      Navigator.pop(context);
    }
  }

// Cropping Image ================================
  Future<File?> _cropImage(File imageFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Image Cropper",
              toolbarColor: Colors.white,
              toolbarWidgetColor:const Color.fromARGB(255, 21, 49, 71),
              // initAspectRatio: CropAspectRatioPreset.ratio3x4,
              lockAspectRatio: true,
              hideBottomControls: true),
          IOSUiSettings(
            title: "Image Cropper",
          ),
        ],
      );
      if (croppedFile != null) {
        return File(croppedFile.path);
      } else {
        notify("error", "No image was cropped.");
        return null;
      }
    } catch (e) {
      notify("error", "Failed to crop image: $e");
    }
    return null;
  }

  getOrder(String nUserUid) async {
    setLoading(true);
    // Clear previous data
    allOrders.clear();
    pendingOrders.clear();
    acceptedOrders.clear();
    shippedOrders.clear();
    deliveredOrders.clear();
    cancelledOrders.clear();

    update();

    CollectionReference orderInst =
        FirebaseFirestore.instance.collection("Orders");

    // Fetch orders based on user UID
    orderInst
        .where("bUserUid", isEqualTo: nUserUid)
        .snapshots()
        .listen((QuerySnapshot data) {
      var ordersData = data.docs.map((doc) => doc.data()).toList();

      // Loop through each order and categorize it by its status
      for (var order in ordersData) {
        // Check if order is not null and status exists
        if (order != null &&
            order is Map<String, dynamic> &&
            order.containsKey("status")) {
          String? status = order["status"] as String?;

          // Switch based on status
          switch (status) {
            case "pending":
              pendingOrders.add(order);
              break;
            case "accepted":
              acceptedOrders.add(order);
              break;
            case "shipped":
              shippedOrders.add(order);
              break;
            case "delivered":
              deliveredOrders.add(order);
              break;
            case "cancelled":
              cancelledOrders.add(order);
              break;
            default:
              // Handle unknown or missing status
              allOrders.add(order);
          }
        } else {
          // Handle cases where order or status is null
          allOrders.add(order); // Optionally add the order to a general list
        }
      }

      // Update with categorized orders
      allOrders =
          ordersData; // If you want to keep all orders in one list as well
      setLoading(false);
      update();
    });
  }

  Future<void> openMap(String lat, String long) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    try {
      await launchUrlString(googleUrl);
    } catch (e) {
      notify("error", 'Error launching URL: $e');
      // Optionally, show an error message to the user
    }
  }

  updateOrder(orderKey, status, reason) async {
    setLoading(true);
    CollectionReference orderInst =
        FirebaseFirestore.instance.collection("Orders");

    var doc = await orderInst.doc(orderKey).get();

    if (doc.exists) {
      await orderInst
          .doc(orderKey)
          .update({"status": status, "reason": reason}).then((_) {
        setLoading(false);
        update();
        notify("Success", "Order updated successfully");
      }).catchError((error) {
        setLoading(false);
        notify("error", "Failed to update status: $error");
      });
    } else {
      setLoading(false);
      notify("error", "Document not found");
    }
  }

  getDashBoardData(bUserUid) {
    // Listen to Dishes collection
    FirebaseFirestore.instance
        .collection("Dishes")
        .snapshots()
        .listen((QuerySnapshot data) {
      notify("Fetched Dishes: ", "${data.docs.length}");
      dishesCount.value = data.docs.length;
    });

    // Listen to Orders and categorize them
    FirebaseFirestore.instance
        .collection("Orders")
        .where("bUserUid", isEqualTo: bUserUid)
        .snapshots()
        .listen((QuerySnapshot data) {
      var ordersData = data.docs.map((doc) => doc.data()).toList();

      // Reset counts for each order status
      pOrders.value = 0;
      aOrders.value = 0;
      sOrders.value = 0;
      dOrders.value = 0;
      cOrders.value = 0;
      allOrders.clear();

      // Loop through each order and categorize it by its status
      for (var order in ordersData) {
        // Check if order is not null and status exists
        if (order != null &&
            order is Map<String, dynamic> &&
            order.containsKey("status")) {
          String? status = order["status"] as String?;

          // Increment the respective order count based on status
          switch (status) {
            case "pending":
              pOrders.value++;
              break;
            case "accepted":
              aOrders.value++;
              break;
            case "shipped":
              sOrders.value++;
              break;
            case "delivered":
              dOrders.value++;
              break;
            case "cancelled":
              cOrders.value++;
              break;
            default:
              alOrders.add(order); // Add to general list if uncategorized
          }
        } else {
          // Handle cases where order or status is null
          alOrders.add(order); // Optionally add the order to a general list
        }
      }

      // Update with categorized orders and notify UI
      setLoading(false);
      update();
    });
  }

  // getting Classes Data --------------------------------------------------
  getClasses(userUid) async {
    setLoading(true);
    try {
      CollectionReference levelsInst =
          FirebaseFirestore.instance.collection("Class");
      levelsInst.snapshots().listen((QuerySnapshot data) {
        var classes = data.docs.map((doc) => doc.data()).toList();
        allClasses.value = classes;
      });
      setLoading(false);
    } finally {
      update();
    }
  }

// Setting Drop Down Value ------------------------------------------------
  setDropDownClassValue(value) {
    dropDownClassValue = value["className"];
    selectDropDownClassKey = value["classKey"];
    update();
  }

// Check if we are good to go to add Dish ---------------------------------
  addExam(q1, a1, q2, a2, q3, o3, a3, q4, o4, a4, q5, a5, userUid, userName,
      userEmail, profilePicture) {
    fireStoreExamDBase(q1, a1, q2, a2, q3, o3, a3, q4, o4, a4, q5, a5, userUid,
        userName, userEmail);
  }

// Adding Dish ----------------------------------------------------------
  fireStoreExamDBase(q1, a1, q2, a2, q3, o3, a3, q4, o4, a4, q5, a5, userUid,
      userName, userEmail) async {
    try {
      CollectionReference examInst =
          FirebaseFirestore.instance.collection("Exams");
      var examKey = FirebaseDatabase.instance.ref("Exams").push().key;

      var examObj = {
        "q1": q1,
        "a1": a1,
        "q2": q2,
        "a2": a2,
        "q3": q3,
        "o3": o3,
        "a3": a3,
        "q4": q4,
        "o4": o4,
        "a4": a4,
        "q5": q5,
        "a5": a5,
        "className": dropDownClassValue,
        "classKey": selectDropDownClassKey,
        "classPic": _imageLink,
        "examKey": examKey,
        "userUid": userUid,
        "userName": userName,
        "userEmail": userEmail,
      };

      await examInst.doc(examKey).set(examObj);

      notify('Success', 'Class Added Successfully');

      setLoading(false);
      dropDownClassValue = "";
      selectDropDownClassKey = "";
      update();
    } catch (e) {
      setLoading(false);
      notify("error", "Database ${e.toString()}");
      update();
    }
  }
}
