// To parse this JSON data, do
//
//     final addResidentComplaintResModel = addResidentComplaintResModelFromJson(jsonString);

import 'dart:convert';

AddResidentComplaintResModel addResidentComplaintResModelFromJson(String str) => AddResidentComplaintResModel.fromJson(json.decode(str));

String addResidentComplaintResModelToJson(AddResidentComplaintResModel data) => json.encode(data.toJson());

class AddResidentComplaintResModel {
    bool? status;
    String? message;
    Data? data;

    AddResidentComplaintResModel({
        this.status,
        this.message,
        this.data,
    });

    factory AddResidentComplaintResModel.fromJson(Map<String, dynamic> json) => AddResidentComplaintResModel(
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
    Modal? modal;
    Complaint? complaint;

    Data({
        this.modal,
        this.complaint,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        modal: json["modal"] == null ? null : Modal.fromJson(json["modal"]),
        complaint: json["complaint"] == null ? null : Complaint.fromJson(json["complaint"]),
    );

    Map<String, dynamic> toJson() => {
        "modal": modal?.toJson(),
        "complaint": complaint?.toJson(),
    };
}

class Complaint {
    int? id;
    String? token;
    String? tokenNoLabel;
    String? subject;
    String? category;
    String? apartmentNumber;
    String? status;
    String? submittedAt;

    Complaint({
        this.id,
        this.token,
        this.tokenNoLabel,
        this.subject,
        this.category,
        this.apartmentNumber,
        this.status,
        this.submittedAt,
    });

    factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
        id: json["id"],
        token: json["token"],
        tokenNoLabel: json["token_no_label"],
        subject: json["subject"],
        category: json["category"],
        apartmentNumber: json["apartment_number"],
        status: json["status"],
        submittedAt: json["submitted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "token_no_label": tokenNoLabel,
        "subject": subject,
        "category": category,
        "apartment_number": apartmentNumber,
        "status": status,
        "submitted_at": submittedAt,
    };
}

class Modal {
    String? badge;
    String? title;
    String? subtitle;
    TokenBox? tokenBox;
    ActionButton? actionButton;

    Modal({
        this.badge,
        this.title,
        this.subtitle,
        this.tokenBox,
        this.actionButton,
    });

    factory Modal.fromJson(Map<String, dynamic> json) => Modal(
        badge: json["badge"],
        title: json["title"],
        subtitle: json["subtitle"],
        tokenBox: json["token_box"] == null ? null : TokenBox.fromJson(json["token_box"]),
        actionButton: json["action_button"] == null ? null : ActionButton.fromJson(json["action_button"]),
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "title": title,
        "subtitle": subtitle,
        "token_box": tokenBox?.toJson(),
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

class TokenBox {
    String? label;
    String? token;
    String? tokenClean;

    TokenBox({
        this.label,
        this.token,
        this.tokenClean,
    });

    factory TokenBox.fromJson(Map<String, dynamic> json) => TokenBox(
        label: json["label"],
        token: json["token"],
        tokenClean: json["token_clean"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "token": token,
        "token_clean": tokenClean,
    };
}
