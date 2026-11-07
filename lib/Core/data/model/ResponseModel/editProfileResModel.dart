// To parse this JSON data, do
//
//     final editProfileResModel = editProfileResModelFromJson(jsonString);

import 'dart:convert';

EditProfileResModel editProfileResModelFromJson(String str) => EditProfileResModel.fromJson(json.decode(str));

String editProfileResModelToJson(EditProfileResModel data) => json.encode(data.toJson());

class EditProfileResModel {
    bool? status;
    String? message;
    Data? data;

    EditProfileResModel({
        this.status,
        this.message,
        this.data,
    });

    factory EditProfileResModel.fromJson(Map<String, dynamic> json) => EditProfileResModel(
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
    String? name;
    String? email;
    String? role;
    String? phone;
    dynamic avatar;
    String? status;
    String? subscriptionStatus;
    dynamic fcmToken;
    dynamic emailVerifiedAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic unitId;

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
    };
}
