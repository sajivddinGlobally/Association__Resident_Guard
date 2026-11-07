// To parse this JSON data, do
//
//     final historyGuardResModel = historyGuardResModelFromJson(jsonString);

import 'dart:convert';

HistoryGuardResModel historyGuardResModelFromJson(String str) => HistoryGuardResModel.fromJson(json.decode(str));

String historyGuardResModelToJson(HistoryGuardResModel data) => json.encode(data.toJson());

class HistoryGuardResModel {
    bool? status;
    String? message;
    Data? data;

    HistoryGuardResModel({
        this.status,
        this.message,
        this.data,
    });

    factory HistoryGuardResModel.fromJson(Map<String, dynamic> json) => HistoryGuardResModel(
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
    List<Tab>? tabs;
    String? sectionTitle;
    List<Guard>? guards;

    Data({
        this.header,
        this.tabs,
        this.sectionTitle,
        this.guards,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        tabs: json["tabs"] == null ? [] : List<Tab>.from(json["tabs"]!.map((x) => Tab.fromJson(x))),
        sectionTitle: json["section_title"],
        guards: json["guards"] == null ? [] : List<Guard>.from(json["guards"]!.map((x) => Guard.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "tabs": tabs == null ? [] : List<dynamic>.from(tabs!.map((x) => x.toJson())),
        "section_title": sectionTitle,
        "guards": guards == null ? [] : List<dynamic>.from(guards!.map((x) => x.toJson())),
    };
}

class Guard {
    int? id;
    String? name;
    String? post;
    String? shiftName;
    String? timings;
    String? status;
    bool? isOnline;
    String? phone;
    String? avatarUrl;

    Guard({
        this.id,
        this.name,
        this.post,
        this.shiftName,
        this.timings,
        this.status,
        this.isOnline,
        this.phone,
        this.avatarUrl,
    });

    factory Guard.fromJson(Map<String, dynamic> json) => Guard(
        id: json["id"],
        name: json["name"],
        post: json["post"],
        shiftName: json["shift_name"],
        timings: json["timings"],
        status: json["status"],
        isOnline: json["is_online"],
        phone: json["phone"],
        avatarUrl: json["avatar_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "post": post,
        "shift_name": shiftName,
        "timings": timings,
        "status": status,
        "is_online": isOnline,
        "phone": phone,
        "avatar_url": avatarUrl,
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

class Tab {
    String? key;
    String? label;
    bool? isActive;

    Tab({
        this.key,
        this.label,
        this.isActive,
    });

    factory Tab.fromJson(Map<String, dynamic> json) => Tab(
        key: json["key"],
        label: json["label"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "label": label,
        "is_active": isActive,
    };
}
