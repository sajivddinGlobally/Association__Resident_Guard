// To parse this JSON data, do
//
//     final getResidentParcelModel = getResidentParcelModelFromJson(jsonString);

import 'dart:convert';

GetResidentParcelModel getResidentParcelModelFromJson(String str) =>
    GetResidentParcelModel.fromJson(json.decode(str));

String getResidentParcelModelToJson(GetResidentParcelModel data) =>
    json.encode(data.toJson());

class GetResidentParcelModel {
  bool? status;
  String? message;
  List<ResidentParcelItem>? data;

  GetResidentParcelModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetResidentParcelModel.fromJson(Map<String, dynamic> json) =>
      GetResidentParcelModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ResidentParcelItem>.from(
                json["data"]!.map((x) => ResidentParcelItem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ResidentParcelItem {
  int? id;
  String? vendorName;
  String? parcelType;
  String? flatNumber;
  String? status;
  String? deliveryMode;
  String? pickupCode;
  String? qrCodeUrl;
  String? receivedAt;
  String? handoverAt;
  String? parcelPhoto;

  ResidentParcelItem({
    this.id,
    this.vendorName,
    this.parcelType,
    this.flatNumber,
    this.status,
    this.deliveryMode,
    this.pickupCode,
    this.qrCodeUrl,
    this.receivedAt,
    this.handoverAt,
    this.parcelPhoto,
  });

  factory ResidentParcelItem.fromJson(Map<String, dynamic> json) =>
      ResidentParcelItem(
        id: json["id"],
        vendorName: json["vendor_name"],
        parcelType: json["parcel_type"],
        flatNumber: json["flat_number"],
        status: json["status"],
        deliveryMode: json["delivery_mode"],
        pickupCode: json["pickup_code"],
        qrCodeUrl: json["qr_code_url"],
        receivedAt: json["received_at"],
        handoverAt: json["handover_at"],
        parcelPhoto: json["parcel_photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendor_name": vendorName,
        "parcel_type": parcelType,
        "flat_number": flatNumber,
        "status": status,
        "delivery_mode": deliveryMode,
        "pickup_code": pickupCode,
        "qr_code_url": qrCodeUrl,
        "received_at": receivedAt,
        "handover_at": handoverAt,
        "parcel_photo": parcelPhoto,
      };
}
