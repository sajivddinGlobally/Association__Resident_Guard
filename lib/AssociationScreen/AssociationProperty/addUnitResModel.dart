// To parse this JSON data, do
//
//     final addUnitResModel = addUnitResModelFromJson(jsonString);

import 'dart:convert';

AddUnitResModel addUnitResModelFromJson(String str) => AddUnitResModel.fromJson(json.decode(str));

String addUnitResModelToJson(AddUnitResModel data) => json.encode(data.toJson());

class AddUnitResModel {
    bool? status;
    String? message;
    Data? data;

    AddUnitResModel({
        this.status,
        this.message,
        this.data,
    });

    factory AddUnitResModel.fromJson(Map<String, dynamic> json) => AddUnitResModel(
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
    Unit? unit;

    Data({
        this.unit,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
    );

    Map<String, dynamic> toJson() => {
        "unit": unit?.toJson(),
    };
}

class Unit {
    int? id;
    int? propertyId;
    int? unitId;
    String? unitNumber;
    String? location;
    String? floor;
    String? area;
    String? bedrooms;
    String? approvalStatus;
    String? approvalLabel;

    Unit({
        this.id,
        this.propertyId,
        this.unitId,
        this.unitNumber,
        this.location,
        this.floor,
        this.area,
        this.bedrooms,
        this.approvalStatus,
        this.approvalLabel,
    });

    factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["id"],
        propertyId: json["property_id"],
        unitId: json["unit_id"],
        unitNumber: json["unit_number"],
        location: json["location"],
        floor: json["floor"],
        area: json["area"],
        bedrooms: json["bedrooms"],
        approvalStatus: json["approval_status"],
        approvalLabel: json["approval_label"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "property_id": propertyId,
        "unit_id": unitId,
        "unit_number": unitNumber,
        "location": location,
        "floor": floor,
        "area": area,
        "bedrooms": bedrooms,
        "approval_status": approvalStatus,
        "approval_label": approvalLabel,
    };
}
