// To parse this JSON data, do
//
//     final getFlatApartmentModel = getFlatApartmentModelFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/material.dart';

GetFlatApartmentModel getFlatApartmentModelFromJson(String str) =>
    GetFlatApartmentModel.fromJson(json.decode(str));

String getFlatApartmentModelToJson(GetFlatApartmentModel data) =>
    json.encode(data.toJson());

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

  factory GetFlatApartmentModel.fromJson(Map<String, dynamic> json) =>
      GetFlatApartmentModel(
        status: json["status"],
        message: json["message"],
        complex: json["complex"] == null
            ? null
            : Complex.fromJson(json["complex"]),
        total: json["total"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        properties: json["properties"] == null
            ? []
            : List<Datum>.from(
                json["properties"]!.map((x) => Datum.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "complex": complex?.toJson(),
    "total": total,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "properties":
        properties == null
            ? []
            : List<dynamic>.from(properties!.map((x) => x.toJson())),
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
  int? complexUnitId;
  int? unitId;
  String? flatNumber;
  String? propertyNameNumber;
  String? propertyType;
  String? location;
  String? status;
  String? statusBadge;
  String? statusColor;
  String? residentName;
  String? residentPhone;
  Owner? owner;
  dynamic tenant;

  Datum({
    this.id,
    this.propertyId,
    this.complexUnitId,
    this.unitId,
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
    complexUnitId: json["complex_unit_id"],
    unitId: json["unit_id"],
    flatNumber: json["flat_number"]?.toString(),
    propertyNameNumber: json["property_name_number"]?.toString(),
    propertyType: json["property_type"]?.toString(),
    location: json["location"]?.toString(),
    status: json["status"]?.toString(),
    statusBadge: json["status_badge"]?.toString(),
    statusColor: json["status_color"]?.toString(),
    residentName: json["resident_name"]?.toString(),
    residentPhone: json["resident_phone"]?.toString(),
    owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
    tenant: json["tenant"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_id": propertyId,
    "complex_unit_id": complexUnitId,
    "unit_id": unitId,
    "flat_number": flatNumber,
    "property_name_number": propertyNameNumber,
    "property_type": propertyType,
    "location": location,
    "status": status,
    "status_badge": statusBadge,
    "status_color": statusColor,
    "resident_name": residentName,
    "resident_phone": residentPhone,
    "owner": owner?.toJson(),
    "tenant": tenant,
  };

  /// Returns true if this flat is vacant or unassigned
  bool get isVacant {
    final s = (status ?? statusBadge ?? '').trim().toLowerCase();
    if (s == 'vacant') return true;
    if (s == 'occupied') return false;
    final res = (residentName ?? '').trim().toLowerCase();
    if (res.contains('vacant') || res.contains('unassigned')) return true;
    if (owner == null &&
        tenant == null &&
        (residentPhone == null || residentPhone!.trim().isEmpty)) {
      return true;
    }
    return false;
  }

  bool get isOccupied => !isVacant;

  /// Display text for status badge ("VACANT", "OCCUPIED", etc.)
  String get displayStatusBadge {
    if (statusBadge != null && statusBadge!.trim().isNotEmpty) {
      return statusBadge!.trim().toUpperCase();
    }
    if (status != null && status!.trim().isNotEmpty) {
      return status!.trim().toUpperCase();
    }
    return isVacant ? "VACANT" : "OCCUPIED";
  }

  /// Badge indicator dot color
  Color get badgeColor {
    if (statusColor != null && statusColor!.trim().startsWith('#')) {
      try {
        final hex = statusColor!.trim().replaceAll('#', '');
        if (hex.length == 6) {
          return Color(int.parse('0xFF$hex'));
        }
      } catch (_) {}
    }
    return isVacant ? const Color(0xFF6B7280) : const Color(0xFF10B981);
  }

  /// Background color for status badge
  Color get badgeBgColor {
    return isVacant ? const Color(0xFFF3F4F6) : const Color(0xFFECFDF5);
  }

  /// Border color for status badge
  Color get badgeBorderColor {
    return isVacant ? const Color(0xFFE5E7EB) : const Color(0xFFA7F3D0);
  }

  /// Text color for status badge
  Color get badgeTextColor {
    return isVacant ? const Color(0xFF4B5563) : const Color(0xFF065F46);
  }
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
    id: json["id"] is int
        ? json["id"]
        : int.tryParse(json["id"]?.toString() ?? ''),
    name: json["name"]?.toString(),
    phone: json["phone"]?.toString(),
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
  INDEPENDENT_HOUSE,
}

final propertyTypeValues = EnumValues({
  "Apartment": PropertyType.APARTMENT,
  "Commercial": PropertyType.COMMERCIAL,
  "Independent house": PropertyType.INDEPENDENT_HOUSE,
});

enum Status {
  OCCUPIED,
  VACANT,
}

final statusValues = EnumValues({
  "occupied": Status.OCCUPIED,
  "vacant": Status.VACANT,
});

enum StatusBadge {
  OCCUPIED,
  VACANT,
}

final statusBadgeValues = EnumValues({
  "OCCUPIED": StatusBadge.OCCUPIED,
  "VACANT": StatusBadge.VACANT,
});

enum StatusColor {
  THE_10_B981,
  THE_6B7280,
}

final statusColorValues = EnumValues({
  "#10b981": StatusColor.THE_10_B981,
  "#6b7280": StatusColor.THE_6B7280,
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
