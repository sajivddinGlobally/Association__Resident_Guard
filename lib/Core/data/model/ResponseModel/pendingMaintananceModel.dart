// To parse this JSON data, do
//
//     final pendingMaintenanceModel = pendingMaintenanceModelFromJson(jsonString);

import 'dart:convert';

PendingMaintenanceModel pendingMaintenanceModelFromJson(String str) => PendingMaintenanceModel.fromJson(json.decode(str));

String pendingMaintenanceModelToJson(PendingMaintenanceModel data) => json.encode(data.toJson());

class PendingMaintenanceModel {
    bool? status;
    String? message;
    Data? data;

    PendingMaintenanceModel({
        this.status,
        this.message,
        this.data,
    });

    factory PendingMaintenanceModel.fromJson(Map<String, dynamic> json) => PendingMaintenanceModel(
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
    Overview? overview;
    List<FilterChip>? filterChips;
    OpenRequests? openRequests;
    String? footerNote;

    Data({
        this.header,
        this.overview,
        this.filterChips,
        this.openRequests,
        this.footerNote,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        overview: json["overview"] == null ? null : Overview.fromJson(json["overview"]),
        filterChips: json["filter_chips"] == null ? [] : List<FilterChip>.from(json["filter_chips"]!.map((x) => FilterChip.fromJson(x))),
        openRequests: json["open_requests"] == null ? null : OpenRequests.fromJson(json["open_requests"]),
        footerNote: json["footer_note"],
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "overview": overview?.toJson(),
        "filter_chips": filterChips == null ? [] : List<dynamic>.from(filterChips!.map((x) => x.toJson())),
        "open_requests": openRequests?.toJson(),
        "footer_note": footerNote,
    };
}

class FilterChip {
    String? key;
    String? label;
    int? count;
    bool? isActive;

    FilterChip({
        this.key,
        this.label,
        this.count,
        this.isActive,
    });

    factory FilterChip.fromJson(Map<String, dynamic> json) => FilterChip(
        key: json["key"],
        label: json["label"],
        count: json["count"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "label": label,
        "count": count,
        "is_active": isActive,
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

class OpenRequests {
    String? countLabel;
    List<Record>? records;

    OpenRequests({
        this.countLabel,
        this.records,
    });

    factory OpenRequests.fromJson(Map<String, dynamic> json) => OpenRequests(
        countLabel: json["count_label"],
        records: json["records"] == null ? [] : List<Record>.from(json["records"]!.map((x) => Record.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count_label": countLabel,
        "records": records == null ? [] : List<dynamic>.from(records!.map((x) => x.toJson())),
    };
}

class Record {
    int? id;
    String? requestCode;
    String? title;
    String? subtitle;
    String? category;
    String? priority;
    String? priorityRaw;
    String? propertyUnit;
    String? raisedOn;
    String? status;
    String? statusRaw;
    String? expectedCompletion;
    String? costReference;
    String? assignedPersonVendor;
    String? viewDetailsUrl;

    Record({
        this.id,
        this.requestCode,
        this.title,
        this.subtitle,
        this.category,
        this.priority,
        this.priorityRaw,
        this.propertyUnit,
        this.raisedOn,
        this.status,
        this.statusRaw,
        this.expectedCompletion,
        this.costReference,
        this.assignedPersonVendor,
        this.viewDetailsUrl,
    });

    factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"],
        requestCode: json["request_code"],
        title: json["title"],
        subtitle: json["subtitle"],
        category: json["category"],
        priority: json["priority"],
        priorityRaw: json["priority_raw"],
        propertyUnit: json["property_unit"],
        raisedOn: json["raised_on"],
        status: json["status"],
        statusRaw: json["status_raw"],
        expectedCompletion: json["expected_completion"],
        costReference: json["cost_reference"],
        assignedPersonVendor: json["assigned_person_vendor"],
        viewDetailsUrl: json["view_details_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "request_code": requestCode,
        "title": title,
        "subtitle": subtitle,
        "category": category,
        "priority": priority,
        "priority_raw": priorityRaw,
        "property_unit": propertyUnit,
        "raised_on": raisedOn,
        "status": status,
        "status_raw": statusRaw,
        "expected_completion": expectedCompletion,
        "cost_reference": costReference,
        "assigned_person_vendor": assignedPersonVendor,
        "view_details_url": viewDetailsUrl,
    };
}

class Overview {
    String? title;
    String? description;
    String? statusBadge;
    int? openItemsCount;
    SummaryMetrics? summaryMetrics;

    Overview({
        this.title,
        this.description,
        this.statusBadge,
        this.openItemsCount,
        this.summaryMetrics,
    });

    factory Overview.fromJson(Map<String, dynamic> json) => Overview(
        title: json["title"],
        description: json["description"],
        statusBadge: json["status_badge"],
        openItemsCount: json["open_items_count"],
        summaryMetrics: json["summary_metrics"] == null ? null : SummaryMetrics.fromJson(json["summary_metrics"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "status_badge": statusBadge,
        "open_items_count": openItemsCount,
        "summary_metrics": summaryMetrics?.toJson(),
    };
}

class SummaryMetrics {
    String? highPriority;
    String? inProgress;
    String? awaitingAction;

    SummaryMetrics({
        this.highPriority,
        this.inProgress,
        this.awaitingAction,
    });

    factory SummaryMetrics.fromJson(Map<String, dynamic> json) => SummaryMetrics(
        highPriority: json["high_priority"],
        inProgress: json["in_progress"],
        awaitingAction: json["awaiting_action"],
    );

    Map<String, dynamic> toJson() => {
        "high_priority": highPriority,
        "in_progress": inProgress,
        "awaiting_action": awaitingAction,
    };
}
