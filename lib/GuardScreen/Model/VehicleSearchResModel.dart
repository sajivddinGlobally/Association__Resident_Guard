// To parse this JSON data, do
//
//     final vehicleSearchResModel = vehicleSearchResModelFromJson(jsonString);

import 'dart:convert';

VehicleSearchResModel vehicleSearchResModelFromJson(String str) => VehicleSearchResModel.fromJson(json.decode(str));

String vehicleSearchResModelToJson(VehicleSearchResModel data) => json.encode(data.toJson());

class VehicleSearchResModel {
    bool? status;
    bool? isRegistered;
    String? message;
    Data? data;

    VehicleSearchResModel({
        this.status,
        this.isRegistered,
        this.message,
        this.data,
    });

    factory VehicleSearchResModel.fromJson(Map<String, dynamic> json) => VehicleSearchResModel(
        status: json["status"],
        isRegistered: json["is_registered"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "is_registered": isRegistered,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    String? vehicleNumber;
    String? flatNumber;
    String? registeredOwner;
    String? status;
    String? verifiedBadge;
    String? searchedAt;

    Data({
        this.vehicleNumber,
        this.flatNumber,
        this.registeredOwner,
        this.status,
        this.verifiedBadge,
        this.searchedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        vehicleNumber: json["vehicle_number"],
        flatNumber: json["flat_number"],
        registeredOwner: json["registered_owner"],
        status: json["status"],
        verifiedBadge: json["verified_badge"],
        searchedAt: json["searched_at"],
    );

    Map<String, dynamic> toJson() => {
        "vehicle_number": vehicleNumber,
        "flat_number": flatNumber,
        "registered_owner": registeredOwner,
        "status": status,
        "verified_badge": verifiedBadge,
        "searched_at": searchedAt,
    };
}
