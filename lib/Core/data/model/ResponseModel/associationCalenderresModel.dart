// To parse this JSON data, do
//
//     final associationCalenderResModel = associationCalenderResModelFromJson(jsonString);

import 'dart:convert';

AssociationCalenderResModel associationCalenderResModelFromJson(String str) => AssociationCalenderResModel.fromJson(json.decode(str));

String associationCalenderResModelToJson(AssociationCalenderResModel data) => json.encode(data.toJson());

class AssociationCalenderResModel {
    bool? status;
    String? message;
    Data? data;

    AssociationCalenderResModel({
        this.status,
        this.message,
        this.data,
    });

    factory AssociationCalenderResModel.fromJson(Map<String, dynamic> json) => AssociationCalenderResModel(
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
    String? eventTitle;
    String? eventType;
    String? eventTypeLabel;
    DateTime? eventDate;
    String? eventDateFormatted;
    String? eventTime;
    String? endTime;
    String? timeRange;
    String? eventFor;
    String? eventForLabel;
    String? organizedBy;
    String? location;
    String? description;
    String? status;
    String? createdAt;

    Data({
        this.id,
        this.eventTitle,
        this.eventType,
        this.eventTypeLabel,
        this.eventDate,
        this.eventDateFormatted,
        this.eventTime,
        this.endTime,
        this.timeRange,
        this.eventFor,
        this.eventForLabel,
        this.organizedBy,
        this.location,
        this.description,
        this.status,
        this.createdAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        eventTitle: json["event_title"],
        eventType: json["event_type"],
        eventTypeLabel: json["event_type_label"],
        eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
        eventDateFormatted: json["event_date_formatted"],
        eventTime: json["event_time"],
        endTime: json["end_time"],
        timeRange: json["time_range"],
        eventFor: json["event_for"],
        eventForLabel: json["event_for_label"],
        organizedBy: json["organized_by"],
        location: json["location"],
        description: json["description"],
        status: json["status"],
        createdAt: json["created_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "event_title": eventTitle,
        "event_type": eventType,
        "event_type_label": eventTypeLabel,
        "event_date": eventDate == null ? null : "${eventDate!.year.toString().padLeft(4, '0')}-${eventDate!.month.toString().padLeft(2, '0')}-${eventDate!.day.toString().padLeft(2, '0')}",
        "event_date_formatted": eventDateFormatted,
        "event_time": eventTime,
        "end_time": endTime,
        "time_range": timeRange,
        "event_for": eventFor,
        "event_for_label": eventForLabel,
        "organized_by": organizedBy,
        "location": location,
        "description": description,
        "status": status,
        "created_at": createdAt,
    };
}
