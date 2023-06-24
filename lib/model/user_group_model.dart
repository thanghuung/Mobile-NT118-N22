class UserGroupModel {
  String? userID;
  String? groupID;

  UserGroupModel({this.userID, this.groupID});

  UserGroupModel.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    groupID = json['groupID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['groupID'] = this.groupID;
    return data;
  }

}
