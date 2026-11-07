// To parse this JSON data, do
//
//     final getPassListResModel = getPassListResModelFromJson(jsonString);

import 'dart:convert';

GetPassListResModel getPassListResModelFromJson(String str) => GetPassListResModel.fromJson(json.decode(str));

String getPassListResModelToJson(GetPassListResModel data) => json.encode(data.toJson());

class GetPassListResModel {
    bool? status;
    String? message;
    Data? data;

    GetPassListResModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetPassListResModel.fromJson(Map<String, dynamic> json) => GetPassListResModel(
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
    int? total;
    List<VisitorPass>? visitorPasses;

    Data({
        this.total,
        this.visitorPasses,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        visitorPasses: json["visitor_passes"] == null ? [] : List<VisitorPass>.from(json["visitor_passes"]!.map((x) => VisitorPass.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "visitor_passes": visitorPasses == null ? [] : List<dynamic>.from(visitorPasses!.map((x) => x.toJson())),
    };
}

class VisitorPass {
    int? id;
    String? passCode;
    dynamic guardId;
    String? guardName;
    String? guardPost;
    String? createdBy;
    int? residentId;
    String? residentName;
    String? residentPhone;
    String? flatNumber;
    String? unitNumber;
    String? visitorName;
    String? visitorPhone;
    String? visitorType;
    String? purpose;
    String? vehicleNumber;
    String? expectedArrival;
    String? status;
    dynamic inTime;
    dynamic outTime;
    String? createdAt;

    VisitorPass({
        this.id,
        this.passCode,
        this.guardId,
        this.guardName,
        this.guardPost,
        this.createdBy,
        this.residentId,
        this.residentName,
        this.residentPhone,
        this.flatNumber,
        this.unitNumber,
        this.visitorName,
        this.visitorPhone,
        this.visitorType,
        this.purpose,
        this.vehicleNumber,
        this.expectedArrival,
        this.status,
        this.inTime,
        this.outTime,
        this.createdAt,
    });

    factory VisitorPass.fromJson(Map<String, dynamic> json) => VisitorPass(
        id: json["id"],
        passCode: json["pass_code"],
        guardId: json["guard_id"],
        guardName: json["guard_name"],
        guardPost: json["guard_post"],
        createdBy: json["created_by"],
        residentId: json["resident_id"],
        residentName: json["resident_name"],
        residentPhone: json["resident_phone"],
        flatNumber: json["flat_number"],
        unitNumber: json["unit_number"],
        visitorName: json["visitor_name"],
        visitorPhone: json["visitor_phone"],
        visitorType: json["visitor_type"],
        purpose: json["purpose"],
        vehicleNumber: json["vehicle_number"],
        expectedArrival: json["expected_arrival"],
        status: json["status"],
        inTime: json["in_time"],
        outTime: json["out_time"],
        createdAt: json["created_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "pass_code": passCode,
        "guard_id": guardId,
        "guard_name": guardName,
        "guard_post": guardPost,
        "created_by": createdBy,
        "resident_id": residentId,
        "resident_name": residentName,
        "resident_phone": residentPhone,
        "flat_number": flatNumber,
        "unit_number": unitNumber,
        "visitor_name": visitorName,
        "visitor_phone": visitorPhone,
        "visitor_type": visitorType,
        "purpose": purpose,
        "vehicle_number": vehicleNumber,
        "expected_arrival": expectedArrival,
        "status": status,
        "in_time": inTime,
        "out_time": outTime,
        "created_at": createdAt,
    };
}
