// To parse this JSON data, do
//
//     final getServiceRequestStatusModel = getServiceRequestStatusModelFromJson(jsonString);

import 'dart:convert';

GetServiceRequestStatusModel getServiceRequestStatusModelFromJson(String str) => GetServiceRequestStatusModel.fromJson(json.decode(str));

String getServiceRequestStatusModelToJson(GetServiceRequestStatusModel data) => json.encode(data.toJson());

class GetServiceRequestStatusModel {
    bool? status;
    Data? data;

    GetServiceRequestStatusModel({
        this.status,
        this.data,
    });

    factory GetServiceRequestStatusModel.fromJson(Map<String, dynamic> json) => GetServiceRequestStatusModel(
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
    TicketProgress? ticketProgress;
    List<LifecycleStage>? lifecycleStages;
    AssignedServiceProvider? assignedServiceProvider;

    Data({
        this.header,
        this.ticketBanner,
        this.ticketProgress,
        this.lifecycleStages,
        this.assignedServiceProvider,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        ticketBanner: json["ticket_banner"] == null ? null : TicketBanner.fromJson(json["ticket_banner"]),
        ticketProgress: json["ticket_progress"] == null ? null : TicketProgress.fromJson(json["ticket_progress"]),
        lifecycleStages: json["lifecycle_stages"] == null ? [] : List<LifecycleStage>.from(json["lifecycle_stages"]!.map((x) => LifecycleStage.fromJson(x))),
        assignedServiceProvider: json["assigned_service_provider"] == null ? null : AssignedServiceProvider.fromJson(json["assigned_service_provider"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "ticket_banner": ticketBanner?.toJson(),
        "ticket_progress": ticketProgress?.toJson(),
        "lifecycle_stages": lifecycleStages == null ? [] : List<dynamic>.from(lifecycleStages!.map((x) => x.toJson())),
        "assigned_service_provider": assignedServiceProvider?.toJson(),
    };
}

class AssignedServiceProvider {
    int? providerId;
    String? providerName;
    String? subtitle;
    String? category;
    String? contact;
    String? status;
    bool? isActive;

    AssignedServiceProvider({
        this.providerId,
        this.providerName,
        this.subtitle,
        this.category,
        this.contact,
        this.status,
        this.isActive,
    });

    factory AssignedServiceProvider.fromJson(Map<String, dynamic> json) => AssignedServiceProvider(
        providerId: json["provider_id"],
        providerName: json["provider_name"],
        subtitle: json["subtitle"],
        category: json["category"],
        contact: json["contact"],
        status: json["status"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "provider_id": providerId,
        "provider_name": providerName,
        "subtitle": subtitle,
        "category": category,
        "contact": contact,
        "status": status,
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

class LifecycleStage {
    int? stage;
    String? title;
    String? description;
    String? date;
    String? status;
    bool? isCompleted;

    LifecycleStage({
        this.stage,
        this.title,
        this.description,
        this.date,
        this.status,
        this.isCompleted,
    });

    factory LifecycleStage.fromJson(Map<String, dynamic> json) => LifecycleStage(
        stage: json["stage"],
        title: json["title"],
        description: json["description"],
        date: json["date"],
        status: json["status"],
        isCompleted: json["is_completed"],
    );

    Map<String, dynamic> toJson() => {
        "stage": stage,
        "title": title,
        "description": description,
        "date": date,
        "status": status,
        "is_completed": isCompleted,
    };
}

class TicketBanner {
    String? tag;
    String? ticketNumber;
    String? status;
    String? title;
    String? subtitle;
    String? raisedDate;
    String? lastUpdate;
    String? priority;

    TicketBanner({
        this.tag,
        this.ticketNumber,
        this.status,
        this.title,
        this.subtitle,
        this.raisedDate,
        this.lastUpdate,
        this.priority,
    });

    factory TicketBanner.fromJson(Map<String, dynamic> json) => TicketBanner(
        tag: json["tag"],
        ticketNumber: json["ticket_number"],
        status: json["status"],
        title: json["title"],
        subtitle: json["subtitle"],
        raisedDate: json["raised_date"],
        lastUpdate: json["last_update"],
        priority: json["priority"],
    );

    Map<String, dynamic> toJson() => {
        "tag": tag,
        "ticket_number": ticketNumber,
        "status": status,
        "title": title,
        "subtitle": subtitle,
        "raised_date": raisedDate,
        "last_update": lastUpdate,
        "priority": priority,
    };
}

class TicketProgress {
    String? title;
    String? headline;
    String? statusBadge;
    int? progressPercentage;
    List<String>? steps;
    String? currentStep;

    TicketProgress({
        this.title,
        this.headline,
        this.statusBadge,
        this.progressPercentage,
        this.steps,
        this.currentStep,
    });

    factory TicketProgress.fromJson(Map<String, dynamic> json) => TicketProgress(
        title: json["title"],
        headline: json["headline"],
        statusBadge: json["status_badge"],
        progressPercentage: json["progress_percentage"],
        steps: json["steps"] == null ? [] : List<String>.from(json["steps"]!.map((x) => x)),
        currentStep: json["current_step"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "headline": headline,
        "status_badge": statusBadge,
        "progress_percentage": progressPercentage,
        "steps": steps == null ? [] : List<dynamic>.from(steps!.map((x) => x)),
        "current_step": currentStep,
    };
}
