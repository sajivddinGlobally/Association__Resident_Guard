// To parse this JSON data, do
//
//     final associationComplaintResModel = associationComplaintResModelFromJson(jsonString);

import 'dart:convert';

AssociationComplaintResModel associationComplaintResModelFromJson(String str) => AssociationComplaintResModel.fromJson(json.decode(str));

String associationComplaintResModelToJson(AssociationComplaintResModel data) => json.encode(data.toJson());

class AssociationComplaintResModel {
    final bool status;
    final Data data;

    AssociationComplaintResModel({
        required this.status,
        required this.data,
    });

    factory AssociationComplaintResModel.fromJson(Map<String, dynamic> json) => AssociationComplaintResModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    final Header header;
    final ComplaintOverview complaintOverview;
    final Filters filters;
    final Summary summary;
    final List<Complaint> complaints;

    Data({
        required this.header,
        required this.complaintOverview,
        required this.filters,
        required this.summary,
        required this.complaints,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: Header.fromJson(json["header"]),
        complaintOverview: ComplaintOverview.fromJson(json["complaint_overview"]),
        filters: Filters.fromJson(json["filters"]),
        summary: Summary.fromJson(json["summary"]),
        complaints: List<Complaint>.from(json["complaints"].map((x) => Complaint.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "complaint_overview": complaintOverview.toJson(),
        "filters": filters.toJson(),
        "summary": summary.toJson(),
        "complaints": List<dynamic>.from(complaints.map((x) => x.toJson())),
    };
}

class ComplaintOverview {
    final String tag;
    final String title;
    final String subtitle;
    final int totalOpen;
    final String totalOpenLabel;
    final int highPriority;
    final String highPriorityLabel;
    final int inProgress;
    final String inProgressLabel;

    ComplaintOverview({
        required this.tag,
        required this.title,
        required this.subtitle,
        required this.totalOpen,
        required this.totalOpenLabel,
        required this.highPriority,
        required this.highPriorityLabel,
        required this.inProgress,
        required this.inProgressLabel,
    });

    factory ComplaintOverview.fromJson(Map<String, dynamic> json) => ComplaintOverview(
        tag: json["tag"],
        title: json["title"],
        subtitle: json["subtitle"],
        totalOpen: json["total_open"],
        totalOpenLabel: json["total_open_label"],
        highPriority: json["high_priority"],
        highPriorityLabel: json["high_priority_label"],
        inProgress: json["in_progress"],
        inProgressLabel: json["in_progress_label"],
    );

    Map<String, dynamic> toJson() => {
        "tag": tag,
        "title": title,
        "subtitle": subtitle,
        "total_open": totalOpen,
        "total_open_label": totalOpenLabel,
        "high_priority": highPriority,
        "high_priority_label": highPriorityLabel,
        "in_progress": inProgress,
        "in_progress_label": inProgressLabel,
    };
}

class Complaint {
    final int id;
    final String ticketNumber;
    final String title;
    final String unitSubtitle;
    final String priority;
    final String priorityColor;
    final bool? isEmergency;
    final String? type;
    final String? areaType;
    final String? areaTypeLabel;
    final String category;
    final String submittedBy;
    final String assignedTo;
    final String date;
    final String status;
    final String statusLabel;
    final String statusColor;
    final String? resolutionPhoto;
    final String viewDetailsUrl;

    Complaint({
        required this.id,
        required this.ticketNumber,
        required this.title,
        required this.unitSubtitle,
        required this.priority,
        required this.priorityColor,
        this.isEmergency,
        this.type,
        this.areaType,
        this.areaTypeLabel,
        required this.category,
        required this.submittedBy,
        required this.assignedTo,
        required this.date,
        required this.status,
        required this.statusLabel,
        required this.statusColor,
        this.resolutionPhoto,
        required this.viewDetailsUrl,
    });

    factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
        id: json["id"],
        ticketNumber: json["ticket_number"],
        title: json["title"],
        unitSubtitle: json["unit_subtitle"],
        priority: json["priority"],
        priorityColor: json["priority_color"],
        isEmergency: json["is_emergency"],
        type: json["type"],
        areaType: json["area_type"],
        areaTypeLabel: json["area_type_label"],
        category: json["category"],
        submittedBy: json["submitted_by"],
        assignedTo: json["assigned_to"],
        date: json["date"],
        status: json["status"],
        statusLabel: json["status_label"],
        statusColor: json["status_color"],
        resolutionPhoto: json["resolution_photo"],
        viewDetailsUrl: json["view_details_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "ticket_number": ticketNumber,
        "title": title,
        "unit_subtitle": unitSubtitle,
        "priority": priority,
        "priority_color": priorityColor,
        "is_emergency": isEmergency,
        "type": type,
        "area_type": areaType,
        "area_type_label": areaTypeLabel,
        "category": category,
        "submitted_by": submittedBy,
        "assigned_to": assignedTo,
        "date": date,
        "status": status,
        "status_label": statusLabel,
        "status_color": statusColor,
        "resolution_photo": resolutionPhoto,
        "view_details_url": viewDetailsUrl,
    };
}

class Filters {
    final String active;
    final List<String> options;

    Filters({
        required this.active,
        required this.options,
    });

    factory Filters.fromJson(Map<String, dynamic> json) => Filters(
        active: json["active"],
        options: List<String>.from(json["options"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "active": active,
        "options": List<dynamic>.from(options.map((x) => x)),
    };
}

class Header {
    final String title;
    final String subtitle;

    Header({
        required this.title,
        required this.subtitle,
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

class Summary {
    final int totalCount;
    final String totalLabel;
    final int filteredCount;

    Summary({
        required this.totalCount,
        required this.totalLabel,
        required this.filteredCount,
    });

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