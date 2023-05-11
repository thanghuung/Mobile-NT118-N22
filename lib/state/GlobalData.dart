import 'package:app/model/Group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalData extends GetxController {
  // task
  List<Map<String, dynamic>> upcomingTasks = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> todayTasks = <Map<String, dynamic>>[].obs;

  Future<List<Map<String, dynamic>>> getUpcomingTasks() async {
    upcomingTasks = <Map<String, dynamic>>[{"loading": true}].obs;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    try {
      final DateTime currentDate = DateTime.now();
      final collectionRef = FirebaseFirestore.instance.collection('tasks');
      var querySnapshot = await collectionRef
          .where('userID', isEqualTo: userId)
          .where('dateDone', isGreaterThanOrEqualTo: currentDate)
          .get();



      print("list: ${querySnapshot.docs.length}");

      // Xóa danh sách cũ trước khi thêm dữ liệu mới
      upcomingTasks.clear();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> taskData = doc.data();
        taskData['id'] = doc.id; // Lấy ID của category
        upcomingTasks.add(taskData);
      }

      querySnapshot = await collectionRef
          .where('userID', isEqualTo: userId)
          .where('dateDone', isEqualTo: currentDate)
          .get();

      return upcomingTasks??[];
    } catch (error) {
      return [];
    }
  }

  void addTaskToFirebase(
      String content,
      String description,
      String color,
      String priority,
      Map<String, dynamic>? category,
      DateTime? dateDone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    if (userId.isNotEmpty) {
      try {
        // Lấy tham chiếu đến collection "tasks"
        final collectionRef = FirebaseFirestore.instance.collection('tasks');

        // Tạo một document mới với id tự động được Firebase sinh ra
        final documentRef = collectionRef.doc();

        // Tạo dữ liệu của task
        final taskData = {
          'content': content,
          'description': description,
          'color': color,
          'priority': priority,
          'categoryID': category?["id"],
          'isCompleted': false,
          'isFavorite': false,
          'dateDone': dateDone,
          'dateCreated': DateTime.now().toString(),
          'userID': userId,
        };

        // Thêm dữ liệu vào document trong collection
        await documentRef.set(taskData);
        upcomingTasks.add({
          'id': "11111",
          'content': content,
          'description': description,
          'color': color,
          'priority': priority,
          'isCompleted': false,
          'categoryID': category?["id"],
          'dateDone': dateDone as Timestamp,
        });
      } catch (error) {}
    }
  }

// group
  final CollectionReference groupsCollection =
      FirebaseFirestore.instance.collection('groups');

  final RxList<Group> groups = RxList<Group>();

  Future<void> createGroup(String groupName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    try {
      final docRef = await groupsCollection.add({
        'groupName': groupName,
        'hostID': userId,
        'dateCreated': DateTime.now()
      });
      final newGroup = Group(id: docRef.id, name: groupName);
      groups.add(newGroup);
    } catch (error) {
      print('Error creating group: $error');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getGroups();
    getUpcomingTasks();
  }

  Future<List<Group>> getGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .where('hostID', isEqualTo: userId)
          .get();

      final List<Group> groups = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Group(
          id: doc.id,
          name: data['groupName'],
          // Các thuộc tính khác của nhóm
        );
      }).toList();

      return groups;
    } catch (error) {
      // Xử lý lỗi
      print('Error getting groups: $error');
      return [];
    }
  }
}
