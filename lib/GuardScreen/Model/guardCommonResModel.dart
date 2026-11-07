import 'dart:convert';

GuardCommonResModel guardCommonResModelFromJson(String str) =>
    GuardCommonResModel.fromJson(json.decode(str));

String guardCommonResModelToJson(GuardCommonResModel data) =>
    json.encode(data.toJson());

class GuardCommonResModel {
  bool? status;
  String? message;
  dynamic data;

  GuardCommonResModel({
    this.status,
    this.message,
    this.data,
  });

  factory GuardCommonResModel.fromJson(Map<String, dynamic> json) =>
      GuardCommonResModel(
        status: json["status"] is bool
            ? json["status"]
            : (json["status"] == 1 || json["status"] == "true"),
        message: json["message"]?.toString(),
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };
}
