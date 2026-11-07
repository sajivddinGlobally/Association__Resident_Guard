// To parse this JSON data, do
//
//     final addParcelResModel = addParcelResModelFromJson(jsonString);

import 'dart:convert';

AddParcelResModel addParcelResModelFromJson(String str) => AddParcelResModel.fromJson(json.decode(str));

String addParcelResModelToJson(AddParcelResModel data) => json.encode(data.toJson());

class AddParcelResModel {
    bool? status;
    String? message;
    Data? data;

    AddParcelResModel({
        this.status,
        this.message,
        this.data,
    });

    factory AddParcelResModel.fromJson(Map<String, dynamic> json) => AddParcelResModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    int? residentId;
    String? residentName;
    String? residentPhone;
    int? propertyId;
    String? vendorName;
    String? parcelType;
    String? flatNumber;
    String? status;
    String? handlingType;
    String? deliveryMode;
    String? pickupCode;
    String? qrCodeUrl;
    String? receivedAt;
    String? parcelPhoto;

    Data({
        this.id,
        this.residentId,
        this.residentName,
        this.residentPhone,
        this.propertyId,
        this.vendorName,
        this.parcelType,
        this.flatNumber,
        this.status,
        this.handlingType,
        this.deliveryMode,
        this.pickupCode,
        this.qrCodeUrl,
        this.receivedAt,
        this.parcelPhoto,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        residentId: json["resident_id"],
        residentName: json["resident_name"],
        residentPhone: json["resident_phone"],
        propertyId: json["property_id"],
        vendorName: json["vendor_name"],
        parcelType: json["parcel_type"],
        flatNumber: json["flat_number"],
        status: json["status"],
        handlingType: json["handling_type"],
        deliveryMode: json["delivery_mode"],
        pickupCode: json["pickup_code"],
        qrCodeUrl: json["qr_code_url"],
        receivedAt: json["received_at"],
        parcelPhoto: json["parcel_photo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "resident_id": residentId,
        "resident_name": residentName,
        "resident_phone": residentPhone,
        "property_id": propertyId,
        "vendor_name": vendorName,
        "parcel_type": parcelType,
        "flat_number": flatNumber,
        "status": status,
        "handling_type": handlingType,
        "delivery_mode": deliveryMode,
        "pickup_code": pickupCode,
        "qr_code_url": qrCodeUrl,
        "received_at": receivedAt,
        "parcel_photo": parcelPhoto,
    };
}
