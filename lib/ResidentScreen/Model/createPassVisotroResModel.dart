// To parse this JSON data, do
//
//     final creatVisitorPassResModdel = creatVisitorPassResModdelFromJson(jsonString);

import 'dart:convert';

CreatVisitorPassResModdel creatVisitorPassResModdelFromJson(String str) => CreatVisitorPassResModdel.fromJson(json.decode(str));

String creatVisitorPassResModdelToJson(CreatVisitorPassResModdel data) => json.encode(data.toJson());

class CreatVisitorPassResModdel {
    bool? status;
    String? message;
    Data? data;

    CreatVisitorPassResModdel({
        this.status,
        this.message,
        this.data,
    });

    factory CreatVisitorPassResModdel.fromJson(Map<String, dynamic> json) => CreatVisitorPassResModdel(
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
    String? token;
    String? title;
    String? visitorName;
    String? subtitle;
    String? status;
    String? statusColor;
    String? visitorType;
    String? purpose;
    String? arrivalTime;
    RawPass? rawPass;

    Data({
        this.id,
        this.token,
        this.title,
        this.visitorName,
        this.subtitle,
        this.status,
        this.statusColor,
        this.visitorType,
        this.purpose,
        this.arrivalTime,
        this.rawPass,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        token: json["token"],
        title: json["title"],
        visitorName: json["visitor_name"],
        subtitle: json["subtitle"],
        status: json["status"],
        statusColor: json["status_color"],
        visitorType: json["visitor_type"],
        purpose: json["purpose"],
        arrivalTime: json["arrival_time"],
        rawPass: json["raw_pass"] == null ? null : RawPass.fromJson(json["raw_pass"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "title": title,
        "visitor_name": visitorName,
        "subtitle": subtitle,
        "status": status,
        "status_color": statusColor,
        "visitor_type": visitorType,
        "purpose": purpose,
        "arrival_time": arrivalTime,
        "raw_pass": rawPass?.toJson(),
    };
}

class RawPass {
    int? residentId;
    int? propertyId;
    String? passCode;
    String? visitorName;
    String? visitorType;
    String? visitorPhone;
    String? purpose;
    DateTime? expectedArrival;
    String? status;
    DateTime? updatedAt;
    DateTime? createdAt;
    int? id;

    RawPass({
        this.residentId,
        this.propertyId,
        this.passCode,
        this.visitorName,
        this.visitorType,
        this.visitorPhone,
        this.purpose,
        this.expectedArrival,
        this.status,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory RawPass.fromJson(Map<String, dynamic> json) => RawPass(
        residentId: json["resident_id"],
        propertyId: json["property_id"],
        passCode: json["pass_code"],
        visitorName: json["visitor_name"],
        visitorType: json["visitor_type"],
        visitorPhone: json["visitor_phone"],
        purpose: json["purpose"],
        expectedArrival: json["expected_arrival"] == null ? null : DateTime.parse(json["expected_arrival"]),
        status: json["status"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "resident_id": residentId,
        "property_id": propertyId,
        "pass_code": passCode,
        "visitor_name": visitorName,
        "visitor_type": visitorType,
        "visitor_phone": visitorPhone,
        "purpose": purpose,
        "expected_arrival": expectedArrival?.toIso8601String(),
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
