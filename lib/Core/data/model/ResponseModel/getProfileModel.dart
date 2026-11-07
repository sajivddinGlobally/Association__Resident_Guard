// To parse this JSON data, do
//
//     final getProfileModel = getProfileModelFromJson(jsonString);

import 'dart:convert';

GetProfileModel getProfileModelFromJson(String str) => GetProfileModel.fromJson(json.decode(str));

String getProfileModelToJson(GetProfileModel data) => json.encode(data.toJson());

class GetProfileModel {
    bool? status;
    Data? data;

    GetProfileModel({
        this.status,
        this.data,
    });

    factory GetProfileModel.fromJson(Map<String, dynamic> json) => GetProfileModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? name;
    String? email;
    String? role;
    String? phone;
    String? avatar;
    String? status;
    String? subscriptionStatus;
    dynamic fcmToken;
    dynamic emailVerifiedAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic unitId;
    String? avatarUrl;
    ActiveComplex? activeComplex;

    Data({
        this.id,
        this.name,
        this.email,
        this.role,
        this.phone,
        this.avatar,
        this.status,
        this.subscriptionStatus,
        this.fcmToken,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.unitId,
        this.avatarUrl,
        this.activeComplex,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        phone: json["phone"],
        avatar: json["avatar"],
        status: json["status"],
        subscriptionStatus: json["subscription_status"],
        fcmToken: json["fcm_token"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        unitId: json["unit_id"],
        avatarUrl: json["avatar_url"],
        activeComplex: json["active_complex"] == null ? null : ActiveComplex.fromJson(json["active_complex"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "phone": phone,
        "avatar": avatar,
        "status": status,
        "subscription_status": subscriptionStatus,
        "fcm_token": fcmToken,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "unit_id": unitId,
        "avatar_url": avatarUrl,
        "active_complex": activeComplex?.toJson(),
    };
}

class ActiveComplex {
    int? id;
    String? name;
    String? address;
    int? totalUnits;
    int? totalBlocks;
    List<String>? facilities;

    ActiveComplex({
        this.id,
        this.name,
        this.address,
        this.totalUnits,
        this.facilities,
        this.totalBlocks
    });

    factory ActiveComplex.fromJson(Map<String, dynamic> json) => ActiveComplex(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        totalUnits: json["total_units"],
        totalBlocks: json["total_blocks"],
        facilities: json["facilities"] == null ? [] : List<String>.from(json["facilities"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "total_units": totalUnits,
        "total_blocks": totalBlocks,
        "facilities": facilities == null ? [] : List<dynamic>.from(facilities!.map((x) => x)),
    };
}
