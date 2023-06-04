class CategoryModel {
  String? id;
  String? name;
  String? description;
  String? userID;
  int? countWork;

  CategoryModel({this.id, this.name, this.description, this.userID, this.countWork});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    userID = json['userID'];
    countWork = json['countWork'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['userID'] = this.userID;
    data['countWork'] = this.countWork;
    return data;
  }
}
