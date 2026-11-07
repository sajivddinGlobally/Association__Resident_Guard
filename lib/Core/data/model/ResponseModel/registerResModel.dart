// To parse this JSON data, do
//
//     final registerResModel = registerResModelFromJson(jsonString);

import 'dart:convert';

RegisterResModel registerResModelFromJson(String str) => RegisterResModel.fromJson(json.decode(str));

String registerResModelToJson(RegisterResModel data) => json.encode(data.toJson());

class RegisterResModel {
    bool? status;
    String? message;
    Data? data;

    RegisterResModel({
        this.status,
        this.message,
        this.data,
    });

    factory RegisterResModel.fromJson(Map<String, dynamic> json) => RegisterResModel(
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
    User? user;
    String? token;
    String? tokenType;
    Complex? complex;

    Data({
        this.user,
        this.token,
        this.tokenType,
        this.complex,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        token: json["token"],
        tokenType: json["token_type"],
        complex: json["complex"] == null ? null : Complex.fromJson(json["complex"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "token": token,
        "token_type": tokenType,
        "complex": complex?.toJson(),
    };
}

class Complex {
    int? id;
    String? name;
    String? address;
    int? totalUnits;
    int? associationHeadId;
    dynamic caretakerId;
    List<String>? facilities;
    DateTime? createdAt;
    DateTime? updatedAt;

    Complex({
        this.id,
        this.name,
        this.address,
        this.totalUnits,
        this.associationHeadId,
        this.caretakerId,
        this.facilities,
        this.createdAt,
        this.updatedAt,
    });

    factory Complex.fromJson(Map<String, dynamic> json) => Complex(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        totalUnits: json["total_units"],
        associationHeadId: json["association_head_id"],
        caretakerId: json["caretaker_id"],
        facilities: json["facilities"] == null ? [] : List<String>.from(json["facilities"]!.map((x) => x)),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "total_units": totalUnits,
        "association_head_id": associationHeadId,
        "caretaker_id": caretakerId,
        "facilities": facilities == null ? [] : List<dynamic>.from(facilities!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class User {
    String? name;
    String? email;
    String? phone;
    String? role;
    String? status;
    DateTime? updatedAt;
    DateTime? createdAt;
    int? id;
    dynamic unitNumber;

    User({
        this.name,
        this.email,
        this.phone,
        this.role,
        this.status,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.unitNumber,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        role: json["role"],
        status: json["status"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
        unitNumber: json["unit_number"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "role": role,
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "unit_number": unitNumber,
    };
}
