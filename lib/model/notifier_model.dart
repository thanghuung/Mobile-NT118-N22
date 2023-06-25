class NotifierModel {
  String? id;
  String? userID;
  String? groupID;
  bool? isSeen;
  String? nameGroup;
  String? nameTask;
  DateTime? timeCreate;

  NotifierModel(
      {this.userID, this.groupID, this.isSeen, this.nameGroup, this.nameTask, this.timeCreate, this.id});

  NotifierModel.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    groupID = json['groupID'];
    isSeen = json['isSeen'];
    nameGroup = json['nameGroup'];
    nameTask = json['nameTask'];
    timeCreate = json['timeCreate'].toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['groupID'] = this.groupID;
    data['isSeen'] = this.isSeen;
    data['nameGroup'] = this.nameGroup;
    data['nameTask'] = this.nameTask;
    data['timeCreate'] = this.timeCreate;
    return data;
  }
}
