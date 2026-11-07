// To parse this JSON data, do
//
//     final getComplaintDetailsResModel = getComplaintDetailsResModelFromJson(jsonString);

import 'dart:convert';

GetComplaintDetailsResModel getComplaintDetailsResModelFromJson(String str) =>
    GetComplaintDetailsResModel.fromJson(json.decode(str));

String getComplaintDetailsResModelToJson(GetComplaintDetailsResModel data) =>
    json.encode(data.toJson());

class GetComplaintDetailsResModel {
  final bool status;
  final Data data;

  GetComplaintDetailsResModel({required this.status, required this.data});

  factory GetComplaintDetailsResModel.fromJson(Map<String, dynamic> json) =>
      GetComplaintDetailsResModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data.toJson()};
}

class Data {
  final Header header;
  final Banner banner;
  final ComplaintInformation complaintInformation;
  final Description description;
  final AssignedPerson assignedPerson;
  final Attachments attachments;
  final CurrentResolutionUpdate currentResolutionUpdate;
  final List<ComplaintActivity> complaintActivity;
  final ActionButton actionButton;

  Data({
    required this.header,
    required this.banner,
    required this.complaintInformation,
    required this.description,
    required this.assignedPerson,
    required this.attachments,
    required this.currentResolutionUpdate,
    required this.complaintActivity,
    required this.actionButton,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    header: Header.fromJson(json["header"]),
    banner: Banner.fromJson(json["banner"]),
    complaintInformation: ComplaintInformation.fromJson(
      json["complaint_information"],
    ),
    description: Description.fromJson(json["description"]),
    assignedPerson: AssignedPerson.fromJson(json["assigned_person"]),
    attachments: Attachments.fromJson(json["attachments"]),
    currentResolutionUpdate: CurrentResolutionUpdate.fromJson(
      json["current_resolution_update"],
    ),
    complaintActivity: List<ComplaintActivity>.from(
      json["complaint_activity"].map((x) => ComplaintActivity.fromJson(x)),
    ),
    actionButton: ActionButton.fromJson(json["action_button"]),
  );

  Map<String, dynamic> toJson() => {
    "header": header.toJson(),
    "banner": banner.toJson(),
    "complaint_information": complaintInformation.toJson(),
    "description": description.toJson(),
    "assigned_person": assignedPerson.toJson(),
    "attachments": attachments.toJson(),
    "current_resolution_update": currentResolutionUpdate.toJson(),
    "complaint_activity": List<dynamic>.from(
      complaintActivity.map((x) => x.toJson()),
    ),
    "action_button": actionButton.toJson(),
  };
}

class ActionButton {
  final String label;
  final String trackingUrl;

  ActionButton({required this.label, required this.trackingUrl});

  factory ActionButton.fromJson(Map<String, dynamic> json) =>
      ActionButton(label: json["label"], trackingUrl: json["tracking_url"]);

  Map<String, dynamic> toJson() => {
    "label": label,
    "tracking_url": trackingUrl,
  };
}

class AssignedPerson {
  final String name;
  final String subtitle;
  final String status;
  final dynamic avatar;

  AssignedPerson({
    required this.name,
    required this.subtitle,
    required this.status,
    required this.avatar,
  });

  factory AssignedPerson.fromJson(Map<String, dynamic> json) => AssignedPerson(
    name: json["name"],
    subtitle: json["subtitle"],
    status: json["status"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "subtitle": subtitle,
    "status": status,
    "avatar": avatar,
  };
}

class Attachments {
  final ComplaintPhoto complaintPhoto;
  final ComplaintPhoto supportingDocument;

  Attachments({required this.complaintPhoto, required this.supportingDocument});

  factory Attachments.fromJson(Map<String, dynamic> json) => Attachments(
    complaintPhoto: ComplaintPhoto.fromJson(json["complaint_photo"]),
    supportingDocument: ComplaintPhoto.fromJson(json["supporting_document"]),
  );

  Map<String, dynamic> toJson() => {
    "complaint_photo": complaintPhoto.toJson(),
    "supporting_document": supportingDocument.toJson(),
  };
}

class ComplaintPhoto {
  String? title;
  String? url;
  String? action;

  ComplaintPhoto({this.title, this.url, this.action});

  factory ComplaintPhoto.fromJson(Map<String, dynamic> json) => ComplaintPhoto(
    title: json["title"],
    url: json["url"],
    action: json["action"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "url": url,
    "action": action,
  };
}

class Banner {
  final String thumbnail;
  final String title;
  final String ticketNumber;
  final String? status;
  final String? statusRaw;
  final String? statusBadge;
  final String priority;
  final String priorityBadge;
  final List<StatusStepper> statusStepper;

