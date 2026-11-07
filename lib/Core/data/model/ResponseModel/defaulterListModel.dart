// To parse this JSON data, do
//
//     final defaulterListResModel = defaulterListResModelFromJson(jsonString);

import 'dart:convert';

DefaulterListResModel defaulterListResModelFromJson(String str) => DefaulterListResModel.fromJson(json.decode(str));

String defaulterListResModelToJson(DefaulterListResModel data) => json.encode(data.toJson());

class DefaulterListResModel {
    bool? status;
    String? message;
    Data? data;

    DefaulterListResModel({
        this.status,
        this.message,
        this.data,
    });

    factory DefaulterListResModel.fromJson(Map<String, dynamic> json) => DefaulterListResModel(
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
    OverdueMaintenanceOverview? overdueMaintenanceOverview;
    KpiSummary? kpiSummary;
    List<FilterChip>? filterChips;
    String? activeFilter;
    Defaulters? defaulters;

    Data({
        this.header,
        this.overdueMaintenanceOverview,
        this.kpiSummary,
        this.filterChips,
        this.activeFilter,
        this.defaulters,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        overdueMaintenanceOverview: json["overdue_maintenance_overview"] == null ? null : OverdueMaintenanceOverview.fromJson(json["overdue_maintenance_overview"]),
        kpiSummary: json["kpi_summary"] == null ? null : KpiSummary.fromJson(json["kpi_summary"]),
        filterChips: json["filter_chips"] == null ? [] : List<FilterChip>.from(json["filter_chips"]!.map((x) => FilterChip.fromJson(x))),
        activeFilter: json["active_filter"],
        defaulters: json["defaulters"] == null ? null : Defaulters.fromJson(json["defaulters"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "overdue_maintenance_overview": overdueMaintenanceOverview?.toJson(),
        "kpi_summary": kpiSummary?.toJson(),
        "filter_chips": filterChips == null ? [] : List<dynamic>.from(filterChips!.map((x) => x.toJson())),
        "active_filter": activeFilter,
        "defaulters": defaulters?.toJson(),
    };
}

class Defaulters {
    String? countLabel;
    List<Record>? records;

    Defaulters({
        this.countLabel,
        this.records,
    });

    factory Defaulters.fromJson(Map<String, dynamic> json) => Defaulters(
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
    String? unitNumber;
    String? ownerName;
    String? dueSince;
    int? overdueDays;
    String? subtitle;
    int? amount;
    String? formattedAmount;
    String? status;
    String? detailsUrl;
    String? defaulterStatus;
    bool? isDefaulter;
    String? badgeColor;
    bool? isOverdueAbove2Months;
    String? statusBadge;

    Record({
        this.id,
        this.unitNumber,
        this.ownerName,
        this.dueSince,
        this.overdueDays,
        this.subtitle,
        this.amount,
        this.formattedAmount,
        this.status,
        this.detailsUrl,
        this.defaulterStatus,
        this.isDefaulter,
        this.badgeColor,
        this.isOverdueAbove2Months,
        this.statusBadge,
    });

    factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"],
        unitNumber: json["unit_number"]?.toString(),
        ownerName: json["owner_name"]?.toString(),
        dueSince: json["due_since"]?.toString(),
        overdueDays: json["overdue_days"] is num
            ? (json["overdue_days"] as num).toInt()
            : int.tryParse(json["overdue_days"]?.toString() ?? ""),
        subtitle: json["subtitle"]?.toString(),
        amount: json["amount"] is num
            ? (json["amount"] as num).toInt()
            : int.tryParse(json["amount"]?.toString() ?? ""),
        formattedAmount: json["formatted_amount"]?.toString(),
        status: json["defaulter_status"]?.toString() ??
            json["status"]?.toString() ??
            json["status_badge"]?.toString(),
        detailsUrl: json["details_url"]?.toString(),
        defaulterStatus: json["defaulter_status"]?.toString(),
        isDefaulter: json["is_defaulter"] == true ||
            json["is_defaulter"] == 1 ||
            json["is_defaulter"] == "true",
        badgeColor: json["badge_color"]?.toString() ??
            json["status_color"]?.toString(),
        isOverdueAbove2Months: json["is_overdue_above_2_months"] == true ||
            json["is_overdue_above_2_months"] == 1 ||
            json["is_overdue_above_2_months"] == "true",
        statusBadge: json["status_badge"]?.toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "unit_number": unitNumber,
        "owner_name": ownerName,
        "due_since": dueSince,
        "overdue_days": overdueDays,
        "subtitle": subtitle,
        "amount": amount,
        "formatted_amount": formattedAmount,
        "status": status,
        "details_url": detailsUrl,
        "defaulter_status": defaulterStatus,
        "is_defaulter": isDefaulter,
        "badge_color": badgeColor,
        "is_overdue_above_2_months": isOverdueAbove2Months,
        "status_badge": statusBadge,
    };
}

enum Status {
    OVERDUE
}

final statusValues = EnumValues({
    "Overdue": Status.OVERDUE
});

class FilterChip {
    String? key;
    String? label;
    bool? isActive;

    FilterChip({
        this.key,
        this.label,
        this.isActive,
    });

    factory FilterChip.fromJson(Map<String, dynamic> json) => FilterChip(
        key: json["key"],
        label: json["label"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "label": label,
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

class KpiSummary {
    AverageOverduePerDay? highestOutstanding;
    AverageOverduePerDay? averageOverduePerDay;

    KpiSummary({
        this.highestOutstanding,
        this.averageOverduePerDay,
    });

    factory KpiSummary.fromJson(Map<String, dynamic> json) => KpiSummary(
        highestOutstanding: json["highest_outstanding"] == null ? null : AverageOverduePerDay.fromJson(json["highest_outstanding"]),
        averageOverduePerDay: json["average_overdue_per_day"] == null ? null : AverageOverduePerDay.fromJson(json["average_overdue_per_day"]),
    );

    Map<String, dynamic> toJson() => {
        "highest_outstanding": highestOutstanding?.toJson(),
        "average_overdue_per_day": averageOverduePerDay?.toJson(),
    };
}

class AverageOverduePerDay {
    int? amount;
    String? formatted;
    String? subtitle;
    String? title;
    String? unit;
    String? label;

    AverageOverduePerDay({
        this.amount,
        this.formatted,
        this.subtitle,
        this.title,
        this.unit,
        this.label,
    });

    factory AverageOverduePerDay.fromJson(Map<String, dynamic> json) => AverageOverduePerDay(
        amount: json["amount"],
        formatted: json["formatted"],
        subtitle: json["subtitle"],
        title: json["title"],
        unit: json["unit"],
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "formatted": formatted,
        "subtitle": subtitle,
        "title": title,
        "unit": unit,
        "label": label,
    };
}

class OverdueMaintenanceOverview {
    String? badge;
    String? title;
    String? sectionTitle;
    String? sectionSubtitle;
    Metrics? metrics;

    OverdueMaintenanceOverview({
        this.badge,
        this.title,
        this.sectionTitle,
        this.sectionSubtitle,
        this.metrics,
    });

    factory OverdueMaintenanceOverview.fromJson(Map<String, dynamic> json) => OverdueMaintenanceOverview(
        badge: json["badge"],
        title: json["title"],
        sectionTitle: json["section_title"],
        sectionSubtitle: json["section_subtitle"],
        metrics: json["metrics"] == null ? null : Metrics.fromJson(json["metrics"]),
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "title": title,
        "section_title": sectionTitle,
        "section_subtitle": sectionSubtitle,
        "metrics": metrics?.toJson(),
    };
}

class Metrics {
    DefaulterUnits? defaulterUnits;
    AverageOverduePerDay? totalOutstanding;

    Metrics({
        this.defaulterUnits,
        this.totalOutstanding,
    });

    factory Metrics.fromJson(Map<String, dynamic> json) => Metrics(
        defaulterUnits: json["defaulter_units"] == null ? null : DefaulterUnits.fromJson(json["defaulter_units"]),
        totalOutstanding: json["total_outstanding"] == null ? null : AverageOverduePerDay.fromJson(json["total_outstanding"]),
    );

    Map<String, dynamic> toJson() => {
        "defaulter_units": defaulterUnits?.toJson(),
        "total_outstanding": totalOutstanding?.toJson(),
    };
}

class DefaulterUnits {
    String? count;
    String? label;
    String? title;

    DefaulterUnits({
        this.count,
        this.label,
        this.title,
    });

    factory DefaulterUnits.fromJson(Map<String, dynamic> json) => DefaulterUnits(
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

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
