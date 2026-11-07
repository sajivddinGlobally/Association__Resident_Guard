// To parse this JSON data, do
//
//     final getResidentDetailsModel = getResidentDetailsModelFromJson(jsonString);

import 'dart:convert';

GetResidentDetailsModel getResidentDetailsModelFromJson(String str) => GetResidentDetailsModel.fromJson(json.decode(str));

String getResidentDetailsModelToJson(GetResidentDetailsModel data) => json.encode(data.toJson());

class GetResidentDetailsModel {
    bool? status;
    String? message;
    Data? data;

    GetResidentDetailsModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetResidentDetailsModel.fromJson(Map<String, dynamic> json) => GetResidentDetailsModel(
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
    Resident? resident;

    Data({
        this.header,
        this.resident,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        resident: json["resident"] == null ? null : Resident.fromJson(json["resident"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "resident": resident?.toJson(),
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

class Resident {
    int? id;
    String? name;
    String? email;
    String? phone;
    String? avatar;
    String? role;
    String? status;
    String? unitNumber;
    String? building;
    String? complex;
    String? joinedDate;

    Resident({
        this.id,
        this.name,
        this.email,
        this.phone,
        this.avatar,
        this.role,
        this.status,
        this.unitNumber,
        this.building,
        this.complex,
        this.joinedDate,
    });

    factory Resident.fromJson(Map<String, dynamic> json) => Resident(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        avatar: json["avatar"],
        role: json["role"],
        status: json["status"],
        unitNumber: json["unit_number"],
        building: json["building"],
        complex: json["complex"],
        joinedDate: json["joined_date"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "avatar": avatar,
        "role": role,
        "status": status,
        "unit_number": unitNumber,
        "building": building,
        "complex": complex,
        "joined_date": joinedDate,
    };
}
