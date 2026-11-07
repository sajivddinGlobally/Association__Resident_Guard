// To parse this JSON data, do
//
//     final serviceManagementPerformanceResModel = serviceManagementPerformanceResModelFromJson(jsonString);

import 'dart:convert';

ServiceManagementPerformanceResModel serviceManagementPerformanceResModelFromJson(String str) => ServiceManagementPerformanceResModel.fromJson(json.decode(str));

String serviceManagementPerformanceResModelToJson(ServiceManagementPerformanceResModel data) => json.encode(data.toJson());

class ServiceManagementPerformanceResModel {
    final bool status;
    final String message;
    final Data data;

    ServiceManagementPerformanceResModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory ServiceManagementPerformanceResModel.fromJson(Map<String, dynamic> json) => ServiceManagementPerformanceResModel(
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
    final PerformanceOverview performanceOverview;
    final PerformanceMetrics performanceMetrics;
    final ServiceSnapshot serviceSnapshot;
    final PerformanceTrend performanceTrend;
    final RecentServiceIssues recentServiceIssues;
    final PerformanceSummary performanceSummary;

    Data({
        required this.header,
        required this.performanceOverview,
        required this.performanceMetrics,
        required this.serviceSnapshot,
        required this.performanceTrend,
        required this.recentServiceIssues,
        required this.performanceSummary,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: Header.fromJson(json["header"]),
        performanceOverview: PerformanceOverview.fromJson(json["performance_overview"]),
        performanceMetrics: PerformanceMetrics.fromJson(json["performance_metrics"]),
        serviceSnapshot: ServiceSnapshot.fromJson(json["service_snapshot"]),
        performanceTrend: PerformanceTrend.fromJson(json["performance_trend"]),
        recentServiceIssues: RecentServiceIssues.fromJson(json["recent_service_issues"]),
        performanceSummary: PerformanceSummary.fromJson(json["performance_summary"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "performance_overview": performanceOverview.toJson(),
        "performance_metrics": performanceMetrics.toJson(),
        "service_snapshot": serviceSnapshot.toJson(),
        "performance_trend": performanceTrend.toJson(),
        "recent_service_issues": recentServiceIssues.toJson(),
        "performance_summary": performanceSummary.toJson(),
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

class PerformanceMetrics {
    final CompletionRate serviceQuality;
    final CompletionRate completionRate;
    final CompletionRate responsePerformance;
    final CompletionRate issueResolution;

    PerformanceMetrics({
        required this.serviceQuality,
        required this.completionRate,
        required this.responsePerformance,
        required this.issueResolution,
    });

    factory PerformanceMetrics.fromJson(Map<String, dynamic> json) => PerformanceMetrics(
        serviceQuality: CompletionRate.fromJson(json["service_quality"]),
        completionRate: CompletionRate.fromJson(json["completion_rate"]),
        responsePerformance: CompletionRate.fromJson(json["response_performance"]),
        issueResolution: CompletionRate.fromJson(json["issue_resolution"]),
    );

    Map<String, dynamic> toJson() => {
        "service_quality": serviceQuality.toJson(),
        "completion_rate": completionRate.toJson(),
        "response_performance": responsePerformance.toJson(),
        "issue_resolution": issueResolution.toJson(),
    };
}

class CompletionRate {
    final String score;
    final String label;
    final String rating;

    CompletionRate({
        required this.score,
        required this.label,
        required this.rating,
    });

    factory CompletionRate.fromJson(Map<String, dynamic> json) => CompletionRate(
        score: json["score"],
        label: json["label"],
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "score": score,
        "label": label,
        "rating": rating,
    };
}

class PerformanceOverview {
    final String badge;
    final String title;
    final String subtitle;
    final String overallPerformance;
    final String statusRating;

    PerformanceOverview({
        required this.badge,
        required this.title,
        required this.subtitle,
        required this.overallPerformance,
        required this.statusRating,
    });

    factory PerformanceOverview.fromJson(Map<String, dynamic> json) => PerformanceOverview(
        badge: json["badge"],
        title: json["title"],
        subtitle: json["subtitle"],
        overallPerformance: json["overall_performance"],
        statusRating: json["status_rating"],
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "title": title,
        "subtitle": subtitle,
        "overall_performance": overallPerformance,
        "status_rating": statusRating,
    };
}

class PerformanceSummary {
    final String monthBadge;
    final String summaryText;
    final String overallStatus;
    final String trend;
    final String nextReview;

    PerformanceSummary({
        required this.monthBadge,
        required this.summaryText,
        required this.overallStatus,
        required this.trend,
        required this.nextReview,
    });

    factory PerformanceSummary.fromJson(Map<String, dynamic> json) => PerformanceSummary(
        monthBadge: json["month_badge"],
        summaryText: json["summary_text"],
        overallStatus: json["overall_status"],
        trend: json["trend"],
        nextReview: json["next_review"],
    );

    Map<String, dynamic> toJson() => {
        "month_badge": monthBadge,
        "summary_text": summaryText,
        "overall_status": overallStatus,
        "trend": trend,
        "next_review": nextReview,
    };
}

class PerformanceTrend {
    final String title;
    final List<String> months;
    final List<int> trendValues;

    PerformanceTrend({
        required this.title,
        required this.months,
        required this.trendValues,
    });

    factory PerformanceTrend.fromJson(Map<String, dynamic> json) => PerformanceTrend(
        title: json["title"],
        months: List<String>.from(json["months"].map((x) => x)),
        trendValues: List<int>.from(json["trend_values"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "months": List<dynamic>.from(months.map((x) => x)),
        "trend_values": List<dynamic>.from(trendValues.map((x) => x)),
    };
}

class RecentServiceIssues {
    final String title;
    final List<Issue> issues;

    RecentServiceIssues({
        required this.title,
        required this.issues,
    });

    factory RecentServiceIssues.fromJson(Map<String, dynamic> json) => RecentServiceIssues(
        title: json["title"],
        issues: List<Issue>.from(json["issues"].map((x) => Issue.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "issues": List<dynamic>.from(issues.map((x) => x.toJson())),
    };
}

class Issue {
    final int id;
    final String issueTitle;
    final String reportedDate;
    final String statusBadge;
    final String statusClass;

    Issue({
        required this.id,
        required this.issueTitle,
        required this.reportedDate,
        required this.statusBadge,
        required this.statusClass,
    });

    factory Issue.fromJson(Map<String, dynamic> json) => Issue(
        id: json["id"],
        issueTitle: json["issue_title"],
        reportedDate: json["reported_date"],
        statusBadge: json["status_badge"],
        statusClass: json["status_class"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "issue_title": issueTitle,
        "reported_date": reportedDate,
        "status_badge": statusBadge,
        "status_class": statusClass,
    };
}

class ServiceSnapshot {
    final Completed completed;
    final AvgResponse avgResponse;
    final AvgResponse resolved;
    final AvgResponse rating;

    ServiceSnapshot({
        required this.completed,
        required this.avgResponse,
        required this.resolved,
        required this.rating,
    });

    factory ServiceSnapshot.fromJson(Map<String, dynamic> json) => ServiceSnapshot(
        completed: Completed.fromJson(json["completed"]),
        avgResponse: AvgResponse.fromJson(json["avg_response"]),
        resolved: AvgResponse.fromJson(json["resolved"]),
        rating: AvgResponse.fromJson(json["rating"]),
    );

    Map<String, dynamic> toJson() => {
        "completed": completed.toJson(),
        "avg_response": avgResponse.toJson(),
        "resolved": resolved.toJson(),
        "rating": rating.toJson(),
    };
}

class AvgResponse {
    final String count;
    final String label;
    final String icon;

    AvgResponse({
        required this.count,
        required this.label,
        required this.icon,
    });

    factory AvgResponse.fromJson(Map<String, dynamic> json) => AvgResponse(
        count: json["count"],
        label: json["label"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "label": label,
        "icon": icon,
    };
}

class Completed {
    final int count;
    final String label;
    final String icon;

    Completed({
        required this.count,
        required this.label,
        required this.icon,
    });

    factory Completed.fromJson(Map<String, dynamic> json) => Completed(
        count: json["count"],
        label: json["label"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "label": label,
        "icon": icon,
    };
}