import 'package:ai_english_learning/Widgets/notification_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserDashboardController extends GetxController{
  RxBool isLoading = false.obs;
  var usersMap = <Map<String, dynamic>>[].obs;
  var userCount = 0.obs;
  var level = <Map<String, dynamic>>[].obs;
  var levelCount = 0.obs;
  var class_ = <Map<String, dynamic>>[].obs;
  var classCount = 0.obs;
  RxList<Map<String, dynamic>> selectedClass = <Map<String, dynamic>>[].obs;

  setLoading(val){
    isLoading.value = val;
  }


    // Function to get dashboard data
  void getDashBoardData() {
    fetchLevels();
    fetchClass();
  }
  
  // Function to fetch all leave requests
  void fetchLevels() {
    FirebaseFirestore.instance.collection("Levels").where("status", isEqualTo: true).snapshots().listen((QuerySnapshot snapshot) {
      level.clear();
      levelCount.value = 0;

      for (var doc in snapshot.docs) {
        level.add(doc.data() as Map<String, dynamic>);
        levelCount.value = level.length;
      }
    });
  }  

  // Function to fetch all leave requests
  void fetchClass() {
    FirebaseFirestore.instance.collection("Class")
    .snapshots().listen((QuerySnapshot snapshot) {
      class_.clear();
      classCount.value = 0;

      for (var doc in snapshot.docs) {
        class_.add(doc.data() as Map<String, dynamic>);
        classCount.value = class_.length;
      }
      // Count class per levels
    for (var levels in level) {
      int count = 0;
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?; // Make sure data is not null
        if (data != null && data['levelKey'] != null && levels['levelKey'] != null) {
          if (data['levelKey'] == levels['levelKey']) {
            count++;
          }
        }
      }
      levels['classCount'] = count; // Add class count to each Levels
    }

      update(); // Notify listeners
    });
  }

  // Get Dishes via Levels
  // Future<void> getClass(int index,) async {

  //   level.refresh(); // To trigger UI updates

  //   if (level[index]["levelKey"] == "") {
  //     CollectionReference classInst = FirebaseFirestore.instance.collection("Class");
  //     await classInst.get().then((QuerySnapshot data) {
  //       var allClassData = data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

  //       selectedClass.value = allClassData;
  //     });
  //   } else {
  //     CollectionReference dishInst = FirebaseFirestore.instance.collection("Class");
  //     await dishInst
  //         .where("levelKey", isEqualTo: level[index]["levelKey"])
  //         .get()
  //         .then((QuerySnapshot data) {
  //       var allClassData = data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

  //       selectedClass.value = allClassData;
  //     });
  //   }
  // }
  
void fetchUnlockedClasses(String userId, String levelKey) async {
  try {
    // Fetch the unlocked classes
    selectedClass.value = await getUnlockedClasses(userId, levelKey);
    // notify("success","Got the data perfectly");
    // print(selectedClass);


  } catch (e) {
    // Handle errors
    notify("Note","You haven't unlocked this level");
  }
}


  Future<List<Map<String, dynamic>>> getUnlockedClasses(String userId, String levelKey) async {
  final userRef = FirebaseFirestore.instance.collection('User').doc(userId);
  final classesRef = FirebaseFirestore.instance.collection('Class');

  // Fetch user progress
  final userSnapshot = await userRef.get();
  final unlockedClassKeys = userSnapshot['progress'][levelKey]['unlockedClasses'] ?? [];

  // Fetch details of unlocked classes
  final unlockedClasses = <Map<String, dynamic>>[];

  for (var classKey in unlockedClassKeys) {
    final classSnapshot = await classesRef.doc(classKey).get();
    if (classSnapshot.exists) {
      unlockedClasses.add({
        'classKey': classKey,
        'className': classSnapshot['className'],
        'classPic': classSnapshot['classPic'],
        'description': classSnapshot['description'],
        'position': classSnapshot['position'],
        'level': classSnapshot['level'],
        'levelKey': classSnapshot['levelKey'],
        'userUid': classSnapshot['userUid']
      });
    }
  }

  // Sort by position (optional)
  unlockedClasses.sort((a, b) => a['position'].compareTo(b['position']));

  return unlockedClasses;
}

Future<void> markClassAsCompleted(String userId, String levelKey, String classKey) async {
  final userRef = FirebaseFirestore.instance.collection('User').doc(userId);
  final classesRef = FirebaseFirestore.instance.collection('Class');
  final levelsRef = FirebaseFirestore.instance.collection('Levels');

  // Fetch the current class and its position
  final currentClassSnapshot = await classesRef.doc(classKey).get();
  final currentPosition = currentClassSnapshot['position'];

  // Fetch the next class in the current level
  final nextClassSnapshot = await classesRef
      .where('levelKey', isEqualTo: levelKey)
      .where('position', isGreaterThan: currentPosition)
      .orderBy('position')
      .limit(1)
      .get();

  if (nextClassSnapshot.docs.isNotEmpty) {
    // If there is a next class, unlock it
    final nextClassKey = nextClassSnapshot.docs.first.id;

    await userRef.update({
      'progress.$levelKey.completedClasses': FieldValue.arrayUnion([classKey]),
      'progress.$levelKey.unlockedClasses': FieldValue.arrayUnion([nextClassKey]),
    });
  } else {
    // No more classes in the current level
    // Fetch the next level
    final levelsSnapshot = await levelsRef
        .orderBy('levelKey') // Assuming level keys are ordered
        .get();

    // Find the next level
    final levels = levelsSnapshot.docs.map((doc) => doc.data()).toList();
    final currentLevelIndex = levels.indexWhere((level) => level['levelKey'] == levelKey);

    if (currentLevelIndex != -1 && currentLevelIndex < levels.length - 1) {
      final nextLevelKey = levels[currentLevelIndex + 1]['levelKey'];

      // Fetch the first class of the next level
      final firstClassSnapshot = await classesRef
          .where('levelKey', isEqualTo: nextLevelKey)
          .orderBy('position')
          .limit(1)
          .get();

      if (firstClassSnapshot.docs.isNotEmpty) {
        final firstClassKey = firstClassSnapshot.docs.first.id;

        // Unlock the first class of the next level
        await userRef.update({
          'progress.$levelKey.completedClasses': FieldValue.arrayUnion([classKey]),
          'progress.$nextLevelKey.unlockedClasses': FieldValue.arrayUnion([firstClassKey]),
        });
      } else {
        // Next level has no classes; just mark the current class as completed
        await userRef.update({
          'progress.$levelKey.completedClasses': FieldValue.arrayUnion([classKey]),
        });
      }
    } else {
      // No next level; just mark the current class as completed
      await userRef.update({
        'progress.$levelKey.completedClasses': FieldValue.arrayUnion([classKey]),
      });
    }
  }
}





}