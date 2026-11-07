// To parse this JSON data, do
//
//     final residentMmcStatusResModel = residentMmcStatusResModelFromJson(jsonString);

import 'dart:convert';

ResidentMmcStatusResModel residentMmcStatusResModelFromJson(String str) =>
    ResidentMmcStatusResModel.fromJson(json.decode(str));

String residentMmcStatusResModelToJson(ResidentMmcStatusResModel data) =>
    json.encode(data.toJson());

int _parseInt(dynamic val, [int def = 0]) {
  if (val == null) return def;
  if (val is int) return val;
  if (val is num) return val.toInt();
  return int.tryParse(val.toString()) ?? def;
}

num _parseNum(dynamic val, [num def = 0]) {
  if (val == null) return def;
  if (val is num) return val;
  return num.tryParse(val.toString()) ?? def;
}

String _parseString(dynamic val, [String def = '']) {
  if (val == null) return def;
  return val.toString();
}

bool _parseBool(dynamic val, [bool def = false]) {
  if (val == null) return def;
  if (val is bool) return val;
  if (val is num) return val != 0;
  final s = val.toString().toLowerCase();
  return s == 'true' || s == '1';
}

class ResidentMmcStatusResModel {
  final bool status;
  final String message;
  final Data data;

  ResidentMmcStatusResModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ResidentMmcStatusResModel.fromJson(Map<String, dynamic> json) =>
      ResidentMmcStatusResModel(
        status: _parseBool(json["status"]),
        message: _parseString(json["message"]),
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  final Header header;
  final CurrentMonth currentMonth;
  final Actions actions;
  final PendingDuesSummary? pendingDuesSummary;
  final List<MmcHistoryItem>? history;
  final int? pendingMonthsCount;
  final int? totalPendingAmount;

  Data({
    required this.header,
    required this.currentMonth,
    required this.actions,
    this.pendingDuesSummary,
    this.history,
    this.pendingMonthsCount,
    this.totalPendingAmount,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    List<MmcHistoryItem> historyList = [];
    if (json["history"] != null && json["history"] is List) {
      historyList = (json["history"] as List)
          .map((x) => MmcHistoryItem.fromJson(x))
          .toList();
    } else if (json["past_months"] != null && json["past_months"] is List) {
      historyList = (json["past_months"] as List)
          .map((x) => MmcHistoryItem.fromJson(x))
          .toList();
    } else if (json["bills"] != null && json["bills"] is List) {
      historyList = (json["bills"] as List)
          .map((x) => MmcHistoryItem.fromJson(x))
          .toList();
    }

    return Data(
      header: Header.fromJson(json["header"] ?? {}),
      currentMonth: CurrentMonth.fromJson(json["current_month"] ?? {}),
      actions: Actions.fromJson(json["actions"] ?? {}),
      pendingDuesSummary: json["pending_dues_summary"] != null
          ? PendingDuesSummary.fromJson(json["pending_dues_summary"])
          : null,
      history: historyList.isNotEmpty ? historyList : null,
      pendingMonthsCount: json["pending_months_count"] ?? json["unpaid_count"],
      totalPendingAmount: json["total_pending_amount"] ?? json["total_due"],
    );
  }

  Map<String, dynamic> toJson() => {
    "header": header.toJson(),
    "current_month": currentMonth.toJson(),
    "actions": actions.toJson(),
    "pending_dues_summary": pendingDuesSummary?.toJson(),
    "history": history?.map((x) => x.toJson()).toList(),
    "pending_months_count": pendingMonthsCount,
    "total_pending_amount": totalPendingAmount,
  };
}

class PendingDuesSummary {
  final bool hasPendingDues;
  final int totalPendingMonths;
  final num totalOutstanding;
  final String totalOutstandingDisplay;
  final String subtitle;
  final List<PendingMonthItem> pendingMonths;

  PendingDuesSummary({
    required this.hasPendingDues,
    required this.totalPendingMonths,
    required this.totalOutstanding,
    required this.totalOutstandingDisplay,
    required this.subtitle,
    required this.pendingMonths,
  });

  factory PendingDuesSummary.fromJson(Map<String, dynamic> json) {
    List<PendingMonthItem> months = [];
    if (json["pending_months"] != null && json["pending_months"] is List) {
      months = (json["pending_months"] as List)
          .map((x) => PendingMonthItem.fromJson(x))
          .toList();
    }

    return PendingDuesSummary(
      hasPendingDues: _parseBool(json["has_pending_dues"]),
      totalPendingMonths: _parseInt(json["total_pending_months"]),
      totalOutstanding: _parseNum(json["total_outstanding"]),
      totalOutstandingDisplay: _parseString(json["total_outstanding_display"]),
      subtitle: _parseString(json["subtitle"]),
      pendingMonths: months,
    );
  }

  Map<String, dynamic> toJson() => {
    "has_pending_dues": hasPendingDues,
    "total_pending_months": totalPendingMonths,
    "total_outstanding": totalOutstanding,
    "total_outstanding_display": totalOutstandingDisplay,
    "subtitle": subtitle,
    "pending_months": pendingMonths.map((x) => x.toJson()).toList(),
  };
}

class PendingMonthItem {
  final int id;
  final String month;
  final num amount;
  final String amountDisplay;
  final String dueDate;
  final String status;
  final String badgeColor;

  PendingMonthItem({
    required this.id,
    required this.month,
    required this.amount,
    required this.amountDisplay,
    required this.dueDate,
    required this.status,
    required this.badgeColor,
  });

  factory PendingMonthItem.fromJson(Map<String, dynamic> json) =>
      PendingMonthItem(
        id: _parseInt(json["id"]),
        month: _parseString(json["month"]),
        amount: _parseNum(json["amount"]),
        amountDisplay: _parseString(json["amount_display"]),
        dueDate: _parseString(json["due_date"]),
        status: _parseString(json["status"]),
        badgeColor: _parseString(json["badge_color"], "#eab308"),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "month": month,
    "amount": amount,
    "amount_display": amountDisplay,
    "due_date": dueDate,
    "status": status,
    "badge_color": badgeColor,
  };
}

class MmcHistoryItem {
  final String month;
  final String amountDisplay;
  final int amount;
  final String currency;
  final String status;
  final bool isPaid;
  final String? dueDate;
  final String? paidDate;

  MmcHistoryItem({
    required this.month,
    required this.amountDisplay,
    required this.amount,
    required this.currency,
    required this.status,
    required this.isPaid,
    this.dueDate,
    this.paidDate,
  });

  factory MmcHistoryItem.fromJson(Map<String, dynamic> json) => MmcHistoryItem(
    month:
        json["month"]?.toString() ?? json["billing_month"]?.toString() ?? "",
    amountDisplay:
        json["amount_display"]?.toString() ??
        "SAR ${json["amount"] ?? 4250}",
    amount: int.tryParse(json["amount"]?.toString() ?? "4250") ?? 4250,
    currency: json["currency"]?.toString() ?? "SAR",
    status:
        json["status"]?.toString() ??
        json["payment_status"]?.toString() ??
        "Pending",
    isPaid:
        (json["status"]?.toString().toLowerCase().contains("paid") ?? false) &&
        !(json["status"]?.toString().toLowerCase().contains("unpaid") ?? false),
    dueDate: json["due_date"]?.toString(),
    paidDate: json["paid_date"]?.toString() ?? json["paid_on"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "amount_display": amountDisplay,
    "amount": amount,
    "currency": currency,
    "status": status,
    "is_paid": isPaid,
    "due_date": dueDate,
    "paid_date": paidDate,
  };
}

class Actions {
  final PayNow viewHistory;
  final PayNow payNow;

  Actions({required this.viewHistory, required this.payNow});

  factory Actions.fromJson(Map<String, dynamic> json) => Actions(
    viewHistory: PayNow.fromJson(json["view_history"] ?? {}),
    payNow: PayNow.fromJson(json["pay_now"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "view_history": viewHistory.toJson(),
    "pay_now": payNow.toJson(),
  };
}

class PayNow {
  final String label;
  final String endpoint;
  final String method;
  final bool? isAvailable;
  final num? payAmount;
  final String? payAmountDisplay;

  PayNow({
    required this.label,
    required this.endpoint,
    required this.method,
    this.isAvailable,
    this.payAmount,
    this.payAmountDisplay,
  });

  factory PayNow.fromJson(Map<String, dynamic> json) => PayNow(
    label: _parseString(json["label"]),
    endpoint: _parseString(json["endpoint"]),
    method: _parseString(json["method"]),
    isAvailable: json["is_available"] != null ? _parseBool(json["is_available"]) : null,
    payAmount: json["pay_amount"] != null ? _parseNum(json["pay_amount"]) : null,
    payAmountDisplay: json["pay_amount_display"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "endpoint": endpoint,
    "method": method,
    "is_available": isAvailable,
    "pay_amount": payAmount,
    "pay_amount_display": payAmountDisplay,
  };
}

class CurrentMonth {
  final String sectionTitle;
  final String cardTitle;
  final Charge charge;
  final CurrentStatus currentStatus;
  final Month month;
  final Month paidOn;
  final TotalOutstanding? totalOutstanding;

  CurrentMonth({
    required this.sectionTitle,
    required this.cardTitle,
    required this.charge,
    required this.currentStatus,
    required this.month,
    required this.paidOn,
    this.totalOutstanding,
  });

  factory CurrentMonth.fromJson(Map<String, dynamic> json) => CurrentMonth(
    sectionTitle: _parseString(json["section_title"], "Current Month"),
    cardTitle: _parseString(json["card_title"], "Monthly Maintenance Charge"),
    charge: Charge.fromJson(json["charge"] ?? {}),
    currentStatus: CurrentStatus.fromJson(json["current_status"] ?? {}),
    month: Month.fromJson(json["month"] ?? {}),
    paidOn: Month.fromJson(json["paid_on"] ?? {}),
    totalOutstanding: json["total_outstanding"] != null
        ? TotalOutstanding.fromJson(json["total_outstanding"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "section_title": sectionTitle,
    "card_title": cardTitle,
    "charge": charge.toJson(),
    "current_status": currentStatus.toJson(),
    "month": month.toJson(),
    "paid_on": paidOn.toJson(),
    "total_outstanding": totalOutstanding?.toJson(),
  };
}

class TotalOutstanding {
  final num amount;
  final String amountDisplay;
  final int pendingMonthsCount;
  final String pendingMonthsLabel;
  final num pastArrears;
  final String pastArrearsDisplay;

  TotalOutstanding({
    required this.amount,
    required this.amountDisplay,
    required this.pendingMonthsCount,
    required this.pendingMonthsLabel,
    required this.pastArrears,
    required this.pastArrearsDisplay,
  });

  factory TotalOutstanding.fromJson(Map<String, dynamic> json) =>
      TotalOutstanding(
        amount: _parseNum(json["amount"]),
        amountDisplay: _parseString(json["amount_display"]),
        pendingMonthsCount: _parseInt(json["pending_months_count"]),
        pendingMonthsLabel: _parseString(json["pending_months_label"]),
        pastArrears: _parseNum(json["past_arrears"]),
        pastArrearsDisplay: _parseString(json["past_arrears_display"]),
      );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "amount_display": amountDisplay,
    "pending_months_count": pendingMonthsCount,
    "pending_months_label": pendingMonthsLabel,
    "past_arrears": pastArrears,
    "past_arrears_display": pastArrearsDisplay,
  };
}

class Charge {
  final String label;
  final num amount;
  final String currency;
  final String amountDisplay;

  Charge({
    required this.label,
    required this.amount,
    required this.currency,
    required this.amountDisplay,
  });

  factory Charge.fromJson(Map<String, dynamic> json) => Charge(
    label: _parseString(json["label"], "Monthly Charge"),
    amount: _parseNum(json["amount"]),
    currency: _parseString(json["currency"], "SAR"),
    amountDisplay: _parseString(json["amount_display"]),
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "amount": amount,
    "currency": currency,
    "amount_display": amountDisplay,
  };
}

class CurrentStatus {
  final String label;
  final String value;
  final String badgeColor;

  CurrentStatus({
    required this.label,
    required this.value,
    required this.badgeColor,
  });

  factory CurrentStatus.fromJson(Map<String, dynamic> json) => CurrentStatus(
    label: _parseString(json["label"], "Current Status"),
    value: _parseString(json["value"], "Pending"),
    badgeColor: _parseString(json["badge_color"], "#c59a3f"),
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
    "badge_color": badgeColor,
  };
}

class Month {
  final String label;
  final String value;

  Month({required this.label, required this.value});

  factory Month.fromJson(Map<String, dynamic> json) => Month(
    label: _parseString(json["label"]),
    value: _parseString(json["value"]),
  );

  Map<String, dynamic> toJson() => {"label": label, "value": value};
}

class Header {
  final String tag;
  final String subtitle;
  final String title;

  Header({required this.tag, required this.subtitle, required this.title});

  factory Header.fromJson(Map<String, dynamic> json) => Header(
    tag: _parseString(json["tag"], "MMC Status"),
    subtitle: _parseString(json["subtitle"], "Monthly Maintenance Charge"),
    title: _parseString(json["title"], "MMC STATUS"),
  );

  Map<String, dynamic> toJson() => {
    "tag": tag,
    "subtitle": subtitle,
    "title": title,
  };
}