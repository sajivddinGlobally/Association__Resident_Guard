// To parse this JSON data, do
//
//     final getVisitorPassListModel = getVisitorPassListModelFromJson(jsonString);

import 'dart:convert';

GetVisitorPassListModel getVisitorPassListModelFromJson(String str) => GetVisitorPassListModel.fromJson(json.decode(str));

String getVisitorPassListModelToJson(GetVisitorPassListModel data) => json.encode(data.toJson());

class GetVisitorPassListModel {
    bool? status;
    String? message;
    Data? data;

    GetVisitorPassListModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetVisitorPassListModel.fromJson(Map<String, dynamic> json) => GetVisitorPassListModel(
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
    HeroCard? heroCard;
    FormConfig? formConfig;
    RecentRequests? recentRequests;

    Data({
        this.header,
        this.heroCard,
        this.formConfig,
        this.recentRequests,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        heroCard: json["hero_card"] == null ? null : HeroCard.fromJson(json["hero_card"]),
        formConfig: json["form_config"] == null ? null : FormConfig.fromJson(json["form_config"]),
        recentRequests: json["recent_requests"] == null ? null : RecentRequests.fromJson(json["recent_requests"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "hero_card": heroCard?.toJson(),
        "form_config": formConfig?.toJson(),
        "recent_requests": recentRequests?.toJson(),
    };
}

class FormConfig {
    VisitorDetails? visitorDetails;
    VisitDetails? visitDetails;
    ActionButton? actionButton;

    FormConfig({
        this.visitorDetails,
        this.visitDetails,
        this.actionButton,
    });

    factory FormConfig.fromJson(Map<String, dynamic> json) => FormConfig(
        visitorDetails: json["visitor_details"] == null ? null : VisitorDetails.fromJson(json["visitor_details"]),
        visitDetails: json["visit_details"] == null ? null : VisitDetails.fromJson(json["visit_details"]),
        actionButton: json["action_button"] == null ? null : ActionButton.fromJson(json["action_button"]),
    );

    Map<String, dynamic> toJson() => {
        "visitor_details": visitorDetails?.toJson(),
        "visit_details": visitDetails?.toJson(),
        "action_button": actionButton?.toJson(),
    };
}

class ActionButton {
    String? label;
    String? endpoint;
    String? method;

    ActionButton({
        this.label,
        this.endpoint,
        this.method,
    });

    factory ActionButton.fromJson(Map<String, dynamic> json) => ActionButton(
        label: json["label"],
        endpoint: json["endpoint"],
        method: json["method"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "endpoint": endpoint,
        "method": method,
    };
}

class VisitDetails {
    String? sectionTitle;
    VisitDetailsFields? fields;

    VisitDetails({
        this.sectionTitle,
        this.fields,
    });

    factory VisitDetails.fromJson(Map<String, dynamic> json) => VisitDetails(
        sectionTitle: json["section_title"],
        fields: json["fields"] == null ? null : VisitDetailsFields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "section_title": sectionTitle,
        "fields": fields?.toJson(),
    };
}

class VisitDetailsFields {
    PurposeOfVisit? visitDate;
    PurposeOfVisit? visitTime;
    PurposeOfVisit? purposeOfVisit;

    VisitDetailsFields({
        this.visitDate,
        this.visitTime,
        this.purposeOfVisit,
    });

    factory VisitDetailsFields.fromJson(Map<String, dynamic> json) => VisitDetailsFields(
        visitDate: json["visit_date"] == null ? null : PurposeOfVisit.fromJson(json["visit_date"]),
        visitTime: json["visit_time"] == null ? null : PurposeOfVisit.fromJson(json["visit_time"]),
        purposeOfVisit: json["purpose_of_visit"] == null ? null : PurposeOfVisit.fromJson(json["purpose_of_visit"]),
    );

    Map<String, dynamic> toJson() => {
        "visit_date": visitDate?.toJson(),
        "visit_time": visitTime?.toJson(),
        "purpose_of_visit": purposeOfVisit?.toJson(),
    };
}

class PurposeOfVisit {
    String? label;
    String? placeholder;
    List<String>? options;
    String? purposeOfVisitDefault;
    String? format;

    PurposeOfVisit({
        this.label,
        this.placeholder,
        this.options,
        this.purposeOfVisitDefault,
        this.format,
    });

    factory PurposeOfVisit.fromJson(Map<String, dynamic> json) => PurposeOfVisit(
        label: json["label"],
        placeholder: json["placeholder"],
        options: json["options"] == null ? [] : List<String>.from(json["options"]!.map((x) => x)),
        purposeOfVisitDefault: json["default"],
        format: json["format"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "placeholder": placeholder,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
        "default": purposeOfVisitDefault,
        "format": format,
    };
}

class VisitorDetails {
    String? sectionTitle;
    VisitorDetailsFields? fields;

    VisitorDetails({
        this.sectionTitle,
        this.fields,
    });

    factory VisitorDetails.fromJson(Map<String, dynamic> json) => VisitorDetails(
        sectionTitle: json["section_title"],
        fields: json["fields"] == null ? null : VisitorDetailsFields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "section_title": sectionTitle,
        "fields": fields?.toJson(),
    };
}

class VisitorDetailsFields {
    MobileNumber? visitorName;
    MobileNumber? mobileNumber;
    VisitorType? visitorType;

    VisitorDetailsFields({
        this.visitorName,
        this.mobileNumber,
        this.visitorType,
    });

    factory VisitorDetailsFields.fromJson(Map<String, dynamic> json) => VisitorDetailsFields(
        visitorName: json["visitor_name"] == null ? null : MobileNumber.fromJson(json["visitor_name"]),
        mobileNumber: json["mobile_number"] == null ? null : MobileNumber.fromJson(json["mobile_number"]),
        visitorType: json["visitor_type"] == null ? null : VisitorType.fromJson(json["visitor_type"]),
    );

    Map<String, dynamic> toJson() => {
        "visitor_name": visitorName?.toJson(),
        "mobile_number": mobileNumber?.toJson(),
        "visitor_type": visitorType?.toJson(),
    };
}

class MobileNumber {
    String? label;
    String? placeholder;
    String? type;
    bool? required;

    MobileNumber({
        this.label,
        this.placeholder,
        this.type,
        this.required,
    });

    factory MobileNumber.fromJson(Map<String, dynamic> json) => MobileNumber(
        label: json["label"],
        placeholder: json["placeholder"],
        type: json["type"],
        required: json["required"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "placeholder": placeholder,
        "type": type,
        "required": required,
    };
}

class VisitorType {
    String? label;
    List<Option>? options;

    VisitorType({
        this.label,
        this.options,
    });

    factory VisitorType.fromJson(Map<String, dynamic> json) => VisitorType(
        label: json["label"],
        options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
    };
}

class Option {
    String? key;
    String? label;
    String? icon;
    bool? isDefault;

    Option({
        this.key,
        this.label,
        this.icon,
        this.isDefault,
    });

    factory Option.fromJson(Map<String, dynamic> json) => Option(
        key: json["key"],
        label: json["label"],
        icon: json["icon"],
        isDefault: json["is_default"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "label": label,
        "icon": icon,
        "is_default": isDefault,
    };
}

class Header {
    String? tag;
    String? subtitle;
    String? title;

    Header({
        this.tag,
        this.subtitle,
        this.title,
    });

    factory Header.fromJson(Map<String, dynamic> json) => Header(
        tag: json["tag"],
        subtitle: json["subtitle"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "tag": tag,
        "subtitle": subtitle,
        "title": title,
    };
}

class HeroCard {
    String? icon;
    String? title;
    String? subtitle;
    RegisteredApartment? registeredApartment;

    HeroCard({
        this.icon,
        this.title,
        this.subtitle,
        this.registeredApartment,
    });

    factory HeroCard.fromJson(Map<String, dynamic> json) => HeroCard(
        icon: json["icon"],
        title: json["title"],
        subtitle: json["subtitle"],
        registeredApartment: json["registered_apartment"] == null ? null : RegisteredApartment.fromJson(json["registered_apartment"]),
    );

    Map<String, dynamic> toJson() => {
        "icon": icon,
        "title": title,
        "subtitle": subtitle,
        "registered_apartment": registeredApartment?.toJson(),
    };
}

class RegisteredApartment {
    String? label;
    String? text;

    RegisteredApartment({
        this.label,
        this.text,
    });

    factory RegisteredApartment.fromJson(Map<String, dynamic> json) => RegisteredApartment(
        label: json["label"],
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "text": text,
    };
}

class RecentRequests {
    String? sectionTitle;
    int? totalCount;
    List<Request>? requests;

    RecentRequests({
        this.sectionTitle,
        this.totalCount,
        this.requests,
    });

    factory RecentRequests.fromJson(Map<String, dynamic> json) => RecentRequests(
        sectionTitle: json["section_title"],
        totalCount: json["total_count"],
        requests: json["requests"] == null ? [] : List<Request>.from(json["requests"]!.map((x) => Request.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "section_title": sectionTitle,
        "total_count": totalCount,
        "requests": requests == null ? [] : List<dynamic>.from(requests!.map((x) => x.toJson())),
    };
}

class Request {
    int? id;
    String? token;
    String? title;
    String? visitorName;
    String? subtitle;
    String? status;
    String? statusColor;
    String? visitorType;
    String? purpose;
    String? arrivalTime;

    Request({
        this.id,
        this.token,
        this.title,
        this.visitorName,
        this.subtitle,
        this.status,
        this.statusColor,
        this.visitorType,
        this.purpose,
        this.arrivalTime,
    });

    factory Request.fromJson(Map<String, dynamic> json) => Request(
        id: json["id"],
        token: json["token"],
        title: json["title"],
        visitorName: json["visitor_name"],
        subtitle: json["subtitle"],
        status: json["status"],
        statusColor: json["status_color"],
        visitorType: json["visitor_type"],
        purpose: json["purpose"],
        arrivalTime: json["arrival_time"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "title": title,
        "visitor_name": visitorName,
        "subtitle": subtitle,
        "status": status,
        "status_color": statusColor,
        "visitor_type": visitorType,
        "purpose": purpose,
        "arrival_time": arrivalTime,
    };
}
