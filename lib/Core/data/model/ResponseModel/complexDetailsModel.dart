// To parse this JSON data, do
//
//     final complexDetailsModel = complexDetailsModelFromJson(jsonString);

import 'dart:convert';

ComplexDetailsModel complexDetailsModelFromJson(String str) => ComplexDetailsModel.fromJson(json.decode(str));

String complexDetailsModelToJson(ComplexDetailsModel data) => json.encode(data.toJson());

class ComplexDetailsModel {
    bool? status;
    Data? data;

    ComplexDetailsModel({
        this.status,
        this.data,
    });

    factory ComplexDetailsModel.fromJson(Map<String, dynamic> json) => ComplexDetailsModel(
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
    Banner? banner;
    StatsCards? statsCards;
    List<ComplexDetail>? complexDetails;
    List<BuildingsBlock>? buildingsBlocks;
    List<CommonFacility>? commonFacilities;
    List<ImportantDocument>? importantDocuments;
    Disclaimer? disclaimer;
    int? id;
    String? name;
    String? address;
    String? roleLabel;
    int? totalUnits;
    int? totalBlocks;
    int? blocks;
    List<String>? facilities;
    int? propertiesCount;
    List<ServiceProvider>? serviceProviders;

    Data({
        this.header,
        this.banner,
        this.statsCards,
        this.complexDetails,
        this.buildingsBlocks,
        this.commonFacilities,
        this.importantDocuments,
        this.disclaimer,
        this.id,
        this.name,
        this.address,
        this.roleLabel,
        this.totalUnits,
        this.totalBlocks,
        this.blocks,
        this.facilities,
        this.propertiesCount,
        this.serviceProviders,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        banner: json["banner"] == null ? null : Banner.fromJson(json["banner"]),
        statsCards: json["stats_cards"] == null ? null : StatsCards.fromJson(json["stats_cards"]),
        complexDetails: json["complex_details"] == null ? [] : List<ComplexDetail>.from(json["complex_details"]!.map((x) => ComplexDetail.fromJson(x))),
        buildingsBlocks: json["buildings_blocks"] == null ? [] : List<BuildingsBlock>.from(json["buildings_blocks"]!.map((x) => BuildingsBlock.fromJson(x))),
        commonFacilities: json["common_facilities"] == null ? [] : List<CommonFacility>.from(json["common_facilities"]!.map((x) => CommonFacility.fromJson(x))),
        importantDocuments: json["important_documents"] == null ? [] : List<ImportantDocument>.from(json["important_documents"]!.map((x) => ImportantDocument.fromJson(x))),
        disclaimer: json["disclaimer"] == null ? null : Disclaimer.fromJson(json["disclaimer"]),
        id: json["id"],
        name: json["name"],
        address: json["address"],
        roleLabel: json["role_label"],
        totalUnits: json["total_units"],
        totalBlocks: json["total_blocks"],
        blocks: json["blocks"],
        facilities: json["facilities"] == null ? [] : List<String>.from(json["facilities"]!.map((x) => x)),
        propertiesCount: json["properties_count"],
        serviceProviders: json["service_providers"] == null ? [] : List<ServiceProvider>.from(json["service_providers"]!.map((x) => ServiceProvider.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "banner": banner?.toJson(),
        "stats_cards": statsCards?.toJson(),
        "complex_details": complexDetails == null ? [] : List<dynamic>.from(complexDetails!.map((x) => x.toJson())),
        "buildings_blocks": buildingsBlocks == null ? [] : List<dynamic>.from(buildingsBlocks!.map((x) => x.toJson())),
        "common_facilities": commonFacilities == null ? [] : List<dynamic>.from(commonFacilities!.map((x) => x.toJson())),
        "important_documents": importantDocuments == null ? [] : List<dynamic>.from(importantDocuments!.map((x) => x.toJson())),
        "disclaimer": disclaimer?.toJson(),
        "id": id,
        "name": name,
        "address": address,
        "role_label": roleLabel,
        "total_units": totalUnits,
        "total_blocks": totalBlocks,
        "blocks": blocks,
        "facilities": facilities == null ? [] : List<dynamic>.from(facilities!.map((x) => x)),
        "properties_count": propertiesCount,
        "service_providers": serviceProviders == null ? [] : List<dynamic>.from(serviceProviders!.map((x) => x.toJson())),
    };
}

class Banner {
    String? tag;
    String? name;
    String? address;
    String? image;
    String? status;

    Banner({
        this.tag,
        this.name,
        this.address,
        this.image,
        this.status,
    });

    factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        tag: json["tag"],
        name: json["name"],
        address: json["address"],
        image: json["image"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "tag": tag,
        "name": name,
        "address": address,
        "image": image,
        "status": status,
    };
}

class BuildingsBlock {
    String? id;
    String? blockCode;
    String? name;
    int? totalUnits;
    String? unitsText;

    BuildingsBlock({
        this.id,
        this.blockCode,
        this.name,
        this.totalUnits,
        this.unitsText,
    });

    factory BuildingsBlock.fromJson(Map<String, dynamic> json) => BuildingsBlock(
        id: json["id"],
        blockCode: json["block_code"],
        name: json["name"],
        totalUnits: json["total_units"],
        unitsText: json["units_text"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "block_code": blockCode,
        "name": name,
        "total_units": totalUnits,
        "units_text": unitsText,
    };
}

class CommonFacility {
    int? id;
    String? title;
    String? subtitle;
    String? category;
    String? status;
    bool? isActive;

    CommonFacility({
        this.id,
        this.title,
        this.subtitle,
        this.category,
        this.status,
        this.isActive,
    });

    factory CommonFacility.fromJson(Map<String, dynamic> json) => CommonFacility(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        category: json["category"],
        status: json["status"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "category": category,
        "status": status,
        "is_active": isActive,
    };
}

class ComplexDetail {
    String? key;
    String? title;
    String? value;
    String? icon;

    ComplexDetail({
        this.key,
        this.title,
        this.value,
        this.icon,
    });

    factory ComplexDetail.fromJson(Map<String, dynamic> json) => ComplexDetail(
        key: json["key"],
        title: json["title"],
        value: json["value"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "title": title,
        "value": value,
        "icon": icon,
    };
}

class Disclaimer {
    String? title;
    String? message;

    Disclaimer({
        this.title,
        this.message,
    });

    factory Disclaimer.fromJson(Map<String, dynamic> json) => Disclaimer(
        title: json["title"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
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

class ImportantDocument {
    int? id;
    String? categoryCode;
    String? title;
    String? subtitle;
    int? documentCount;
    String? actionText;
    String? route;

    ImportantDocument({
        this.id,
        this.categoryCode,
        this.title,
        this.subtitle,
        this.documentCount,
        this.actionText,
        this.route,
    });

    factory ImportantDocument.fromJson(Map<String, dynamic> json) => ImportantDocument(
        id: json["id"],
        categoryCode: json["category_code"],
        title: json["title"],
        subtitle: json["subtitle"],
        documentCount: json["document_count"],
        actionText: json["action_text"],
        route: json["route"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_code": categoryCode,
        "title": title,
        "subtitle": subtitle,
        "document_count": documentCount,
        "action_text": actionText,
        "route": route,
    };
}

class ServiceProvider {
    int? id;
    int? complexId;
    String? serviceCategory;
    String? vendorName;
    String? contactInfo;
    String? modelNumber;
    String? serialNumber;
    DateTime? installationDate;
    DateTime? amcExpiryDate;
    DateTime? lastServiceDate;
    DateTime? nextServiceDate;
    String? contractDetails;
    String? status;
    double? performanceScore;
    DateTime? createdAt;
    DateTime? updatedAt;

    ServiceProvider({
        this.id,
        this.complexId,
        this.serviceCategory,
        this.vendorName,
        this.contactInfo,
        this.modelNumber,
        this.serialNumber,
        this.installationDate,
        this.amcExpiryDate,
        this.lastServiceDate,
        this.nextServiceDate,
        this.contractDetails,
        this.status,
        this.performanceScore,
        this.createdAt,
        this.updatedAt,
    });

    factory ServiceProvider.fromJson(Map<String, dynamic> json) => ServiceProvider(
        id: json["id"],
        complexId: json["complex_id"],
        serviceCategory: json["service_category"],
        vendorName: json["vendor_name"],
        contactInfo: json["contact_info"],
        modelNumber: json["model_number"],
        serialNumber: json["serial_number"],
        installationDate: json["installation_date"] == null ? null : DateTime.parse(json["installation_date"]),
        amcExpiryDate: json["amc_expiry_date"] == null ? null : DateTime.parse(json["amc_expiry_date"]),
        lastServiceDate: json["last_service_date"] == null ? null : DateTime.parse(json["last_service_date"]),
        nextServiceDate: json["next_service_date"] == null ? null : DateTime.parse(json["next_service_date"]),
        contractDetails: json["contract_details"],
        status: json["status"],
        performanceScore: json["performance_score"]?.toDouble(),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "complex_id": complexId,
        "service_category": serviceCategory,
        "vendor_name": vendorName,
        "contact_info": contactInfo,
        "model_number": modelNumber,
        "serial_number": serialNumber,
        "installation_date": installationDate?.toIso8601String(),
        "amc_expiry_date": amcExpiryDate?.toIso8601String(),
        "last_service_date": lastServiceDate?.toIso8601String(),
        "next_service_date": nextServiceDate?.toIso8601String(),
        "contract_details": contractDetails,
        "status": status,
        "performance_score": performanceScore,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class StatsCards {
    BuildingsBlocks? totalUnits;
    BuildingsBlocks? buildingsBlocks;

    StatsCards({
        this.totalUnits,
        this.buildingsBlocks,
    });

    factory StatsCards.fromJson(Map<String, dynamic> json) => StatsCards(
        totalUnits: json["total_units"] == null ? null : BuildingsBlocks.fromJson(json["total_units"]),
        buildingsBlocks: json["buildings_blocks"] == null ? null : BuildingsBlocks.fromJson(json["buildings_blocks"]),
    );

    Map<String, dynamic> toJson() => {
        "total_units": totalUnits?.toJson(),
        "buildings_blocks": buildingsBlocks?.toJson(),
    };
}

class BuildingsBlocks {
    int? value;
    String? label;
    String? icon;

    BuildingsBlocks({
        this.value,
        this.label,
        this.icon,
    });

    factory BuildingsBlocks.fromJson(Map<String, dynamic> json) => BuildingsBlocks(
        value: json["value"],
        label: json["label"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "label": label,
        "icon": icon,
    };
}
