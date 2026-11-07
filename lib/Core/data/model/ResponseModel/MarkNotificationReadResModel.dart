// To parse this JSON data, do
//
//     final markNotificationReadResModel = markNotificationReadResModelFromJson(jsonString);

import 'dart:convert';

MarkNotificationReadResModel markNotificationReadResModelFromJson(String str) =>
    MarkNotificationReadResModel.fromJson(json.decode(str));

String markNotificationReadResModelToJson(MarkNotificationReadResModel data) =>
    json.encode(data.toJson());

class MarkNotificationReadResModel {
  final bool? status;
  final String? message;

  MarkNotificationReadResModel({
    this.status,
    this.message,
  });

  factory MarkNotificationReadResModel.fromJson(Map<String, dynamic> json) =>
      MarkNotificationReadResModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
