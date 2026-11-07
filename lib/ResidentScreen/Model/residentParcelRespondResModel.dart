// To parse this JSON data, do
//
//     final residentParcelRespondResModel = residentParcelRespondResModelFromJson(jsonString);

import 'dart:convert';

ResidentParcelRespondResModel residentParcelRespondResModelFromJson(
  String str,
) => ResidentParcelRespondResModel.fromJson(json.decode(str));

String residentParcelRespondResModelToJson(
  ResidentParcelRespondResModel data,
) => json.encode(data.toJson());

class ResidentParcelRespondResModel {
  bool? status;
  String? message;
  dynamic data;

  ResidentParcelRespondResModel({
    this.status,
    this.message,
    this.data,
  });

  factory ResidentParcelRespondResModel.fromJson(Map<String, dynamic> json) =>
      ResidentParcelRespondResModel(
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
