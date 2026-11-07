// To parse this JSON data, do
//
//     final frequentVisitorsResModel = frequentVisitorsResModelFromJson(jsonString);

import 'dart:convert';

FrequentVisitorsResModel frequentVisitorsResModelFromJson(String str) => FrequentVisitorsResModel.fromJson(json.decode(str));

String frequentVisitorsResModelToJson(FrequentVisitorsResModel data) => json.encode(data.toJson());

class FrequentVisitorsResModel {
    bool? status;
    String? message;
    Data? data;

    FrequentVisitorsResModel({
        this.status,
        this.message,
        this.data,
    });

    factory FrequentVisitorsResModel.fromJson(Map<String, dynamic> json) => FrequentVisitorsResModel(
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
    Header? header;
    String? searchPlaceholder;
    List<Metric>? metrics;
    String? sectionTitle;
    String? sortLabel;
    List<Visitor>? visitors;

    Data({
        this.header,
        this.searchPlaceholder,
        this.metrics,
        this.sectionTitle,
        this.sortLabel,
        this.visitors,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        searchPlaceholder: json["search_placeholder"],
        metrics: json["metrics"] == null ? [] : List<Metric>.from(json["metrics"]!.map((x) => Metric.fromJson(x))),
        sectionTitle: json["section_title"],
        sortLabel: json["sort_label"],
        visitors: json["visitors"] == null ? [] : List<Visitor>.from(json["visitors"]!.map((x) => Visitor.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "search_placeholder": searchPlaceholder,
        "metrics": metrics == null ? [] : List<dynamic>.from(metrics!.map((x) => x.toJson())),
        "section_title": sectionTitle,
        "sort_label": sortLabel,
        "visitors": visitors == null ? [] : List<dynamic>.from(visitors!.map((x) => x.toJson())),
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

class Metric {
    String? count;
    String? label;

    Metric({
        this.count,
        this.label,
    });

    factory Metric.fromJson(Map<String, dynamic> json) => Metric(
        count: json["count"],
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "label": label,
    };
}

class Visitor {
    int? id;
    String? name;
    String? roleType;
    String? apartment;
    String? avatarUrl;
    Badges? badges;
    String? lastVisit;
    String? inTime;
    String? totalVisits;
    bool? isInside;
    String? primaryAction;

    Visitor({
        this.id,
        this.name,
        this.roleType,
        this.apartment,
        this.avatarUrl,
        this.badges,
        this.lastVisit,
        this.inTime,
        this.totalVisits,
        this.isInside,
        this.primaryAction,
    });

    factory Visitor.fromJson(Map<String, dynamic> json) => Visitor(
        id: json["id"],
        name: json["name"],
        roleType: json["role_type"],
        apartment: json["apartment"],
        avatarUrl: json["avatar_url"],
        badges: json["badges"] == null ? null : Badges.fromJson(json["badges"]),
        lastVisit: json["last_visit"],
        inTime: json["in_time"],
        totalVisits: json["total_visits"],
        isInside: json["is_inside"],
        primaryAction: json["primary_action"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role_type": roleType,
        "apartment": apartment,
        "avatar_url": avatarUrl,
        "badges": badges?.toJson(),
        "last_visit": lastVisit,
        "in_time": inTime,
        "total_visits": totalVisits,
        "is_inside": isInside,
        "primary_action": primaryAction,
    };
}

class Badges {
    String? status;
    String? statusColor;
    String? tag;
    String? tagColor;

    Badges({
        this.status,
        this.statusColor,
        this.tag,
        this.tagColor,
    });

    factory Badges.fromJson(Map<String, dynamic> json) => Badges(
        status: json["status"],
        statusColor: json["status_color"],
        tag: json["tag"],
        tagColor: json["tag_color"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "status_color": statusColor,
        "tag": tag,
        "tag_color": tagColor,
    };
}
