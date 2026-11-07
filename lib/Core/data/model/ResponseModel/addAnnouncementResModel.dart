// To parse this JSON data, do
//
//     final addAnnouncementResModel = addAnnouncementResModelFromJson(jsonString);

import 'dart:convert';

AddAnnouncementResModel addAnnouncementResModelFromJson(String str) => AddAnnouncementResModel.fromJson(json.decode(str));

String addAnnouncementResModelToJson(AddAnnouncementResModel data) => json.encode(data.toJson());

class AddAnnouncementResModel {
    bool? status;
    String? message;
    Data? data;

    AddAnnouncementResModel({
        this.status,
        this.message,
        this.data,
    });

    factory AddAnnouncementResModel.fromJson(Map<String, dynamic> json) => AddAnnouncementResModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    int? complexId;
    String? complexName;
    String? title;
    String? message;
    String? type;
    String? priority;
    dynamic attachment;
    dynamic attachmentUrl;
    String? targetAudience;
    String? status;
    bool? pinned;
    CreatedBy? createdBy;
    dynamic expiresAt;
    String? createdAt;
    String? createdAtFormatted;
    String? dateHuman;

    Data({
        this.id,
        this.complexId,
        this.complexName,
        this.title,
        this.message,
        this.type,
        this.priority,
        this.attachment,
        this.attachmentUrl,
        this.targetAudience,
        this.status,
        this.pinned,
        this.createdBy,
        this.expiresAt,
        this.createdAt,
        this.createdAtFormatted,
        this.dateHuman,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        complexId: json["complex_id"],
        complexName: json["complex_name"],
        title: json["title"],
        message: json["message"],
        type: json["type"],
        priority: json["priority"],
        attachment: json["attachment"],
        attachmentUrl: json["attachment_url"],
        targetAudience: json["target_audience"],
        status: json["status"],
        pinned: json["pinned"],
        createdBy: json["created_by"] == null ? null : CreatedBy.fromJson(json["created_by"]),
        expiresAt: json["expires_at"],
        createdAt: json["created_at"],
        createdAtFormatted: json["created_at_formatted"],
        dateHuman: json["date_human"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "complex_id": complexId,
        "complex_name": complexName,
        "title": title,
        "message": message,
        "type": type,
        "priority": priority,
        "attachment": attachment,
        "attachment_url": attachmentUrl,
        "target_audience": targetAudience,
        "status": status,
        "pinned": pinned,
        "created_by": createdBy?.toJson(),
        "expires_at": expiresAt,
        "created_at": createdAt,
        "created_at_formatted": createdAtFormatted,
        "date_human": dateHuman,
    };
}

class CreatedBy {
    int? id;
    String? name;
    String? role;

    CreatedBy({
        this.id,
        this.name,
        this.role,
    });

    factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"],
        name: json["name"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role": role,
    };
}
