// To parse this JSON data, do
//
//     final residentCommunityContactResModel = residentCommunityContactResModelFromJson(jsonString);

import 'dart:convert';

ResidentCommunityContactResModel residentCommunityContactResModelFromJson(String str) => ResidentCommunityContactResModel.fromJson(json.decode(str));

String residentCommunityContactResModelToJson(ResidentCommunityContactResModel data) => json.encode(data.toJson());

class ResidentCommunityContactResModel {
    final bool status;
    final String message;
    final Data data;

    ResidentCommunityContactResModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory ResidentCommunityContactResModel.fromJson(Map<String, dynamic> json) => ResidentCommunityContactResModel(
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
    final List<AssociationRepresentative> sections;
    final AssociationRepresentative caretaker;
    final AssociationRepresentative associationRepresentative;
    final Security security;
    final AssociationCommittee associationCommittee;

    Data({
        required this.header,
        required this.sections,
        required this.caretaker,
        required this.associationRepresentative,
        required this.security,
        required this.associationCommittee,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: Header.fromJson(json["header"]),
        sections: List<AssociationRepresentative>.from(json["sections"].map((x) => AssociationRepresentative.fromJson(x))),
        caretaker: AssociationRepresentative.fromJson(json["caretaker"]),
        associationRepresentative: AssociationRepresentative.fromJson(json["association_representative"]),
        security: Security.fromJson(json["security"]),
        associationCommittee: AssociationCommittee.fromJson(json["association_committee"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
        "caretaker": caretaker.toJson(),
        "association_representative": associationRepresentative.toJson(),
        "security": security.toJson(),
        "association_committee": associationCommittee.toJson(),
    };
}

class AssociationCommittee {
    final String name;
    final String phone;
    final String email;
    final String role;

    AssociationCommittee({
        required this.name,
        required this.phone,
        required this.email,
        required this.role,
    });

    factory AssociationCommittee.fromJson(Map<String, dynamic> json) => AssociationCommittee(
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "email": email,
        "role": role,
    };
}

class AssociationRepresentative {
    final String type;
    final String sectionTitle;
    final String name;
    final String subtitle;
    final String badge;
    final String badgeColor;
    final String phone;
    final String icon;
    final CallAction callAction;

    AssociationRepresentative({
        required this.type,
        required this.sectionTitle,
        required this.name,
        required this.subtitle,
        required this.badge,
        required this.badgeColor,
        required this.phone,
        required this.icon,
        required this.callAction,
    });

    factory AssociationRepresentative.fromJson(Map<String, dynamic> json) => AssociationRepresentative(
        type: json["type"],
        sectionTitle: json["section_title"],
        name: json["name"],
        subtitle: json["subtitle"],
        badge: json["badge"],
        badgeColor: json["badge_color"],
        phone: json["phone"],
        icon: json["icon"],
        callAction: CallAction.fromJson(json["call_action"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "section_title": sectionTitle,
        "name": name,
        "subtitle": subtitle,
        "badge": badge,
        "badge_color": badgeColor,
        "phone": phone,
        "icon": icon,
        "call_action": callAction.toJson(),
    };
}

class CallAction {
    final String label;
    final String telUri;

    CallAction({
        required this.label,
        required this.telUri,
    });

    factory CallAction.fromJson(Map<String, dynamic> json) => CallAction(
        label: json["label"],
        telUri: json["tel_uri"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "tel_uri": telUri,
    };
}

class Header {
    final String tag;
    final String subtitle;
    final String title;

    Header({
        required this.tag,
        required this.subtitle,
        required this.title,
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

class Security {
    final String gateName;
    final String phone;
    final String vendor;
    final String patrolDuty;

    Security({
        required this.gateName,
        required this.phone,
        required this.vendor,
        required this.patrolDuty,
    });

    factory Security.fromJson(Map<String, dynamic> json) => Security(
        gateName: json["gate_name"],
        phone: json["phone"],
        vendor: json["vendor"],
        patrolDuty: json["patrol_duty"],
    );

    Map<String, dynamic> toJson() => {
        "gate_name": gateName,
        "phone": phone,
        "vendor": vendor,
        "patrol_duty": patrolDuty,
    };
}