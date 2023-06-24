import 'package:app/model/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalData extends GetxController {
  // task
  List<Map<String, dynamic>> upcomingTasks = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> todayTasks = <Map<String, dynamic>>[].obs;

  Future<List<Map<String, dynamic>>> getUpcomingTasks() async {
    upcomingTasks = <Map<String, dynamic>>[
      {"loading": true}
    ].obs;
    todayTasks = <Map<String, dynamic>>[
      {"loading": true}
    ].obs;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? "";
    try {
      final DateTime currentDate = DateTime.now();
      final collectionRef = FirebaseFirestore.instance.collection('tasks');
      var querySnapshot = await collectionRef
          .where('userID', isEqualTo: userId)
          // .where('dateDone', isLessThan: currentDate)
          .get();

      // Xóa danh sách cũ trước khi thêm dữ liệu mới
      upcomingTasks.clear();
      todayTasks.clear();

      for (var doc in querySnapshot.docs) {
        final date = DateTime.fromMicrosecondsSinceEpoch((doc.data()['dateDone'] as Timestamp).microsecondsSinceEpoch);
        if (compareDate(date, DateTime.now()) == -1 && doc.data()['isCompleted'] == false) {
          Map<String, dynamic> taskData = doc.data();
          taskData['id'] = doc.id; // Lấy ID của category
          upcomingTasks.add(taskData);
        }
        if (compareDate(date, DateTime.now()) == 0) {
          Map<String, dynamic> taskData = doc.data();
          taskData['id'] = doc.id; // Lấy ID của category
          todayTasks.add(taskData);
        }
      }

      return upcomingTasks ?? [];
    } catch (error) {
      return [];
    }
  }

  Future<void> addTaskToFirebase(
      String content, String description, String color, String priority, Map<String, dynamic>? category, DateTime? dateDone, DateTime? dateStart,
      {String? idUser, String? idGroup, String? email}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    print(userId);
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
          'categoryID': category?["id"] ?? "",
          'groupID': idGroup,
          'isCompleted': false,
          'isFavorite': false,
          'dateDone': dateDone,
          'dateCreated': DateTime.now(),
          'dateStart': dateStart,
          'userID': idUser ?? userId,
          'email': email,
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
//   final CollectionReference groupsCollection = FirebaseFirestore.instance.collection('group');
//
//   final RxList<Group> groups = RxList<Group>();
//
//   Future<void> createGroup(String groupName) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String userId = prefs.getString('userId') ?? '';
//     try {
//       final docRef = await groupsCollection.add({
//         'groupName': groupName,
//         'hostID': userId,
//         'members': [userId],
//         'dateCreated': DateTime.now()
//       });
//       final newGroup = Group(id: docRef.id, name: groupName);
//       groups.add(newGroup);
//     } catch (error) {
//       print('Error creating group: $error');
//     }
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     getGroups();
//     getUpcomingTasks();
//   }
//
//   Future<List<Group>> getGroups() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String userId = prefs.getString('userId') ?? '';
//     try {
//       final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('groups')
//           .where('hostID', isEqualTo: userId)
//           .get();
//
//       final List<Group> groups = querySnapshot.docs.map((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         return Group(
//           id: doc.id,
//           name: data['groupName'],
//           // Các thuộc tính khác của nhóm
//         );
//       }).toList();
//
//       return groups;
//     } catch (error) {
//       // Xử lý lỗi
//       print('Error getting groups: $error');
//       return [];
//     }
//   }
}

/// -1 => <
/// 0 => =
/// 1 => >
int compareDate(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return 0;
  }
  if (a.year > b.year) {
    return 1;
  } else {
    if (a.year < b.year) {
      return -1;
    } else {
      if (a.month > b.month) {
        return 1;
      } else {
        if (a.month < b.month) {
          return -1;
        } else {
          if (a.day > b.day) {
            return 1;
          } else {
            if (a.day < b.day) {
              return -1;
            } else {
              return 0;
            }
          }
        }
      }
    }
  }
}
