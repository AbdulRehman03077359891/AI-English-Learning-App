import 'package:ai_english_learning/Screen/Admin/admin_dashboard.dart';
import 'package:ai_english_learning/Widgets/notification_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  RxBool isLoading = false.obs;
  var usersMap = <Map<String, dynamic>>[].obs;
  var userCount = 0.obs;
  var level = <Map<String, dynamic>>[].obs;
  var levelCount = 0.obs;
  var req = <Map<String, dynamic>>[].obs;
  var reqCount = 0.obs;
  var class_ = <Map<String, dynamic>>[].obs;
  var classCount = 0.obs;
  RxList<Map<String, dynamic>> selectedClass = <Map<String, dynamic>>[].obs;

  setLoading(val) {
    isLoading.value = val;
  }

  // Function to get dashboard data
  void getDashBoardData() {
    fetchUsers();
    fetchLevels();
    fetchRequests();
    fetchClass();
  }

  // Function to fetch all users from the 'user' collection
  void fetchUsers() {
    FirebaseFirestore.instance
        .collection("User")
        .snapshots()
        .listen((QuerySnapshot snapshot) async {
      usersMap.clear();
      userCount.value = 0;

      try {
        for (var doc in snapshot.docs) {
          usersMap.add(doc.data() as Map<String, dynamic>);
          userCount.value = usersMap.length;
        }
      } catch (e) {
        print("Error fetching users: $e");
      }
    });
  }

  // Function to fetch all leave requests
  void fetchLevels() {
    FirebaseFirestore.instance
        .collection("Levels")
        .where("status", isEqualTo: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      level.clear();
      levelCount.value = 0;

      for (var doc in snapshot.docs) {
        level.add(doc.data() as Map<String, dynamic>);
        levelCount.value = level.length;
      }
    });
  }

  // Function to fetch all leave requests
  void fetchRequests() {
    FirebaseFirestore.instance
        .collection("Requests")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      req.clear();
      reqCount.value = 0;

      for (var doc in snapshot.docs) {
        req.add(doc.data() as Map<String, dynamic>);
        reqCount.value = req.length;
      }
    });
  }

  Future<void> updateRequest(String reqKey, String status, String userUid,
      String userName, String userEmail) async {
    try {
      await FirebaseFirestore.instance
          .collection('Requests')
          .doc(reqKey)
          .update({"status": status});
      notify('Success', 'Request updated successfully!');
      Get.off(() => AdminDashboard(
          userUid: userUid, userName: userName, userEmail: userEmail));
    } catch (e) {
      notify('error', 'Error updating request: $e');
    }
  }

  // Function to fetch all leave requests
  void fetchClass() {
    FirebaseFirestore.instance
        .collection("Class")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      class_.clear();
      classCount.value = 0;

      for (var doc in snapshot.docs) {
        class_.add(doc.data() as Map<String, dynamic>);
        classCount.value = class_.length;
      }
      // Count class per Levels
      for (var levels in level) {
        int count = 0;
        for (var doc in snapshot.docs) {
          var data =
              doc.data() as Map<String, dynamic>?; // Make sure data is not null
          if (data != null &&
              data["levelKey"] != null &&
              levels["levelKey"] != null) {
            if (data["levelKey"] == levels["levelKey"]) {
              count++;
            }
          }
        }
        levels['classCount'] = count; // Add post count to each level
      }

      update(); // Notify listeners
    });
  }

  // Get Dishes via Levels
  Future<void> getClass(
    int index,
  ) async {
    level.refresh(); // To trigger UI updates

    if (level[index]["levelKey"] == "") {
      CollectionReference postInst =
          FirebaseFirestore.instance.collection("Class");
      await postInst.get().then((QuerySnapshot data) {
        var allClassData =
            data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        selectedClass.value = allClassData;
      });
    } else {
      CollectionReference dishInst =
          FirebaseFirestore.instance.collection("Class");
      await dishInst
          .where("levelKey", isEqualTo: level[index]["levelKey"])
          .get()
          .then((QuerySnapshot data) {
        var allClassData =
            data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        selectedClass.value = allClassData;
      });
    }
  }
}
