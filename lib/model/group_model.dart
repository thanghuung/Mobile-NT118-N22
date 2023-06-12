import 'package:app/model/user_model.dart';

class GroupModel {
  String? id;
  String? name;
  String? des;
  String? isHost;
  List<UserModel>? userModels;
  int? numUser;

  GroupModel({this.id, this.name, this.des, this.isHost, this.userModels, this.numUser});

  GroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    des = json['des'];
    isHost = json['isHost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['des'] = this.des;
    data['isHost'] = this.isHost;
    return data;
  }
}
