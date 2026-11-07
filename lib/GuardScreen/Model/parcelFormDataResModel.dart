import 'dart:convert';

ParcelFormDataResModel parcelFormDataResModelFromJson(String str) =>
    ParcelFormDataResModel.fromJson(json.decode(str));

String parcelFormDataResModelToJson(ParcelFormDataResModel data) =>
    json.encode(data.toJson());

class ParcelFormDataResModel {
  bool? status;
  String? message;
  ParcelFormData? data;

  ParcelFormDataResModel({
    this.status,
    this.message,
    this.data,
  });

  factory ParcelFormDataResModel.fromJson(Map<String, dynamic> json) =>
      ParcelFormDataResModel(
        status: json["status"] is bool
            ? json["status"]
            : (json["status"] == 1 || json["status"] == "true"),
        message: json["message"]?.toString(),
        data: json["data"] != null ? ParcelFormData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ParcelFormData {
  List<dynamic>? flats;
  List<String>? parcelTypes;
  List<String>? handlingTypes;
  List<String>? deliveryCompanies;

  ParcelFormData({
    this.flats,
    this.parcelTypes,
    this.handlingTypes,
    this.deliveryCompanies,
  });

  factory ParcelFormData.fromJson(Map<String, dynamic> json) =>
      ParcelFormData(
        flats: json["flats"] ?? json["properties"],
        parcelTypes: json["parcel_types"] != null
            ? List<String>.from(json["parcel_types"].map((x) => x.toString()))
            : null,
        handlingTypes: json["handling_types"] != null
            ? List<String>.from(json["handling_types"].map((x) => x.toString()))
            : null,
        deliveryCompanies: json["delivery_companies"] != null
            ? List<String>.from(json["delivery_companies"].map((x) => x.toString()))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "flats": flats,
        "parcel_types": parcelTypes,
        "handling_types": handlingTypes,
        "delivery_companies": deliveryCompanies,
      };
}
