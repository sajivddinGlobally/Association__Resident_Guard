// To parse this JSON data, do
//
//     final associationReportResModel = associationReportResModelFromJson(jsonString);

import 'dart:convert';

AssociationReportResModel associationReportResModelFromJson(String str) => AssociationReportResModel.fromJson(json.decode(str));

String associationReportResModelToJson(AssociationReportResModel data) => json.encode(data.toJson());

class AssociationReportResModel {
    final bool status;
    final String message;
    final Data data;

    AssociationReportResModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory AssociationReportResModel.fromJson(Map<String, dynamic> json) => AssociationReportResModel(
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
    final ReportsCentreInsights reportsCentreInsights;
    final List<FilterChip> filterChips;
    final QuickReports quickReports;
    final ReportsList reportsList;
    final String footerNote;

    Data({
        required this.header,
        required this.reportsCentreInsights,
        required this.filterChips,
        required this.quickReports,
        required this.reportsList,
        required this.footerNote,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: Header.fromJson(json["header"]),
        reportsCentreInsights: ReportsCentreInsights.fromJson(json["reports_centre_insights"]),
        filterChips: List<FilterChip>.from(json["filter_chips"].map((x) => FilterChip.fromJson(x))),
        quickReports: QuickReports.fromJson(json["quick_reports"]),
        reportsList: ReportsList.fromJson(json["reports_list"]),
        footerNote: json["footer_note"],
    );

    Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "reports_centre_insights": reportsCentreInsights.toJson(),
        "filter_chips": List<dynamic>.from(filterChips.map((x) => x.toJson())),
        "quick_reports": quickReports.toJson(),
        "reports_list": reportsList.toJson(),
        "footer_note": footerNote,
    };
}

class FilterChip {
    final String key;
    final String label;
    final bool isActive;

    FilterChip({
        required this.key,
        required this.label,
        required this.isActive,
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

class QuickReports {
    final String title;
    final List<QuickReportsItem> items;

    QuickReports({
        required this.title,
        required this.items,
    });

    factory QuickReports.fromJson(Map<String, dynamic> json) => QuickReports(
        title: json["title"],
        items: List<QuickReportsItem>.from(json["items"].map((x) => QuickReportsItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class QuickReportsItem {
    final String id;
    final String title;
    final String subtitle;
    final String icon;
    final String route;
    final String apiUrl;

    QuickReportsItem({
        required this.id,
        required this.title,
        required this.subtitle,
        required this.icon,
        required this.route,
        required this.apiUrl,
    });

    factory QuickReportsItem.fromJson(Map<String, dynamic> json) => QuickReportsItem(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        icon: json["icon"],
        route: json["route"],
        apiUrl: json["api_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "icon": icon,
        "route": route,
        "api_url": apiUrl,
    };
}

class ReportsCentreInsights {
    final String badge;
    final String headline;
    final String description;
    final Metrics metrics;

    ReportsCentreInsights({
        required this.badge,
        required this.headline,
        required this.description,
        required this.metrics,
    });

    factory ReportsCentreInsights.fromJson(Map<String, dynamic> json) => ReportsCentreInsights(
        badge: json["badge"],
        headline: json["headline"],
        description: json["description"],
        metrics: Metrics.fromJson(json["metrics"]),
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "headline": headline,
        "description": description,
        "metrics": metrics.toJson(),
    };
}

class Metrics {
    final Categories totalReports;
    final Categories thisMonth;
    final Categories categories;

    Metrics({
        required this.totalReports,
        required this.thisMonth,
        required this.categories,
    });

    factory Metrics.fromJson(Map<String, dynamic> json) => Metrics(
        totalReports: Categories.fromJson(json["total_reports"]),
        thisMonth: Categories.fromJson(json["this_month"]),
        categories: Categories.fromJson(json["categories"]),
    );

    Map<String, dynamic> toJson() => {
        "total_reports": totalReports.toJson(),
        "this_month": thisMonth.toJson(),
        "categories": categories.toJson(),
    };
}

class Categories {
    final String count;
    final String label;
    final String title;

    Categories({
        required this.count,
        required this.label,
        required this.title,
    });

    factory Categories.fromJson(Map<String, dynamic> json) => Categories(
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

class ReportsList {
    final String title;
    final int count;
    final List<ReportsListItem> items;

    ReportsList({
        required this.title,
        required this.count,
        required this.items,
    });

    factory ReportsList.fromJson(Map<String, dynamic> json) => ReportsList(
        title: json["title"],
        count: json["count"],
        items: List<ReportsListItem>.from(json["items"].map((x) => ReportsListItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "count": count,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class ReportsListItem {
    final int id;
    final String title;
    final String categoryKey;
    final String category;
    final String period;
    final String subtitle;
    final String statBadge;
    final String format;
    final String status;
    final String statusBadge;
    final String viewUrl;
    final String downloadUrl;
    final DateTime createdAt;

    ReportsListItem({
        required this.id,
        required this.title,
        required this.categoryKey,
        required this.category,
        required this.period,
        required this.subtitle,
        required this.statBadge,
        required this.format,
        required this.status,
        required this.statusBadge,
        required this.viewUrl,
        required this.downloadUrl,
        required this.createdAt,
    });

    factory ReportsListItem.fromJson(Map<String, dynamic> json) => ReportsListItem(
        id: json["id"],
        title: json["title"],
        categoryKey: json["category_key"],
        category: json["category"],
        period: json["period"],
        subtitle: json["subtitle"],
        statBadge: json["stat_badge"],
        format: json["format"],
        status: json["status"],
        statusBadge: json["status_badge"],
        viewUrl: json["view_url"],
        downloadUrl: json["download_url"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "category_key": categoryKey,
        "category": category,
        "period": period,
        "subtitle": subtitle,
        "stat_badge": statBadge,
        "format": format,
        "status": status,
        "status_badge": statusBadge,
        "view_url": viewUrl,
        "download_url": downloadUrl,
        "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    };
}