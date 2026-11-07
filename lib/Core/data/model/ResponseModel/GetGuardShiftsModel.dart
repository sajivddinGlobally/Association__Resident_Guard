// To parse this JSON data, do
//
//     final getGuardShiftsModel = getGuardShiftsModelFromJson(jsonString);

import 'dart:convert';

GetGuardShiftsModel getGuardShiftsModelFromJson(String str) => GetGuardShiftsModel.fromJson(json.decode(str));

String getGuardShiftsModelToJson(GetGuardShiftsModel data) => json.encode(data.toJson());

class GetGuardShiftsModel {
    bool? status;
    String? message;
    List<Shift>? shifts;

    GetGuardShiftsModel({
        this.status,
        this.message,
        this.shifts,
    });

    factory GetGuardShiftsModel.fromJson(Map<String, dynamic> json) => GetGuardShiftsModel(
        status: json["status"],
        message: json["message"],
        shifts: json["shifts"] == null ? [] : List<Shift>.from(json["shifts"]!.map((x) => Shift.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "shifts": shifts == null ? [] : List<dynamic>.from(shifts!.map((x) => x.toJson())),
    };
}

class Shift {
    int? id;
    String? name;
    String? startTime;
    String? endTime;
    String? timings;
    bool? isActive;

    Shift({
        this.id,
        this.name,
        this.startTime,
        this.endTime,
        this.timings,
        this.isActive,
    });

    factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        id: json["id"],
        name: json["name"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        timings: json["timings"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "start_time": startTime,
        "end_time": endTime,
        "timings": timings,
        "is_active": isActive,
    };
}
