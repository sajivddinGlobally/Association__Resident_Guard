import 'dart:convert';

MaintananceChargeStatusModel maintananceChargeStatusModelFromJson(String str) =>
    MaintananceChargeStatusModel.fromJson(json.decode(str));

String maintananceChargeStatusModelToJson(MaintananceChargeStatusModel data) =>
    json.encode(data.toJson());

class MaintananceChargeStatusModel {
  bool? status;
  String? message;
  Data? data;

  MaintananceChargeStatusModel({
    this.status,
    this.message,
    this.data,
  });

  factory MaintananceChargeStatusModel.fromJson(Map<String, dynamic> json) =>
      MaintananceChargeStatusModel(
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
  MonthlyCollection? monthlyCollection;
  ChargeOverview? chargeOverview;
  CollectionProgress? collectionProgress;
  PaymentStatusBreakdown? paymentStatusBreakdown;
  UnitWiseStatus? unitWiseStatus;

  Data({
    this.header,
    this.monthlyCollection,
    this.chargeOverview,
    this.collectionProgress,
    this.paymentStatusBreakdown,
    this.unitWiseStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        monthlyCollection: json["monthly_collection"] == null
            ? null
            : MonthlyCollection.fromJson(json["monthly_collection"]),
        chargeOverview: json["charge_overview"] == null
            ? null
            : ChargeOverview.fromJson(json["charge_overview"]),
        collectionProgress: json["collection_progress"] == null
            ? null
            : CollectionProgress.fromJson(json["collection_progress"]),
        paymentStatusBreakdown: json["payment_status_breakdown"] == null
            ? null
            : PaymentStatusBreakdown.fromJson(
                json["payment_status_breakdown"],
              ),
        unitWiseStatus: json["unit_wise_status"] == null
            ? null
            : UnitWiseStatus.fromJson(json["unit_wise_status"]),
      );

  Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "monthly_collection": monthlyCollection?.toJson(),
        "charge_overview": chargeOverview?.toJson(),
        "collection_progress": collectionProgress?.toJson(),
        "payment_status_breakdown": paymentStatusBreakdown?.toJson(),
        "unit_wise_status": unitWiseStatus?.toJson(),
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

class MonthlyCollection {
  String? badge;
  String? title;
  int? totalCollected;
  String? formattedTotalCollected;
  String? description;
  MonthlyCollectionSummary? summary;

  MonthlyCollection({
    this.badge,
    this.title,
    this.totalCollected,
    this.formattedTotalCollected,
    this.description,
    this.summary,
  });

  factory MonthlyCollection.fromJson(Map<String, dynamic> json) =>
      MonthlyCollection(
        badge: json["badge"],
        title: json["title"],
        totalCollected: json["total_collected"] is num
            ? (json["total_collected"] as num).toInt()
            : int.tryParse(json["total_collected"]?.toString() ?? ""),
        formattedTotalCollected: json["formatted_total_collected"]?.toString(),
        description: json["description"],
        summary: json["summary"] == null
            ? null
            : MonthlyCollectionSummary.fromJson(json["summary"]),
      );

  Map<String, dynamic> toJson() => {
        "badge": badge,
        "title": title,
        "total_collected": totalCollected,
        "formatted_total_collected": formattedTotalCollected,
        "description": description,
        "summary": summary?.toJson(),
      };
}

class MonthlyCollectionSummary {
  String? totalUnits;
  String? paidUnits;
  String? pendingUnits;

  MonthlyCollectionSummary({
    this.totalUnits,
    this.paidUnits,
    this.pendingUnits,
  });

  factory MonthlyCollectionSummary.fromJson(Map<String, dynamic> json) =>
      MonthlyCollectionSummary(
        totalUnits: json["total_units"]?.toString(),
        paidUnits: json["paid_units"]?.toString(),
        pendingUnits: json["pending_units"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "total_units": totalUnits,
        "paid_units": paidUnits,
        "pending_units": pendingUnits,
      };
}

class ChargeOverview {
  String? paidAmount;
  String? paidUnitsLabel;
  String? pendingAmount;
  String? pendingUnitsLabel;
  String? overdueAmount;
  String? overdueUnitsLabel;
  String? collectionRate;
  String? collectionRateLabel;

  ChargeOverview({
    this.paidAmount,
    this.paidUnitsLabel,
    this.pendingAmount,
    this.pendingUnitsLabel,
    this.overdueAmount,
    this.overdueUnitsLabel,
    this.collectionRate,
    this.collectionRateLabel,
  });

  factory ChargeOverview.fromJson(Map<String, dynamic> json) => ChargeOverview(
        paidAmount: json["paid_amount"]?.toString(),
        paidUnitsLabel: json["paid_units_label"]?.toString(),
        pendingAmount: json["pending_amount"]?.toString(),
        pendingUnitsLabel: json["pending_units_label"]?.toString(),
        overdueAmount: json["overdue_amount"]?.toString(),
        overdueUnitsLabel: json["overdue_units_label"]?.toString(),
        collectionRate: json["collection_rate"]?.toString(),
        collectionRateLabel: json["collection_rate_label"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "paid_amount": paidAmount,
        "paid_units_label": paidUnitsLabel,
        "pending_amount": pendingAmount,
        "pending_units_label": pendingUnitsLabel,
        "overdue_amount": overdueAmount,
        "overdue_units_label": overdueUnitsLabel,
        "collection_rate": collectionRate,
        "collection_rate_label": collectionRateLabel,
      };
}

class CollectionProgress {
  int? percentage;
  String? percentageText;
  String? collectedText;
  String? totalDueText;

  CollectionProgress({
    this.percentage,
    this.percentageText,
    this.collectedText,
    this.totalDueText,
  });

  factory CollectionProgress.fromJson(Map<String, dynamic> json) =>
      CollectionProgress(
        percentage: json["percentage"] is num
            ? (json["percentage"] as num).toInt()
            : int.tryParse(json["percentage"]?.toString() ?? ""),
        percentageText: json["percentage_text"]?.toString(),
        collectedText: json["collected_text"]?.toString(),
        totalDueText: json["total_due_text"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "percentage": percentage,
        "percentage_text": percentageText,
        "collected_text": collectedText,
        "total_due_text": totalDueText,
      };
}

class PaymentStatusBreakdown {
  PaymentStatusItem? paid;
  PaymentStatusItem? pending;
  PaymentStatusItem? overdue;

  PaymentStatusBreakdown({
    this.paid,
    this.pending,
    this.overdue,
  });

  factory PaymentStatusBreakdown.fromJson(Map<String, dynamic> json) =>
      PaymentStatusBreakdown(
        paid: json["paid"] == null
            ? null
            : PaymentStatusItem.fromJson(json["paid"]),
        pending: json["pending"] == null
            ? null
            : PaymentStatusItem.fromJson(json["pending"]),
        overdue: json["overdue"] == null
            ? null
            : PaymentStatusItem.fromJson(json["overdue"]),
      );

  Map<String, dynamic> toJson() => {
        "paid": paid?.toJson(),
        "pending": pending?.toJson(),
        "overdue": overdue?.toJson(),
      };
}

class PaymentStatusItem {
  int? count;
  String? title;
  String? subtitle;

  PaymentStatusItem({
    this.count,
    this.title,
    this.subtitle,
  });

  factory PaymentStatusItem.fromJson(Map<String, dynamic> json) =>
      PaymentStatusItem(
        count: json["count"] is num
            ? (json["count"] as num).toInt()
            : int.tryParse(json["count"]?.toString() ?? ""),
        title: json["title"]?.toString(),
        subtitle: json["subtitle"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "title": title,
        "subtitle": subtitle,
      };
}

class UnitWiseStatus {
  String? title;
  List<TabItem>? tabs;
  String? activeTab;
  List<RecordItem>? records;

  UnitWiseStatus({
    this.title,
    this.tabs,
    this.activeTab,
    this.records,
  });

  factory UnitWiseStatus.fromJson(Map<String, dynamic> json) => UnitWiseStatus(
        title: json["title"]?.toString(),
        tabs: json["tabs"] == null
            ? []
            : List<TabItem>.from(
                json["tabs"].map((x) => TabItem.fromJson(x)),
              ),
        activeTab: json["active_tab"]?.toString(),
        records: json["records"] == null
            ? []
            : List<RecordItem>.from(
                json["records"].map((x) => RecordItem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "tabs": tabs == null ? [] : List<dynamic>.from(tabs!.map((x) => x.toJson())),
        "active_tab": activeTab,
        "records": records == null
            ? []
            : List<dynamic>.from(records!.map((x) => x.toJson())),
      };
}

class TabItem {
  String? key;
  String? label;
  bool? isActive;

  TabItem({
    this.key,
    this.label,
    this.isActive,
  });

  factory TabItem.fromJson(Map<String, dynamic> json) => TabItem(
        key: json["key"]?.toString(),
        label: json["label"]?.toString(),
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "label": label,
        "is_active": isActive,
      };
}

class RecordItem {
  int? id;
  String? unitNumber;
  String? block;
  String? ownerName;
  String? subtitle;
  int? amount;
  String? formattedAmount;
  String? status;
  String? statusRaw;
  String? badgeColor;
  String? dueDate;
  String? defaulterStatus;
  bool? isDefaulter;
  bool? isOverdueAbove2Months;

  RecordItem({
    this.id,
    this.unitNumber,
    this.block,
    this.ownerName,
    this.subtitle,
    this.amount,
    this.formattedAmount,
    this.status,
    this.statusRaw,
    this.badgeColor,
    this.dueDate,
    this.defaulterStatus,
    this.isDefaulter,
    this.isOverdueAbove2Months,
  });

  factory RecordItem.fromJson(Map<String, dynamic> json) => RecordItem(
        id: json["id"] is num
            ? (json["id"] as num).toInt()
            : int.tryParse(json["id"]?.toString() ?? ""),
        unitNumber: json["unit_number"]?.toString(),
        block: json["block"]?.toString(),
        ownerName: json["owner_name"]?.toString(),
        subtitle: json["subtitle"]?.toString(),
        amount: json["amount"] is num
            ? (json["amount"] as num).toInt()
            : int.tryParse(json["amount"]?.toString() ?? ""),
        formattedAmount: json["formatted_amount"]?.toString(),
        status: json["defaulter_status"]?.toString() ??
            json["status"]?.toString() ??
            json["status_badge"]?.toString(),
        statusRaw: json["status_raw"]?.toString(),
        badgeColor: json["badge_color"]?.toString() ??
            json["status_color"]?.toString(),
        dueDate: json["due_date"]?.toString(),
        defaulterStatus: json["defaulter_status"]?.toString(),
        isDefaulter: json["is_defaulter"] == true ||
            json["is_defaulter"] == 1 ||
            json["is_defaulter"] == "true",
        isOverdueAbove2Months: json["is_overdue_above_2_months"] == true ||
            json["is_overdue_above_2_months"] == 1 ||
            json["is_overdue_above_2_months"] == "true",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unit_number": unitNumber,
        "block": block,
        "owner_name": ownerName,
        "subtitle": subtitle,
        "amount": amount,
        "formatted_amount": formattedAmount,
        "status": status,
        "status_raw": statusRaw,
        "badge_color": badgeColor,
        "due_date": dueDate,
        "defaulter_status": defaulterStatus,
        "is_defaulter": isDefaulter,
        "is_overdue_above_2_months": isOverdueAbove2Months,
      };
}
