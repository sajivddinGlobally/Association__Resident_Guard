import 'dart:convert';

AddAnnouncementBodyModel addAnnouncementBodyModelFromJson(String str) =>
    AddAnnouncementBodyModel.fromJson(json.decode(str));

String addAnnouncementBodyModelToJson(AddAnnouncementBodyModel data) =>
    json.encode(data.toJson());

class AddAnnouncementBodyModel {
  String? title;
  String? message;
  String? type;
  String? priority;
  String? targetAudience;
  bool? pinned;

  AddAnnouncementBodyModel({
    this.title,
    this.message,
    this.type = "maintenance",
    this.priority = "high",
    this.targetAudience = "residents",
    this.pinned = true,
  });

  factory AddAnnouncementBodyModel.fromJson(Map<String, dynamic> json) =>
      AddAnnouncementBodyModel(
        title: json["title"],
        message: json["message"],
        type: json["type"],
        priority: json["priority"],
        targetAudience: json["target_audience"],
        pinned: json["pinned"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
        if (type != null) "type": type,
        if (priority != null) "priority": priority,
        if (targetAudience != null) "target_audience": targetAudience,
        if (pinned != null) "pinned": pinned,
      };
}
