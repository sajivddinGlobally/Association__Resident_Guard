// To parse this JSON data, do
//
//     final guardDashBoardModel = guardDashBoardModelFromJson(jsonString);

import 'dart:convert';

GuardDashBoardModel guardDashBoardModelFromJson(String str) => GuardDashBoardModel.fromJson(json.decode(str));

String guardDashBoardModelToJson(GuardDashBoardModel data) => json.encode(data.toJson());

class GuardDashBoardModel {
    bool? status;
    String? message;
    Data? data;

    GuardDashBoardModel({
        this.status,
        this.message,
        this.data,
    });

    factory GuardDashBoardModel.fromJson(Map<String, dynamic> json) => GuardDashBoardModel(
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
    ShiftCard? shiftCard;
    List<QuickAction>? quickActions;
    TodaysActivity? todaysActivity;
    VehicleSearchWidget? vehicleSearchWidget;
    GuardCommunication? guardCommunication;
    List<BottomNavigation>? bottomNavigation;

    Data({
        this.header,
        this.shiftCard,
        this.quickActions,
        this.todaysActivity,
        this.vehicleSearchWidget,
        this.guardCommunication,
        this.bottomNavigation,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        shiftCard: json["shift_card"] == null ? null : ShiftCard.fromJson(json["shift_card"]),
        quickActions: json["quick_actions"] == null ? [] : List<QuickAction>.from(json["quick_actions"]!.map((x) => QuickAction.fromJson(x))),
        todaysActivity: json["todays_activity"] == null ? null : TodaysActivity.fromJson(json["todays_activity"]),
        vehicleSearchWidget: json["vehicle_search_widget"] == null ? null : VehicleSearchWidget.fromJson(json["vehicle_search_widget"]),
        guardCommunication: json["guard_communication"] == null ? null : GuardCommunication.fromJson(json["guard_communication"]),
        bottomNavigation: json["bottom_navigation"] == null ? [] : List<BottomNavigation>.from(json["bottom_navigation"]!.map((x) => BottomNavigation.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "shift_card": shiftCard?.toJson(),
        "quick_actions": quickActions == null ? [] : List<dynamic>.from(quickActions!.map((x) => x.toJson())),
        "todays_activity": todaysActivity?.toJson(),
        "vehicle_search_widget": vehicleSearchWidget?.toJson(),
        "guard_communication": guardCommunication?.toJson(),
        "bottom_navigation": bottomNavigation == null ? [] : List<dynamic>.from(bottomNavigation!.map((x) => x.toJson())),
    };
}

class BottomNavigation {
    String? key;
    String? label;
    String? icon;
    bool? isActive;

    BottomNavigation({
        this.key,
        this.label,
        this.icon,
        this.isActive,
    });

    factory BottomNavigation.fromJson(Map<String, dynamic> json) => BottomNavigation(
        key: json["key"],
        label: json["label"],
        icon: json["icon"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "label": label,
        "icon": icon,
        "is_active": isActive,
    };
}

class GuardCommunication {
    String? title;
    String? description;
    List<Action>? actions;

    GuardCommunication({
        this.title,
        this.description,
        this.actions,
    });

    factory GuardCommunication.fromJson(Map<String, dynamic> json) => GuardCommunication(
        title: json["title"],
        description: json["description"],
        actions: json["actions"] == null ? [] : List<Action>.from(json["actions"]!.map((x) => Action.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "actions": actions == null ? [] : List<dynamic>.from(actions!.map((x) => x.toJson())),
    };
}

class Action {
    String? label;
    String? guardName;
    String? phone;
    String? post;

    Action({
        this.label,
        this.guardName,
        this.phone,
        this.post,
    });

    factory Action.fromJson(Map<String, dynamic> json) => Action(
        label: json["label"],
        guardName: json["guard_name"],
        phone: json["phone"],
        post: json["post"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "guard_name": guardName,
        "phone": phone,
        "post": post,
    };
}

class Header {
    String? greeting;
    String? guardName;
    String? avatarUrl;
    bool? hasNotifications;

    Header({
        this.greeting,
        this.guardName,
        this.avatarUrl,
        this.hasNotifications,
    });

    factory Header.fromJson(Map<String, dynamic> json) => Header(
        greeting: json["greeting"],
        guardName: json["guard_name"],
        avatarUrl: json["avatar_url"],
        hasNotifications: json["has_notifications"],
    );

    Map<String, dynamic> toJson() => {
        "greeting": greeting,
        "guard_name": guardName,
        "avatar_url": avatarUrl,
        "has_notifications": hasNotifications,
    };
}

class QuickAction {
    String? key;
    String? title;
    String? description;
    String? icon;
    String? targetScreen;

    QuickAction({
        this.key,
        this.title,
        this.description,
        this.icon,
        this.targetScreen,
    });

    factory QuickAction.fromJson(Map<String, dynamic> json) => QuickAction(
        key: json["key"],
        title: json["title"],
        description: json["description"],
        icon: json["icon"],
        targetScreen: json["target_screen"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "title": title,
        "description": description,
        "icon": icon,
        "target_screen": targetScreen,
    };
}

class ShiftCard {
    String? shiftName;
    String? timings;
    bool? isOnDuty;
    String? statusLabel;
    String? statusBadgeColor;
    String? backgroundImage;

    ShiftCard({
        this.shiftName,
        this.timings,
        this.isOnDuty,
        this.statusLabel,
        this.statusBadgeColor,
        this.backgroundImage,
    });

    factory ShiftCard.fromJson(Map<String, dynamic> json) => ShiftCard(
        shiftName: json["shift_name"],
        timings: json["timings"],
        isOnDuty: json["is_on_duty"],
        statusLabel: json["status_label"],
        statusBadgeColor: json["status_badge_color"],
        backgroundImage: json["background_image"],
    );

    Map<String, dynamic> toJson() => {
        "shift_name": shiftName,
        "timings": timings,
        "is_on_duty": isOnDuty,
        "status_label": statusLabel,
        "status_badge_color": statusBadgeColor,
        "background_image": backgroundImage,
    };
}

class TodaysActivity {
    String? title;
    String? liveBadge;
    List<Item>? items;

    TodaysActivity({
        this.title,
        this.liveBadge,
        this.items,
    });

    factory TodaysActivity.fromJson(Map<String, dynamic> json) => TodaysActivity(
        title: json["title"],
        liveBadge: json["live_badge"],
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "live_badge": liveBadge,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class Item {
    int? id;
    String? type;
    String? title;
    String? subtitle;
    String? badge;
    String? badgeColor;
    DateTime? timestamp;

    Item({
        this.id,
        this.type,
        this.title,
        this.subtitle,
        this.badge,
        this.badgeColor,
        this.timestamp,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        type: json["type"],
        title: json["title"],
        subtitle: json["subtitle"],
        badge: json["badge"],
        badgeColor: json["badge_color"],
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "title": title,
        "subtitle": subtitle,
        "badge": badge,
        "badge_color": badgeColor,
        "timestamp": timestamp?.toIso8601String(),
    };
}

class VehicleSearchWidget {
    String? title;
    String? description;
    String? placeholder;
    String? buttonLabel;

    VehicleSearchWidget({
        this.title,
        this.description,
        this.placeholder,
        this.buttonLabel,
    });

    factory VehicleSearchWidget.fromJson(Map<String, dynamic> json) => VehicleSearchWidget(
        title: json["title"],
        description: json["description"],
        placeholder: json["placeholder"],
        buttonLabel: json["button_label"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "placeholder": placeholder,
        "button_label": buttonLabel,
    };
}
