class EventType {
  String? typeId;
  String? orgId;
  String? name;
  String? createdAt;

  EventType({
    this.typeId,
    this.orgId,
    this.name,
    this.createdAt,
  });

  EventType copyWith(
          {String? typeId, String? orgId, String? name, String? createdAt}) =>
      EventType(
        typeId: typeId ?? this.typeId,
        orgId: orgId ?? this.orgId,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );

  factory EventType.fromJson(Map<String, dynamic> json) => EventType(
        typeId: json["typeId"],
        orgId: json["orgId"],
        name: json["name"],
        createdAt: json['createdAt'],
      );

  Map<String, dynamic> toJson() => {
        "typeId": typeId,
        "orgId": orgId,
        "name": name,
        "createdAt": createdAt,
      };
}
