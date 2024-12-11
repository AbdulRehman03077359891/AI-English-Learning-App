
import 'package:ai_english_learning/Screen/User/user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserController extends GetxController{
  RxBool isLoading = false.obs;
  
  var req = <Map<String, dynamic>>[].obs;
  var reqCount = 0.obs;

  setLoading(val){
    isLoading.value = val;
  }

  formRequest(userUid, userName, userEmail, userPic, userContact, userCnic, userAddress, userGender, userBloodType, classKey, classPic, className, hosName, adminUid) async {
    CollectionReference reqIns = FirebaseFirestore.instance.collection("Requests");
    var reqKey = FirebaseDatabase.instance.ref("Requests").push().key;

    var reqObj = {
      "userUid" : userUid,
      "userName" : userName,
      "userEmail" : userEmail,
      "userPic" : userPic,
      "userContact" : userContact,
      "userCnic" : userCnic,
      "userGender" : userGender,
      "userBloodType" : userBloodType,
      "className" : className,
      "classKey" : classKey,
      "classPic" : classPic,
      "level" : hosName,
      "status" : "pending",
      "appliedAt" : DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
      "reqKey" : reqKey
    };

    await reqIns.doc(reqKey).set(reqObj);

    Get.off(UserScreen(userUid: userUid, userName: userName, userEmail: userEmail));

  }

    // Function to fetch all leave requests
  void fetchRequests(userUid) {
    FirebaseFirestore.instance.collection("Requests").where("userUid", isEqualTo: userUid).snapshots().listen((QuerySnapshot snapshot) {
      req.clear();
      reqCount.value = 0;

      for (var doc in snapshot.docs) {
        req.add(doc.data() as Map<String, dynamic>);
        reqCount.value = req.length;
      }
    });
  }

  



}