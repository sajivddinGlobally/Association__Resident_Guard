// To parse this JSON data, do
//
//     final commiteDashboardModel = commiteDashboardModelFromJson(jsonString);

import 'dart:convert';

CommiteDashboardModel commiteDashboardModelFromJson(String str) =>
    CommiteDashboardModel.fromJson(json.decode(str));

String commiteDashboardModelToJson(CommiteDashboardModel data) =>
    json.encode(data.toJson());

class CommiteDashboardModel {
  bool? status;
  Data? data;

  CommiteDashboardModel({this.status, this.data});

  factory CommiteDashboardModel.fromJson(Map<String, dynamic> json) =>
      CommiteDashboardModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  Header? header;
  Complex? complex;
  List<QuickAction>? quickActions;
  AmcPlan? amcPlan;
  PropertyAssistant? propertyAssistant;
  ComplexOverview? complexOverview;
  ServicePerformance? servicePerformance;
  DataLatestInspection? latestInspection;
  MaintenanceChargesMonthly? maintenanceChargesMonthly;
  List<ImportantAlert>? importantAlerts;
  Widgets? widgets;

  Data({
    this.header,
    this.complex,
    this.quickActions,
    this.amcPlan,
    this.propertyAssistant,
    this.complexOverview,
    this.servicePerformance,
    this.latestInspection,
    this.maintenanceChargesMonthly,
    this.importantAlerts,
    this.widgets,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    header: json["header"] == null ? null : Header.fromJson(json["header"]),
    complex: json["complex"] == null ? null : Complex.fromJson(json["complex"]),
    quickActions: json["quick_actions"] == null
        ? []
        : List<QuickAction>.from(
            json["quick_actions"]!.map((x) => QuickAction.fromJson(x)),
          ),
    amcPlan: json["amc_plan"] == null
        ? null
        : AmcPlan.fromJson(json["amc_plan"]),
    propertyAssistant: json["property_assistant"] == null
        ? null
        : PropertyAssistant.fromJson(json["property_assistant"]),
    complexOverview: json["complex_overview"] == null
        ? null
        : ComplexOverview.fromJson(json["complex_overview"]),
    servicePerformance: json["service_performance"] == null
        ? null
        : ServicePerformance.fromJson(json["service_performance"]),
    latestInspection: json["latest_inspection"] == null
        ? null
        : DataLatestInspection.fromJson(json["latest_inspection"]),
    maintenanceChargesMonthly: json["maintenance_charges_monthly"] == null
        ? null
        : MaintenanceChargesMonthly.fromJson(
            json["maintenance_charges_monthly"],
          ),
    importantAlerts: json["important_alerts"] == null
        ? []
        : List<ImportantAlert>.from(
            json["important_alerts"]!.map((x) => ImportantAlert.fromJson(x)),
          ),
    widgets: json["widgets"] == null ? null : Widgets.fromJson(json["widgets"]),
  );

  Map<String, dynamic> toJson() => {
    "header": header?.toJson(),
    "complex": complex?.toJson(),
    "quick_actions": quickActions == null
        ? []
        : List<dynamic>.from(quickActions!.map((x) => x.toJson())),
    "amc_plan": amcPlan?.toJson(),
    "property_assistant": propertyAssistant?.toJson(),
    "complex_overview": complexOverview?.toJson(),
    "service_performance": servicePerformance?.toJson(),
    "latest_inspection": latestInspection?.toJson(),
    "maintenance_charges_monthly": maintenanceChargesMonthly?.toJson(),
    "important_alerts": importantAlerts == null
        ? []
        : List<dynamic>.from(importantAlerts!.map((x) => x.toJson())),
    "widgets": widgets?.toJson(),
  };
}

class AmcPlan {
  String? title;
  String? planName;
  String? status;
  String? badgeColor;
  bool? isActive;
  String? description;

  AmcPlan({
    this.title,
    this.planName,
    this.status,
    this.badgeColor,
    this.isActive,
    this.description,
  });

