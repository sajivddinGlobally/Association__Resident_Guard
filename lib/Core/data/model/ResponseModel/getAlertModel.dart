// To parse this JSON data, do
//
//     final getAlertModel = getAlertModelFromJson(jsonString);

import 'dart:convert';

GetAlertModel getAlertModelFromJson(String str) => GetAlertModel.fromJson(json.decode(str));

String getAlertModelToJson(GetAlertModel data) => json.encode(data.toJson());

class GetAlertModel {
    bool? status;
    String? message;
    Data? data;

    GetAlertModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetAlertModel.fromJson(Map<String, dynamic> json) => GetAlertModel(
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
    AlertOverview? alertOverview;
    AlertsSection? alertsSection;
    List<FilterChip>? filterChips;
    int? totalAlertsCount;
    List<Alert>? alerts;

    Data({
        this.header,
        this.alertOverview,
        this.alertsSection,
        this.filterChips,
        this.totalAlertsCount,
        this.alerts,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        alertOverview: json["alert_overview"] == null ? null : AlertOverview.fromJson(json["alert_overview"]),
        alertsSection: json["alerts_section"] == null ? null : AlertsSection.fromJson(json["alerts_section"]),
        filterChips: json["filter_chips"] == null ? [] : List<FilterChip>.from(json["filter_chips"]!.map((x) => FilterChip.fromJson(x))),
        totalAlertsCount: json["total_alerts_count"],
        alerts: json["alerts"] == null ? [] : List<Alert>.from(json["alerts"]!.map((x) => Alert.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "alert_overview": alertOverview?.toJson(),
        "alerts_section": alertsSection?.toJson(),
        "filter_chips": filterChips == null ? [] : List<dynamic>.from(filterChips!.map((x) => x.toJson())),
        "total_alerts_count": totalAlertsCount,
        "alerts": alerts == null ? [] : List<dynamic>.from(alerts!.map((x) => x.toJson())),
    };
}

class AlertOverview {
    String? badge;
    String? title;
    String? description;
    Metrics? metrics;

    AlertOverview({
        this.badge,
        this.title,
        this.description,
        this.metrics,
    });

    factory AlertOverview.fromJson(Map<String, dynamic> json) => AlertOverview(
        badge: json["badge"],
        title: json["title"],
        description: json["description"],
        metrics: json["metrics"] == null ? null : Metrics.fromJson(json["metrics"]),
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "title": title,
        "description": description,
        "metrics": metrics?.toJson(),
    };
}

class Metrics {
    General? urgent;
    General? unread;
    General? general;

    Metrics({
        this.urgent,
        this.unread,
        this.general,
    });

    factory Metrics.fromJson(Map<String, dynamic> json) => Metrics(
        urgent: json["urgent"] == null ? null : General.fromJson(json["urgent"]),
        unread: json["unread"] == null ? null : General.fromJson(json["unread"]),
        general: json["general"] == null ? null : General.fromJson(json["general"]),
    );

    Map<String, dynamic> toJson() => {
        "urgent": urgent?.toJson(),
        "unread": unread?.toJson(),
        "general": general?.toJson(),
    };
}

class General {
    String? count;
    String? label;
    bool? isHighlighted;

    General({
        this.count,
        this.label,
        this.isHighlighted,
    });

    factory General.fromJson(Map<String, dynamic> json) => General(
        count: json["count"],
        label: json["label"],
        isHighlighted: json["is_highlighted"],
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "label": label,
        "is_highlighted": isHighlighted,
    };
}

class Alert {
    String? id;
    String? cardType;
    String? category;
    bool? isUrgent;
    bool? isUnread;
    String? badgeText;
    String? timeAgo;
    String? title;
    String? subtitle;
    String? locationInfo;
    QuickAction? actionButton;
    String? iconType;
    String? iconBg;
    String? iconColor;
    Badge? badge;
    QuickAction? actionLink;

    Alert({
        this.id,
        this.cardType,
        this.category,
        this.isUrgent,
        this.isUnread,
        this.badgeText,
        this.timeAgo,
        this.title,
        this.subtitle,
        this.locationInfo,
        this.actionButton,
        this.iconType,
        this.iconBg,
        this.iconColor,
        this.badge,
        this.actionLink,
    });

    factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        id: json["id"],
        cardType: json["card_type"],
        category: json["category"],
        isUrgent: json["is_urgent"],
        isUnread: json["is_unread"],
        badgeText: json["badge_text"],
        timeAgo: json["time_ago"],
        title: json["title"],
        subtitle: json["subtitle"],
        locationInfo: json["location_info"],
        actionButton: json["action_button"] == null ? null : QuickAction.fromJson(json["action_button"]),
        iconType: json["icon_type"],
        iconBg: json["icon_bg"],
        iconColor: json["icon_color"],
        badge: json["badge"] == null ? null : Badge.fromJson(json["badge"]),
        actionLink: json["action_link"] == null ? null : QuickAction.fromJson(json["action_link"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "card_type": cardType,
        "category": category,
        "is_urgent": isUrgent,
        "is_unread": isUnread,
        "badge_text": badgeText,
        "time_ago": timeAgo,
        "title": title,
        "subtitle": subtitle,
        "location_info": locationInfo,
        "action_button": actionButton?.toJson(),
        "icon_type": iconType,
        "icon_bg": iconBg,
        "icon_color": iconColor,
        "badge": badge?.toJson(),
        "action_link": actionLink?.toJson(),
    };
}

class QuickAction {
    String? label;
    String? actionUrl;

    QuickAction({
        this.label,
        this.actionUrl,
    });

    factory QuickAction.fromJson(Map<String, dynamic> json) => QuickAction(
        label: json["label"],
        actionUrl: json["action_url"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "action_url": actionUrl,
    };
}

class Badge {
    String? text;
    String? type;
    String? borderColor;
    String? textColor;
    String? bgColor;

    Badge({
        this.text,
        this.type,
        this.borderColor,
        this.textColor,
        this.bgColor,
    });

    factory Badge.fromJson(Map<String, dynamic> json) => Badge(
        text: json["text"],
        type: json["type"],
        borderColor: json["border_color"],
        textColor: json["text_color"],
        bgColor: json["bg_color"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "type": type,
        "border_color": borderColor,
        "text_color": textColor,
        "bg_color": bgColor,
    };
}

class AlertsSection {
    String? title;
    QuickAction? quickAction;

    AlertsSection({
        this.title,
        this.quickAction,
    });

    factory AlertsSection.fromJson(Map<String, dynamic> json) => AlertsSection(
        title: json["title"],
        quickAction: json["quick_action"] == null ? null : QuickAction.fromJson(json["quick_action"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "quick_action": quickAction?.toJson(),
    };
}

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
