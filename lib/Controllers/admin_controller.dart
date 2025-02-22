import 'dart:io';

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

class AdminController extends GetxController {
  var isLoading = true;
  var levelList = [];
  late String _imageLink = '';
  final pickedImageFile = Rx<File?>(null);
  var allLevels = [];
  var selectedDishes = [];

// Setting Loading ---------------------------------------------------------
  setLoading(value) {
    isLoading = value;
    update();
  }
// Levels Settings -------------------------------------------------------

// Get Data================
  getLevelsList() async {
    setLoading(true);
    levelList.clear();
    CollectionReference levelsInst =
        FirebaseFirestore.instance.collection("Levels");
    await levelsInst.get().then((QuerySnapshot data) {
      for (var element in data.docs) {
        levelList.add(element.data());
      }
    });
    setLoading(false);
    update();
  }

  getLevels() async {
    setLoading(true);
    CollectionReference levelsInst =
        FirebaseFirestore.instance.collection("Levels");
    await levelsInst
        .where("status", isEqualTo: true)
        .get()
        .then((QuerySnapshot data) {
      allLevels = data.docs.map((doc) => doc.data()).toList();
      var newData = {
        "levelKey": "",
        "name": "All",
        "status": true,
        "imageUrl":
            "https://firebasestorage.googleapis.com/v0/b/humanlibrary-1c35f.appspot.com/o/dish%2Fdata%2Fuser%2F0%2Fcom.example.my_ecom_app%2Fcache%2Fddef191b-ec35-409a-97d0-97f477f3ba23%2F1000340493.jpg?alt=media&token=73b61dd1-a8f8-441f-87cb-24eb4af30c7e",
        "selected": false,
      };
      allLevels = allLevels;
      allLevels.insert(0, newData);
      getClasses(0);
    });
    setLoading(false);
    update();
  }

// Get Dish via Levels==========
  getClasses(index) async {
    for (int i = 0; i < allLevels.length; i++) {
      allLevels[i]["selected"] = false;
    }
    allLevels[index]["selected"] = true;
    if (allLevels[index]["levelKey"] == "") {
      CollectionReference dishInst =
          FirebaseFirestore.instance.collection("Dishes");
      await dishInst.get().then((QuerySnapshot data) {
        var allDishesData = data.docs.map((doc) => doc.data()).toList();

        selectedDishes = allDishesData;
        update();
      });
    } else {
      CollectionReference dishInst =
          FirebaseFirestore.instance.collection("Dishes");
      await dishInst
          .where("levelKey", isEqualTo: allLevels[index]["levelKey"])
          .get()
          .then((QuerySnapshot data) {
        var allDishesData = data.docs.map((doc) => doc.data()).toList();

        selectedDishes = allDishesData;
        update();
      });
    }
  }

// // Delete Dishes
//   deleteDish(index) async {
//     CollectionReference dishInst =
//         FirebaseFirestore.instance.collection("Dishes");
//     await dishInst.doc(selectedDishes[index]["dishKey"]).delete();
//     selectedDishes.removeAt(index);
//     update();
//   }

// Delete Levels============
  deleteLevel(index) async {
    setLoading(true);
    CollectionReference levelsInst =
        FirebaseFirestore.instance.collection("Levels");
    await levelsInst.doc(levelList[index]["levelKey"]).delete();
    levelList.removeAt(index);
    setLoading(false);
    update();
  }

// Update Levels Status=======
  updateLevelStatus(index) async {
    setLoading(true);
    CollectionReference levelsInst =
        FirebaseFirestore.instance.collection("Levels");
    await levelsInst
        .doc(levelList[index]["levelKey"])
        .update({"status": !levelList[index]["status"]});
    levelList[index]["status"] = !levelList[index]["status"];
    setLoading(false);
    update();
  }

// Update Levels Data=============
  updateLevelData(
    index,
    name,
    // type, address
  ) async {
    setLoading(true);
    if (name.isEmpty) {
      notify("error", "Please enter a valid name");
      setLoading(false);
      return;
    } else if (pickedImageFile.value == null) {
      notify("error", "Please pick an image");
      setLoading(false);
      return;
      // } else if (type.isEmpty) {
      //   notify("error", "Please enter a valid type");
      //   return;
      // } else if (address.isEmpty) {
      //   notify("error", "Please enter a valid address");
      //   return;
    }
    try {
      updateLevel(
        index, name,
        // type, address
      );
      update();
    } catch (e) {
      setLoading(false);
      notify("error", "ImageStorages ${e.toString()}");
    }
  }

  updateLevel(
    index,
    name,
    //  type, address
  ) async {
    FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef =
          storage.ref().child("level/${pickedImageFile.value!.path}");
      UploadTask upLoad = storageRef.putFile(pickedImageFile.value as File);
      TaskSnapshot snapshot = await upLoad.whenComplete(() => ());
      String downloadUrl = await snapshot.ref.getDownloadURL();

      _imageLink = downloadUrl;
      
    CollectionReference levelsInst =
        FirebaseFirestore.instance.collection("Levels");

    var docKey = levelList[index]["levelKey"];
    var doc = await levelsInst.doc(docKey).get();

    if (doc.exists) {
      await levelsInst.doc(docKey).update({
        "name": name,
        "levelImage": _imageLink,
        // "type": type,
        // "address": address,
      }).then((_) {
        getLevelsList();
        pickedImageFile.value = null;
        setLoading(false);
        update();
        notify("Success", "Levels updated successfully");
      }).catchError((error) {
        setLoading(false);
        notify("error", "Failed to update name: $error");
      });
    } else {
      setLoading(false);
      notify("error", "Document not found");
    }
  }

// Adding New Level======
  addLevel(
    String name,
    //  String type, String address
  ) {
    try {
      setLoading(true);
      if (name.isEmpty) {
        notify("error", "Please enter level's name.");
      } else if (pickedImageFile.value == null) {
        notify("error", "Please pick an image.");
      } else {
        imageStoreStorage(
          name,
          //  type, address
        );
      }
    } finally {
      setLoading(false);
    }
  }

  //Storing Category Image -----------------------------------------------
  imageStoreStorage(name) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef =
          storage.ref().child("level/${pickedImageFile.value!.path}");
      UploadTask upLoad = storageRef.putFile(pickedImageFile.value as File);
      TaskSnapshot snapshot = await upLoad.whenComplete(() => ());
      String downloadUrl = await snapshot.ref.getDownloadURL();

      _imageLink = downloadUrl;
      fireStoreDBase(name);
      update();
    } catch (e) {
      setLoading(false);
      notify("error", "ImageStorages ${e.toString()}");
    }
  }

// Storing New level Data in Firebase Data Base===
  fireStoreDBase(
    name,
    //  type, address
  ) async {
    CollectionReference levelsInst =
        FirebaseFirestore.instance.collection("Levels");
    var key = FirebaseDatabase.instance.ref("Levels").push().key;
    var levelObj = {
      "name": name,
      "status": true,
      "levelImage": _imageLink,
      "levelKey": key,
      "selected": false,
    };
    await levelsInst.doc(key).set(levelObj);
    notify("Success", "Level added Successfully");
    pickedImageFile.value = null;
    getLevelsList();
    setLoading(false);
    update();
  }

// Taking permission to from Mobile ==========================
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

// Taking Level Picture from Camera/Storage =====================
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

// Cropping Image=================================
  Future<File?> _cropImage(File imageFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        // aspectRatio:
        //     const CropAspectRatio(ratioX: 2, ratioY: 3), // Portrait Aspect Ratio
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Image Cropper",
              toolbarColor: const Color.fromARGB(255, 119, 118, 119),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
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
}
