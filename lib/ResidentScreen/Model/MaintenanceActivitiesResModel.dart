// To parse this JSON data, do
//
//     final maintenanceActivitiesResModel = maintenanceActivitiesResModelFromJson(jsonString);

import 'dart:convert';

MaintenanceActivitiesResModel maintenanceActivitiesResModelFromJson(
  String str,
) => MaintenanceActivitiesResModel.fromJson(json.decode(str));

String maintenanceActivitiesResModelToJson(
  MaintenanceActivitiesResModel data,
) => json.encode(data.toJson());

class MaintenanceActivitiesResModel {
  bool? status;
  String? message;
  Data? data;

  MaintenanceActivitiesResModel({this.status, this.message, this.data});

  factory MaintenanceActivitiesResModel.fromJson(Map<String, dynamic> json) =>
      MaintenanceActivitiesResModel(
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
  String? unitNumber;
  String? complexName;
  int? totalRecords;
  List<Activity>? activities;

  Data({this.unitNumber, this.complexName, this.totalRecords, this.activities});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    unitNumber: json["unit_number"],
    complexName: json["complex_name"],
    totalRecords: json["total_records"],
    activities: json["activities"] == null
        ? []
        : List<Activity>.from(
            json["activities"]!.map((x) => Activity.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "unit_number": unitNumber,
    "complex_name": complexName,
    "total_records": totalRecords,
    "activities": activities == null
        ? []
        : List<dynamic>.from(activities!.map((x) => x.toJson())),
  };
}

class Activity {
  int? id;
  String? workOrderNo;
  String? propertyUnit;
  String? complexName;
  String? title;
  String? category;
  String? workType;
  AssignedSupervisor? assignedSupervisor;
  String? timelineStatus;
  String? statusRaw;
  String? targetDate;
  dynamic completedOn;
  num? cost;
  String? formattedCost;
  dynamic reportPdf;
  String? reportUrl;

  Activity({
    this.id,
    this.workOrderNo,
    this.propertyUnit,
    this.complexName,
    this.title,
    this.category,
    this.workType,
    this.assignedSupervisor,
    this.timelineStatus,
    this.statusRaw,
    this.targetDate,
    this.completedOn,
    this.cost,
    this.formattedCost,
    this.reportPdf,
    this.reportUrl,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json["id"],
    workOrderNo: json["work_order_no"],
    propertyUnit: json["property_unit"],
    complexName: json["complex_name"],
    title: json["title"],
    category: json["category"],
    workType: json["work_type"],
    assignedSupervisor: json["assigned_supervisor"] == null
        ? null
        : AssignedSupervisor.fromJson(json["assigned_supervisor"]),
    timelineStatus: json["timeline_status"],
    statusRaw: json["status_raw"],
    targetDate: json["target_date"],
    completedOn: json["completed_on"],
    cost: json["cost"],
    formattedCost: json["formatted_cost"],
    reportPdf: json["report_pdf"],
    reportUrl: json["report_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "work_order_no": workOrderNo,
    "property_unit": propertyUnit,
    "complex_name": complexName,
    "title": title,
    "category": category,
    "work_type": workType,
    "assigned_supervisor": assignedSupervisor?.toJson(),
    "timeline_status": timelineStatus,
    "status_raw": statusRaw,
    "target_date": targetDate,
    "completed_on": completedOn,
    "cost": cost,
    "formatted_cost": formattedCost,
    "report_pdf": reportPdf,
    "report_url": reportUrl,
  };
}

class AssignedSupervisor {
  String? name;
  String? role;
  String? avatar;

  AssignedSupervisor({this.name, this.role, this.avatar});

  factory AssignedSupervisor.fromJson(Map<String, dynamic> json) =>
      AssignedSupervisor(
        name: json["name"],
        role: json["role"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "role": role,
    "avatar": avatar,
  };
}
