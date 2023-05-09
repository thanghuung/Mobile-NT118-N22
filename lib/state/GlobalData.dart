import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalData extends GetxController {
  List<Map<String, dynamic>> upcomingTasks = <Map<String, dynamic>>[].obs;

  Future<List<Map<String, dynamic>>> getUpcomingTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    try {
      final DateTime currentDate = DateTime.now();

      final collectionRef = FirebaseFirestore.instance.collection('tasks');
      final querySnapshot = await collectionRef
          .where('userID', isEqualTo: userId)
          .where('dateDone', isGreaterThanOrEqualTo: currentDate)
          .get();

      // Xóa danh sách cũ trước khi thêm dữ liệu mới
      upcomingTasks.clear();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> taskData = doc.data();
        taskData['id'] = doc.id; // Lấy ID của category
        upcomingTasks.add(taskData);
      });

      return upcomingTasks;
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
}
