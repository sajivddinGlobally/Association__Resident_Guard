// To parse this JSON data, do
//
//     final getComplaintListModel = getComplaintListModelFromJson(jsonString);

import 'dart:convert';

GetComplaintListModel getComplaintListModelFromJson(String str) =>
    GetComplaintListModel.fromJson(json.decode(str));

String getComplaintListModelToJson(GetComplaintListModel data) =>
    json.encode(data.toJson());

class GetComplaintListModel {
  bool? status;
  String? message;
  Data? data;

  GetComplaintListModel({this.status, this.message, this.data});

  factory GetComplaintListModel.fromJson(Map<String, dynamic> json) =>
      GetComplaintListModel(
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
  Header? header;
  RegisteredApartment? registeredApartment;
  List<FilterTab>? filterTabs;
  int? totalCount;
  List<Request>? requests;

  Data({
    this.header,
    this.registeredApartment,
    this.filterTabs,
    this.totalCount,
    this.requests,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    header: json["header"] == null ? null : Header.fromJson(json["header"]),
    registeredApartment: json["registered_apartment"] == null
        ? null
        : RegisteredApartment.fromJson(json["registered_apartment"]),
    filterTabs: json["filter_tabs"] == null
        ? []
        : List<FilterTab>.from(
            json["filter_tabs"]!.map((x) => FilterTab.fromJson(x)),
          ),
    totalCount: json["total_count"],
    requests: json["requests"] == null
        ? []
        : List<Request>.from(json["requests"]!.map((x) => Request.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "header": header?.toJson(),
    "registered_apartment": registeredApartment?.toJson(),
    "filter_tabs": filterTabs == null
        ? []
        : List<dynamic>.from(filterTabs!.map((x) => x.toJson())),
    "total_count": totalCount,
    "requests": requests == null
        ? []
        : List<dynamic>.from(requests!.map((x) => x.toJson())),
  };
}

class FilterTab {
  String? key;
  String? label;
  bool? isActive;

  FilterTab({this.key, this.label, this.isActive});

  factory FilterTab.fromJson(Map<String, dynamic> json) => FilterTab(
    key: json["key"],
    label: json["label"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "label": label,
    "is_active": isActive,
  };
}

class Header {
  String? subtitle;
  String? title;

  Header({this.subtitle, this.title});

  factory Header.fromJson(Map<String, dynamic> json) =>
      Header(subtitle: json["subtitle"], title: json["title"]);

  Map<String, dynamic> toJson() => {"subtitle": subtitle, "title": title};
}

class RegisteredApartment {
  String? label;
  String? text;

  RegisteredApartment({this.label, this.text});

  factory RegisteredApartment.fromJson(Map<String, dynamic> json) =>
      RegisteredApartment(label: json["label"], text: json["text"]);

  Map<String, dynamic> toJson() => {"label": label, "text": text};
}

class Request {
  int? id;
  String? tokenLabel;
  String? tokenNumber;
  String? status;
  String? statusColor;
  bool? isEmergency;
  String? emergencyIndicator;
  String? areaType;
  String? areaTypeLabel;
  String? title;
  String? location;
  String? resolutionPhoto;
  String? viewDetailsUrl;
  bool? isOverdue;
  String? deadline;
  String? issueScope;
  String? ticketNumber;
  // 'complaint' ya 'service_request' (backend `type`); purane backend par null = complaint
  String? type;
  String? typeLabel;
  bool canMarkCompleted;

  bool get isServiceRequest => type == 'service_request';

  Request({
    this.id,
    this.tokenLabel,
    this.tokenNumber,
    this.status,
    this.statusColor,
    this.isEmergency,
    this.emergencyIndicator,
    this.areaType,
    this.areaTypeLabel,
    this.title,
    this.location,
    this.resolutionPhoto,
    this.viewDetailsUrl,
    this.isOverdue,
    this.deadline,
    this.issueScope,
    this.ticketNumber,
    this.type,
    this.typeLabel,
    this.canMarkCompleted = false,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    final statusStr = json["status"]?.toString() ?? "";
    final deadlineStr =
        json["deadline"] ?? json["sla_target_date"] ?? json["target_date"];
    final bool isEmergencyVal =
        json["is_emergency"] == true ||
        json["is_emergency"] == 1 ||
        statusStr.toLowerCase().contains("emergency") ||
        statusStr.toLowerCase().contains("overdue");

    bool overdue =
        isEmergencyVal || json["is_overdue"] == true || json["is_overdue"] == 1;

    if (!overdue && deadlineStr != null) {
      final dt = DateTime.tryParse(deadlineStr.toString());
      final st = statusStr.toLowerCase();
      if (dt != null &&
          DateTime.now().isAfter(dt) &&
          st != "resolved" &&
          st != "completed" &&
          st != "closed") {
        overdue = true;
      }
    }

    final areaTypeVal =
        json["area_type"]?.toString() ??
        json["issue_scope"]?.toString() ??
        json["scope"]?.toString();

    final areaTypeLabelVal =
        json["area_type_label"]?.toString() ??
        (areaTypeVal == "common_area"
            ? "Common Area"
            : (areaTypeVal == "inside_house" ? "Inside House" : null));

    return Request(
      id: json["id"],
      tokenLabel: json["token_label"],
      tokenNumber: json["token_number"],
      status: json["status"],
      statusColor: json["status_color"],
      isEmergency: isEmergencyVal,
      emergencyIndicator: json["emergency_indicator"]?.toString(),
      areaType: areaTypeVal,
      areaTypeLabel: areaTypeLabelVal,
      title: json["title"],
      location: json["location"],
      resolutionPhoto: json["resolution_photo"]?.toString(),
      viewDetailsUrl: json["view_details_url"],
      isOverdue: overdue,
      deadline: deadlineStr?.toString(),
      issueScope: areaTypeVal,
      ticketNumber: json["ticket_number"]?.toString(),
      type: json["type"]?.toString(),
      typeLabel: json["type_label"]?.toString(),
      canMarkCompleted: json["can_mark_completed"] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "token_label": tokenLabel,
    "token_number": tokenNumber,
    "status": status,
    "status_color": statusColor,
    "is_emergency": isEmergency,
    "emergency_indicator": emergencyIndicator,
    "area_type": areaType,
    "area_type_label": areaTypeLabel,
    "title": title,
    "location": location,
    "resolution_photo": resolutionPhoto,
    "view_details_url": viewDetailsUrl,
    "is_overdue": isOverdue,
    "deadline": deadline,
    "issue_scope": issueScope,
    "ticket_number": ticketNumber,
    "type": type,
    "type_label": typeLabel,
    "can_mark_completed": canMarkCompleted,
  };
}