  factory AmcPlan.fromJson(Map<String, dynamic> json) => AmcPlan(
    title: json["title"],
    planName: json["plan_name"],
    status: json["status"],
    badgeColor: json["badge_color"],
    isActive: json["is_active"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "plan_name": planName,
    "status": status,
    "badge_color": badgeColor,
    "is_active": isActive,
    "description": description,
  };
}

class Complex {
  int? id;
  String? name;
  String? address;
  String? image;
  String? status;
  String? roleLabel;
  int? totalUnits;
  String? totalBlocks;
  String? blocks;
  int? occupiedUnits;
  String? occupancyPercentage;
  String? occupancyDisplay;
  OccupancyOverview? occupancyOverview;

  Complex({
    this.id,
    this.name,
    this.address,
    this.image,
    this.status,
    this.roleLabel,
    this.totalUnits,
    this.totalBlocks,
    this.blocks,
    this.occupiedUnits,
    this.occupancyPercentage,
    this.occupancyDisplay,
    this.occupancyOverview,
  });

  factory Complex.fromJson(Map<String, dynamic> json) => Complex(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    image: json["image"],
    status: json["status"],
    roleLabel: json["role_label"],
    totalUnits: json["total_units"],
    totalBlocks: json["total_blocks"],
    blocks: json["blocks"],
    occupiedUnits: json["occupied_units"],
    occupancyPercentage: json["occupancy_percentage"],
    occupancyDisplay: json["occupancy_display"],
    occupancyOverview: json["occupancy_overview"] == null
        ? null
        : OccupancyOverview.fromJson(json["occupancy_overview"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "image": image,
    "status": status,
    "role_label": roleLabel,
    "total_units": totalUnits,
    "total_blocks": totalBlocks,
    "blocks": blocks,
    "occupied_units": occupiedUnits,
    "occupancy_percentage": occupancyPercentage,
    "occupancy_display": occupancyDisplay,
    "occupancy_overview": occupancyOverview?.toJson(),
  };
}

class OccupancyOverview {
  int? totalProperties;
  int? occupied;
  int? vacant;

  OccupancyOverview({this.totalProperties, this.occupied, this.vacant});

  factory OccupancyOverview.fromJson(Map<String, dynamic> json) =>
      OccupancyOverview(
        totalProperties: json["total_properties"],
        occupied: json["occupied"],
        vacant: json["vacant"],
      );

  Map<String, dynamic> toJson() => {
    "total_properties": totalProperties,
    "occupied": occupied,
    "vacant": vacant,
  };
}

class ComplexOverview {
  String? statusLabel;
  bool? isLive;
  int? totalProperties;
  int? totalUnits;
  int? occupiedUnits;
  String? occupancyPercentage;
  int? occupancyProgress;
  String? occupancyText;
  Stats? stats;

  ComplexOverview({
    this.statusLabel,
    this.isLive,
    this.totalProperties,
    this.totalUnits,
    this.occupiedUnits,
    this.occupancyPercentage,
    this.occupancyProgress,
    this.occupancyText,
    this.stats,
  });

  factory ComplexOverview.fromJson(Map<String, dynamic> json) =>
      ComplexOverview(
        statusLabel: json["status_label"],
        isLive: json["is_live"],
        totalProperties: json["total_properties"],
        totalUnits: json["total_units"],
        occupiedUnits: json["occupied_units"],
        occupancyPercentage: json["occupancy_percentage"],
        occupancyProgress: json["occupancy_progress"],
        occupancyText: json["occupancy_text"],
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
      );

  Map<String, dynamic> toJson() => {
    "status_label": statusLabel,
    "is_live": isLive,
    "total_properties": totalProperties,
    "total_units": totalUnits,
    "occupied_units": occupiedUnits,
    "occupancy_percentage": occupancyPercentage,
    "occupancy_progress": occupancyProgress,
    "occupancy_text": occupancyText,
    "stats": stats?.toJson(),
  };
}

class Stats {
  int? openComplaints;
  int? pendingMaintenance;
  int? activeServices;
  int? outstandingUnits;

  Stats({
    this.openComplaints,
    this.pendingMaintenance,
    this.activeServices,
    this.outstandingUnits,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    openComplaints: json["open_complaints"],
    pendingMaintenance: json["pending_maintenance"],
    activeServices: json["active_services"],
    outstandingUnits: json["outstanding_units"],
  );

  Map<String, dynamic> toJson() => {
    "open_complaints": openComplaints,
    "pending_maintenance": pendingMaintenance,
    "active_services": activeServices,
    "outstanding_units": outstandingUnits,
  };
}

class Header {
  String? greeting;
  String? userName;
  String? role;
  int? unreadNotifications;

  Header({this.greeting, this.userName, this.role, this.unreadNotifications});

  factory Header.fromJson(Map<String, dynamic> json) => Header(
    greeting: json["greeting"],
    userName: json["user_name"],
    role: json["role"],
    unreadNotifications: json["unread_notifications"],
  );

  Map<String, dynamic> toJson() => {
    "greeting": greeting,
    "user_name": userName,
    "role": role,
    "unread_notifications": unreadNotifications,
  };
}

class ImportantAlert {
  int? id;
  String? type;
  int? count;
  String? title;
  String? subtitle;
  String? actionRoute;
  String? severity;

  ImportantAlert({
    this.id,
    this.type,
    this.count,
    this.title,
    this.subtitle,
    this.actionRoute,
    this.severity,
  });

  factory ImportantAlert.fromJson(Map<String, dynamic> json) => ImportantAlert(
    id: json["id"],
    type: json["type"],
    count: json["count"],
    title: json["title"],
    subtitle: json["subtitle"],
    actionRoute: json["action_route"],
    severity: json["severity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "count": count,
    "title": title,
    "subtitle": subtitle,
    "action_route": actionRoute,
    "severity": severity,
  };
}

class DataLatestInspection {
  int? id;
  String? title;
  String? status;
  String? description;
  String? date;
  String? issues;
  String? inspector;
  String? score;
  String? viewAllRoute;

  DataLatestInspection({
    this.id,
    this.title,
    this.status,
    this.description,
    this.date,
    this.issues,
    this.inspector,
    this.score,
    this.viewAllRoute,
  });

  factory DataLatestInspection.fromJson(Map<String, dynamic> json) =>
      DataLatestInspection(
        id: json["id"],
        title: json["title"]?.toString(),
        status: json["status"]?.toString(),
        description: json["description"]?.toString(),
        date: json["date"]?.toString(),
        issues: json["issues"]?.toString(),
        inspector: json["inspector"]?.toString(),
        score: json["score"]?.toString(),
        viewAllRoute: json["view_all_route"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "status": status,
    "description": description,
    "date": date,
    "issues": issues,
    "inspector": inspector,
    "score": score,
    "view_all_route": viewAllRoute,
  };
}

class MaintenanceChargesMonthly {
  String? title;
  String? status;
  String? statusBadge;
  int? paidUnits;
  int? unpaidUnits;
  int? defaulters;
  String? totalOutstanding;
  String? viewDetailsRoute;

  MaintenanceChargesMonthly({
    this.title,
    this.status,
    this.statusBadge,
    this.paidUnits,
    this.unpaidUnits,
    this.defaulters,
    this.totalOutstanding,
    this.viewDetailsRoute,
  });

  factory MaintenanceChargesMonthly.fromJson(Map<String, dynamic> json) =>
      MaintenanceChargesMonthly(
        title: json["title"],
        status: json["status"],
        statusBadge: json["status_badge"],
        paidUnits: json["paid_units"],
        unpaidUnits: json["unpaid_units"],
        defaulters: json["defaulters"],
        totalOutstanding: json["total_outstanding"],
        viewDetailsRoute: json["view_details_route"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "status": status,
    "status_badge": statusBadge,
    "paid_units": paidUnits,
    "unpaid_units": unpaidUnits,
    "defaulters": defaulters,
    "total_outstanding": totalOutstanding,
    "view_details_route": viewDetailsRoute,
  };
}

class PropertyAssistant {
  String? title;
  String? badge;
  String? subtitle;
  String? actionRoute;

  PropertyAssistant({this.title, this.badge, this.subtitle, this.actionRoute});

  factory PropertyAssistant.fromJson(Map<String, dynamic> json) =>
      PropertyAssistant(
        title: json["title"],
        badge: json["badge"],
        subtitle: json["subtitle"],
        actionRoute: json["action_route"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "badge": badge,
    "subtitle": subtitle,
    "action_route": actionRoute,
  };
}

class QuickAction {
  String? id;
  String? title;
  String? icon;
  String? route;
  String? badge;

  QuickAction({this.id, this.title, this.icon, this.route, this.badge});

  factory QuickAction.fromJson(Map<String, dynamic> json) => QuickAction(
    id: json["id"],
    title: json["title"],
    icon: json["icon"],
    route: json["route"],
    badge: json["badge"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "icon": icon,
    "route": route,
    "badge": badge,
  };
}

class ServicePerformance {
  String? title;
  String? score;
  num? scoreValue;
  String? label;
  String? rating;
  String? message;
  String? statusIcon;
  String? viewDetailsRoute;

  ServicePerformance({
    this.title,
    this.score,
    this.scoreValue,
    this.label,
    this.rating,
    this.message,
    this.statusIcon,
    this.viewDetailsRoute,
  });

  factory ServicePerformance.fromJson(Map<String, dynamic> json) =>
      ServicePerformance(
        title: json["title"],
        score: json["score"],
        scoreValue: json["score_value"],
        label: json["label"],
        rating: json["rating"],
        message: json["message"],
        statusIcon: json["status_icon"],
        viewDetailsRoute: json["view_details_route"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "score": score,
    "score_value": scoreValue,
    "label": label,
    "rating": rating,
    "message": message,
    "status_icon": statusIcon,
    "view_details_route": viewDetailsRoute,
  };
}

class Widgets {
  int? openComplaints;
  int? pendingMaintenance;
  int? activeServices;
  Defaulters? defaulters;
  num? propertyScore;
  WidgetsLatestInspection? latestInspection;

  Widgets({
    this.openComplaints,
    this.pendingMaintenance,
    this.activeServices,
    this.defaulters,
    this.propertyScore,
    this.latestInspection,
  });

  factory Widgets.fromJson(Map<String, dynamic> json) => Widgets(
    openComplaints: json["open_complaints"],
    pendingMaintenance: json["pending_maintenance"],
    activeServices: json["active_services"],
    defaulters: json["defaulters"] == null
        ? null
        : Defaulters.fromJson(json["defaulters"]),
    propertyScore: json["property_score"],
    latestInspection: json["latest_inspection"] == null
        ? null
        : WidgetsLatestInspection.fromJson(json["latest_inspection"]),
  );

  Map<String, dynamic> toJson() => {
    "open_complaints": openComplaints,
    "pending_maintenance": pendingMaintenance,
    "active_services": activeServices,
    "defaulters": defaulters?.toJson(),
    "property_score": propertyScore,
    "latest_inspection": latestInspection?.toJson(),
  };
}

class Defaulters {
  int? count;
  dynamic totalOutstanding;

  Defaulters({this.count, this.totalOutstanding});

  factory Defaulters.fromJson(Map<String, dynamic> json) => Defaulters(
    count: json["count"],
    totalOutstanding: json["total_outstanding"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "total_outstanding": totalOutstanding,
  };
}

class WidgetsLatestInspection {
  int? id;
  dynamic date;
  String? score;

  WidgetsLatestInspection({this.id, this.date, this.score});

  factory WidgetsLatestInspection.fromJson(Map<String, dynamic> json) =>
      WidgetsLatestInspection(
        id: json["id"],
        date: json["date"],
        score: json["score"]?.toString(),
      );

  Map<String, dynamic> toJson() => {"id": id, "date": date, "score": score};
}
