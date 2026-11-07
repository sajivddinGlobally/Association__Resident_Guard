// To parse this JSON data, do
//
//     final maintananceOverviewModel = maintananceOverviewModelFromJson(jsonString);

import 'dart:convert';

MaintananceOverviewModel maintananceOverviewModelFromJson(String str) => MaintananceOverviewModel.fromJson(json.decode(str));

String maintananceOverviewModelToJson(MaintananceOverviewModel data) => json.encode(data.toJson());

class MaintananceOverviewModel {
    bool? status;
    String? message;
    Data? data;

    MaintananceOverviewModel({
        this.status,
        this.message,
        this.data,
    });

    factory MaintananceOverviewModel.fromJson(Map<String, dynamic> json) => MaintananceOverviewModel(
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
    PropertyOperations? propertyOperations;
    MaintenanceSection? maintenanceSection;
    ServicesSection? servicesSection;
    QuickAccess? quickAccess;
    ServiceSnapshot? serviceSnapshot;

    Data({
        this.header,
        this.propertyOperations,
        this.maintenanceSection,
        this.servicesSection,
        this.quickAccess,
        this.serviceSnapshot,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        propertyOperations: json["property_operations"] == null ? null : PropertyOperations.fromJson(json["property_operations"]),
        maintenanceSection: json["maintenance_section"] == null ? null : MaintenanceSection.fromJson(json["maintenance_section"]),
        servicesSection: json["services_section"] == null ? null : ServicesSection.fromJson(json["services_section"]),
        quickAccess: json["quick_access"] == null ? null : QuickAccess.fromJson(json["quick_access"]),
        serviceSnapshot: json["service_snapshot"] == null ? null : ServiceSnapshot.fromJson(json["service_snapshot"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "property_operations": propertyOperations?.toJson(),
        "maintenance_section": maintenanceSection?.toJson(),
        "services_section": servicesSection?.toJson(),
        "quick_access": quickAccess?.toJson(),
        "service_snapshot": serviceSnapshot?.toJson(),
    };
}

class Header {
    String? title;
    String? subtitle;
    String? complexName;

    Header({
        this.title,
        this.subtitle,
        this.complexName,
    });

    factory Header.fromJson(Map<String, dynamic> json) => Header(
        title: json["title"],
        subtitle: json["subtitle"],
        complexName: json["complex_name"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "complex_name": complexName,
    };
}

class MaintenanceSection {
    String? title;
    String? subtitle;
    MaintenanceHistory? pendingMaintenance;
    MaintenanceHistory? maintenanceHistory;

    MaintenanceSection({
        this.title,
        this.subtitle,
        this.pendingMaintenance,
        this.maintenanceHistory,
    });

    factory MaintenanceSection.fromJson(Map<String, dynamic> json) => MaintenanceSection(
        title: json["title"],
        subtitle: json["subtitle"],
        pendingMaintenance: json["pending_maintenance"] == null ? null : MaintenanceHistory.fromJson(json["pending_maintenance"]),
        maintenanceHistory: json["maintenance_history"] == null ? null : MaintenanceHistory.fromJson(json["maintenance_history"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "pending_maintenance": pendingMaintenance?.toJson(),
        "maintenance_history": maintenanceHistory?.toJson(),
    };
}

class MaintenanceHistory {
    String? title;
    String? description;
    String? badgeText;
    int? count;
    String? route;

    MaintenanceHistory({
        this.title,
        this.description,
        this.badgeText,
        this.count,
        this.route,
    });

    factory MaintenanceHistory.fromJson(Map<String, dynamic> json) => MaintenanceHistory(
        title: json["title"],
        description: json["description"],
        badgeText: json["badge_text"],
        count: json["count"],
        route: json["route"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "badge_text": badgeText,
        "count": count,
        "route": route,
    };
}

class PropertyOperations {
    String? badge;
    String? headline;
    String? description;
    Metrics? metrics;

    PropertyOperations({
        this.badge,
        this.headline,
        this.description,
        this.metrics,
    });

    factory PropertyOperations.fromJson(Map<String, dynamic> json) => PropertyOperations(
        badge: json["badge"],
        headline: json["headline"],
        description: json["description"],
        metrics: json["metrics"] == null ? null : Metrics.fromJson(json["metrics"]),
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "headline": headline,
        "description": description,
        "metrics": metrics?.toJson(),
    };
}

class Metrics {
    Pending? pending;
    Pending? services;
    Pending? resolved;

    Metrics({
        this.pending,
        this.services,
        this.resolved,
    });

    factory Metrics.fromJson(Map<String, dynamic> json) => Metrics(
        pending: json["pending"] == null ? null : Pending.fromJson(json["pending"]),
        services: json["services"] == null ? null : Pending.fromJson(json["services"]),
        resolved: json["resolved"] == null ? null : Pending.fromJson(json["resolved"]),
    );

    Map<String, dynamic> toJson() => {
        "pending": pending?.toJson(),
        "services": services?.toJson(),
        "resolved": resolved?.toJson(),
    };
}

class Pending {
    String? count;
    String? label;
    String? title;

    Pending({
        this.count,
        this.label,
        this.title,
    });

    factory Pending.fromJson(Map<String, dynamic> json) => Pending(
        count: json["count"],
        label: json["label"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "label": label,
        "title": title,
    };
}

class QuickAccess {
    String? title;
    String? subtitle;
    List<Action>? actions;

    QuickAccess({
        this.title,
        this.subtitle,
        this.actions,
    });

    factory QuickAccess.fromJson(Map<String, dynamic> json) => QuickAccess(
        title: json["title"],
        subtitle: json["subtitle"],
        actions: json["actions"] == null ? [] : List<Action>.from(json["actions"]!.map((x) => Action.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "actions": actions == null ? [] : List<dynamic>.from(actions!.map((x) => x.toJson())),
    };
}

class Action {
    String? id;
    String? title;
    String? description;
    String? icon;
    String? actionRoute;

    Action({
        this.id,
        this.title,
        this.description,
        this.icon,
        this.actionRoute,
    });

    factory Action.fromJson(Map<String, dynamic> json) => Action(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        icon: json["icon"],
        actionRoute: json["action_route"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "icon": icon,
        "action_route": actionRoute,
    };
}

class ServiceSnapshot {
    String? title;
    String? viewAllRoute;
    List<Item>? items;

    ServiceSnapshot({
        this.title,
        this.viewAllRoute,
        this.items,
    });

    factory ServiceSnapshot.fromJson(Map<String, dynamic> json) => ServiceSnapshot(
        title: json["title"],
        viewAllRoute: json["view_all_route"],
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "view_all_route": viewAllRoute,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class Item {
    int? id;
    String? title;
    String? subtitle;
    String? description;
    String? status;
    String? icon;

    Item({
        this.id,
        this.title,
        this.subtitle,
        this.description,
        this.status,
        this.icon,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        description: json["description"],
        status: json["status"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "description": description,
        "status": status,
        "icon": icon,
    };
}

class ServicesSection {
    String? title;
    String? subtitle;
    MaintenanceHistory? serviceManagement;

    ServicesSection({
        this.title,
        this.subtitle,
        this.serviceManagement,
    });

    factory ServicesSection.fromJson(Map<String, dynamic> json) => ServicesSection(
        title: json["title"],
        subtitle: json["subtitle"],
        serviceManagement: json["service_management"] == null ? null : MaintenanceHistory.fromJson(json["service_management"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "service_management": serviceManagement?.toJson(),
    };
}
