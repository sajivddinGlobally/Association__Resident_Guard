import 'dart:convert';

VisitorPassResModel visitorPassResModelFromJson(String str) =>
    VisitorPassResModel.fromJson(json.decode(str));

String visitorPassResModelToJson(VisitorPassResModel data) =>
    json.encode(data.toJson());

class VisitorPassResModel {
  bool? status;
  String? message;
  VisitorPassData? data;

  VisitorPassResModel({
    this.status,
    this.message,
    this.data,
  });

  factory VisitorPassResModel.fromJson(Map<String, dynamic> json) =>
      VisitorPassResModel(
        status: json["status"],
        message: json["message"],
        data:
            json["data"] == null ? null : VisitorPassData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class VisitorPassData {
  Header? header;
  ApprovalStatusCard? approvalStatusCard;
  VisitorDetails? visitorDetails;
  ResidentApproval? residentApproval;
  VisitorPassCard? visitorPassCard;
  Timings? timings;
  ActionButton? actionButton;

  VisitorPassData({
    this.header,
    this.approvalStatusCard,
    this.visitorDetails,
    this.residentApproval,
    this.visitorPassCard,
    this.timings,
    this.actionButton,
  });

  factory VisitorPassData.fromJson(Map<String, dynamic> json) =>
      VisitorPassData(
        header:
            json["header"] == null ? null : Header.fromJson(json["header"]),
        approvalStatusCard: json["approval_status_card"] == null
            ? null
            : ApprovalStatusCard.fromJson(json["approval_status_card"]),
        visitorDetails: json["visitor_details"] == null
            ? null
            : VisitorDetails.fromJson(json["visitor_details"]),
        residentApproval: json["resident_approval"] == null
            ? null
            : ResidentApproval.fromJson(json["resident_approval"]),
        visitorPassCard: json["visitor_pass_card"] == null
            ? null
            : VisitorPassCard.fromJson(json["visitor_pass_card"]),
        timings:
            json["timings"] == null ? null : Timings.fromJson(json["timings"]),
        actionButton: json["action_button"] == null
            ? null
            : ActionButton.fromJson(json["action_button"]),
      );

  Map<String, dynamic> toJson() => {
    "header": header?.toJson(),
    "approval_status_card": approvalStatusCard?.toJson(),
    "visitor_details": visitorDetails?.toJson(),
    "resident_approval": residentApproval?.toJson(),
    "visitor_pass_card": visitorPassCard?.toJson(),
    "timings": timings?.toJson(),
    "action_button": actionButton?.toJson(),
  };
}

class Header {
  String? title;
  String? subtitle;

  Header({this.title, this.subtitle});

  factory Header.fromJson(Map<String, dynamic> json) => Header(
    title: json["title"],
    subtitle: json["subtitle"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "subtitle": subtitle,
  };
}

class ApprovalStatusCard {
  String? badge;
  String? badgeColor;
  String? title;
  String? description;
  int? countdownSeconds;

  ApprovalStatusCard({
    this.badge,
    this.badgeColor,
    this.title,
    this.description,
    this.countdownSeconds,
  });

  factory ApprovalStatusCard.fromJson(Map<String, dynamic> json) =>
      ApprovalStatusCard(
        badge: json["badge"],
        badgeColor: json["badge_color"],
        title: json["title"],
        description: json["description"],
        countdownSeconds: json["countdown_seconds"],
      );

  Map<String, dynamic> toJson() => {
    "badge": badge,
    "badge_color": badgeColor,
    "title": title,
    "description": description,
    "countdown_seconds": countdownSeconds,
  };
}

class VisitorDetails {
  dynamic id;
  String? name;
  String? photoUrl;
  String? typeLabel;
  String? apartment;
  String? visitorMobile;
  String? vehicle;
  String? purpose;
  String? requestedAt;

  VisitorDetails({
    this.id,
    this.name,
    this.photoUrl,
    this.typeLabel,
    this.apartment,
    this.visitorMobile,
    this.vehicle,
    this.purpose,
    this.requestedAt,
  });

  factory VisitorDetails.fromJson(Map<String, dynamic> json) => VisitorDetails(
    id: json["id"],
    name: json["name"],
    photoUrl: json["photo_url"],
    typeLabel: json["type_label"],
    apartment: json["apartment"],
    visitorMobile: json["visitor_mobile"],
    vehicle: json["vehicle"],
    purpose: json["purpose"],
    requestedAt: json["requested_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "photo_url": photoUrl,
    "type_label": typeLabel,
    "apartment": apartment,
    "visitor_mobile": visitorMobile,
    "vehicle": vehicle,
    "purpose": purpose,
    "requested_at": requestedAt,
  };
}

class ResidentApproval {
  String? residentName;
  String? residentPhone;
  String? status;
  String? approvalType;
  String? buttonLabel;
  bool? canVerbalApprove;

  ResidentApproval({
    this.residentName,
    this.residentPhone,
    this.status,
    this.approvalType,
    this.buttonLabel,
    this.canVerbalApprove,
  });

  factory ResidentApproval.fromJson(Map<String, dynamic> json) =>
      ResidentApproval(
        residentName: json["resident_name"],
        residentPhone: json["resident_phone"],
        status: json["status"],
        approvalType: json["approval_type"],
        buttonLabel: json["button_label"],
        canVerbalApprove: json["can_verbal_approve"],
      );

  Map<String, dynamic> toJson() => {
    "resident_name": residentName,
    "resident_phone": residentPhone,
    "status": status,
    "approval_type": approvalType,
    "button_label": buttonLabel,
    "can_verbal_approve": canVerbalApprove,
  };
}

class VisitorPassCard {
  String? badge;
  String? passCode;
  String? qrCodeUrl;
  String? instruction;
  String? actionLabel;

  VisitorPassCard({
    this.badge,
    this.passCode,
    this.qrCodeUrl,
    this.instruction,
    this.actionLabel,
  });

  factory VisitorPassCard.fromJson(Map<String, dynamic> json) =>
      VisitorPassCard(
        badge: json["badge"],
        passCode: json["pass_code"],
        qrCodeUrl: json["qr_code_url"],
        instruction: json["instruction"],
        actionLabel: json["action_label"],
      );

  Map<String, dynamic> toJson() => {
    "badge": badge,
    "pass_code": passCode,
    "qr_code_url": qrCodeUrl,
    "instruction": instruction,
    "action_label": actionLabel,
  };
}

class Timings {
  String? inTime;
  String? outTime;
  bool? isInside;

  Timings({
    this.inTime,
    this.outTime,
    this.isInside,
  });

  factory Timings.fromJson(Map<String, dynamic> json) => Timings(
    inTime: json["in_time"],
    outTime: json["out_time"],
    isInside: json["is_inside"],
  );

  Map<String, dynamic> toJson() => {
    "in_time": inTime,
    "out_time": outTime,
    "is_inside": isInside,
  };
}

class ActionButton {
  String? label;
  bool? isEnabled;

  ActionButton({this.label, this.isEnabled});

  factory ActionButton.fromJson(Map<String, dynamic> json) => ActionButton(
    label: json["label"],
    isEnabled: json["is_enabled"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "is_enabled": isEnabled,
  };
}
