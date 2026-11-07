// To parse this JSON data, do
//
//     final complainCloseBodyModel = complainCloseBodyModelFromJson(jsonString);

import 'dart:convert';

ComplainCloseBodyModel complainCloseBodyModelFromJson(String str) => ComplainCloseBodyModel.fromJson(json.decode(str));

String complainCloseBodyModelToJson(ComplainCloseBodyModel data) => json.encode(data.toJson());

class ComplainCloseBodyModel {
    String? status;
    String? residentStatus;

    ComplainCloseBodyModel({
        this.status,
        this.residentStatus,
    });

    factory ComplainCloseBodyModel.fromJson(Map<String, dynamic> json) => ComplainCloseBodyModel(
        status: json["status"],
        residentStatus: json["resident_status"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "resident_status": residentStatus,
    };
}
