import 'dart:convert';

ScanPassResModel scanPassResModelFromJson(String str) =>
    ScanPassResModel.fromJson(json.decode(str));

String scanPassResModelToJson(ScanPassResModel data) =>
    json.encode(data.toJson());

class ScanPassResModel {
  bool? status;
  String? message;
  ScanPassData? data;

  ScanPassResModel({
    this.status,
    this.message,
    this.data,
  });

  factory ScanPassResModel.fromJson(Map<String, dynamic> json) =>
      ScanPassResModel(
        status: json["status"] is bool
            ? json["status"]
            : (json["status"] == 1 || json["status"] == "true"),
        message: json["message"]?.toString(),
        data: json["data"] != null ? ScanPassData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ScanPassData {
  dynamic id;
  dynamic visitorId;
  String? passCode;
  String? visitorName;
  String? visitorPhone;
  String? flatNumber;
  String? passType;
  String? validDate;
  String? status;
  String? photoUrl;
  String? residentName;
  String? residentPhone;
  String? inTime;
  String? outTime;

  ScanPassData({
    this.id,
    this.visitorId,
    this.passCode,
    this.visitorName,
    this.visitorPhone,
    this.flatNumber,
    this.passType,
    this.validDate,
    this.status,
    this.photoUrl,
    this.residentName,
    this.residentPhone,
    this.inTime,
    this.outTime,
  });

  factory ScanPassData.fromJson(Map<String, dynamic> json) {
    final vDetails = json["visitor_details"] is Map<String, dynamic>
        ? json["visitor_details"] as Map<String, dynamic>
        : null;
    final vPassCard = json["visitor_pass_card"] is Map<String, dynamic>
        ? json["visitor_pass_card"] as Map<String, dynamic>
        : null;
    final rApproval = json["resident_approval"] is Map<String, dynamic>
        ? json["resident_approval"] as Map<String, dynamic>
        : null;
    final timings = json["timings"] is Map<String, dynamic>
        ? json["timings"] as Map<String, dynamic>
        : null;
    final appCard = json["approval_status_card"] is Map<String, dynamic>
        ? json["approval_status_card"] as Map<String, dynamic>
        : null;

    return ScanPassData(
      id: vDetails?["id"] ?? json["id"] ?? json["visitor_id"],
      visitorId: vDetails?["id"] ?? json["visitor_id"] ?? json["id"],
      passCode: vPassCard?["pass_code"] ??
          json["pass_code"] ??
          json["code"] ??
          json["scanned_code"],
      visitorName: vDetails?["name"] ?? json["visitor_name"] ?? json["name"],
      visitorPhone: vDetails?["visitor_mobile"] ??
          json["visitor_phone"] ??
          json["phone"],
      flatNumber: vDetails?["apartment"] ??
          json["flat_number"] ??
          json["flat"] ??
          json["apartment"],
      passType: vDetails?["type_label"] ??
          json["pass_type"] ??
          json["type"] ??
          json["visit_type"],
      validDate: json["valid_date"] ??
          json["date"] ??
          json["valid_until"] ??
          timings?["in_time"] ??
          "Today",
      status: appCard?["badge"] ??
          rApproval?["status"] ??
          json["status"] ??
          json["approval_status"] ??
          "APPROVED",
      photoUrl: vDetails?["photo_url"] ?? json["photo_url"] ?? json["photo"],
      residentName: rApproval?["resident_name"] ?? json["resident_name"],
      residentPhone: rApproval?["resident_phone"] ?? json["resident_phone"],
      inTime: timings?["in_time"] ?? json["in_time"],
      outTime: timings?["out_time"] ?? json["out_time"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "visitor_id": visitorId,
        "pass_code": passCode,
        "visitor_name": visitorName,
        "visitor_phone": visitorPhone,
        "flat_number": flatNumber,
        "pass_type": passType,
        "valid_date": validDate,
        "status": status,
        "photo_url": photoUrl,
        "resident_name": residentName,
        "resident_phone": residentPhone,
        "in_time": inTime,
        "out_time": outTime,
      };
}
