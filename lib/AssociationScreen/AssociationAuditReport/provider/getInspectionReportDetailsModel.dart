// To parse this JSON data, do
//
//     final getInspectionReportDetailsModel = getInspectionReportDetailsModelFromJson(jsonString);

import 'dart:convert';

GetInspectionReportDetailsModel getInspectionReportDetailsModelFromJson(
  String str,
) => GetInspectionReportDetailsModel.fromJson(json.decode(str));

String getInspectionReportDetailsModelToJson(
  GetInspectionReportDetailsModel data,
) => json.encode(data.toJson());

class GetInspectionReportDetailsModel {
  bool? status;
  Data? data;

  GetInspectionReportDetailsModel({this.status, this.data});

  factory GetInspectionReportDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetInspectionReportDetailsModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  int? id;
  String? reportType;
  dynamic auditType;
  String? targetType;
  int? complexId;
  String? complexName;
  String? propertyName;
  String? inspectionDate;
  String? date;
  String? dateFormatted;
  num? score;
  String? status;
  String? findings;
  String? recommendations;
  Attachments? attachments;
  AttachmentsUrls? attachmentsUrls;
  String? downloadUrl;
  String? checklistPdfUrl;
  String? reportPdfUrl;
  List<DigitalChecklist>? digitalChecklist;
  Inspector? inspector;

  Data({
    this.id,
    this.reportType,
    this.auditType,
    this.targetType,
    this.complexId,
    this.complexName,
    this.propertyName,
    this.inspectionDate,
    this.date,
    this.dateFormatted,
    this.score,
    this.status,
    this.findings,
    this.recommendations,
    this.attachments,
    this.attachmentsUrls,
    this.downloadUrl,
    this.checklistPdfUrl,
    this.reportPdfUrl,
    this.digitalChecklist,
    this.inspector,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    reportType: json["report_type"],
    auditType: json["audit_type"],
    targetType: json["target_type"],
    complexId: json["complex_id"],
    complexName: json["complex_name"],
    propertyName: json["property_name"],
    inspectionDate: json["inspection_date"],
    date: json["date"],
    dateFormatted: json["date_formatted"],
    score: json["score"],
    status: json["status"],
    findings: json["findings"],
    recommendations: json["recommendations"],
    attachments: json["attachments"] == null
        ? null
        : Attachments.fromJson(json["attachments"]),
    attachmentsUrls: json["attachments_urls"] == null
        ? null
        : AttachmentsUrls.fromJson(json["attachments_urls"]),
    downloadUrl: json["download_url"],
    checklistPdfUrl: json["checklist_pdf_url"],
    reportPdfUrl: json["report_pdf_url"],
    digitalChecklist: json["digital_checklist"] == null
        ? []
        : List<DigitalChecklist>.from(
            json["digital_checklist"]!.map((x) => DigitalChecklist.fromJson(x)),
          ),
    inspector: json["inspector"] == null
        ? null
        : Inspector.fromJson(json["inspector"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "report_type": reportType,
    "audit_type": auditType,
    "target_type": targetType,
    "complex_id": complexId,
    "complex_name": complexName,
    "property_name": propertyName,
    "inspection_date": inspectionDate,
    "date": date,
    "date_formatted": dateFormatted,
    "score": score,
    "status": status,
    "findings": findings,
    "recommendations": recommendations,
    "attachments": attachments?.toJson(),
    "attachments_urls": attachmentsUrls?.toJson(),
    "download_url": downloadUrl,
    "checklist_pdf_url": checklistPdfUrl,
    "report_pdf_url": reportPdfUrl,
    "digital_checklist": digitalChecklist == null
        ? []
        : List<dynamic>.from(digitalChecklist!.map((x) => x.toJson())),
    "inspector": inspector?.toJson(),
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
        : List<String>.from(json["images"]!.map((x) => x.toString())),
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

class DigitalChecklist {
  int? id;
  int? inspectionId;
  String? itemName;
  String? status;
  String? remarks;
  dynamic photos;
  DateTime? createdAt;
  DateTime? updatedAt;

  DigitalChecklist({
    this.id,
    this.inspectionId,
    this.itemName,
    this.status,
    this.remarks,
    this.photos,
    this.createdAt,
    this.updatedAt,
  });

  factory DigitalChecklist.fromJson(Map<String, dynamic> json) =>
      DigitalChecklist(
        id: json["id"],
        inspectionId: json["inspection_id"],
        itemName: json["item_name"],
        status: json["status"],
        remarks: json["remarks"],
        photos: json["photos"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "inspection_id": inspectionId,
    "item_name": itemName,
    "status": status,
    "remarks": remarks,
    "photos": photos,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Inspector {
  int? id;
  String? name;
  String? phone;

  Inspector({this.id, this.name, this.phone});

  factory Inspector.fromJson(Map<String, dynamic> json) =>
      Inspector(id: json["id"], name: json["name"], phone: json["phone"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "phone": phone};
}
