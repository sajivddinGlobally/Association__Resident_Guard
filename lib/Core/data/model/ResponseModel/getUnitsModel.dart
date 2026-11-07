// To parse this JSON data, do
//
//     final getUnitsModel = getUnitsModelFromJson(jsonString);

import 'dart:convert';

GetUnitsModel getUnitsModelFromJson(String str) => GetUnitsModel.fromJson(json.decode(str));

String getUnitsModelToJson(GetUnitsModel data) => json.encode(data.toJson());

class GetUnitsModel {
    bool? status;
    String? message;
    Data? data;

    GetUnitsModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetUnitsModel.fromJson(Map<String, dynamic> json) => GetUnitsModel(
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
    Complex? complex;
    int? totalAvailable;
    int? totalUnits;
    int? vacantUnits;
    int? occupiedUnits;
    List<AvailableUnit>? availableUnits;

    Data({
        this.complex,
        this.totalAvailable,
        this.totalUnits,
        this.vacantUnits,
        this.occupiedUnits,
        this.availableUnits,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        complex: json["complex"] == null ? null : Complex.fromJson(json["complex"]),
        totalAvailable: json["total_available"],
        totalUnits: json["total_units"],
        vacantUnits: json["vacant_units"],
        occupiedUnits: json["occupied_units"],
        availableUnits: json["available_units"] == null ? [] : List<AvailableUnit>.from(json["available_units"]!.map((x) => AvailableUnit.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "complex": complex?.toJson(),
        "total_available": totalAvailable,
        "total_units": totalUnits,
        "vacant_units": vacantUnits,
        "occupied_units": occupiedUnits,
        "available_units": availableUnits == null ? [] : List<dynamic>.from(availableUnits!.map((x) => x.toJson())),
    };
}

class AvailableUnit {
    int? id;
    int? propertyId;
    int? unitId;
    String? unitNumber;
    String? propertyName;
    String? ownerName;
    String? residentName;
    String? residentType;
    bool? isVacant;
    bool? isOccupied;
    bool? isSelectable;
    String? occupancyStatus;
    String? floor;
    String? area;
    String? label;

    AvailableUnit({
        this.id,
        this.propertyId,
        this.unitId,
        this.unitNumber,
        this.propertyName,
        this.ownerName,
        this.residentName,
        this.residentType,
        this.isVacant,
        this.isOccupied,
        this.isSelectable,
        this.occupancyStatus,
        this.floor,
        this.area,
        this.label,
    });

    factory AvailableUnit.fromJson(Map<String, dynamic> json) => AvailableUnit(
        id: json["id"],
        propertyId: json["property_id"],
        unitId: json["unit_id"],
        unitNumber: json["unit_number"],
        propertyName: json["property_name"],
        ownerName: json["owner_name"],
        residentName: json["resident_name"],
        residentType: json["resident_type"],
        isVacant: json["is_vacant"],
        isOccupied: json["is_occupied"],
        isSelectable: json["is_selectable"],
        occupancyStatus: json["occupancy_status"],
        floor: json["floor"],
        area: json["area"],
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "property_id": propertyId,
        "unit_id": unitId,
        "unit_number": unitNumber,
        "property_name": propertyName,
        "owner_name": ownerName,
        "resident_name": residentName,
        "resident_type": residentType,
        "is_vacant": isVacant,
        "is_occupied": isOccupied,
        "is_selectable": isSelectable,
        "occupancy_status": occupancyStatus,
        "floor": floor,
        "area": area,
        "label": label,
    };
}

class Complex {
    int? id;
    String? name;

    Complex({
        this.id,
        this.name,
    });

    factory Complex.fromJson(Map<String, dynamic> json) => Complex(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
