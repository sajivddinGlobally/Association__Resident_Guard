// To parse this JSON data, do
//
//     final guardProfileModel = guardProfileModelFromJson(jsonString);

import 'dart:convert';

GuardProfileModel guardProfileModelFromJson(String str) => GuardProfileModel.fromJson(json.decode(str));

String guardProfileModelToJson(GuardProfileModel data) => json.encode(data.toJson());

class GuardProfileModel {
    bool? status;
    String? message;
    Data? data;

    GuardProfileModel({
        this.status,
        this.message,
        this.data,
    });

    factory GuardProfileModel.fromJson(Map<String, dynamic> json) => GuardProfileModel(
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
    String? name;
    String? role;
    String? guardPost;
    String? complexName;
    int? shiftId;
    String? shiftName;
    String? shiftTimings;
    bool? isOnDuty;
    String? avatarUrl;

    Data({
        this.name,
        this.role,
        this.guardPost,
        this.complexName,
        this.shiftId,
        this.shiftName,
        this.shiftTimings,
        this.isOnDuty,
        this.avatarUrl,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        role: json["role"],
        guardPost: json["guard_post"],
        complexName: json["complex_name"],
        shiftId: json["shift_id"],
        shiftName: json["shift_name"],
        shiftTimings: json["shift_timings"],
        isOnDuty: json["is_on_duty"],
        avatarUrl: json["avatar_url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "role": role,
        "guard_post": guardPost,
        "complex_name": complexName,
        "shift_id": shiftId,
        "shift_name": shiftName,
        "shift_timings": shiftTimings,
        "is_on_duty": isOnDuty,
        "avatar_url": avatarUrl,
    };
}
