// To parse this JSON data, do
//
//     final serviceWorkOrdersResModel = serviceWorkOrdersResModelFromJson(jsonString);

import 'dart:convert';

ServiceWorkOrdersResModel serviceWorkOrdersResModelFromJson(String str) => ServiceWorkOrdersResModel.fromJson(json.decode(str));

String serviceWorkOrdersResModelToJson(ServiceWorkOrdersResModel data) => json.encode(data.toJson());

class ServiceWorkOrdersResModel {
    bool? status;
    String? message;
    Data? data;

    ServiceWorkOrdersResModel({
        this.status,
        this.message,
        this.data,
    });

    factory ServiceWorkOrdersResModel.fromJson(Map<String, dynamic> json) => ServiceWorkOrdersResModel(
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
    Complex? complex;
    Summary? summary;
    List<FilterChip>? filterChips;
    int? count;
    List<Record>? records;
    dynamic emptyMessage;
    String? note;

    Data({
        this.complex,
        this.summary,
        this.filterChips,
        this.count,
        this.records,
        this.emptyMessage,
        this.note,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        complex: json["complex"] == null ? null : Complex.fromJson(json["complex"]),
        summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        filterChips: json["filter_chips"] == null ? [] : List<FilterChip>.from(json["filter_chips"]!.map((x) => FilterChip.fromJson(x))),
        count: json["count"],
        records: json["records"] == null ? [] : List<Record>.from(json["records"]!.map((x) => Record.fromJson(x))),
        emptyMessage: json["empty_message"],
        note: json["note"],
    );

    Map<String, dynamic> toJson() => {
        "complex": complex?.toJson(),
        "summary": summary?.toJson(),
        "filter_chips": filterChips == null ? [] : List<dynamic>.from(filterChips!.map((x) => x.toJson())),
        "count": count,
        "records": records == null ? [] : List<dynamic>.from(records!.map((x) => x.toJson())),
        "empty_message": emptyMessage,
        "note": note,
    };
}

class Complex {
    int? id;
    String? name;

    Complex({
        this.id,
        this.name,
    });

    factory Complex.fromJson(Map<String, dynamic> json) => Complex(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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

class Record {
    int? id;
    String? code;
    String? title;
    String? category;
    String? workType;
    String? priority;
    String? priorityRaw;
    String? unit;
    dynamic ownerName;
    String? status;
    String? statusRaw;
    Vendor? vendor;
    String? raisedOn;
    String? expectedCompletion;
    String? actualCompletion;
    double? cost;
    String? costFormatted;
    dynamic reportPdfUrl;
    String? detailsRoute;
    String? detailsApi;

    Record({
        this.id,
        this.code,
        this.title,
        this.category,
        this.workType,
        this.priority,
        this.priorityRaw,
        this.unit,
        this.ownerName,
        this.status,
        this.statusRaw,
        this.vendor,
        this.raisedOn,
        this.expectedCompletion,
        this.actualCompletion,
        this.cost,
        this.costFormatted,
        this.reportPdfUrl,
        this.detailsRoute,
        this.detailsApi,
    });

    factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"],
        code: json["code"],
        title: json["title"],
        category: json["category"],
        workType: json["work_type"],
        priority: json["priority"],
        priorityRaw: json["priority_raw"],
        unit: json["unit"],
        ownerName: json["owner_name"],
        status: json["status"],
        statusRaw: json["status_raw"],
        vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
        raisedOn: json["raised_on"],
        expectedCompletion: json["expected_completion"],
        actualCompletion: json["actual_completion"],
        cost: json["cost"]?.toDouble(),
        costFormatted: json["cost_formatted"],
        reportPdfUrl: json["report_pdf_url"],
        detailsRoute: json["details_route"],
        detailsApi: json["details_api"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "title": title,
        "category": category,
        "work_type": workType,
        "priority": priority,
        "priority_raw": priorityRaw,
        "unit": unit,
        "owner_name": ownerName,
        "status": status,
        "status_raw": statusRaw,
        "vendor": vendor?.toJson(),
        "raised_on": raisedOn,
        "expected_completion": expectedCompletion,
        "actual_completion": actualCompletion,
        "cost": cost,
        "cost_formatted": costFormatted,
        "report_pdf_url": reportPdfUrl,
        "details_route": detailsRoute,
        "details_api": detailsApi,
    };
}

class Vendor {
    bool? isAssigned;
    String? name;
    String? role;
    String? phone;
    dynamic supervisor;

    Vendor({
        this.isAssigned,
        this.name,
        this.role,
        this.phone,
        this.supervisor,
    });

    factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        isAssigned: json["is_assigned"],
        name: json["name"],
        role: json["role"],
        phone: json["phone"],
        supervisor: json["supervisor"],
    );

    Map<String, dynamic> toJson() => {
        "is_assigned": isAssigned,
        "name": name,
        "role": role,
        "phone": phone,
        "supervisor": supervisor,
    };
}

class Summary {
    int? totalOrders;
    int? requested;
    int? inProgress;
    int? completed;
    int? notAssigned;
    double? totalCost;
    String? totalCostText;
    double? completedCost;
    String? completedCostText;
    int? openCost;
    String? openCostText;

    Summary({
        this.totalOrders,
        this.requested,
        this.inProgress,
        this.completed,
        this.notAssigned,
        this.totalCost,
        this.totalCostText,
        this.completedCost,
        this.completedCostText,
        this.openCost,
        this.openCostText,
    });

    factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        totalOrders: json["total_orders"],
        requested: json["requested"],
        inProgress: json["in_progress"],
        completed: json["completed"],
        notAssigned: json["not_assigned"],
        totalCost: json["total_cost"]?.toDouble(),
        totalCostText: json["total_cost_text"],
        completedCost: json["completed_cost"]?.toDouble(),
        completedCostText: json["completed_cost_text"],
        openCost: json["open_cost"],
        openCostText: json["open_cost_text"],
    );

    Map<String, dynamic> toJson() => {
        "total_orders": totalOrders,
        "requested": requested,
        "in_progress": inProgress,
        "completed": completed,
        "not_assigned": notAssigned,
        "total_cost": totalCost,
        "total_cost_text": totalCostText,
        "completed_cost": completedCost,
        "completed_cost_text": completedCostText,
        "open_cost": openCost,
        "open_cost_text": openCostText,
    };
}
