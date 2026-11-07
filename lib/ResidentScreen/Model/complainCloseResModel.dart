// To parse this JSON data, do
//
//     final complainCloseResModel = complainCloseResModelFromJson(jsonString);

import 'dart:convert';

ComplainCloseResModel complainCloseResModelFromJson(String str) => ComplainCloseResModel.fromJson(json.decode(str));

String complainCloseResModelToJson(ComplainCloseResModel data) => json.encode(data.toJson());

class ComplainCloseResModel {
    bool? status;
    String? message;
    Data? data;

    ComplainCloseResModel({
        this.status,
        this.message,
        this.data,
    });

    factory ComplainCloseResModel.fromJson(Map<String, dynamic> json) => ComplainCloseResModel(
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
    String? ticketNumber;
    String? status;
    String? residentStatus;
    dynamic rating;
    dynamic feedbackComments;
    String? updatedAt;

    Data({
        this.id,
        this.ticketNumber,
        this.status,
        this.residentStatus,
        this.rating,
        this.feedbackComments,
        this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        ticketNumber: json["ticket_number"],
        status: json["status"],
        residentStatus: json["resident_status"],
        rating: json["rating"],
        feedbackComments: json["feedback_comments"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "ticket_number": ticketNumber,
        "status": status,
        "resident_status": residentStatus,
        "rating": rating,
        "feedback_comments": feedbackComments,
        "updated_at": updatedAt,
    };
}
