// To parse this JSON data, do
//
//     final residentEmergencyContactResModel = residentEmergencyContactResModelFromJson(jsonString);

import 'dart:convert';

ResidentEmergencyContactResModel residentEmergencyContactResModelFromJson(String str) => ResidentEmergencyContactResModel.fromJson(json.decode(str));

String residentEmergencyContactResModelToJson(ResidentEmergencyContactResModel data) => json.encode(data.toJson());

class ResidentEmergencyContactResModel {
    final bool status;
    final String message;
    final Data data;

    ResidentEmergencyContactResModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory ResidentEmergencyContactResModel.fromJson(Map<String, dynamic> json) => ResidentEmergencyContactResModel(
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
    final Card card;
    final Card emergencyDesk;
    final EmergencyContact emergencyContact;

    Data({
        required this.header,
        required this.card,
        required this.emergencyDesk,
        required this.emergencyContact,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: Header.fromJson(json["header"]),
        card: Card.fromJson(json["card"]),
        emergencyDesk: Card.fromJson(json["emergency_desk"]),
        emergencyContact: EmergencyContact.fromJson(json["emergency_contact"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "card": card.toJson(),
        "emergency_desk": emergencyDesk.toJson(),
        "emergency_contact": emergencyContact.toJson(),
    };
}

class Card {
    final String badge;
    final String badgeColor;
    final String title;
    final String? subtitle;
    final String deskName;
    final String phone;
    final String? icon;
    final CallAction callAction;

    Card({
        required this.badge,
        required this.badgeColor,
        required this.title,
        this.subtitle,
        required this.deskName,
        required this.phone,
        this.icon,
        required this.callAction,
    });

    factory Card.fromJson(Map<String, dynamic> json) => Card(
        badge: json["badge"],
        badgeColor: json["badge_color"],
        title: json["title"],
        subtitle: json["subtitle"],
        deskName: json["desk_name"],
        phone: json["phone"],
        icon: json["icon"],
        callAction: CallAction.fromJson(json["call_action"]),
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "badge_color": badgeColor,
        "title": title,
        "subtitle": subtitle,
        "desk_name": deskName,
        "phone": phone,
        "icon": icon,
        "call_action": callAction.toJson(),
    };
}

class CallAction {
    final String label;
    final String telUri;
    final String buttonColor;

    CallAction({
        required this.label,
        required this.telUri,
        required this.buttonColor,
    });

    factory CallAction.fromJson(Map<String, dynamic> json) => CallAction(
        label: json["label"],
        telUri: json["tel_uri"],
        buttonColor: json["button_color"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "tel_uri": telUri,
        "button_color": buttonColor,
    };
}

class EmergencyContact {
    final String title;
    final String subtitle;
    final String phone;

    EmergencyContact({
        required this.title,
        required this.subtitle,
        required this.phone,
    });

    factory EmergencyContact.fromJson(Map<String, dynamic> json) => EmergencyContact(
        title: json["title"],
        subtitle: json["subtitle"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "phone": phone,
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