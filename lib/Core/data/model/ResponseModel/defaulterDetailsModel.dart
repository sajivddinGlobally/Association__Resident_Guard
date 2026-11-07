// To parse this JSON data, do
//
//     final defaulterDetailsModel = defaulterDetailsModelFromJson(jsonString);

import 'dart:convert';

DefaulterDetailsModel defaulterDetailsModelFromJson(String str) => DefaulterDetailsModel.fromJson(json.decode(str));

String defaulterDetailsModelToJson(DefaulterDetailsModel data) => json.encode(data.toJson());

class DefaulterDetailsModel {
    bool? status;
    String? message;
    Data? data;

    DefaulterDetailsModel({
        this.status,
        this.message,
        this.data,
    });

    factory DefaulterDetailsModel.fromJson(Map<String, dynamic> json) => DefaulterDetailsModel(
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
    UnitCard? unitCard;
    OutstandingAmount? outstandingAmount;
    PaymentInformation? paymentInformation;
    MaintenanceHistory? maintenanceHistory;

    Data({
        this.header,
        this.unitCard,
        this.outstandingAmount,
        this.paymentInformation,
        this.maintenanceHistory,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        unitCard: json["unit_card"] == null ? null : UnitCard.fromJson(json["unit_card"]),
        outstandingAmount: json["outstanding_amount"] == null ? null : OutstandingAmount.fromJson(json["outstanding_amount"]),
        paymentInformation: json["payment_information"] == null ? null : PaymentInformation.fromJson(json["payment_information"]),
        maintenanceHistory: json["maintenance_history"] == null ? null : MaintenanceHistory.fromJson(json["maintenance_history"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "unit_card": unitCard?.toJson(),
        "outstanding_amount": outstandingAmount?.toJson(),
        "payment_information": paymentInformation?.toJson(),
        "maintenance_history": maintenanceHistory?.toJson(),
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

class MaintenanceHistory {
    String? badge;
    String? title;
    List<Timeline>? timeline;

    MaintenanceHistory({
        this.badge,
        this.title,
        this.timeline,
    });

    factory MaintenanceHistory.fromJson(Map<String, dynamic> json) => MaintenanceHistory(
        badge: json["badge"],
        title: json["title"],
        timeline: json["timeline"] == null ? [] : List<Timeline>.from(json["timeline"]!.map((x) => Timeline.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "title": title,
        "timeline": timeline == null ? [] : List<dynamic>.from(timeline!.map((x) => x.toJson())),
    };
}

class Timeline {
    String? monthYear;
    String? description;
    int? amount;
    String? formattedAmount;
    String? status;

    Timeline({
        this.monthYear,
        this.description,
        this.amount,
        this.formattedAmount,
        this.status,
    });

    factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
        monthYear: json["month_year"],
        description: json["description"],
        amount: json["amount"],
        formattedAmount: json["formatted_amount"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "month_year": monthYear,
        "description": description,
        "amount": amount,
        "formatted_amount": formattedAmount,
        "status": status,
    };
}

class OutstandingAmount {
    String? title;
    int? totalOutstanding;
    String? formattedTotalOutstanding;
    List<BreakdownItem>? breakdownItems;

    OutstandingAmount({
        this.title,
        this.totalOutstanding,
        this.formattedTotalOutstanding,
        this.breakdownItems,
    });

    factory OutstandingAmount.fromJson(Map<String, dynamic> json) => OutstandingAmount(
        title: json["title"],
        totalOutstanding: json["total_outstanding"],
        formattedTotalOutstanding: json["formatted_total_outstanding"],
        breakdownItems: json["breakdown_items"] == null ? [] : List<BreakdownItem>.from(json["breakdown_items"]!.map((x) => BreakdownItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "total_outstanding": totalOutstanding,
        "formatted_total_outstanding": formattedTotalOutstanding,
        "breakdown_items": breakdownItems == null ? [] : List<dynamic>.from(breakdownItems!.map((x) => x.toJson())),
    };
}

class BreakdownItem {
    String? title;
    int? amount;
    String? formattedAmount;
    String? status;

    BreakdownItem({
        this.title,
        this.amount,
        this.formattedAmount,
        this.status,
    });

    factory BreakdownItem.fromJson(Map<String, dynamic> json) => BreakdownItem(
        title: json["title"],
        amount: json["amount"],
        formattedAmount: json["formatted_amount"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "amount": amount,
        "formatted_amount": formattedAmount,
        "status": status,
    };
}

class PaymentInformation {
    String? title;
    CurrentBillingMonth? currentBillingMonth;
    OverdueSince? overdueSince;
    LastRecordedPayment? lastRecordedPayment;

    PaymentInformation({
        this.title,
        this.currentBillingMonth,
        this.overdueSince,
        this.lastRecordedPayment,
    });

    factory PaymentInformation.fromJson(Map<String, dynamic> json) => PaymentInformation(
        title: json["title"],
        currentBillingMonth: json["current_billing_month"] == null ? null : CurrentBillingMonth.fromJson(json["current_billing_month"]),
        overdueSince: json["overdue_since"] == null ? null : OverdueSince.fromJson(json["overdue_since"]),
        lastRecordedPayment: json["last_recorded_payment"] == null ? null : LastRecordedPayment.fromJson(json["last_recorded_payment"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "current_billing_month": currentBillingMonth?.toJson(),
        "overdue_since": overdueSince?.toJson(),
        "last_recorded_payment": lastRecordedPayment?.toJson(),
    };
}

class CurrentBillingMonth {
    String? label;
    String? monthYear;
    String? status;

    CurrentBillingMonth({
        this.label,
        this.monthYear,
        this.status,
    });

    factory CurrentBillingMonth.fromJson(Map<String, dynamic> json) => CurrentBillingMonth(
        label: json["label"],
        monthYear: json["month_year"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "month_year": monthYear,
        "status": status,
    };
}

class LastRecordedPayment {
    String? label;
    String? monthYear;
    int? amount;
    String? formattedAmount;

    LastRecordedPayment({
        this.label,
        this.monthYear,
        this.amount,
        this.formattedAmount,
    });

    factory LastRecordedPayment.fromJson(Map<String, dynamic> json) => LastRecordedPayment(
        label: json["label"],
        monthYear: json["month_year"],
        amount: json["amount"],
        formattedAmount: json["formatted_amount"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "month_year": monthYear,
        "amount": amount,
        "formatted_amount": formattedAmount,
    };
}

class OverdueSince {
    String? label;
    String? date;
    String? daysText;

    OverdueSince({
        this.label,
        this.date,
        this.daysText,
    });

    factory OverdueSince.fromJson(Map<String, dynamic> json) => OverdueSince(
        label: json["label"],
        date: json["date"],
        daysText: json["days_text"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "date": date,
        "days_text": daysText,
    };
}

class UnitCard {
    String? unitNumber;
    String? statusBadge;
    String? propertyType;
    String? propertyOwner;
    String? dueDate;
    String? defaulterStatus;
    bool? isDefaulter;
    String? badgeColor;
    bool? isOverdueAbove2Months;
    // Partial payment: bill kitna, mila kitna, baaki kitna
    num? billAmount;
    num? paidAmount;
    num? balanceAmount;
    String? formattedBillAmount;
    String? formattedPaidAmount;
    String? formattedBalanceAmount;
    bool? isPartiallyPaid;

    UnitCard({
        this.unitNumber,
        this.statusBadge,
        this.propertyType,
        this.propertyOwner,
        this.dueDate,
        this.defaulterStatus,
        this.isDefaulter,
        this.badgeColor,
        this.isOverdueAbove2Months,
        this.billAmount,
        this.paidAmount,
        this.balanceAmount,
        this.formattedBillAmount,
        this.formattedPaidAmount,
        this.formattedBalanceAmount,
        this.isPartiallyPaid,
    });

    factory UnitCard.fromJson(Map<String, dynamic> json) => UnitCard(
        unitNumber: json["unit_number"]?.toString(),
        statusBadge: json["defaulter_status"]?.toString() ??
            json["status_badge"]?.toString(),
        propertyType: json["property_type"]?.toString(),
        propertyOwner: json["property_owner"]?.toString(),
        dueDate: json["due_date"]?.toString(),
        defaulterStatus: json["defaulter_status"]?.toString(),
        isDefaulter: json["is_defaulter"] == true ||
            json["is_defaulter"] == 1 ||
            json["is_defaulter"] == "true",
        badgeColor: json["badge_color"]?.toString() ??
            json["status_color"]?.toString(),
        isOverdueAbove2Months: json["is_overdue_above_2_months"] == true ||
            json["is_overdue_above_2_months"] == 1 ||
            json["is_overdue_above_2_months"] == "true",
        billAmount: num.tryParse('${json["bill_amount"] ?? ""}'),
        paidAmount: num.tryParse('${json["paid_amount"] ?? ""}'),
        balanceAmount: num.tryParse('${json["balance_amount"] ?? ""}'),
        formattedBillAmount: json["formatted_bill_amount"]?.toString(),
        formattedPaidAmount: json["formatted_paid_amount"]?.toString(),
        formattedBalanceAmount: json["formatted_balance_amount"]?.toString(),
        isPartiallyPaid: json["is_partially_paid"] == true,
    );

    Map<String, dynamic> toJson() => {
        "unit_number": unitNumber,
        "status_badge": statusBadge,
        "property_type": propertyType,
        "property_owner": propertyOwner,
        "due_date": dueDate,
        "defaulter_status": defaulterStatus,
        "is_defaulter": isDefaulter,
        "badge_color": badgeColor,
        "is_overdue_above_2_months": isOverdueAbove2Months,
        "bill_amount": billAmount,
        "paid_amount": paidAmount,
        "balance_amount": balanceAmount,
        "formatted_bill_amount": formattedBillAmount,
        "formatted_paid_amount": formattedPaidAmount,
        "formatted_balance_amount": formattedBalanceAmount,
        "is_partially_paid": isPartiallyPaid,
    };
}
