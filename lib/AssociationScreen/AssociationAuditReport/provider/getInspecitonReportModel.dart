// To parse this JSON data, do
//
//     final getInspectionReportModel = getInspectionReportModelFromJson(jsonString);

import 'dart:convert';

GetInspectionReportModel getInspectionReportModelFromJson(String str) =>
    GetInspectionReportModel.fromJson(json.decode(str));

String getInspectionReportModelToJson(GetInspectionReportModel data) =>
    json.encode(data.toJson());

class GetInspectionReportModel {
  bool? status;
  List<Datum>? data;

  GetInspectionReportModel({this.status, this.data});

  factory GetInspectionReportModel.fromJson(Map<String, dynamic> json) =>
      GetInspectionReportModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  int? complexId;
  int? propertyId;
  int? inspectorId;
  String? reportType;
  dynamic auditType;
  String? inspectionDate;
  String? findings;
  String? recommendations;
  dynamic categoryRemarks;
  String? score;
  String? status;
  Attachments? attachments;
  DateTime? createdAt;
  DateTime? updatedAt;
  AttachmentsUrls? attachmentsUrls;
  String? reportPdfUrl;
  String? date;
  String? dateFormatted;
  String? inspectionDateFormatted;
  Inspector? inspector;
  Property? property;
  Complex? complex;

