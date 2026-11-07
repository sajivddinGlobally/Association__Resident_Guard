import 'dart:convert';

ResidentVisitorRespondResModel residentVisitorRespondResModelFromJson(
  String str,
) =>
    ResidentVisitorRespondResModel.fromJson(json.decode(str));

String residentVisitorRespondResModelToJson(
  ResidentVisitorRespondResModel data,
) =>
    json.encode(data.toJson());

class ResidentVisitorRespondResModel {
  bool? status;
  String? message;
  dynamic data;

  ResidentVisitorRespondResModel({
    this.status,
    this.message,
    this.data,
  });

  factory ResidentVisitorRespondResModel.fromJson(Map<String, dynamic> json) =>
      ResidentVisitorRespondResModel(
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
