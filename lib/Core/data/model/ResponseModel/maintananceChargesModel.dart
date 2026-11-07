// To parse this JSON data, do
//
//     final maintananceChargesModel = maintananceChargesModelFromJson(jsonString);

import 'dart:convert';

MaintananceChargesModel maintananceChargesModelFromJson(String str) => MaintananceChargesModel.fromJson(json.decode(str));

String maintananceChargesModelToJson(MaintananceChargesModel data) => json.encode(data.toJson());

class MaintananceChargesModel {
    bool? status;
    String? message;
    Data? data;

    MaintananceChargesModel({
        this.status,
        this.message,
        this.data,
    });

    factory MaintananceChargesModel.fromJson(Map<String, dynamic> json) => MaintananceChargesModel(
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
    MonthlyChargesOverview? monthlyChargesOverview;
    ChargeOverview? chargeOverview;
    CollectionProgress? collectionProgress;
    NavigationLinks? navigationLinks;

    Data({
        this.header,
        this.monthlyChargesOverview,
        this.chargeOverview,
        this.collectionProgress,
        this.navigationLinks,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        monthlyChargesOverview: json["monthly_charges_overview"] == null ? null : MonthlyChargesOverview.fromJson(json["monthly_charges_overview"]),
        chargeOverview: json["charge_overview"] == null ? null : ChargeOverview.fromJson(json["charge_overview"]),
        collectionProgress: json["collection_progress"] == null ? null : CollectionProgress.fromJson(json["collection_progress"]),
        navigationLinks: json["navigation_links"] == null ? null : NavigationLinks.fromJson(json["navigation_links"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "monthly_charges_overview": monthlyChargesOverview?.toJson(),
        "charge_overview": chargeOverview?.toJson(),
        "collection_progress": collectionProgress?.toJson(),
        "navigation_links": navigationLinks?.toJson(),
    };
}

class ChargeOverview {
    String? title;
    List<Card>? cards;

    ChargeOverview({
        this.title,
        this.cards,
    });

    factory ChargeOverview.fromJson(Map<String, dynamic> json) => ChargeOverview(
        title: json["title"],
        cards: json["cards"] == null ? [] : List<Card>.from(json["cards"]!.map((x) => Card.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "cards": cards == null ? [] : List<dynamic>.from(cards!.map((x) => x.toJson())),
    };
}

class Card {
    String? key;
    dynamic count;
    String? title;
    String? subtitle;
    String? status;

    Card({
        this.key,
        this.count,
        this.title,
        this.subtitle,
        this.status,
    });

    factory Card.fromJson(Map<String, dynamic> json) => Card(
        key: json["key"],
        count: json["count"],
        title: json["title"],
        subtitle: json["subtitle"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "count": count,
        "title": title,
        "subtitle": subtitle,
        "status": status,
    };
}

class CollectionProgress {
    String? title;
    String? label;
    int? percentage;
    String? percentageText;
    String? collectedText;
    String? totalDueText;

    CollectionProgress({
        this.title,
        this.label,
        this.percentage,
        this.percentageText,
        this.collectedText,
        this.totalDueText,
    });

    factory CollectionProgress.fromJson(Map<String, dynamic> json) => CollectionProgress(
        title: json["title"],
        label: json["label"],
        percentage: json["percentage"],
        percentageText: json["percentage_text"],
        collectedText: json["collected_text"],
        totalDueText: json["total_due_text"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "label": label,
        "percentage": percentage,
        "percentage_text": percentageText,
        "collected_text": collectedText,
        "total_due_text": totalDueText,
    };
}

class Header {
    String? title;
    String? subtitle;
    String? monthYear;

    Header({
        this.title,
        this.subtitle,
        this.monthYear,
    });

    factory Header.fromJson(Map<String, dynamic> json) => Header(
        title: json["title"],
        subtitle: json["subtitle"],
        monthYear: json["month_year"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "month_year": monthYear,
    };
}

class MonthlyChargesOverview {
    String? badge;
    String? title;
    String? description;
    Metrics? metrics;

    MonthlyChargesOverview({
        this.badge,
        this.title,
        this.description,
        this.metrics,
    });

    factory MonthlyChargesOverview.fromJson(Map<String, dynamic> json) => MonthlyChargesOverview(
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
    Collected? totalDue;
    Collected? collected;
    Collected? outstanding;

    Metrics({
        this.totalDue,
        this.collected,
        this.outstanding,
    });

    factory Metrics.fromJson(Map<String, dynamic> json) => Metrics(
        totalDue: json["total_due"] == null ? null : Collected.fromJson(json["total_due"]),
        collected: json["collected"] == null ? null : Collected.fromJson(json["collected"]),
        outstanding: json["outstanding"] == null ? null : Collected.fromJson(json["outstanding"]),
    );

    Map<String, dynamic> toJson() => {
        "total_due": totalDue?.toJson(),
        "collected": collected?.toJson(),
        "outstanding": outstanding?.toJson(),
    };
}

class Collected {
    int? amount;
    String? formatted;
    String? label;
    String? title;

    Collected({
        this.amount,
        this.formatted,
        this.label,
        this.title,
    });

    factory Collected.fromJson(Map<String, dynamic> json) => Collected(
        amount: json["amount"],
        formatted: json["formatted"],
        label: json["label"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "formatted": formatted,
        "label": label,
        "title": title,
    };
}

class NavigationLinks {
    String? title;
    String? subtitle;
    List<Item>? items;

    NavigationLinks({
        this.title,
        this.subtitle,
        this.items,
    });

    factory NavigationLinks.fromJson(Map<String, dynamic> json) => NavigationLinks(
        title: json["title"],
        subtitle: json["subtitle"],
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class Item {
    String? id;
    String? title;
    String? subtitle;
    String? route;

    Item({
        this.id,
        this.title,
        this.subtitle,
        this.route,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        route: json["route"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "route": route,
    };
}