  Datum({
    this.id,
    this.complexId,
    this.propertyId,
    this.inspectorId,
    this.reportType,
    this.auditType,
    this.inspectionDate,
    this.findings,
    this.recommendations,
    this.categoryRemarks,
    this.score,
    this.status,
    this.attachments,
    this.createdAt,
    this.updatedAt,
    this.attachmentsUrls,
    this.reportPdfUrl,
    this.date,
    this.dateFormatted,
    this.inspectionDateFormatted,
    this.inspector,
    this.property,
    this.complex,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    complexId: json["complex_id"],
    propertyId: json["property_id"],
    inspectorId: json["inspector_id"],
    reportType: json["report_type"],
    auditType: json["audit_type"],
    inspectionDate: json['inspection_date'],
    findings: json["findings"],
    recommendations: json["recommendations"],
    categoryRemarks: json["category_remarks"],
    score: json["score"]?.toString(),
    status: json["status"],
    attachments: json["attachments"] == null
        ? null
        : Attachments.fromJson(json["attachments"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"].toString()),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"].toString()),
    attachmentsUrls: json["attachments_urls"] == null
        ? null
        : AttachmentsUrls.fromJson(json["attachments_urls"]),
    reportPdfUrl: json["report_pdf_url"],
    date: json["date"],
    dateFormatted: json["date_formatted"],
    inspectionDateFormatted: json["inspection_date_formatted"],
    inspector: json["inspector"] == null
        ? null
        : Inspector.fromJson(json["inspector"]),
    property: json["property"] == null
        ? null
        : Property.fromJson(json["property"]),
    complex: json["complex"] == null
        ? null
        : Complex.fromJson(json["complex"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "complex_id": complexId,
    "property_id": propertyId,
    "inspector_id": inspectorId,
    "report_type": reportType,
    "audit_type": auditType,
    "inspection_date": inspectionDate,
    "findings": findings,
    "recommendations": recommendations,
    "category_remarks": categoryRemarks,
    "score": score,
    "status": status,
    "attachments": attachments?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "attachments_urls": attachmentsUrls?.toJson(),
    "report_pdf_url": reportPdfUrl,
    "date": date,
    "date_formatted": dateFormatted,
    "inspection_date_formatted": inspectionDateFormatted,
    "inspector": inspector?.toJson(),
    "property": property?.toJson(),
    "complex": complex?.toJson(),
  };
}

class Attachments {
  String? pdf;
  List<String>? images;

  Attachments({this.pdf, this.images});

  factory Attachments.fromJson(Map<String, dynamic> json) => Attachments(
    pdf: json["pdf"]?.toString(),
    images: json["images"] == null
        ? []
        : List<String>.from(json["images"].map((x) => x.toString())),
  );

  Map<String, dynamic> toJson() => {
    "pdf": pdf,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
  };
}

class AttachmentsUrls {
  String? pdf;
  List<String>? images;

  AttachmentsUrls({this.pdf, this.images});

  factory AttachmentsUrls.fromJson(Map<String, dynamic> json) => AttachmentsUrls(
    pdf: json["pdf"]?.toString(),
    images: json["images"] == null
        ? []
        : List<String>.from(json["images"].map((x) => x.toString())),
  );

  Map<String, dynamic> toJson() => {
    "pdf": pdf,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
  };
}

class Inspector {
  int? id;
  String? name;
  String? email;
  String? role;
  String? guardPost;
  dynamic isOnDuty;
  dynamic shiftId;
  String? phone;
  dynamic avatar;
  String? status;
  String? subscriptionStatus;
  dynamic fcmToken;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic unitId;
  dynamic complexId;

  Inspector({
    this.id,
    this.name,
    this.email,
    this.role,
    this.guardPost,
    this.isOnDuty,
    this.shiftId,
    this.phone,
    this.avatar,
    this.status,
    this.subscriptionStatus,
    this.fcmToken,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.unitId,
    this.complexId,
  });

  factory Inspector.fromJson(Map<String, dynamic> json) => Inspector(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    guardPost: json["guard_post"],
    isOnDuty: json["is_on_duty"],
    shiftId: json["shift_id"],
    phone: json["phone"],
    avatar: json["avatar"],
    status: json["status"],
    subscriptionStatus: json["subscription_status"],
    fcmToken: json["fcm_token"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"].toString()),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"].toString()),
    unitId: json["unit_id"],
    complexId: json["complex_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
    "guard_post": guardPost,
    "is_on_duty": isOnDuty,
    "shift_id": shiftId,
    "phone": phone,
    "avatar": avatar,
    "status": status,
    "subscription_status": subscriptionStatus,
    "fcm_token": fcmToken,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "unit_id": unitId,
    "complex_id": complexId,
  };
}

class Property {
  int? id;
  int? complexId;
  int? complexUnitId;
  int? ownerId;
  dynamic caretakerId;
  String? propertyNameNumber;
  String? propertyType;
  String? image;
  String? location;
  String? area;
  String? bedrooms;
  String? floors;
  String? occupancyStatus;
  String? status;
  String? carePackage;
  bool? hasMmc;
  String? monthlyMaintenanceFee;
  String? electricityMeterNo;
  String? waterConnectionNo;
  String? municipalityNumber;
  bool? isIndependent;
  num? overallScore;
  bool? isSelected;
  String? propertyCode;
  String? displayType;
  DateTime? createdAt;
  DateTime? updatedAt;

  Property({
    this.id,
    this.complexId,
    this.complexUnitId,
    this.ownerId,
    this.caretakerId,
    this.propertyNameNumber,
    this.propertyType,
    this.image,
    this.location,
    this.area,
    this.bedrooms,
    this.floors,
    this.occupancyStatus,
    this.status,
    this.carePackage,
    this.hasMmc,
    this.monthlyMaintenanceFee,
    this.electricityMeterNo,
    this.waterConnectionNo,
    this.municipalityNumber,
    this.isIndependent,
    this.overallScore,
    this.isSelected,
    this.propertyCode,
    this.displayType,
    this.createdAt,
    this.updatedAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
    id: json["id"],
    complexId: json["complex_id"],
    complexUnitId: json["complex_unit_id"],
    ownerId: json["owner_id"],
    caretakerId: json["caretaker_id"],
    propertyNameNumber: json["property_name_number"],
    propertyType: json["property_type"],
    image: json["image"],
    location: json["location"],
    area: json["area"],
    bedrooms: json["bedrooms"]?.toString(),
    floors: json["floors"]?.toString(),
    occupancyStatus: json["occupancy_status"],
    status: json["status"],
    carePackage: json["care_package"],
    hasMmc: json["has_mmc"],
    monthlyMaintenanceFee: json["monthly_maintenance_fee"]?.toString(),
    electricityMeterNo: json["electricity_meter_no"],
    waterConnectionNo: json["water_connection_no"],
    municipalityNumber: json["municipality_number"],
    isIndependent: json["is_independent"],
    overallScore: json["overall_score"] == null
        ? null
        : (json["overall_score"] as num).toDouble(),
    isSelected: json["is_selected"],
    propertyCode: json["property_code"],
    displayType: json["display_type"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"].toString()),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "complex_id": complexId,
    "complex_unit_id": complexUnitId,
    "owner_id": ownerId,
    "caretaker_id": caretakerId,
    "property_name_number": propertyNameNumber,
    "property_type": propertyType,
    "image": image,
    "location": location,
    "area": area,
    "bedrooms": bedrooms,
    "floors": floors,
    "occupancy_status": occupancyStatus,
    "status": status,
    "care_package": carePackage,
    "has_mmc": hasMmc,
    "monthly_maintenance_fee": monthlyMaintenanceFee,
    "electricity_meter_no": electricityMeterNo,
    "water_connection_no": waterConnectionNo,
    "municipality_number": municipalityNumber,
    "is_independent": isIndependent,
    "overall_score": overallScore,
    "is_selected": isSelected,
    "property_code": propertyCode,
    "display_type": displayType,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Complex {
  int? id;
  String? name;
  String? address;
  String? image;
  String? status;
  int? totalUnits;
  int? totalBlocks;
  int? associationHeadId;
  List<dynamic>? securityId;
  dynamic caretakerId;
  List<String>? facilities;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? complexCode;

  Complex({
    this.id,
    this.name,
    this.address,
    this.image,
    this.status,
    this.totalUnits,
    this.totalBlocks,
    this.associationHeadId,
    this.securityId,
    this.caretakerId,
    this.facilities,
    this.createdAt,
    this.updatedAt,
    this.complexCode,
  });

  factory Complex.fromJson(Map<String, dynamic> json) => Complex(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    image: json["image"],
    status: json["status"],
    totalUnits: json["total_units"],
    totalBlocks: json["total_blocks"],
    associationHeadId: json["association_head_id"],
    securityId: json["security_id"] == null
        ? []
        : List<dynamic>.from(json["security_id"].map((x) => x)),
    caretakerId: json["caretaker_id"],
    facilities: json["facilities"] == null
        ? []
        : List<String>.from(json["facilities"].map((x) => x.toString())),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"].toString()),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"].toString()),
    complexCode: json["complex_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "image": image,
    "status": status,
    "total_units": totalUnits,
    "total_blocks": totalBlocks,
    "association_head_id": associationHeadId,
    "security_id": securityId,
    "caretaker_id": caretakerId,
    "facilities": facilities,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "complex_code": complexCode,
  };
}
