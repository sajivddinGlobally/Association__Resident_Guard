// To parse this JSON data, do
//
//     final getResidentCalenderModel = getResidentCalenderModelFromJson(jsonString);

import 'dart:convert';

GetResidentCalenderModel getResidentCalenderModelFromJson(String str) => GetResidentCalenderModel.fromJson(json.decode(str));

String getResidentCalenderModelToJson(GetResidentCalenderModel data) => json.encode(data.toJson());

class GetResidentCalenderModel {
    bool? status;
    String? message;
    Data? data;

    GetResidentCalenderModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetResidentCalenderModel.fromJson(Map<String, dynamic> json) => GetResidentCalenderModel(
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
    Calendar? calendar;
    UpcomingEvents? upcomingEvents;

    Data({
        this.header,
        this.calendar,
        this.upcomingEvents,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        calendar: json["calendar"] == null ? null : Calendar.fromJson(json["calendar"]),
        upcomingEvents: json["upcoming_events"] == null ? null : UpcomingEvents.fromJson(json["upcoming_events"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "calendar": calendar?.toJson(),
        "upcoming_events": upcomingEvents?.toJson(),
    };
}

class Calendar {
    String? title;
    String? monthYear;
    String? subtitle;
    String? currentMonth;
    String? previousMonth;
    String? nextMonth;
    DateTime? selectedDate;
    int? selectedDay;
    List<String>? weekdays;
    List<DaysGrid>? daysGrid;

    Calendar({
        this.title,
        this.monthYear,
        this.subtitle,
        this.currentMonth,
        this.previousMonth,
        this.nextMonth,
        this.selectedDate,
        this.selectedDay,
        this.weekdays,
        this.daysGrid,
    });

    factory Calendar.fromJson(Map<String, dynamic> json) => Calendar(
        title: json["title"],
        monthYear: json["month_year"],
        subtitle: json["subtitle"],
        currentMonth: json["current_month"],
        previousMonth: json["previous_month"],
        nextMonth: json["next_month"],
        selectedDate: json["selected_date"] == null ? null : DateTime.parse(json["selected_date"]),
        selectedDay: json["selected_day"],
        weekdays: json["weekdays"] == null ? [] : List<String>.from(json["weekdays"]!.map((x) => x)),
        daysGrid: json["days_grid"] == null ? [] : List<DaysGrid>.from(json["days_grid"]!.map((x) => DaysGrid.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "month_year": monthYear,
        "subtitle": subtitle,
        "current_month": currentMonth,
        "previous_month": previousMonth,
        "next_month": nextMonth,
        "selected_date": selectedDate == null ? null : "${selectedDate!.year.toString().padLeft(4, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}",
        "selected_day": selectedDay,
        "weekdays": weekdays == null ? [] : List<dynamic>.from(weekdays!.map((x) => x)),
        "days_grid": daysGrid == null ? [] : List<dynamic>.from(daysGrid!.map((x) => x.toJson())),
    };
}

class DaysGrid {
    int? dayNumber;
    DateTime? date;
    String? dayOfWeek;
    bool? isCurrentMonth;
    bool? hasEvents;
    int? eventCount;
    bool? isSelected;
    bool? isToday;

    DaysGrid({
        this.dayNumber,
        this.date,
        this.dayOfWeek,
        this.isCurrentMonth,
        this.hasEvents,
        this.eventCount,
        this.isSelected,
        this.isToday,
    });

    factory DaysGrid.fromJson(Map<String, dynamic> json) => DaysGrid(
        dayNumber: json["day_number"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        dayOfWeek: json["day_of_week"],
        isCurrentMonth: json["is_current_month"],
        hasEvents: json["has_events"],
        eventCount: json["event_count"],
        isSelected: json["is_selected"],
        isToday: json["is_today"],
    );

    Map<String, dynamic> toJson() => {
        "day_number": dayNumber,
        "date": date == null ? null : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "day_of_week": dayOfWeek,
        "is_current_month": isCurrentMonth,
        "has_events": hasEvents,
        "event_count": eventCount,
        "is_selected": isSelected,
        "is_today": isToday,
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

class UpcomingEvents {
    String? sectionTitle;
    int? totalCount;
    List<Event>? events;

    UpcomingEvents({
        this.sectionTitle,
        this.totalCount,
        this.events,
    });

    factory UpcomingEvents.fromJson(Map<String, dynamic> json) => UpcomingEvents(
        sectionTitle: json["section_title"],
        totalCount: json["total_count"],
        events: json["events"] == null ? [] : List<Event>.from(json["events"]!.map((x) => Event.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "section_title": sectionTitle,
        "total_count": totalCount,
        "events": events == null ? [] : List<dynamic>.from(events!.map((x) => x.toJson())),
    };
}

class Event {
    int? id;
    String? title;
    String? type;
    String? typeLabel;
    String? icon;
    String? badgeIconBg;
    String? badgeIconColor;
    String? date;
    DateTime? dateRaw;
    String? time;
    String? location;
    String? description;
    String? organizedBy;

    Event({
        this.id,
        this.title,
        this.type,
        this.typeLabel,
        this.icon,
        this.badgeIconBg,
        this.badgeIconColor,
        this.date,
        this.dateRaw,
        this.time,
        this.location,
        this.description,
        this.organizedBy,
    });

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        title: json["title"],
        type: json["type"],
        typeLabel: json["type_label"],
        icon: json["icon"],
        badgeIconBg: json["badge_icon_bg"],
        badgeIconColor: json["badge_icon_color"],
        date: json["date"],
        dateRaw: json["date_raw"] == null ? null : DateTime.parse(json["date_raw"]),
        time: json["time"],
        location: json["location"],
        description: json["description"],
        organizedBy: json["organized_by"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "type": type,
        "type_label": typeLabel,
        "icon": icon,
        "badge_icon_bg": badgeIconBg,
        "badge_icon_color": badgeIconColor,
        "date": date,
        "date_raw": dateRaw == null ? null : "${dateRaw!.year.toString().padLeft(4, '0')}-${dateRaw!.month.toString().padLeft(2, '0')}-${dateRaw!.day.toString().padLeft(2, '0')}",
        "time": time,
        "location": location,
        "description": description,
        "organized_by": organizedBy,
    };
}
