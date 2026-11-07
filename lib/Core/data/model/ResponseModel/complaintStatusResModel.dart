// To parse this JSON data, do
//
//     final complaintStatusResModel = complaintStatusResModelFromJson(jsonString);

import 'dart:convert';

ComplaintStatusResModel complaintStatusResModelFromJson(String str) =>
    ComplaintStatusResModel.fromJson(json.decode(str));

String complaintStatusResModelToJson(ComplaintStatusResModel data) =>
    json.encode(data.toJson());

class ComplaintStatusResModel {
  final bool status;
  final Data data;

  ComplaintStatusResModel({required this.status, required this.data});

  factory ComplaintStatusResModel.fromJson(Map<String, dynamic> json) =>
      ComplaintStatusResModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data.toJson()};
}

class Data {
  final Header header;
  final TicketCard ticketCard;
  final CurrentStatusCard currentStatusCard;
  final List<StatusTimeline> statusTimeline;
  final ComplaintInformation complaintInformation;
  final LatestUpdate latestUpdate;

  Data({
    required this.header,
    required this.ticketCard,
    required this.currentStatusCard,
    required this.statusTimeline,
    required this.complaintInformation,
    required this.latestUpdate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    header: Header.fromJson(json["header"]),
    ticketCard: TicketCard.fromJson(json["ticket_card"]),
    currentStatusCard: CurrentStatusCard.fromJson(json["current_status_card"]),
    statusTimeline: List<StatusTimeline>.from(
      json["status_timeline"].map((x) => StatusTimeline.fromJson(x)),
    ),
    complaintInformation: ComplaintInformation.fromJson(
      json["complaint_information"],
    ),
    latestUpdate: LatestUpdate.fromJson(json["latest_update"]),
  );

  Map<String, dynamic> toJson() => {
    "header": header.toJson(),
    "ticket_card": ticketCard.toJson(),
    "current_status_card": currentStatusCard.toJson(),
    "status_timeline": List<dynamic>.from(
      statusTimeline.map((x) => x.toJson()),
    ),
    "complaint_information": complaintInformation.toJson(),
    "latest_update": latestUpdate.toJson(),
  };
}

class ComplaintInformation {
  final String issue;
  final String category;
  final String priority;

  ComplaintInformation({
    required this.issue,
    required this.category,
    required this.priority,
  });

  factory ComplaintInformation.fromJson(Map<String, dynamic> json) =>
      ComplaintInformation(
        issue: json["issue"],
        category: json["category"],
        priority: json["priority"],
      );

  Map<String, dynamic> toJson() => {
    "issue": issue,
    "category": category,
    "priority": priority,
  };
}

class CurrentStatusCard {
  final String statusHeadline;
  final String message;

  CurrentStatusCard({required this.statusHeadline, required this.message});

  factory CurrentStatusCard.fromJson(Map<String, dynamic> json) =>
      CurrentStatusCard(
        statusHeadline: json["status_headline"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "status_headline": statusHeadline,
    "message": message,
  };
}

class Header {
  final String title;
  final String subtitle;

  Header({required this.title, required this.subtitle});

  factory Header.fromJson(Map<String, dynamic> json) =>
      Header(title: json["title"], subtitle: json["subtitle"]);

  Map<String, dynamic> toJson() => {"title": title, "subtitle": subtitle};
}

class LatestUpdate {
  final String title;
  final String note;

  LatestUpdate({required this.title, required this.note});

  factory LatestUpdate.fromJson(Map<String, dynamic> json) =>
      LatestUpdate(title: json["title"], note: json["note"]);

  Map<String, dynamic> toJson() => {"title": title, "note": note};
}

class StatusTimeline {
  final int stage;
  final String title;
  final String description;
  final String date;
  final String status;
  final bool isCompleted;
  final bool? isCurrent;

  StatusTimeline({
    required this.stage,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.isCompleted,
    this.isCurrent,
  });

  factory StatusTimeline.fromJson(Map<String, dynamic> json) => StatusTimeline(
    stage: json["stage"],
    title: json["title"],
    description: json["description"],
    date: json["date"],
    status: json["status"],
    isCompleted: json["is_completed"],
    isCurrent: json["is_current"],
  );

  Map<String, dynamic> toJson() => {
    "stage": stage,
    "title": title,
    "description": description,
    "date": date,
    "status": status,
    "is_completed": isCompleted,
    "is_current": isCurrent,
  };
}

class TicketCard {
  final String tag;
  final String ticketNumber;
  final String status;
  final String statusPill;
  final String title;
  final String subtitle;
  final String unit;
  final String unitDisplay;
  final String date;

  TicketCard({
    required this.tag,
    required this.ticketNumber,
    required this.status,
    required this.statusPill,
    required this.title,
    required this.subtitle,
    required this.unit,
    required this.unitDisplay,
    required this.date,
  });

  factory TicketCard.fromJson(Map<String, dynamic> json) => TicketCard(
    tag: json["tag"],
    ticketNumber: json["ticket_number"],
    status: json["status"],
    statusPill: json["status_pill"],
    title: json["title"],
    subtitle: json["subtitle"],
    unit: json["unit"],
    unitDisplay: json["unit_display"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "tag": tag,
    "ticket_number": ticketNumber,
    "status": status,
    "status_pill": statusPill,
    "title": title,
    "subtitle": subtitle,
    "unit": unit,
    "unit_display": unitDisplay,
    "date": date,
  };
}