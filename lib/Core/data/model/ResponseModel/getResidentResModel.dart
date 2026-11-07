// To parse this JSON data, do
//
//     final getResidentListModel = getResidentListModelFromJson(jsonString);

import 'dart:convert';

GetResidentListModel getResidentListModelFromJson(String str) => GetResidentListModel.fromJson(json.decode(str));

String getResidentListModelToJson(GetResidentListModel data) => json.encode(data.toJson());

class GetResidentListModel {
    bool? status;
    String? message;
    Data? data;

    GetResidentListModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetResidentListModel.fromJson(Map<String, dynamic> json) => GetResidentListModel(
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
    List<Resident>? residents;

    Data({
        this.header,
        this.residents,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        residents: json["residents"] == null ? [] : List<Resident>.from(json["residents"]!.map((x) => Resident.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "residents": residents == null ? [] : List<dynamic>.from(residents!.map((x) => x.toJson())),
    };
}

class Header {
    String? title;
    String? subtitle;
    String? complexName;
    int? totalCount;

    Header({
        this.title,
        this.subtitle,
        this.complexName,
        this.totalCount,
    });

    factory Header.fromJson(Map<String, dynamic> json) => Header(
        title: json["title"],
        subtitle: json["subtitle"],
        complexName: json["complex_name"],
        totalCount: json["total_count"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "complex_name": complexName,
        "total_count": totalCount,
    };
}

class Resident {
    int? id;
    String? name;
    String? unitNumber;
    String? phone;
    String? email;
    String? avatar;
    String? status;
    String? statusBadge;
    bool? isActive;
    String? viewUrl;

    Resident({
        this.id,
        this.name,
        this.unitNumber,
        this.phone,
        this.email,
        this.avatar,
        this.status,
        this.statusBadge,
        this.isActive,
        this.viewUrl,
    });

    factory Resident.fromJson(Map<String, dynamic> json) => Resident(
        id: json["id"],
        name: json["name"],
        unitNumber: json["unit_number"],
        phone: json["phone"],
        email: json["email"],
        avatar: json["avatar"],
        status: json["status"],
        statusBadge: json["status_badge"],
        isActive: json["is_active"],
        viewUrl: json["view_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "unit_number": unitNumber,
        "phone": phone,
        "email": email,
        "avatar": avatar,
        "status": status,
        "status_badge": statusBadge,
        "is_active": isActive,
        "view_url": viewUrl,
    };
}
