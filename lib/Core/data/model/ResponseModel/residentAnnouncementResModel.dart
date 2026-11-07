import 'dart:convert';
import 'package:flutter/material.dart';

GetResidentAnnouncementModel getResidentAnnouncementModelFromJson(String str) =>
    GetResidentAnnouncementModel.fromJson(json.decode(str));

String getResidentAnnouncementModelToJson(GetResidentAnnouncementModel data) =>
    json.encode(data.toJson());

class GetResidentAnnouncementModel {
  bool? status;
  String? message;
  List<ResidentAnnouncementItem>? data;

  GetResidentAnnouncementModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetResidentAnnouncementModel.fromJson(Map<String, dynamic> json) {
    List<ResidentAnnouncementItem> items = [];

    final rawData = json["data"];
    if (rawData is List) {
      items = rawData
          .where((x) => x != null && x is Map<String, dynamic>)
          .map((x) => ResidentAnnouncementItem.fromJson(x as Map<String, dynamic>))
          .toList();
    } else if (rawData is Map<String, dynamic>) {
      final list = rawData["announcements"] ??
          rawData["data"] ??
          rawData["list"] ??
          rawData["items"];
      if (list is List) {
        items = list
            .where((x) => x != null && x is Map<String, dynamic>)
            .map((x) => ResidentAnnouncementItem.fromJson(x as Map<String, dynamic>))
            .toList();
      } else {
        items = [ResidentAnnouncementItem.fromJson(rawData)];
      }
    }

    return GetResidentAnnouncementModel(
      status: json["status"] is bool
          ? json["status"]
          : (json["status"] == 1 ||
              json["status"] == "true" ||
              json["status"] == "success"),
      message: json["message"]?.toString(),
      data: items,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ResidentAnnouncementItem {
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
  ResidentCreatedBy? createdBy;
  dynamic expiresAt;
  String? createdAt;
  String? createdAtFormatted;
  String? dateHuman;

  ResidentAnnouncementItem({
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

  factory ResidentAnnouncementItem.fromJson(Map<String, dynamic> json) =>
      ResidentAnnouncementItem(
        id: json["id"] is int ? json["id"] : int.tryParse(json["id"]?.toString() ?? ""),
        complexId: json["complex_id"] is int
            ? json["complex_id"]
            : int.tryParse(json["complex_id"]?.toString() ?? ""),
        complexName: json["complex_name"]?.toString(),
        title: json["title"]?.toString(),
        message: json["message"]?.toString(),
        type: json["type"]?.toString(),
        priority: json["priority"]?.toString(),
        attachment: json["attachment"],
        attachmentUrl: json["attachment_url"],
        targetAudience: json["target_audience"]?.toString(),
        status: json["status"]?.toString(),
        pinned: json["pinned"] is bool
            ? json["pinned"]
            : (json["pinned"] == 1 || json["pinned"] == "1" || json["pinned"] == "true"),
        createdBy: json["created_by"] == null || json["created_by"] is! Map<String, dynamic>
            ? null
            : ResidentCreatedBy.fromJson(json["created_by"]),
        expiresAt: json["expires_at"],
        createdAt: json["created_at"]?.toString(),
        createdAtFormatted: json["created_at_formatted"]?.toString(),
        dateHuman: json["date_human"]?.toString(),
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

  // Helper getters for compatibility with existing UI
  String get postedDate => dateHuman ?? createdAtFormatted ?? createdAt ?? "";
  String get postedBy => createdBy?.name ?? "Society Association";
  String get content => message ?? "";
  String get shortDescription => message ?? "";

  Color get priorityColor {
    switch (priority?.toLowerCase()) {
      case 'high':
      case 'urgent':
        return const Color(0xFFD32F2F);
      case 'medium':
        return const Color(0xFFFB8C00);
      case 'low':
        return const Color(0xFF388E3C);
      default:
        return const Color(0xFF101C16);
    }
  }

  Color get typeColor {
    switch (type?.toLowerCase()) {
      case 'maintenance':
        return const Color(0xFFB8860B);
      case 'security':
        return const Color(0xFF1976D2);
      case 'event':
        return const Color(0xFF7B1FA2);
      case 'emergency':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFF101C16);
    }
  }

  IconData get typeIcon {
    switch (type?.toLowerCase()) {
      case 'maintenance':
        return Icons.build_circle_outlined;
      case 'security':
        return Icons.security_rounded;
      case 'event':
        return Icons.event_available_outlined;
      case 'emergency':
        return Icons.warning_amber_rounded;
      default:
        return Icons.campaign_outlined;
    }
  }
}

class ResidentCreatedBy {
  int? id;
  String? name;
  String? role;

  ResidentCreatedBy({
    this.id,
    this.name,
    this.role,
  });

  factory ResidentCreatedBy.fromJson(Map<String, dynamic> json) => ResidentCreatedBy(
        id: json["id"] is int ? json["id"] : int.tryParse(json["id"]?.toString() ?? ""),
        name: json["name"]?.toString(),
        role: json["role"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role": role,
      };
}
