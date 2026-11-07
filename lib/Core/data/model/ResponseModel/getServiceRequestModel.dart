// To parse this JSON data, do
//
//     final getServiceRequestModel = getServiceRequestModelFromJson(jsonString);

import 'dart:convert';

GetServiceRequestModel getServiceRequestModelFromJson(String str) =>
    GetServiceRequestModel.fromJson(json.decode(str));

String getServiceRequestModelToJson(GetServiceRequestModel data) =>
    json.encode(data.toJson());

class GetServiceRequestModel {
  bool? status;
  Data? data;

  GetServiceRequestModel({this.status, this.data});

  factory GetServiceRequestModel.fromJson(Map<String, dynamic> json) =>
      GetServiceRequestModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  Header? header;
  StatCards? statCards;
  Filters? filters;
  Summary? summary;
  List<Request>? requests;
  RequestSummary? requestSummary;

  Data({
    this.header,
    this.statCards,
    this.filters,
    this.summary,
    this.requests,
    this.requestSummary,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    header: json["header"] == null ? null : Header.fromJson(json["header"]),
    statCards: json["stat_cards"] == null
        ? null
        : StatCards.fromJson(json["stat_cards"]),
    filters: json["filters"] == null ? null : Filters.fromJson(json["filters"]),
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
    requests: json["requests"] == null
        ? []
        : List<Request>.from(json["requests"]!.map((x) => Request.fromJson(x))),
    requestSummary: json["request_summary"] == null
        ? null
        : RequestSummary.fromJson(json["request_summary"]),
  );

  Map<String, dynamic> toJson() => {
    "header": header?.toJson(),
    "stat_cards": statCards?.toJson(),
    "filters": filters?.toJson(),
    "summary": summary?.toJson(),
    "requests": requests == null
        ? []
        : List<dynamic>.from(requests!.map((x) => x.toJson())),
    "request_summary": requestSummary?.toJson(),
  };
}

class Filters {
  String? active;
  List<String>? options;

  Filters({this.active, this.options});

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
    active: json["active"],
    options: json["options"] == null
        ? []
        : List<String>.from(json["options"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "active": active,
    "options": options == null
        ? []
        : List<dynamic>.from(options!.map((x) => x)),
  };
}

class Header {
  String? title;
  String? subtitle;

  Header({this.title, this.subtitle});

  factory Header.fromJson(Map<String, dynamic> json) =>
      Header(title: json["title"], subtitle: json["subtitle"]);

  Map<String, dynamic> toJson() => {"title": title, "subtitle": subtitle};
}

class RequestSummary {
  InProgress? pending;
  InProgress? inProgress;

  RequestSummary({this.pending, this.inProgress});

  factory RequestSummary.fromJson(Map<String, dynamic> json) => RequestSummary(
    pending: json["pending"] == null
        ? null
        : InProgress.fromJson(json["pending"]),
    inProgress: json["in_progress"] == null
        ? null
        : InProgress.fromJson(json["in_progress"]),
  );

  Map<String, dynamic> toJson() => {
    "pending": pending?.toJson(),
    "in_progress": inProgress?.toJson(),
  };
}

class InProgress {
  String? value;
  String? label;
  String? subtitle;

  InProgress({this.value, this.label, this.subtitle});

  factory InProgress.fromJson(Map<String, dynamic> json) => InProgress(
    value: json["value"]?.toString(),
    label: json["label"]?.toString(),
    subtitle: json["subtitle"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
    "subtitle": subtitle,
  };
}

class Request {
  int? id;
  String? ticketNumber;
  String? title;
  String? subtitle;
  String? type;
  String? category;
  String? flatNumber;
  String? residentName;
  String? status;
  String? statusLabel;
  String? priority;
  bool? isHighPriority;
  String? date;
  String? fullDate;
  String? viewDetailsUrl;

  Request({
    this.id,
    this.ticketNumber,
    this.title,
    this.subtitle,
    this.type,
    this.category,
    this.flatNumber,
    this.residentName,
    this.status,
    this.statusLabel,
    this.priority,
    this.isHighPriority,
    this.date,
    this.fullDate,
    this.viewDetailsUrl,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    id: json["id"],
    ticketNumber: json["ticket_number"],
    title: json["title"],
    subtitle: json["subtitle"],
    type: json["type"],
    category: json["category"],
    flatNumber: json["flat_number"],
    residentName: json["resident_name"],
    status: json["status"],
    statusLabel: json["status_label"],
    priority: json["priority"],
    isHighPriority: json["is_high_priority"],
    date: json["date"],
    fullDate: json["full_date"],
    viewDetailsUrl: json["view_details_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ticket_number": ticketNumber,
    "title": title,
    "subtitle": subtitle,
    "type": type,
    "category": category,
    "flat_number": flatNumber,
    "resident_name": residentName,
    "status": status,
    "status_label": statusLabel,
    "priority": priority,
    "is_high_priority": isHighPriority,
    "date": date,
    "full_date": fullDate,
    "view_details_url": viewDetailsUrl,
  };
}

class StatCards {
  InProgress? activeRequests;
  InProgress? resolved;

  StatCards({this.activeRequests, this.resolved});

  factory StatCards.fromJson(Map<String, dynamic> json) => StatCards(
    activeRequests: json["active_requests"] == null
        ? null
        : InProgress.fromJson(json["active_requests"]),
    resolved: json["resolved"] == null
        ? null
        : InProgress.fromJson(json["resolved"]),
  );

  Map<String, dynamic> toJson() => {
    "active_requests": activeRequests?.toJson(),
    "resolved": resolved?.toJson(),
  };
}

class Summary {
  int? totalCount;
  String? totalLabel;
  int? filteredCount;

  Summary({this.totalCount, this.totalLabel, this.filteredCount});

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalCount: json["total_count"],
    totalLabel: json["total_label"],
    filteredCount: json["filtered_count"],
  );

  Map<String, dynamic> toJson() => {
    "total_count": totalCount,
    "total_label": totalLabel,
    "filtered_count": filteredCount,
  };
}
