// To parse this JSON data, do
//
//     final historyRecordsResModel = historyRecordsResModelFromJson(jsonString);

import 'dart:convert';

HistoryRecordsResModel historyRecordsResModelFromJson(String str) =>
    HistoryRecordsResModel.fromJson(json.decode(str));

String historyRecordsResModelToJson(HistoryRecordsResModel data) =>
    json.encode(data.toJson());

class HistoryRecordsResModel {
  bool? status;
  String? message;
  Data? data;

  HistoryRecordsResModel({this.status, this.message, this.data});

  factory HistoryRecordsResModel.fromJson(Map<String, dynamic> json) =>
      HistoryRecordsResModel(
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
  List<FilterChip>? tabs;
  List<FilterChip>? filterChips;
  List<Record>? records;

  Data({this.header, this.tabs, this.filterChips, this.records});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    header: json["header"] == null ? null : Header.fromJson(json["header"]),
    tabs: json["tabs"] == null
        ? []
        : List<FilterChip>.from(
            json["tabs"]!.map((x) => FilterChip.fromJson(x)),
          ),
    filterChips: json["filter_chips"] == null
        ? []
        : List<FilterChip>.from(
            json["filter_chips"]!.map((x) => FilterChip.fromJson(x)),
          ),
    records: json["records"] == null
        ? []
        : List<Record>.from(json["records"]!.map((x) => Record.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "header": header?.toJson(),
    "tabs": tabs == null
        ? []
        : List<dynamic>.from(tabs!.map((x) => x.toJson())),
    "filter_chips": filterChips == null
        ? []
        : List<dynamic>.from(filterChips!.map((x) => x.toJson())),
    "records": records == null
        ? []
        : List<dynamic>.from(records!.map((x) => x.toJson())),
  };
}

class FilterChip {
  String? key;
  String? label;
  bool? isActive;

  FilterChip({this.key, this.label, this.isActive});

  factory FilterChip.fromJson(Map<String, dynamic> json) => FilterChip(
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
  String? title;
  String? subtitle;

  Header({this.title, this.subtitle});

  factory Header.fromJson(Map<String, dynamic> json) =>
      Header(title: json["title"], subtitle: json["subtitle"]);

  Map<String, dynamic> toJson() => {"title": title, "subtitle": subtitle};
}

class Record {
  String? id;
  int? rawId;
  String? type;
  String? title;
  String? name;
  String? visitorName;
  String? categoryLabel;
  String? badge;
  String? badgeColor;
  String? inTime;
  String? outTime;
  String? date;
  String? statusNote;
  bool? canMarkExit;
  ActionButton? actionButton;
  List<Grid>? grid;
  String? avatarUrl;
  DateTime? createdAt;
  String? vendorName;
  String? receivedTime;
  String? handoverTime;

  Record({
    this.id,
    this.rawId,
    this.type,
    this.title,
    this.name,
    this.visitorName,
    this.categoryLabel,
    this.badge,
    this.badgeColor,
    this.inTime,
    this.outTime,
    this.date,
    this.statusNote,
    this.canMarkExit,
    this.actionButton,
    this.grid,
    this.avatarUrl,
    this.createdAt,
    this.vendorName,
    this.receivedTime,
    this.handoverTime,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    id: json["id"],
    rawId: json["raw_id"],
    type: json["type"],
    title: json["title"],
    name: json["name"],
    visitorName: json["visitor_name"],
    categoryLabel: json["category_label"],
    badge: json["badge"],
    badgeColor: json["badge_color"],
    inTime: json["in_time"],
    outTime: json["out_time"],
    date: json["date"],
    statusNote: json["status_note"],
    canMarkExit: json["can_mark_exit"],
    actionButton: json["action_button"] == null
        ? null
        : ActionButton.fromJson(json["action_button"]),
    grid: json["grid"] == null
        ? []
        : List<Grid>.from(json["grid"]!.map((x) => Grid.fromJson(x))),
    avatarUrl: json["avatar_url"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    vendorName: json["vendor_name"],
    receivedTime: json["received_time"],
    handoverTime: json["handover_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "raw_id": rawId,
    "type": type,
    "title": title,
    "name": name,
    "visitor_name": visitorName,
    "category_label": categoryLabel,
    "badge": badge,
    "badge_color": badgeColor,
    "in_time": inTime,
    "out_time": outTime,
    "date": date,
    "status_note": statusNote,
    "can_mark_exit": canMarkExit,
    "action_button": actionButton?.toJson(),
    "grid": grid == null
        ? []
        : List<dynamic>.from(grid!.map((x) => x.toJson())),
    "avatar_url": avatarUrl,
    "created_at": createdAt?.toIso8601String(),
    "vendor_name": vendorName,
    "received_time": receivedTime,
    "handover_time": handoverTime,
  };
}

class ActionButton {
  String? label;
  String? action;
  String? endpoint;
  bool? isEnabled;

  ActionButton({this.label, this.action, this.endpoint, this.isEnabled});

  factory ActionButton.fromJson(Map<String, dynamic> json) => ActionButton(
    label: json["label"],
    action: json["action"],
    endpoint: json["endpoint"],
    isEnabled: json["is_enabled"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "action": action,
    "endpoint": endpoint,
    "is_enabled": isEnabled,
  };
}

class Grid {
  String? label;
  String? value;

  Grid({this.label, this.value});

  factory Grid.fromJson(Map<String, dynamic> json) =>
      Grid(label: json["label"], value: json["value"]);

  Map<String, dynamic> toJson() => {"label": label, "value": value};
}
