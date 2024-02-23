// To parse this JSON data, do
//
//     final participant = participantFromJson(jsonString);

import 'dart:convert';

Participant participantFromJson(String str) =>
    Participant.fromJson(json.decode(str));

String participantToJson(Participant data) => json.encode(data.toJson());

class Participant {
  String? orgId;
  String? eventId;
  String? userId;
  String? joinedDate;
  String? eventDate;
  String? eventTime;

  Participant({
    this.orgId,
    this.eventId,
    this.userId,
    this.joinedDate,
    this.eventDate,
    this.eventTime,
  });

  Participant copyWith({
    String? orgId,
    String? eventId,
    String? userId,
    String? joinedDate,
    String? eventDate,
    String? eventTime,
  }) =>
      Participant(
        orgId: orgId ?? this.orgId,
        eventId: eventId ?? this.eventId,
        userId: userId ?? this.userId,
        joinedDate: joinedDate ?? this.joinedDate,
        eventDate: eventDate ?? this.eventDate,
        eventTime: eventTime ?? this.eventTime,
      );

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        orgId: json["orgId"],
        eventId: json["eventId"],
        userId: json["userId"],
        joinedDate: json["joinedDate"],
        eventDate: json["eventDate"],
        eventTime: json["eventTime"],
      );

  Map<String, dynamic> toJson() => {
        "orgId": orgId,
        "eventId": eventId,
        "userId": userId,
        "joinedDate": joinedDate,
        "eventDate": eventDate,
        "eventTime": eventTime,
      };
}
