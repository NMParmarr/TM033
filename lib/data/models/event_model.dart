// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

import 'dart:convert';

EventModel eventModelFromJson(String str) =>
    EventModel.fromJson(json.decode(str));

String eventModelToJson(EventModel data) => json.encode(data.toJson());

class EventModel {
  String? eventId;
  String? orgId;
  String? eventName;
  String? eventDate;
  String? eventTime;
  String? location;
  String? type;
  String? about;
  String? image;
  String? createdAt;
  // List<String>? participants;

  EventModel({
    this.eventId,
    this.orgId,
    this.eventName,
    this.eventDate,
    this.eventTime,
    this.location,
    this.type,
    this.about,
    this.image,
    this.createdAt,
    // this.participants,
  });

  EventModel copyWith({
    String? eventId,
    String? orgId,
    String? eventName,
    String? eventDate,
    String? eventTime,
    String? location,
    String? type,
    String? about,
    String? image,
    String? createdAt,
    // List<String>? participants,
  }) =>
      EventModel(
        eventId: eventId ?? this.eventId,
        orgId: orgId ?? this.orgId,
        eventName: eventName ?? this.eventName,
        eventDate: eventDate ?? this.eventDate,
        eventTime: eventTime ?? this.eventTime,
        location: location ?? this.location,
        type: type ?? this.type,
        about: about ?? this.about,
        image: image ?? this.image,
        createdAt: createdAt ?? this.createdAt,
        // participants: participants ?? this.participants,
      );

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        eventId: json["eventId"],
        orgId: json["orgId"],
        eventName: json["eventName"],
        eventDate: json["eventDate"],
        eventTime: json["eventTime"],
        location: json["location"],
        type: json["type"],
        about: json["about"],
        image: json["image"],
        createdAt: json["createdAt"],
        // participants: List<String>.from(json["participants"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "eventId": eventId,
        "orgId": orgId,
        "eventName": eventName,
        "eventDate": eventDate,
        "eventTime": eventTime,
        "location": location,
        "type": type,
        "about": about,
        "image": image,
        "createdAt": createdAt,
        // "participants": List<dynamic>.from(participants!.map((x) => x)),
      };
}
