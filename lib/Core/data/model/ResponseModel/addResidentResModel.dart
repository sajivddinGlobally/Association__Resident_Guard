// To parse this JSON data, do
//
//     final addResidentResModel = addResidentResModelFromJson(jsonString);

import 'dart:convert';

AddResidentResModel addResidentResModelFromJson(String str) => AddResidentResModel.fromJson(json.decode(str));

String addResidentResModelToJson(AddResidentResModel data) => json.encode(data.toJson());

class AddResidentResModel {
    bool? status;
    String? message;
    Data? data;

    AddResidentResModel({
        this.status,
        this.message,
        this.data,
    });

    factory AddResidentResModel.fromJson(Map<String, dynamic> json) => AddResidentResModel(
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
    Resident? resident;
    String? viewUrl;

    Data({
        this.resident,
        this.viewUrl,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        resident: json["resident"] == null ? null : Resident.fromJson(json["resident"]),
        viewUrl: json["view_url"],
    );

    Map<String, dynamic> toJson() => {
        "resident": resident?.toJson(),
        "view_url": viewUrl,
    };
}

class Resident {
    int? id;
    String? name;
    String? email;
    String? phone;
    String? unitNumber;
    String? role;
    String? status;
    String? complex;
    String? createdAt;

    Resident({
        this.id,
        this.name,
        this.email,
        this.phone,
        this.unitNumber,
        this.role,
        this.status,
        this.complex,
        this.createdAt,
    });

    factory Resident.fromJson(Map<String, dynamic> json) => Resident(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        unitNumber: json["unit_number"],
        role: json["role"],
        status: json["status"],
        complex: json["complex"],
        createdAt: json["created_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "unit_number": unitNumber,
        "role": role,
        "status": status,
        "complex": complex,
        "created_at": createdAt,
    };
}
