// To parse this JSON data, do
//
//     final getComplaintRequestListModel = getComplaintRequestListModelFromJson(jsonString);

import 'dart:convert';

GetComplaintRequestListModel getComplaintRequestListModelFromJson(String str) => GetComplaintRequestListModel.fromJson(json.decode(str));

String getComplaintRequestListModelToJson(GetComplaintRequestListModel data) => json.encode(data.toJson());

class GetComplaintRequestListModel {
    bool? status;
    String? message;
    Data? data;

    GetComplaintRequestListModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetComplaintRequestListModel.fromJson(Map<String, dynamic> json) => GetComplaintRequestListModel(
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
    RegisteredApartment? registeredApartment;
    List<IssueCategory>? issueCategories;
    DescriptionField? descriptionField;
    PhotoField? photoField;
    Actions? actions;

    Data({
        this.header,
        this.registeredApartment,
        this.issueCategories,
        this.descriptionField,
        this.photoField,
        this.actions,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        registeredApartment: json["registered_apartment"] == null ? null : RegisteredApartment.fromJson(json["registered_apartment"]),
        issueCategories: json["issue_categories"] == null ? [] : List<IssueCategory>.from(json["issue_categories"]!.map((x) => IssueCategory.fromJson(x))),
        descriptionField: json["description_field"] == null ? null : DescriptionField.fromJson(json["description_field"]),
        photoField: json["photo_field"] == null ? null : PhotoField.fromJson(json["photo_field"]),
        actions: json["actions"] == null ? null : Actions.fromJson(json["actions"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "registered_apartment": registeredApartment?.toJson(),
        "issue_categories": issueCategories == null ? [] : List<dynamic>.from(issueCategories!.map((x) => x.toJson())),
        "description_field": descriptionField?.toJson(),
        "photo_field": photoField?.toJson(),
        "actions": actions?.toJson(),
    };
}

class Actions {
    Submit? submit;

    Actions({
        this.submit,
    });

    factory Actions.fromJson(Map<String, dynamic> json) => Actions(
        submit: json["submit"] == null ? null : Submit.fromJson(json["submit"]),
    );

    Map<String, dynamic> toJson() => {
        "submit": submit?.toJson(),
    };
}

class Submit {
    String? label;
    String? endpoint;
    String? method;

    Submit({
        this.label,
        this.endpoint,
        this.method,
    });

    factory Submit.fromJson(Map<String, dynamic> json) => Submit(
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

class DescriptionField {
    String? label;
    String? placeholder;
    bool? required;

    DescriptionField({
        this.label,
        this.placeholder,
        this.required,
    });

    factory DescriptionField.fromJson(Map<String, dynamic> json) => DescriptionField(
        label: json["label"],
        placeholder: json["placeholder"],
        required: json["required"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "placeholder": placeholder,
        "required": required,
    };
}

class Header {
    String? subtitle;
    String? title;

    Header({
        this.subtitle,
        this.title,
    });

    factory Header.fromJson(Map<String, dynamic> json) => Header(
        subtitle: json["subtitle"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "subtitle": subtitle,
        "title": title,
    };
}

class IssueCategory {
    String? key;
    String? title;
    String? subtitle;
    String? icon;
    String? defaultSubject;

    IssueCategory({
        this.key,
        this.title,
        this.subtitle,
        this.icon,
        this.defaultSubject,
    });

    factory IssueCategory.fromJson(Map<String, dynamic> json) => IssueCategory(
        key: json["key"],
        title: json["title"],
        subtitle: json["subtitle"],
        icon: json["icon"],
        defaultSubject: json["default_subject"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "title": title,
        "subtitle": subtitle,
        "icon": icon,
        "default_subject": defaultSubject,
    };
}

class PhotoField {
    String? label;
    String? placeholder;
    List<String>? acceptedFormats;
    String? maxSize;

    PhotoField({
        this.label,
        this.placeholder,
        this.acceptedFormats,
        this.maxSize,
    });

    factory PhotoField.fromJson(Map<String, dynamic> json) => PhotoField(
        label: json["label"],
        placeholder: json["placeholder"],
        acceptedFormats: json["accepted_formats"] == null ? [] : List<String>.from(json["accepted_formats"]!.map((x) => x)),
        maxSize: json["max_size"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "placeholder": placeholder,
        "accepted_formats": acceptedFormats == null ? [] : List<dynamic>.from(acceptedFormats!.map((x) => x)),
        "max_size": maxSize,
    };
}

class RegisteredApartment {
    String? label;
    String? text;
    String? unitNumber;

    RegisteredApartment({
        this.label,
        this.text,
        this.unitNumber,
    });

    factory RegisteredApartment.fromJson(Map<String, dynamic> json) => RegisteredApartment(
        label: json["label"],
        text: json["text"],
        unitNumber: json["unit_number"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "text": text,
        "unit_number": unitNumber,
    };
}
