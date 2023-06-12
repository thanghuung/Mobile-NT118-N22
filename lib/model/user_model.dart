class UserModel {
  String? email;
  String? password;
  String? id;

  UserModel({this.email, this.password, this.id});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['id'] = this.id;
    return data;
  }
}