  Banner({
    required this.thumbnail,
    required this.title,
    required this.ticketNumber,
    this.status,
    this.statusRaw,
    this.statusBadge,
    required this.priority,
    required this.priorityBadge,
    required this.statusStepper,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    thumbnail: json["thumbnail"] ?? "",
    title: json["title"] ?? "",
    ticketNumber: json["ticket_number"] ?? "",
    status: json["status"]?.toString(),
    statusRaw: json["status_raw"]?.toString(),
    statusBadge: json["status_badge"]?.toString(),
    priority: json["priority"] ?? "",
    priorityBadge: json["priority_badge"] ?? "",
    statusStepper: json["status_stepper"] != null
        ? List<StatusStepper>.from(
            json["status_stepper"].map((x) => StatusStepper.fromJson(x)),
          )
        : [],
  );

  Map<String, dynamic> toJson() => {
    "thumbnail": thumbnail,
    "title": title,
    "ticket_number": ticketNumber,
    "status": status,
    "status_raw": statusRaw,
    "status_badge": statusBadge,
    "priority": priority,
    "priority_badge": priorityBadge,
    "status_stepper": List<dynamic>.from(statusStepper.map((x) => x.toJson())),
  };
}

class StatusStepper {
  final String name;
  final bool isCompleted;
  final bool isCurrent;

  StatusStepper({
    required this.name,
    required this.isCompleted,
    required this.isCurrent,
  });

  factory StatusStepper.fromJson(Map<String, dynamic> json) => StatusStepper(
    name: json["name"] ?? "",
    isCompleted: json["is_completed"] ?? false,
    isCurrent: json["is_current"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "is_completed": isCompleted,
    "is_current": isCurrent,
  };
}

class ComplaintActivity {
  final int step;
  final String title;
  final String timestamp;
  final String note;
  final bool isCompleted;

  ComplaintActivity({
    required this.step,
    required this.title,
    required this.timestamp,
    required this.note,
    required this.isCompleted,
  });

  factory ComplaintActivity.fromJson(Map<String, dynamic> json) =>
      ComplaintActivity(
        step: json["step"] ?? 0,
        title: json["title"] ?? "",
        timestamp: json["timestamp"] ?? "",
        note: json["note"] ?? "",
        isCompleted: json["is_completed"] ?? false,
      );

  Map<String, dynamic> toJson() => {
    "step": step,
    "title": title,
    "timestamp": timestamp,
    "note": note,
    "is_completed": isCompleted,
  };
}

class ComplaintInformation {
  final String propertyUnit;
  final String category;
  final String submittedBy;
  final String submittedDate;
  final String urgency;
  final String? status;
  final String? areaType;
  final String? areaTypeLabel;
  final String? location;
  final List<Item> items;

  ComplaintInformation({
    required this.propertyUnit,
    required this.category,
    required this.submittedBy,
    required this.submittedDate,
    required this.urgency,
    this.status,
    this.areaType,
    this.areaTypeLabel,
    this.location,
    required this.items,
  });

  factory ComplaintInformation.fromJson(Map<String, dynamic> json) =>
      ComplaintInformation(
        propertyUnit: json["property_unit"] ?? "",
        category: json["category"] ?? "",
        submittedBy: json["submitted_by"] ?? "",
        submittedDate: json["submitted_date"] ?? "",
        urgency: json["urgency"] ?? "",
        status: json["status"]?.toString(),
        areaType: json["area_type"]?.toString(),
        areaTypeLabel: json["area_type_label"]?.toString(),
        location: json["location"]?.toString(),
        items: json["items"] != null
            ? List<Item>.from(json["items"].map((x) => Item.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
    "property_unit": propertyUnit,
    "category": category,
    "submitted_by": submittedBy,
    "submitted_date": submittedDate,
    "urgency": urgency,
    "status": status,
    "area_type": areaType,
    "area_type_label": areaTypeLabel,
    "location": location,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  String? label;
  String? value;

  Item({this.label, this.value});

  factory Item.fromJson(Map<String, dynamic> json) =>
      Item(label: json["label"], value: json["value"]);

  Map<String, dynamic> toJson() => {"label": label, "value": value};
}

class CurrentResolutionUpdate {
  final String title;
  final String message;

  CurrentResolutionUpdate({required this.title, required this.message});

  factory CurrentResolutionUpdate.fromJson(Map<String, dynamic> json) =>
      CurrentResolutionUpdate(title: json["title"], message: json["message"]);

  Map<String, dynamic> toJson() => {"title": title, "message": message};
}

class Description {
  final String title;
  final String content;

  Description({required this.title, required this.content});

  factory Description.fromJson(Map<String, dynamic> json) =>
      Description(title: json["title"], content: json["content"]);

  Map<String, dynamic> toJson() => {"title": title, "content": content};
}

class Header {
  final String title;
  final String subtitle;

  Header({required this.title, required this.subtitle});

  factory Header.fromJson(Map<String, dynamic> json) =>
      Header(title: json["title"], subtitle: json["subtitle"]);

  Map<String, dynamic> toJson() => {"title": title, "subtitle": subtitle};
}
