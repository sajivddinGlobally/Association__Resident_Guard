// To parse this JSON data, do
//
//     final markOutResModel = markOutResModelFromJson(jsonString);

import 'dart:convert';

MarkOutResModel markOutResModelFromJson(String str) => MarkOutResModel.fromJson(json.decode(str));

String markOutResModelToJson(MarkOutResModel data) => json.encode(data.toJson());

class MarkOutResModel {
    bool? status;
    String? message;
    Data? data;

    MarkOutResModel({
        this.status,
        this.message,
        this.data,
    });

    factory MarkOutResModel.fromJson(Map<String, dynamic> json) => MarkOutResModel(
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
    String? recordId;
    String? modalTitle;
    String? modalSubtitle;
    String? visitorName;
    String? apartment;
    String? inTime;
    String? outTime;
    String? status;
    String? statusBadge;
    String? buttonLabel;

    Data({
        this.id,
        this.recordId,
        this.modalTitle,
        this.modalSubtitle,
        this.visitorName,
        this.apartment,
        this.inTime,
        this.outTime,
        this.status,
        this.statusBadge,
        this.buttonLabel,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        recordId: json["record_id"],
        modalTitle: json["modal_title"],
        modalSubtitle: json["modal_subtitle"],
        visitorName: json["visitor_name"],
        apartment: json["apartment"],
        inTime: json["in_time"],
        outTime: json["out_time"],
        status: json["status"],
        statusBadge: json["status_badge"],
        buttonLabel: json["button_label"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "record_id": recordId,
        "modal_title": modalTitle,
        "modal_subtitle": modalSubtitle,
        "visitor_name": visitorName,
        "apartment": apartment,
        "in_time": inTime,
        "out_time": outTime,
        "status": status,
        "status_badge": statusBadge,
        "button_label": buttonLabel,
    };
}
