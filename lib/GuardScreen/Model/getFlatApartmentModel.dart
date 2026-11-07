// To parse this JSON data, do
//
//     final getFlatApartmentModel = getFlatApartmentModelFromJson(jsonString);

import 'dart:convert';

GetFlatApartmentModel getFlatApartmentModelFromJson(String str) => GetFlatApartmentModel.fromJson(json.decode(str));

String getFlatApartmentModelToJson(GetFlatApartmentModel data) => json.encode(data.toJson());

class GetFlatApartmentModel {
    bool? status;
    String? message;
    Complex? complex;
    int? total;
    List<Datum>? data;
    List<Datum>? properties;

    GetFlatApartmentModel({
        this.status,
        this.message,
        this.complex,
        this.total,
        this.data,
        this.properties,
    });

    factory GetFlatApartmentModel.fromJson(Map<String, dynamic> json) => GetFlatApartmentModel(
        status: json["status"],
        message: json["message"],
        complex: json["complex"] == null ? null : Complex.fromJson(json["complex"]),
        total: json["total"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        properties: json["properties"] == null ? [] : List<Datum>.from(json["properties"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "complex": complex?.toJson(),
        "total": total,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "properties": properties == null ? [] : List<dynamic>.from(properties!.map((x) => x.toJson())),
    };
}

class Complex {
    int? id;
    String? name;
    String? address;
    int? totalFlats;
    int? occupiedCount;
    int? vacantCount;

    Complex({
        this.id,
        this.name,
        this.address,
        this.totalFlats,
        this.occupiedCount,
        this.vacantCount,
    });

    factory Complex.fromJson(Map<String, dynamic> json) => Complex(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        totalFlats: json["total_flats"],
        occupiedCount: json["occupied_count"],
        vacantCount: json["vacant_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "total_flats": totalFlats,
        "occupied_count": occupiedCount,
        "vacant_count": vacantCount,
    };
}

class Datum {
    int? id;
    int? propertyId;
    String? flatNumber;
    String? propertyNameNumber;
    PropertyType? propertyType;
    String? location;
    Status? status;
    StatusBadge? statusBadge;
    StatusColor? statusColor;
    String? residentName;
    String? residentPhone;
    Owner? owner;
    dynamic tenant;

    Datum({
        this.id,
        this.propertyId,
        this.flatNumber,
        this.propertyNameNumber,
        this.propertyType,
        this.location,
        this.status,
        this.statusBadge,
        this.statusColor,
        this.residentName,
        this.residentPhone,
        this.owner,
        this.tenant,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        propertyId: json["property_id"],
        flatNumber: json["flat_number"],
        propertyNameNumber: json["property_name_number"],
        propertyType: propertyTypeValues.map[json["property_type"]],
        location: json["location"],
        status: statusValues.map[json["status"]],
        statusBadge: statusBadgeValues.map[json["status_badge"]],
        statusColor: statusColorValues.map[json["status_color"]],
        residentName: json["resident_name"],
        residentPhone: json["resident_phone"],
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
        tenant: json["tenant"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "property_id": propertyId,
        "flat_number": flatNumber,
        "property_name_number": propertyNameNumber,
        "property_type": propertyTypeValues.reverse[propertyType],
        "location": location,
        "status": statusValues.reverse[status],
        "status_badge": statusBadgeValues.reverse[statusBadge],
        "status_color": statusColorValues.reverse[statusColor],
        "resident_name": residentName,
        "resident_phone": residentPhone,
        "owner": owner?.toJson(),
        "tenant": tenant,
    };
}

class Owner {
    int? id;
    String? name;
    String? phone;

    Owner({
        this.id,
        this.name,
        this.phone,
    });

    factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
    };
}

enum PropertyType {
    APARTMENT,
    COMMERCIAL,
    INDEPENDENT_HOUSE
}

final propertyTypeValues = EnumValues({
    "Apartment": PropertyType.APARTMENT,
    "Commercial": PropertyType.COMMERCIAL,
    "Independent house": PropertyType.INDEPENDENT_HOUSE
});

enum Status {
    OCCUPIED
}

final statusValues = EnumValues({
    "occupied": Status.OCCUPIED
});

enum StatusBadge {
    OCCUPIED
}

final statusBadgeValues = EnumValues({
    "OCCUPIED": StatusBadge.OCCUPIED
});

enum StatusColor {
    THE_10_B981
}

final statusColorValues = EnumValues({
    "#10b981": StatusColor.THE_10_B981
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
