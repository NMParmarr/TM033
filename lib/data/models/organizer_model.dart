// To parse this JSON data, do
//
//     final organizerModel = organizerModelFromJson(jsonString);

import 'dart:convert';

OrganizerModel organizerModelFromJson(String str) => OrganizerModel.fromJson(json.decode(str));

String organizerModelToJson(OrganizerModel data) => json.encode(data.toJson());

class OrganizerModel {
    String? id;
    String? organization;
    String? organizer;
    String? email;
    String? mobile;
    String? password;
    String? about;
    String? image;
    String? joinDate;

    OrganizerModel({
        this.id,
        this.organization,
        this.organizer,
        this.email,
        this.mobile,
        this.password,
        this.about,
        this.image,
        this.joinDate,
    });

    OrganizerModel copyWith({
        String? id,
        String? organization,
        String? organizer,
        String? email,
        String? mobile,
        String? password,
        String? about,
        String? image,
        String? joinDate,
    }) => 
        OrganizerModel(
            id: id ?? this.id,
            organization: organization ?? this.organization,
            organizer: organizer ?? this.organizer,
            email: email ?? this.email,
            mobile: mobile ?? this.mobile,
            password: password ?? this.password,
            about: about ?? this.about,
            image: image ?? this.image,
            joinDate: joinDate ?? this.joinDate,
        );

    factory OrganizerModel.fromJson(Map<String, dynamic> json) => OrganizerModel(
        id: json["id"],
        organization: json["organization"],
        organizer: json["organizer"],
        email: json["email"],
        mobile: json["mobile"],
        password: json["password"],
        about: json["about"],
        image: json["image"],
        joinDate: json["joinDate"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "organization": organization,
        "organizer": organizer,
        "email": email,
        "mobile": mobile,
        "password": password,
        "about": about,
        "image": image,
        "joinDate": joinDate,
    };
}
