import 'dart:io';

import 'package:ai_english_learning/Screen/Admin/admin_dashboard.dart';
import 'package:ai_english_learning/Screen/Firebase/sign_in.dart';
import 'package:ai_english_learning/Screen/User/user_screen.dart';
import 'package:ai_english_learning/Widgets/notification_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireController extends GetxController {
  RxBool isLoading = false.obs;
  final RxString _uid = ''.obs;
  final RxString imageLink = ''.obs;
  final pickedImageFile = Rx<File?>(null);
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  final RxList usersListB = <Map<String, dynamic>>[].obs;
  final RxList usersListN = <Map<String, dynamic>>[].obs;
  var allLevels = [];


  // Loading indicator
  setLoading(value) {
    isLoading.value = value;
    update();
  }

  // FireBase SignUp userEmail/password
  Future<UserCredential?> registerUser(userEmail, password, userName, userType) async {
    try {
      setLoading(true);

      final FirebaseAuth auth = FirebaseAuth.instance;

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: userEmail, password: password);
      final user = userCredential.user;

      _uid.value = user!.uid;

      fireStoreDBase(userName, userEmail, password, userType);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      if (e.code == 'weak-password') {
        notify("error", "The password provided is too weak.");
      } else if (e.code == 'userEmail-already-in-use') {
        notify("error", "userEmail already registered");
      }
    } catch (e) {
      setLoading(false);
      notify("error", "Firebase ${e.toString()}");
    }
    finally{
      setLoading(false);
    }
    return null;
  }

  // Storing Profile Image
  Future<void> storeImage(File? image) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef = storage.ref().child("user/${pickedImageFile.value!.path.split('/').last}");
      UploadTask upLoad = storageRef.putFile(pickedImageFile.value as File);
      TaskSnapshot snapshot = await upLoad.whenComplete(() => ());
      String downloadUrl = await snapshot.ref.getDownloadURL();

      imageLink.value = downloadUrl;
      update();
    } catch (e) {
      notify("error", "ImageStorage ${e.toString()}");
    }
  }

  // Picking Image
  Future<void> pickImage(source, picker, context) async {
    final pickedFile = await picker.pickImage(source: source);

    Navigator.pop(context);
    pickedImageFile.value = File(pickedFile!.path);
    update();
  }

  // Storing Data --RealTime DataBase
  Future<void> realTimeDebase(context, userName, userEmail, password, userType) async {
    try {
      var dBaseInstance = FirebaseDatabase.instance;
      DatabaseReference dBaseRef = dBaseInstance.ref();

      var userObj = {
        "name": userName,
        "userEmail": userEmail,
        "password": password,
        "imageUrl": imageLink.value,
        "uid": _uid.value,
        "userType": userType,
        "contact": "contact",
        "address": "address",
        "gender": "gender",
        "dateOfBirth": "dob",
      };

      await dBaseRef.child(userType).child(_uid.value).update(userObj);
      setLoading(false);
      notify('Success', 'User Registered Successfully');

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignInPage()));
    } catch (e) {
      notify("error", "Database ${e.toString()}");
    }
  }

  // Storing Data --Firestore Database
  Future<void> fireStoreDBase(userName, userEmail, password, userType) async {
    try {
      var dBaseInstance = FirebaseFirestore.instance;
      CollectionReference dBaseRef = dBaseInstance.collection(userType);

      var userObj = {
        "userName": userName,
        "userEmail": userEmail,
        "password": password,
        "userUid": _uid.value,
        "userType": userType,
      };

      await dBaseRef.doc(_uid.value).set(userObj);
      notify('Success', 'User Registered Successfully');

      getLevels(_uid.value);
      setLoading(false);

    } catch (e) {
      notify("error", "Database ${e.toString()}");
    }
  }
  Future<void> initializeUserProgress(String userId, String levelKey) async {
  final userRef = FirebaseFirestore.instance.collection('User').doc(userId);

  // Fetch the first class in the level
  final classesRef = FirebaseFirestore.instance.collection('Class');
  final firstClassSnapshot = await classesRef
      .where('levelKey', isEqualTo: levelKey)
      .orderBy('position')
      .limit(1)
      .get();

  if (firstClassSnapshot.docs.isNotEmpty) {
    final firstClassKey = firstClassSnapshot.docs.first["classKey"];

    // Initialize progress for the user
    await userRef.set({
      'progress': {
        levelKey: {
          'completedClasses': [],
          'unlockedClasses': [firstClassKey],
        },
      },
    }, SetOptions(merge: true));
  }
      Get.off(const SignInPage());
}
// getting Levels Data --------------------------------------------------
  getLevels(userUid) async {
    setLoading(true);
    CollectionReference levelsInst =
        FirebaseFirestore.instance.collection("Levels");
    await levelsInst
        .get().then((value) => allLevels = value.docs.map((e) => e.data()).toList());
    //     .then((QuerySnapshot data) {
    //   allLevels = data.docs.map((doc) => doc.data()).toList();
    // });
    initializeUserProgress(userUid, allLevels[0]["levelKey"]);
    setLoading(false);
    update();
  }


  // Auto LogIn preferences
  Future<void> setPreference(Map<String, dynamic> userData) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("Login", true);
    pref.setString("userType", userData["userType"]);
    pref.setString("userEmail", userData["userEmail"]);
    pref.setString("userName", userData["userName"]);
    pref.setString("userUid", userData["userUid"]);
  }

  Future<void> logOut() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    Get.offAll(const SignInPage());
  }

  // User Data when LoginUser
  Future<UserCredential?> logInUser(String userEmail, String password, context, go) async {
    try {
      setLoading(true);
      final FirebaseAuth auth = FirebaseAuth.instance;

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: userEmail, password: password);
      final user = userCredential.user;

      fireBaseDataFetch(context, user, go);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      if (e.code == 'weak-password') {
        notify('error', 'The password provided is too weak.');
      } else if (e.code == 'userEmail-already-in-use') {
        notify("error", "The userEmail address is already in use by another user.");
      } else if (e.code == "invalid-credential") {
        notify("error", "invalid-credential: ${e.toString()}");
      }
    } catch (e) {
      setLoading(false);
      notify("error", e.toString());
    }
    return null;
  }

  // FireBase DataBase DataFetch
  Future<void> fireBaseDataFetch(context, user, go) async {
    setLoading(true);
    await FirebaseFirestore.instance
        .collection("User")
        .doc(go == "go" ? user : user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map;
        userData.value = Map<String, dynamic>.from(data);
        setLoading(false);
        setPreference(userData);

        go == "go" ? debugPrint(go) : Get.offAll(UserScreen(
            userUid: userData["userUid"],
            userName: userData["userName"],
            userEmail: userData["userEmail"],
          ));
      } else {
        await FirebaseFirestore.instance
            .collection("Admin")
            .doc(go == "go" ? user : user.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            var data = documentSnapshot.data() as Map;
            userData.value = Map<String, dynamic>.from(data);

            setLoading(false);
            setPreference(userData);

            go == "go" ? debugPrint(go) : Get.offAll(AdminDashboard(
                userName: userData["userName"],
                userEmail: userData["userEmail"],
                userUid: userData["userUid"],
              ));
          } else {
            setLoading(false);
            notify("error", "Document does not exist");
          }
        });
      }
    });
  }


  // User Data Fetch for User Profile
  Future<void> userProfileData() async {
    setLoading(true);
    await FirebaseFirestore.instance
        .collection("NormUsers")
        .doc(_uid.value)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map;
        userData.value = Map<String, dynamic>.from(data);
        setLoading(false);
        update();
      } else {
        setLoading(false);
        notify("error", "Document does not exist");
      }
    });
  }

  // Updating User Data
  Future<void> updateUserData(imageUrl, userName, userUid, address, gender, contact, dob, userEmail,type) async {
    CollectionReference userInst = FirebaseFirestore.instance.collection(type);
    var doc = await userInst.doc(userUid).get();

    if (doc.exists) {
      await userInst.doc(userUid).update({
        "userName": userName.toString(),
        "userContact": contact.toString(),
        "userAddress": address.toString(),
        "userGender": gender.toString(),
        "dateOfBirth": dob.toString(),
        "profilePic": imageUrl.toString(),
      }).then((_) async {
        pickedImageFile.value = null;
        setLoading(false);
        notify("Success", "Personal Data updated successfully");
      }).catchError((error) {
        setLoading(false);
        notify("error", "Failed to update Personal Data: $error");
      });
    } else {
      setLoading(false);
      notify("error", "Document not found");
    }
  }

