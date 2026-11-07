// To parse this JSON data, do
//
//     final residentDashbordModel = residentDashbordModelFromJson(jsonString);

import 'dart:convert';

ResidentDashbordModel residentDashbordModelFromJson(String str) => ResidentDashbordModel.fromJson(json.decode(str));

String residentDashbordModelToJson(ResidentDashbordModel data) => json.encode(data.toJson());

class ResidentDashbordModel {
    bool? status;
    String? message;
    Data? data;

    ResidentDashbordModel({
        this.status,
        this.message,
        this.data,
    });

    factory ResidentDashbordModel.fromJson(Map<String, dynamic> json) => ResidentDashbordModel(
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
    MyResidence? myResidence;
    QuickActions? quickActions;
    Community? community;
    Support? support;
    Assistant? assistant;
    ResidentInfo? residentInfo;
    int? openTicketsCount;
    List<dynamic>? recentOpenTickets;

    Data({
        this.header,
        this.myResidence,
        this.quickActions,
        this.community,
        this.support,
        this.assistant,
        this.residentInfo,
        this.openTicketsCount,
        this.recentOpenTickets,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        myResidence: json["my_residence"] == null ? null : MyResidence.fromJson(json["my_residence"]),
        quickActions: json["quick_actions"] == null ? null : QuickActions.fromJson(json["quick_actions"]),
        community: json["community"] == null ? null : Community.fromJson(json["community"]),
        support: json["support"] == null ? null : Support.fromJson(json["support"]),
        assistant: json["assistant"] == null ? null : Assistant.fromJson(json["assistant"]),
        residentInfo: json["resident_info"] == null ? null : ResidentInfo.fromJson(json["resident_info"]),
        openTicketsCount: json["open_tickets_count"],
        recentOpenTickets: json["recent_open_tickets"] == null ? [] : List<dynamic>.from(json["recent_open_tickets"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "my_residence": myResidence?.toJson(),
        "quick_actions": quickActions?.toJson(),
        "community": community?.toJson(),
        "support": support?.toJson(),
        "assistant": assistant?.toJson(),
        "resident_info": residentInfo?.toJson(),
        "open_tickets_count": openTicketsCount,
        "recent_open_tickets": recentOpenTickets == null ? [] : List<dynamic>.from(recentOpenTickets!.map((x) => x)),
    };
}

class Assistant {
    PropertyAssistant? propertyAssistant;
    PropertyAssistant? visitorPass;

    Assistant({
        this.propertyAssistant,
        this.visitorPass,
    });

    factory Assistant.fromJson(Map<String, dynamic> json) => Assistant(
        propertyAssistant: json["property_assistant"] == null ? null : PropertyAssistant.fromJson(json["property_assistant"]),
        visitorPass: json["visitor_pass"] == null ? null : PropertyAssistant.fromJson(json["visitor_pass"]),
    );

    Map<String, dynamic> toJson() => {
        "property_assistant": propertyAssistant?.toJson(),
        "visitor_pass": visitorPass?.toJson(),
    };
}

class PropertyAssistant {
    String? title;
    String? badge;
    String? subtitle;
    String? actionUrl;
    int? unreadCount;

    PropertyAssistant({
        this.title,
        this.badge,
        this.subtitle,
        this.actionUrl,
        this.unreadCount,
    });

    factory PropertyAssistant.fromJson(Map<String, dynamic> json) => PropertyAssistant(
        title: json["title"],
        badge: json["badge"],
        subtitle: json["subtitle"],
        actionUrl: json["action_url"],
        unreadCount: json["unread_count"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "badge": badge,
        "subtitle": subtitle,
        "action_url": actionUrl,
        "unread_count": unreadCount,
    };
}

class Community {
    MmcStatus? mmcStatus;
    PropertyAssistant? associationCalendar;
    PropertyAssistant? notifications;

    Community({
        this.mmcStatus,
        this.associationCalendar,
        this.notifications,
    });

    factory Community.fromJson(Map<String, dynamic> json) => Community(
        mmcStatus: json["mmc_status"] == null ? null : MmcStatus.fromJson(json["mmc_status"]),
        associationCalendar: json["association_calendar"] == null ? null : PropertyAssistant.fromJson(json["association_calendar"]),
        notifications: json["notifications"] == null ? null : PropertyAssistant.fromJson(json["notifications"]),
    );

    Map<String, dynamic> toJson() => {
        "mmc_status": mmcStatus?.toJson(),
        "association_calendar": associationCalendar?.toJson(),
        "notifications": notifications?.toJson(),
    };
}

class MmcStatus {
    String? title;
    String? subtitle;
    String? badge;
    String? badgeColor;
    int? amount;
    String? actionUrl;

    MmcStatus({
        this.title,
        this.subtitle,
        this.badge,
        this.badgeColor,
        this.amount,
        this.actionUrl,
    });

    factory MmcStatus.fromJson(Map<String, dynamic> json) => MmcStatus(
        title: json["title"],
        subtitle: json["subtitle"],
        badge: json["badge"],
        badgeColor: json["badge_color"],
        amount: json["amount"],
        actionUrl: json["action_url"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "badge": badge,
        "badge_color": badgeColor,
        "amount": amount,
        "action_url": actionUrl,
    };
}

class Header {
    String? greeting;
    String? title;
    String? userAvatar;
    int? unreadNotificationsCount;
    String? notificationsUrl;

    Header({
        this.greeting,
        this.title,
        this.userAvatar,
        this.unreadNotificationsCount,
        this.notificationsUrl,
    });

    factory Header.fromJson(Map<String, dynamic> json) => Header(
        greeting: json["greeting"],
        title: json["title"],
        userAvatar: json["user_avatar"],
        unreadNotificationsCount: json["unread_notifications_count"],
        notificationsUrl: json["notifications_url"],
    );

    Map<String, dynamic> toJson() => {
        "greeting": greeting,
        "title": title,
        "user_avatar": userAvatar,
        "unread_notifications_count": unreadNotificationsCount,
        "notifications_url": notificationsUrl,
    };
}

class MyResidence {
    String? tag;
    String? complexName;
    String? unitBadge;
    String? subtitle;
    String? image;
    String? detailsUrl;

    MyResidence({
        this.tag,
        this.complexName,
        this.unitBadge,
        this.subtitle,
        this.image,
        this.detailsUrl,
    });

    factory MyResidence.fromJson(Map<String, dynamic> json) => MyResidence(
        tag: json["tag"],
        complexName: json["complex_name"],
        unitBadge: json["unit_badge"],
        subtitle: json["subtitle"],
        image: json["image"],
        detailsUrl: json["details_url"],
    );

    Map<String, dynamic> toJson() => {
        "tag": tag,
        "complex_name": complexName,
        "unit_badge": unitBadge,
        "subtitle": subtitle,
        "image": image,
        "details_url": detailsUrl,
    };
}

class QuickActions {
    MyRequests? raiseComplaint;
    MyRequests? myRequests;

    QuickActions({
        this.raiseComplaint,
        this.myRequests,
    });

    factory QuickActions.fromJson(Map<String, dynamic> json) => QuickActions(
        raiseComplaint: json["raise_complaint"] == null ? null : MyRequests.fromJson(json["raise_complaint"]),
        myRequests: json["my_requests"] == null ? null : MyRequests.fromJson(json["my_requests"]),
    );

    Map<String, dynamic> toJson() => {
        "raise_complaint": raiseComplaint?.toJson(),
        "my_requests": myRequests?.toJson(),
    };
}

class MyRequests {
    String? title;
    String? subtitle;
    String? icon;
    int? openCount;
    String? endpoint;
    String? method;

    MyRequests({
        this.title,
        this.subtitle,
        this.icon,
        this.openCount,
        this.endpoint,
        this.method,
    });

    factory MyRequests.fromJson(Map<String, dynamic> json) => MyRequests(
        title: json["title"],
        subtitle: json["subtitle"],
        icon: json["icon"],
        openCount: json["open_count"],
        endpoint: json["endpoint"],
        method: json["method"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "icon": icon,
        "open_count": openCount,
        "endpoint": endpoint,
        "method": method,
    };
}

class ResidentInfo {
    String? name;
    String? apartmentNumber;
    String? complexName;
    int? propertyId;

    ResidentInfo({
        this.name,
        this.apartmentNumber,
        this.complexName,
        this.propertyId,
    });

    factory ResidentInfo.fromJson(Map<String, dynamic> json) => ResidentInfo(
        name: json["name"],
        apartmentNumber: json["apartment_number"],
        complexName: json["complex_name"],
        propertyId: json["property_id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "apartment_number": apartmentNumber,
        "complex_name": complexName,
        "property_id": propertyId,
    };
}

class Support {
    CaretakerSupport? caretakerSupport;
    CaretakerSupport? emergencyContact;

    Support({
        this.caretakerSupport,
        this.emergencyContact,
    });

    factory Support.fromJson(Map<String, dynamic> json) => Support(
        caretakerSupport: json["caretaker_support"] == null ? null : CaretakerSupport.fromJson(json["caretaker_support"]),
        emergencyContact: json["emergency_contact"] == null ? null : CaretakerSupport.fromJson(json["emergency_contact"]),
    );

    Map<String, dynamic> toJson() => {
        "caretaker_support": caretakerSupport?.toJson(),
        "emergency_contact": emergencyContact?.toJson(),
    };
}

class CaretakerSupport {
    String? title;
    String? subtitle;
    String? contactName;
    String? phone;

    CaretakerSupport({
        this.title,
        this.subtitle,
        this.contactName,
        this.phone,
    });

    factory CaretakerSupport.fromJson(Map<String, dynamic> json) => CaretakerSupport(
        title: json["title"],
        subtitle: json["subtitle"],
        contactName: json["contact_name"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "contact_name": contactName,
        "phone": phone,
    };
}
