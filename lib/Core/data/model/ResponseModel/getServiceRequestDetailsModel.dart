// To parse this JSON data, do
//
//     final getServiceRequestDetailsModel = getServiceRequestDetailsModelFromJson(jsonString);

import 'dart:convert';

GetServiceRequestDetailsModel getServiceRequestDetailsModelFromJson(String str) => GetServiceRequestDetailsModel.fromJson(json.decode(str));

String getServiceRequestDetailsModelToJson(GetServiceRequestDetailsModel data) => json.encode(data.toJson());

class GetServiceRequestDetailsModel {
    bool? status;
    Data? data;

    GetServiceRequestDetailsModel({
        this.status,
        this.data,
    });

    factory GetServiceRequestDetailsModel.fromJson(Map<String, dynamic> json) => GetServiceRequestDetailsModel(
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
    TicketBanner? ticketBanner;
    RaisedBy? raisedBy;
    RequestInformation? requestInformation;
    IssueDescription? issueDescription;
    Priority? priority;
    AssignedService? assignedService;
    List<CurrentStatus>? currentStatus;
    ActionButton? actionButton;

    Data({
        this.header,
        this.ticketBanner,
        this.raisedBy,
        this.requestInformation,
        this.issueDescription,
        this.priority,
        this.assignedService,
        this.currentStatus,
        this.actionButton,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        ticketBanner: json["ticket_banner"] == null ? null : TicketBanner.fromJson(json["ticket_banner"]),
        raisedBy: json["raised_by"] == null ? null : RaisedBy.fromJson(json["raised_by"]),
        requestInformation: json["request_information"] == null ? null : RequestInformation.fromJson(json["request_information"]),
        issueDescription: json["issue_description"] == null ? null : IssueDescription.fromJson(json["issue_description"]),
        priority: json["priority"] == null ? null : Priority.fromJson(json["priority"]),
        assignedService: json["assigned_service"] == null ? null : AssignedService.fromJson(json["assigned_service"]),
        currentStatus: json["current_status"] == null ? [] : List<CurrentStatus>.from(json["current_status"]!.map((x) => CurrentStatus.fromJson(x))),
        actionButton: json["action_button"] == null ? null : ActionButton.fromJson(json["action_button"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "ticket_banner": ticketBanner?.toJson(),
        "raised_by": raisedBy?.toJson(),
        "request_information": requestInformation?.toJson(),
        "issue_description": issueDescription?.toJson(),
        "priority": priority?.toJson(),
        "assigned_service": assignedService?.toJson(),
        "current_status": currentStatus == null ? [] : List<dynamic>.from(currentStatus!.map((x) => x.toJson())),
        "action_button": actionButton?.toJson(),
    };
}

class ActionButton {
    String? label;
    String? trackingUrl;

    ActionButton({
        this.label,
        this.trackingUrl,
    });

    factory ActionButton.fromJson(Map<String, dynamic> json) => ActionButton(
        label: json["label"],
        trackingUrl: json["tracking_url"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "tracking_url": trackingUrl,
    };
}

class AssignedService {
    int? providerId;
    String? providerName;
    String? category;
    String? subtitle;
    String? status;
    String? contact;
    String? actionText;

    AssignedService({
        this.providerId,
        this.providerName,
        this.category,
        this.subtitle,
        this.status,
        this.contact,
        this.actionText,
    });

    factory AssignedService.fromJson(Map<String, dynamic> json) => AssignedService(
        providerId: json["provider_id"],
        providerName: json["provider_name"],
        category: json["category"],
        subtitle: json["subtitle"],
        status: json["status"],
        contact: json["contact"],
        actionText: json["action_text"],
    );

    Map<String, dynamic> toJson() => {
        "provider_id": providerId,
        "provider_name": providerName,
        "category": category,
        "subtitle": subtitle,
        "status": status,
        "contact": contact,
        "action_text": actionText,
    };
}

class CurrentStatus {
    int? step;
    String? title;
    String? dateTime;
    bool? isCompleted;
    bool? isCurrent;

    CurrentStatus({
        this.step,
        this.title,
        this.dateTime,
        this.isCompleted,
        this.isCurrent,
    });

    factory CurrentStatus.fromJson(Map<String, dynamic> json) => CurrentStatus(
        step: json["step"],
        title: json["title"],
        dateTime: json["date_time"],
        isCompleted: json["is_completed"],
        isCurrent: json["is_current"],
    );

    Map<String, dynamic> toJson() => {
        "step": step,
        "title": title,
        "date_time": dateTime,
        "is_completed": isCompleted,
        "is_current": isCurrent,
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

class IssueDescription {
    String? title;
    String? description;

    IssueDescription({
        this.title,
        this.description,
    });

    factory IssueDescription.fromJson(Map<String, dynamic> json) => IssueDescription(
        title: json["title"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
    };
}

class Priority {
    String? title;
    String? subtitle;
    String? level;
    bool? isHigh;

    Priority({
        this.title,
        this.subtitle,
        this.level,
        this.isHigh,
    });

    factory Priority.fromJson(Map<String, dynamic> json) => Priority(
        title: json["title"],
        subtitle: json["subtitle"],
        level: json["level"],
        isHigh: json["is_high"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "level": level,
        "is_high": isHigh,
    };
}

class RaisedBy {
    String? name;
    String? role;
    String? avatar;
    String? unitBadge;
    String? flatNumber;
    String? contact;

    RaisedBy({
        this.name,
        this.role,
        this.avatar,
        this.unitBadge,
        this.flatNumber,
        this.contact,
    });

    factory RaisedBy.fromJson(Map<String, dynamic> json) => RaisedBy(
        name: json["name"],
        role: json["role"],
        avatar: json["avatar"],
        unitBadge: json["unit_badge"],
        flatNumber: json["flat_number"],
        contact: json["contact"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "role": role,
        "avatar": avatar,
        "unit_badge": unitBadge,
        "flat_number": flatNumber,
        "contact": contact,
    };
}

class RequestInformation {
    String? requestType;
    String? category;
    String? location;
    String? preferredVisit;
    List<Item>? items;

    RequestInformation({
        this.requestType,
        this.category,
        this.location,
        this.preferredVisit,
        this.items,
    });

    factory RequestInformation.fromJson(Map<String, dynamic> json) => RequestInformation(
        requestType: json["request_type"],
        category: json["category"],
        location: json["location"],
        preferredVisit: json["preferred_visit"],
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "request_type": requestType,
        "category": category,
        "location": location,
        "preferred_visit": preferredVisit,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class Item {
    String? label;
    String? value;

    Item({
        this.label,
        this.value,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        label: json["label"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
    };
}

class TicketBanner {
    String? tag;
    String? ticketNumber;
    String? status;
    String? statusKey;
    String? title;
    String? subtitle;
    String? raisedOn;
    String? lastUpdated;

    TicketBanner({
        this.tag,
        this.ticketNumber,
        this.status,
        this.statusKey,
        this.title,
        this.subtitle,
        this.raisedOn,
        this.lastUpdated,
    });

    factory TicketBanner.fromJson(Map<String, dynamic> json) => TicketBanner(
        tag: json["tag"],
        ticketNumber: json["ticket_number"],
        status: json["status"],
        statusKey: json["status_key"],
        title: json["title"],
        subtitle: json["subtitle"],
        raisedOn: json["raised_on"],
        lastUpdated: json["last_updated"],
    );

    Map<String, dynamic> toJson() => {
        "tag": tag,
        "ticket_number": ticketNumber,
        "status": status,
        "status_key": statusKey,
        "title": title,
        "subtitle": subtitle,
        "raised_on": raisedOn,
        "last_updated": lastUpdated,
    };
}
