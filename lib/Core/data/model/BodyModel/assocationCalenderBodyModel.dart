// To parse this JSON data, do
//
//     final associationCalenderBodyModel = associationCalenderBodyModelFromJson(jsonString);

import 'dart:convert';

AssociationCalenderBodyModel associationCalenderBodyModelFromJson(String str) => AssociationCalenderBodyModel.fromJson(json.decode(str));

String associationCalenderBodyModelToJson(AssociationCalenderBodyModel data) => json.encode(data.toJson());

class AssociationCalenderBodyModel {
    String? eventName;
    String? eventType;
    DateTime? visitDate;
    String? visitTime;
    String? endTime;
    String? organizedBy;
    String? eventFor;
    String? description;
    String? location;

    AssociationCalenderBodyModel({
        this.eventName,
        this.eventType,
        this.visitDate,
        this.visitTime,
        this.endTime,
        this.organizedBy,
        this.eventFor,
        this.description,
        this.location,
    });

    factory AssociationCalenderBodyModel.fromJson(Map<String, dynamic> json) => AssociationCalenderBodyModel(
        eventName: json["event_name"],
        eventType: json["event_type"],
        visitDate: json["visit_date"] == null ? null : DateTime.parse(json["visit_date"]),
        visitTime: json["visit_time"],
        endTime: json["end_time"],
        organizedBy: json["organized_by"],
        eventFor: json["event_for"],
        description: json["description"],
        location: json["location"],
    );

    Map<String, dynamic> toJson() => {
        "event_name": eventName,
        "event_type": eventType,
        "visit_date": visitDate == null ? null : "${visitDate!.year.toString().padLeft(4, '0')}-${visitDate!.month.toString().padLeft(2, '0')}-${visitDate!.day.toString().padLeft(2, '0')}",
        "visit_time": visitTime,
        "end_time": endTime,
        "organized_by": organizedBy,
        "event_for": eventFor,
        "description": description,
        "location": location,
    };
}
