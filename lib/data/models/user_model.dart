// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? orgId;
  String? name;
  String? organization;
  String? email;
  String? mobile;
  String? dob;
  String? field;
  String? password;
  String? about;
  String? image;
  String? joinDate;
  bool? isProfileCompleted;

  UserModel({
    this.id,
    this.orgId,
    this.name,
    this.organization,
    this.email,
    this.mobile,
    this.dob,
    this.field,
    this.password,
    this.about,
    this.image,
    this.joinDate,
    this.isProfileCompleted,
  });

  UserModel copyWith({
    String? id,
    String? orgId,
    String? name,
    String? organization,
    String? email,
    String? mobile,
    String? dob,
    String? field,
    String? password,
    String? about,
    String? image,
    String? joinDate,
    bool? isProfileCompleted,
  }) =>
      UserModel(
        id: id ?? this.id,
        orgId: orgId ?? this.orgId,
        name: name ?? this.name,
        organization: organization ?? this.organization,
        email: email ?? this.email,
        mobile: mobile ?? this.mobile,
        dob: dob ?? this.dob,
        field: field ?? this.field,
        password: password ?? this.password,
        about: about ?? this.about,
        image: image ?? this.image,
        joinDate: joinDate ?? this.joinDate,
        isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        orgId: json["orgId"],
        name: json["name"],
        organization: json["organization"],
        email: json["email"],
        mobile: json["mobile"],
        dob: json["dob"],
        field: json["field"],
        password: json["password"],
        about: json["about"],
        image: json["image"],
        joinDate: json["joinDate"],
        isProfileCompleted: json['isProfileCompleted'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orgId": orgId,
        "name": name,
        "organization": organization,
        "email": email,
        "mobile": mobile,
        "dob": dob,
        "field": field,
        "password": password,
        "about": about,
        "image": image,
        "joinDate": joinDate,
        "isProfileCompleted" : isProfileCompleted,
      };
}
