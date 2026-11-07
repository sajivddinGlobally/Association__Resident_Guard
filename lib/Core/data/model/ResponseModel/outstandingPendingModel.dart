// To parse this JSON data, do
//
//     final outstandingPendingModel = outstandingPendingModelFromJson(jsonString);

import 'dart:convert';

OutstandingPendingModel outstandingPendingModelFromJson(String str) => OutstandingPendingModel.fromJson(json.decode(str));

String outstandingPendingModelToJson(OutstandingPendingModel data) => json.encode(data.toJson());

class OutstandingPendingModel {
    bool? status;
    String? message;
    Data? data;

    OutstandingPendingModel({
        this.status,
        this.message,
        this.data,
    });

    factory OutstandingPendingModel.fromJson(Map<String, dynamic> json) => OutstandingPendingModel(
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
    PendingAmountOverview? pendingAmountOverview;
    KpiCards? kpiCards;
    PendingByUnitHeader? pendingByUnitHeader;
    List<FilterChip>? filterChips;
    TotalOutstandingCard? totalOutstandingCard;
    PendingUnits? pendingUnits;

    Data({
        this.header,
        this.pendingAmountOverview,
        this.kpiCards,
        this.pendingByUnitHeader,
        this.filterChips,
        this.totalOutstandingCard,
        this.pendingUnits,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        pendingAmountOverview: json["pending_amount_overview"] == null ? null : PendingAmountOverview.fromJson(json["pending_amount_overview"]),
        kpiCards: json["kpi_cards"] == null ? null : KpiCards.fromJson(json["kpi_cards"]),
        pendingByUnitHeader: json["pending_by_unit_header"] == null ? null : PendingByUnitHeader.fromJson(json["pending_by_unit_header"]),
        filterChips: json["filter_chips"] == null ? [] : List<FilterChip>.from(json["filter_chips"]!.map((x) => FilterChip.fromJson(x))),
        totalOutstandingCard: json["total_outstanding_card"] == null ? null : TotalOutstandingCard.fromJson(json["total_outstanding_card"]),
        pendingUnits: json["pending_units"] == null ? null : PendingUnits.fromJson(json["pending_units"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "pending_amount_overview": pendingAmountOverview?.toJson(),
        "kpi_cards": kpiCards?.toJson(),
        "pending_by_unit_header": pendingByUnitHeader?.toJson(),
        "filter_chips": filterChips == null ? [] : List<dynamic>.from(filterChips!.map((x) => x.toJson())),
        "total_outstanding_card": totalOutstandingCard?.toJson(),
        "pending_units": pendingUnits?.toJson(),
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

class KpiCards {
    CurrentMonth? currentMonth;
    CurrentMonth? totalPending;

    KpiCards({
        this.currentMonth,
        this.totalPending,
    });

    factory KpiCards.fromJson(Map<String, dynamic> json) => KpiCards(
        currentMonth: json["current_month"] == null ? null : CurrentMonth.fromJson(json["current_month"]),
        totalPending: json["total_pending"] == null ? null : CurrentMonth.fromJson(json["total_pending"]),
    );

    Map<String, dynamic> toJson() => {
        "current_month": currentMonth?.toJson(),
        "total_pending": totalPending?.toJson(),
    };
}

class CurrentMonth {
    String? title;
    String? amount;
    String? subtitle;

    CurrentMonth({
        this.title,
        this.amount,
        this.subtitle,
    });

    factory CurrentMonth.fromJson(Map<String, dynamic> json) => CurrentMonth(
        title: json["title"],
        amount: json["amount"],
        subtitle: json["subtitle"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "amount": amount,
        "subtitle": subtitle,
    };
}

class PendingAmountOverview {
    String? cardTitle;
    String? badge;
    String? unitNumber;
    String? subtitle;
    String? propertyOwner;
    String? dueDate;
    String? image;
    String? detailsUrl;

    PendingAmountOverview({
        this.cardTitle,
        this.badge,
        this.unitNumber,
        this.subtitle,
        this.propertyOwner,
        this.dueDate,
        this.image,
        this.detailsUrl,
    });

    factory PendingAmountOverview.fromJson(Map<String, dynamic> json) => PendingAmountOverview(
        cardTitle: json["card_title"],
        badge: json["badge"],
        unitNumber: json["unit_number"],
        subtitle: json["subtitle"],
        propertyOwner: json["property_owner"],
        dueDate: json["due_date"],
        image: json["image"],
        detailsUrl: json["details_url"],
    );

    Map<String, dynamic> toJson() => {
        "card_title": cardTitle,
        "badge": badge,
        "unit_number": unitNumber,
        "subtitle": subtitle,
        "property_owner": propertyOwner,
        "due_date": dueDate,
        "image": image,
        "details_url": detailsUrl,
    };
}

class PendingByUnitHeader {
    String? title;
    String? countBadge;

    PendingByUnitHeader({
        this.title,
        this.countBadge,
    });

    factory PendingByUnitHeader.fromJson(Map<String, dynamic> json) => PendingByUnitHeader(
        title: json["title"],
        countBadge: json["count_badge"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "count_badge": countBadge,
    };
}

class PendingUnits {
    int? count;
    List<Item>? items;

    PendingUnits({
        this.count,
        this.items,
    });

    factory PendingUnits.fromJson(Map<String, dynamic> json) => PendingUnits(
        count: json["count"],
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class Item {
    int? id;
    String? unitNumber;
    String? ownerName;
    String? subtitle;
    int? amount;
    String? formattedAmount;
    String? statusBadge;
    String? statusColor;
    String? image;
    String? detailsUrl;
    String? defaulterStatus;
    bool? isDefaulter;
    String? badgeColor;
    bool? isOverdueAbove2Months;

    Item({
        this.id,
        this.unitNumber,
        this.ownerName,
        this.subtitle,
        this.amount,
        this.formattedAmount,
        this.statusBadge,
        this.statusColor,
        this.image,
        this.detailsUrl,
        this.defaulterStatus,
        this.isDefaulter,
        this.badgeColor,
        this.isOverdueAbove2Months,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        unitNumber: json["unit_number"]?.toString(),
        ownerName: json["owner_name"]?.toString(),
        subtitle: json["subtitle"]?.toString(),
        amount: json["amount"] is num
            ? (json["amount"] as num).toInt()
            : int.tryParse(json["amount"]?.toString() ?? ""),
        formattedAmount: json["formatted_amount"]?.toString(),
        statusBadge: json["defaulter_status"]?.toString() ??
            json["status_badge"]?.toString(),
        statusColor: json["badge_color"]?.toString() ??
            json["status_color"]?.toString(),
        image: json["image"]?.toString(),
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
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "unit_number": unitNumber,
        "owner_name": ownerName,
        "subtitle": subtitle,
        "amount": amount,
        "formatted_amount": formattedAmount,
        "status_badge": statusBadge,
        "status_color": statusColor,
        "image": image,
        "details_url": detailsUrl,
        "defaulter_status": defaulterStatus,
        "is_defaulter": isDefaulter,
        "badge_color": badgeColor,
        "is_overdue_above_2_months": isOverdueAbove2Months,
    };
}

enum StatusBadge {
    OVERDUE
}

final statusBadgeValues = EnumValues({
    "OVERDUE": StatusBadge.OVERDUE
});

enum StatusColor {
    EF4444
}

final statusColorValues = EnumValues({
    "#ef4444": StatusColor.EF4444
});

class TotalOutstandingCard {
    String? title;
    String? amount;
    int? percentage;
    String? collectedText;
    String? totalDueText;

    TotalOutstandingCard({
        this.title,
        this.amount,
        this.percentage,
        this.collectedText,
        this.totalDueText,
    });

    factory TotalOutstandingCard.fromJson(Map<String, dynamic> json) => TotalOutstandingCard(
        title: json["title"],
        amount: json["amount"],
        percentage: json["percentage"],
        collectedText: json["collected_text"],
        totalDueText: json["total_due_text"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "amount": amount,
        "percentage": percentage,
        "collected_text": collectedText,
        "total_due_text": totalDueText,
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
