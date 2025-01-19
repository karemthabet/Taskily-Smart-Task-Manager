class UserDataModel {
  String? name;
  String? email;
  String? id;
  UserDataModel({
     this.email,
     this.id,
     this.name,
  });
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
    };
  }

  UserDataModel.fromJson(Map<String, dynamic> json)
      : this(id: json["id"], email: json["email"], name: json["name"]);
}
