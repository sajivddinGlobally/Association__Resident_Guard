// To parse this JSON data, do
//
//     final getNotificaionListModel = getNotificaionListModelFromJson(jsonString);

import 'dart:convert';

GetNotificaionListModel getNotificaionListModelFromJson(String str) => GetNotificaionListModel.fromJson(json.decode(str));

String getNotificaionListModelToJson(GetNotificaionListModel data) => json.encode(data.toJson());

class GetNotificaionListModel {
    bool? status;
    Data? data;

    GetNotificaionListModel({
        this.status,
        this.data,
    });

    factory GetNotificaionListModel.fromJson(Map<String, dynamic> json) => GetNotificaionListModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    Header? header;
    List<String>? filters;
    String? activeFilter;
    int? unreadCount;
    List<Section>? sections;
    List<Notification>? notifications;

    Data({
        this.header,
        this.filters,
        this.activeFilter,
        this.unreadCount,
        this.sections,
        this.notifications,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        filters: json["filters"] == null ? [] : List<String>.from(json["filters"]!.map((x) => x)),
        activeFilter: json["active_filter"],
        unreadCount: json["unread_count"],
        sections: json["sections"] == null ? [] : List<Section>.from(json["sections"]!.map((x) => Section.fromJson(x))),
        notifications: json["notifications"] == null ? [] : List<Notification>.from(json["notifications"]!.map((x) => Notification.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "filters": filters == null ? [] : List<dynamic>.from(filters!.map((x) => x)),
        "active_filter": activeFilter,
        "unread_count": unreadCount,
        "sections": sections == null ? [] : List<dynamic>.from(sections!.map((x) => x.toJson())),
        "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
    };
}

class Header {
    String? title;
    String? subtitle;

    Header({
        this.title,
        this.subtitle,
    });

    factory Header.fromJson(Map<String, dynamic> json) => Header(
        title: json["title"],
        subtitle: json["subtitle"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
    };
}

class Notification {
    int? id;
    String? title;
    String? message;
    String? tag;
    String? type;
    String? iconType;
    String? time;
    bool? isRead;
    String? createdAt;
    String? timeAgo;
    bool? isOverdue;
    String? redTag;
    String? headingReminderTag;
    String? tagColor;
    String? badgeColor;
    String? badgeClass;

    Notification({
        this.id,
        this.title,
        this.message,
        this.tag,
        this.type,
        this.iconType,
        this.time,
        this.isRead,
        this.createdAt,
        this.timeAgo,
        this.isOverdue,
        this.redTag,
        this.headingReminderTag,
        this.tagColor,
        this.badgeColor,
        this.badgeClass,
    });

    factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        tag: json["tag"],
        type: json["type"],
        iconType: json["icon_type"],
        time: json["time"],
        isRead: json["is_read"],
        createdAt: json["created_at"],
        timeAgo: json["time_ago"]?.toString(),
        isOverdue: json["is_overdue"] == true ||
            json["is_overdue"] == 1 ||
            json["is_overdue"] == "true",
        redTag: json["red_tag"]?.toString(),
        headingReminderTag: json["heading_reminder_tag"]?.toString(),
        tagColor: json["tag_color"]?.toString(),
        badgeColor: json["badge_color"]?.toString(),
        badgeClass: json["badge_class"]?.toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "tag": tag,
        "type": type,
        "icon_type": iconType,
        "time": time,
        "is_read": isRead,
        "created_at": createdAt,
        "time_ago": timeAgo,
        "is_overdue": isOverdue,
        "red_tag": redTag,
        "heading_reminder_tag": headingReminderTag,
        "tag_color": tagColor,
        "badge_color": badgeColor,
        "badge_class": badgeClass,
    };
}

class Section {
    String? title;
    String? badge;
    int? count;
    List<Notification>? items;

    Section({
        this.title,
        this.badge,
        this.count,
        this.items,
    });

    factory Section.fromJson(Map<String, dynamic> json) => Section(
        title: json["title"],
        badge: json["badge"],
        count: json["count"],
        items: json["items"] == null ? [] : List<Notification>.from(json["items"]!.map((x) => Notification.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "badge": badge,
        "count": count,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
