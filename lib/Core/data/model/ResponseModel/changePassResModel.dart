// To parse this JSON data, do
//
//     final changePasswordResModel = changePasswordResModelFromJson(jsonString);

import 'dart:convert';

ChangePasswordResModel changePasswordResModelFromJson(String str) =>
    ChangePasswordResModel.fromJson(json.decode(str));

String changePasswordResModelToJson(ChangePasswordResModel data) =>
    json.encode(data.toJson());

class ChangePasswordResModel {
  bool? status;
  String? message;

  ChangePasswordResModel({this.status, this.message});

  factory ChangePasswordResModel.fromJson(Map<String, dynamic> json) =>
      ChangePasswordResModel(status: json["status"], message: json["message"]);

  Map<String, dynamic> toJson() => {"status": status, "message": message};
}
