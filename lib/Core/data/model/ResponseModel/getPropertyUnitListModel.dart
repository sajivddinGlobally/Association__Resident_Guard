// To parse this JSON data, do
//
//     final getPropertyUnitListModel = getPropertyUnitListModelFromJson(jsonString);

import 'dart:convert';

GetPropertyUnitListModel getPropertyUnitListModelFromJson(String str) => GetPropertyUnitListModel.fromJson(json.decode(str));

String getPropertyUnitListModelToJson(GetPropertyUnitListModel data) => json.encode(data.toJson());

class GetPropertyUnitListModel {
    bool? status;
    Data? data;

    GetPropertyUnitListModel({
        this.status,
        this.data,
    });

    factory GetPropertyUnitListModel.fromJson(Map<String, dynamic> json) => GetPropertyUnitListModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    Header? header;
    Complex? complex;
    Filters? filters;
    Summary? summary;
    List<Block>? blocks;
    List<Unit>? allUnits;
    String? disclaimer;

    Data({
        this.header,
        this.complex,
        this.filters,
        this.summary,
        this.blocks,
        this.allUnits,
        this.disclaimer,
    });

    List<Unit> get flattenedUnits {
        if (allUnits != null && allUnits!.isNotEmpty) {
            return allUnits!;
        }
        final List<Unit> list = [];
        for (final b in (blocks ?? [])) {
            list.addAll(b.units ?? []);
        }
        return list;
    }

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        complex: json["complex"] == null ? null : Complex.fromJson(json["complex"]),
        filters: json["filters"] == null ? null : Filters.fromJson(json["filters"]),
        summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        blocks: json["blocks"] == null ? [] : List<Block>.from(json["blocks"]!.map((x) => Block.fromJson(x))),
        allUnits: json["all_units"] == null ? [] : List<Unit>.from(json["all_units"]!.map((x) => Unit.fromJson(x))),
        disclaimer: json["disclaimer"],
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "complex": complex?.toJson(),
        "filters": filters?.toJson(),
        "summary": summary?.toJson(),
        "blocks": blocks == null ? [] : List<dynamic>.from(blocks!.map((x) => x.toJson())),
        "all_units": allUnits == null ? [] : List<dynamic>.from(allUnits!.map((x) => x.toJson())),
        "disclaimer": disclaimer,
    };
}

class Block {
    String? blockName;
    String? blockCode;
    String? blockTitle;
    int? totalUnits;
    List<Unit>? units;

    Block({
        this.blockName,
        this.blockCode,
        this.blockTitle,
        this.totalUnits,
        this.units,
    });

    factory Block.fromJson(Map<String, dynamic> json) => Block(
        blockName: json["block_name"],
        blockCode: json["block_code"],
        blockTitle: json["block_title"],
        totalUnits: json["total_units"],
        units: json["units"] == null ? [] : List<Unit>.from(json["units"]!.map((x) => Unit.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "block_name": blockName,
        "block_code": blockCode,
        "block_title": blockTitle,
        "total_units": totalUnits,
        "units": units == null ? [] : List<dynamic>.from(units!.map((x) => x.toJson())),
    };
}

class Unit {
    int? id;
    String? badge;
    String? unitNumber;
    String? block;
    String? floor;
    String? subtitle;
    String? propertyOwner;
    String? residents;
    String? propertyStatus;
    String? occupancyStatus;
    num? propertyScore;
    String? image;
    String? viewReportUrl;

    Unit({
        this.id,
        this.badge,
        this.unitNumber,
        this.block,
        this.floor,
        this.subtitle,
        this.propertyOwner,
        this.residents,
        this.propertyStatus,
        this.occupancyStatus,
        this.propertyScore,
        this.image,
        this.viewReportUrl,
    });

    factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["id"],
        badge: json["badge"],
        unitNumber: json["unit_number"],
        block: json["block"],
        floor: json["floor"]?.toString(),
        subtitle: json["subtitle"],
        propertyOwner: json["property_owner"],
        residents: json["residents"]?.toString(),
        propertyStatus: json["property_status"]?.toString(),
        occupancyStatus: json["occupancy_status"]?.toString(),
        propertyScore: json["property_score"],
        image: json["image"],
        viewReportUrl: json["view_report_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "badge": badge,
        "unit_number": unitNumber,
        "block": block,
        "floor": floor,
        "subtitle": subtitle,
        "property_owner": propertyOwner,
        "residents": residents,
        "property_status": propertyStatus,
        "occupancy_status": occupancyStatus,
        "property_score": propertyScore,
        "image": image,
        "view_report_url": viewReportUrl,
    };
}

class Complex {
    int? id;
    String? name;
    String? address;
    String? image;
    String? status;
    int? totalUnits;
    int? occupiedUnits;
    int? vacantUnits;

    Complex({
        this.id,
        this.name,
        this.address,
        this.image,
        this.status,
        this.totalUnits,
        this.occupiedUnits,
        this.vacantUnits,
    });

    factory Complex.fromJson(Map<String, dynamic> json) => Complex(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        image: json["image"],
        status: json["status"],
        totalUnits: json["total_units"],
        occupiedUnits: json["occupied_units"],
        vacantUnits: json["vacant_units"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "image": image,
        "status": status,
        "total_units": totalUnits,
        "occupied_units": occupiedUnits,
        "vacant_units": vacantUnits,
    };
}

class Filters {
    String? activeFilter;
    String? activeBlock;
    List<String>? availableBlocks;

    Filters({
        this.activeFilter,
        this.activeBlock,
        this.availableBlocks,
    });

    factory Filters.fromJson(Map<String, dynamic> json) => Filters(
        activeFilter: json["active_filter"],
        activeBlock: json["active_block"],
        availableBlocks: json["available_blocks"] == null ? [] : List<String>.from(json["available_blocks"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "active_filter": activeFilter,
        "active_block": activeBlock,
        "available_blocks": availableBlocks == null ? [] : List<dynamic>.from(availableBlocks!.map((x) => x)),
    };
}

class Header {
    String? title;
    String? subtitle;

    Header({
        this.title,
        this.subtitle,
    });

    factory Header.fromJson(Map<String, dynamic> json) => Header(
        title: json["title"],
        subtitle: json["subtitle"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
    };
}

class Summary {
    String? label;
    String? totalUnitsDisplay;
    int? filteredCount;

    Summary({
        this.label,
        this.totalUnitsDisplay,
        this.filteredCount,
    });

    factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        label: json["label"],
        totalUnitsDisplay: json["total_units_display"],
        filteredCount: json["filtered_count"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "total_units_display": totalUnitsDisplay,
        "filtered_count": filteredCount,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
