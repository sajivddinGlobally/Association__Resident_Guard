// To parse this JSON data, do
//
//     final parcelHandoverResModel = parcelHandoverResModelFromJson(jsonString);

import 'dart:convert';

ParcelHandoverResModel parcelHandoverResModelFromJson(String str) =>
    ParcelHandoverResModel.fromJson(json.decode(str));

String parcelHandoverResModelToJson(ParcelHandoverResModel data) =>
    json.encode(data.toJson());

class ParcelHandoverResModel {
  bool? status;
  String? message;
  dynamic data;

  ParcelHandoverResModel({
    this.status,
    this.message,
    this.data,
  });

  factory ParcelHandoverResModel.fromJson(Map<String, dynamic> json) =>
      ParcelHandoverResModel(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };
}
