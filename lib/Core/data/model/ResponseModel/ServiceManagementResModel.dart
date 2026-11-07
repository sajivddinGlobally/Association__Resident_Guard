// To parse this JSON data, do
//
//     final serviceManagementResModelDart = serviceManagementResModelDartFromJson(jsonString);

import 'dart:convert';

ServiceManagementResModelDart serviceManagementResModelDartFromJson(String str) => ServiceManagementResModelDart.fromJson(json.decode(str));

String serviceManagementResModelDartToJson(ServiceManagementResModelDart data) => json.encode(data.toJson());

class ServiceManagementResModelDart {
    final bool status;
    final String message;
    final Data data;

    ServiceManagementResModelDart({
        required this.status,
        required this.message,
        required this.data,
    });

    factory ServiceManagementResModelDart.fromJson(Map<String, dynamic> json) => ServiceManagementResModelDart(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    final Header header;
    final ComplexServiceOverview complexServiceOverview;
    final List<FilterChip> filterChips;
    final List<ServicesList> servicesList;
    final String footerNote;

    Data({
        required this.header,
        required this.complexServiceOverview,
        required this.filterChips,
        required this.servicesList,
        required this.footerNote,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: Header.fromJson(json["header"]),
        complexServiceOverview: ComplexServiceOverview.fromJson(json["complex_service_overview"]),
        filterChips: List<FilterChip>.from(json["filter_chips"].map((x) => FilterChip.fromJson(x))),
        servicesList: List<ServicesList>.from(json["services_list"].map((x) => ServicesList.fromJson(x))),
        footerNote: json["footer_note"],
    );

    Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "complex_service_overview": complexServiceOverview.toJson(),
        "filter_chips": List<dynamic>.from(filterChips.map((x) => x.toJson())),
        "services_list": List<dynamic>.from(servicesList.map((x) => x.toJson())),
        "footer_note": footerNote,
    };
}

class ComplexServiceOverview {
    final String badge;
    final String title;
    final String description;
    final Metrics metrics;

    ComplexServiceOverview({
        required this.badge,
        required this.title,
        required this.description,
        required this.metrics,
    });

    factory ComplexServiceOverview.fromJson(Map<String, dynamic> json) => ComplexServiceOverview(
        badge: json["badge"],
        title: json["title"],
        description: json["description"],
        metrics: Metrics.fromJson(json["metrics"]),
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "title": title,
        "description": description,
        "metrics": metrics.toJson(),
    };
}

class Metrics {
    final ActiveServices activeServices;
    final ActiveServices providers;
    final ActiveServices performance;

    Metrics({
        required this.activeServices,
        required this.providers,
        required this.performance,
    });

    factory Metrics.fromJson(Map<String, dynamic> json) => Metrics(
        activeServices: ActiveServices.fromJson(json["active_services"]),
        providers: ActiveServices.fromJson(json["providers"]),
        performance: ActiveServices.fromJson(json["performance"]),
    );

    Map<String, dynamic> toJson() => {
        "active_services": activeServices.toJson(),
        "providers": providers.toJson(),
        "performance": performance.toJson(),
    };
}

class ActiveServices {
    final String count;
    final String label;
    final String title;

    ActiveServices({
        required this.count,
        required this.label,
        required this.title,
    });

    factory ActiveServices.fromJson(Map<String, dynamic> json) => ActiveServices(
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

class FilterChip {
    final String key;
    final String label;
    final int count;
    final bool isActive;

    FilterChip({
        required this.key,
        required this.label,
        required this.count,
        required this.isActive,
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
    final String title;
    final String subtitle;
    final String complexName;

    Header({
        required this.title,
        required this.subtitle,
        required this.complexName,
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

class ServicesList {
    final int id;
    final String category;
    final String title;
    final String subtitle;
    final String statusBadge;
    final String assignedProvider;
    final String serviceSchedule;
    final String reportedIssues;
    final int reportedIssuesCount;
    final String lastService;
    final String nextService;
    final AssignedPerson assignedPerson;
    final ServicePerformance servicePerformance;
    final String viewDetailsUrl;
    final EquipmentDetails? equipmentDetails;

    ServicesList({
        required this.id,
        required this.category,
        required this.title,
        required this.subtitle,
        required this.statusBadge,
        required this.assignedProvider,
        required this.serviceSchedule,
        required this.reportedIssues,
        required this.reportedIssuesCount,
        required this.lastService,
        required this.nextService,
        required this.assignedPerson,
        required this.servicePerformance,
        required this.viewDetailsUrl,
        this.equipmentDetails,
    });

    factory ServicesList.fromJson(Map<String, dynamic> json) => ServicesList(
        id: json["id"],
        category: json["category"],
        title: json["title"],
        subtitle: json["subtitle"],
        statusBadge: json["status_badge"],
        assignedProvider: json["assigned_provider"],
        serviceSchedule: json["service_schedule"],
        reportedIssues: json["reported_issues"],
        reportedIssuesCount: json["reported_issues_count"],
        lastService: json["last_service"],
        nextService: json["next_service"],
        assignedPerson: AssignedPerson.fromJson(json["assigned_person"]),
        servicePerformance: ServicePerformance.fromJson(json["service_performance"]),
        viewDetailsUrl: json["view_details_url"],
        equipmentDetails: json["equipment_details"] == null ? null : EquipmentDetails.fromJson(json["equipment_details"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "title": title,
        "subtitle": subtitle,
        "status_badge": statusBadge,
        "assigned_provider": assignedProvider,
        "service_schedule": serviceSchedule,
        "reported_issues": reportedIssues,
        "reported_issues_count": reportedIssuesCount,
        "last_service": lastService,
        "next_service": nextService,
        "assigned_person": assignedPerson.toJson(),
        "service_performance": servicePerformance.toJson(),
        "view_details_url": viewDetailsUrl,
        "equipment_details": equipmentDetails?.toJson(),
    };
}

class AssignedPerson {
    final String label;
    final String name;
    final String avatar;

    AssignedPerson({
        required this.label,
        required this.name,
        required this.avatar,
    });

    factory AssignedPerson.fromJson(Map<String, dynamic> json) => AssignedPerson(
        label: json["label"],
        name: json["name"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "name": name,
        "avatar": avatar,
    };
}

class EquipmentDetails {
    final String equipmentName;
    final String modelNumber;
    final String serialNumber;
    final String status;
    final String providerOemDate;
    final String nextServiceDate;

    EquipmentDetails({
        required this.equipmentName,
        required this.modelNumber,
        required this.serialNumber,
        required this.status,
        required this.providerOemDate,
        required this.nextServiceDate,
    });

    factory EquipmentDetails.fromJson(Map<String, dynamic> json) => EquipmentDetails(
        equipmentName: json["equipment_name"],
        modelNumber: json["model_number"],
        serialNumber: json["serial_number"],
        status: json["status"],
        providerOemDate: json["provider_oem_date"],
        nextServiceDate: json["next_service_date"],
    );

    Map<String, dynamic> toJson() => {
        "equipment_name": equipmentName,
        "model_number": modelNumber,
        "serial_number": serialNumber,
        "status": status,
        "provider_oem_date": providerOemDate,
        "next_service_date": nextServiceDate,
    };
}

class ServicePerformance {
    final int percentage;
    final String formatted;
    final String rating;

    ServicePerformance({
        required this.percentage,
        required this.formatted,
        required this.rating,
    });

    factory ServicePerformance.fromJson(Map<String, dynamic> json) => ServicePerformance(
        percentage: json["percentage"],
        formatted: json["formatted"],
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "percentage": percentage,
        "formatted": formatted,
        "rating": rating,
    };
}