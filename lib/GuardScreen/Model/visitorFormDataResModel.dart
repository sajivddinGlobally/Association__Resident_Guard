import 'dart:convert';

VisitorFormDataResModel visitorFormDataResModelFromJson(String str) =>
    VisitorFormDataResModel.fromJson(json.decode(str));

String visitorFormDataResModelToJson(VisitorFormDataResModel data) =>
    json.encode(data.toJson());

class VisitorFormDataResModel {
  bool? status;
  String? message;
  VisitorFormData? data;

  VisitorFormDataResModel({
    this.status,
    this.message,
    this.data,
  });

  factory VisitorFormDataResModel.fromJson(Map<String, dynamic> json) =>
      VisitorFormDataResModel(
        status: json["status"] is bool
            ? json["status"]
            : (json["status"] == 1 || json["status"] == "true"),
        message: json["message"]?.toString(),
        data: json["data"] != null ? VisitorFormData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class VisitorFormData {
  List<dynamic>? flats;
  List<String>? visitTypes;
  List<String>? frequentRoles;

  VisitorFormData({
    this.flats,
    this.visitTypes,
    this.frequentRoles,
  });

  factory VisitorFormData.fromJson(Map<String, dynamic> json) =>
      VisitorFormData(
        flats: json["flats"] ?? json["properties"],
        visitTypes: json["visit_types"] != null
            ? List<String>.from(json["visit_types"].map((x) => x.toString()))
            : null,
        frequentRoles: json["frequent_roles"] != null
            ? List<String>.from(json["frequent_roles"].map((x) => x.toString()))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "flats": flats,
        "visit_types": visitTypes,
        "frequent_roles": frequentRoles,
      };
}