// Storing Profile Image
  Future<void> imageStoreStorage(BuildContext context, String userName, String userEmail, String password, String userType) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef = storage.ref().child("user/${pickedImageFile.value!.path.split('/').last}");
      UploadTask upLoad = storageRef.putFile(pickedImageFile.value as File);
      TaskSnapshot snapshot = await upLoad.whenComplete(() => ());
      String downloadUrl = await snapshot.ref.getDownloadURL();

      imageLink.value = downloadUrl;
      update();
      fireStoreDBase(userName, userEmail, password, userType);
    } catch (e) {
      notify("error", "ImageStorage ${e.toString()}");
    }
  }


// Fetching RealTime Data
  Future<void> realTimeDataFetch(User user) async {
    final ref = FirebaseDatabase.instance.ref();
    await ref.child('NormalUser').child(user.uid).once().then((event) async {
      if (event.snapshot.value == null) {
        await ref.child('BusinessUser').child(user.uid).once().then((event) async {
          var data = event.snapshot.value as Map;
          userData.value = Map<String, dynamic>.from(data);
          update();
        });
      } else {
        var data = event.snapshot.value as Map;
        userData.value = Map<String, dynamic>.from(data);
        update();
      }
    });
  }
  // Fetch All Business Users
  Future<void> getAllBusinessUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection("BusinessUsers");
    usersListB.clear();
    await users.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        usersListB.add(doc.data() as Map<String, dynamic>);
      }
    });
    update();
  }

  // Fetch All Normal Users
  Future<void> getAllNormUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection("NormUsers");
    usersListN.clear();
    await users.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        usersListN.add(doc.data() as Map<String, dynamic>);
      }
    });
    update();
  }

  // Update User Address
  Future<void> updateUserAddress(String address, String userUid, String userName, String userEmail) async {
    CollectionReference userInst = FirebaseFirestore.instance.collection("NormUsers");
    var doc = await userInst.doc(userUid).get();

    if (doc.exists) {
      await userInst.doc(userUid).update({"address": address}).then((value) async {
        update();
        // Uncomment this line if you want to navigate after updating
        // Get.offAll(UserScreen(userUid: userUid, userName: userName, userEmail: userEmail, ));
      });
    }
  }
}
