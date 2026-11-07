// To parse this JSON data, do
//
//     final maintananceDetailsModel = maintananceDetailsModelFromJson(jsonString);

import 'dart:convert';

MaintananceDetailsModel maintananceDetailsModelFromJson(String str) => MaintananceDetailsModel.fromJson(json.decode(str));

String maintananceDetailsModelToJson(MaintananceDetailsModel data) => json.encode(data.toJson());

class MaintananceDetailsModel {
    bool? status;
    String? message;
    Data? data;

    MaintananceDetailsModel({
        this.status,
        this.message,
        this.data,
    });

    factory MaintananceDetailsModel.fromJson(Map<String, dynamic> json) => MaintananceDetailsModel(
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
    RequestInformation? requestInformation;
    PropertyUnit? propertyUnit;
    MaintenanceDetails? maintenanceDetails;
    AssignedVendor? assignedVendor;
    ActivityHistory? activityHistory;
    SupportingDocuments? supportingDocuments;
    CurrentStatusBar? currentStatusBar;

    Data({
        this.header,
        this.requestInformation,
        this.propertyUnit,
        this.maintenanceDetails,
        this.assignedVendor,
        this.activityHistory,
        this.supportingDocuments,
        this.currentStatusBar,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        requestInformation: json["request_information"] == null ? null : RequestInformation.fromJson(json["request_information"]),
        propertyUnit: json["property_unit"] == null ? null : PropertyUnit.fromJson(json["property_unit"]),
        maintenanceDetails: json["maintenance_details"] == null ? null : MaintenanceDetails.fromJson(json["maintenance_details"]),
        assignedVendor: json["assigned_vendor"] == null ? null : AssignedVendor.fromJson(json["assigned_vendor"]),
        activityHistory: json["activity_history"] == null ? null : ActivityHistory.fromJson(json["activity_history"]),
        supportingDocuments: json["supporting_documents"] == null ? null : SupportingDocuments.fromJson(json["supporting_documents"]),
        currentStatusBar: json["current_status_bar"] == null ? null : CurrentStatusBar.fromJson(json["current_status_bar"]),
    );

    Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "request_information": requestInformation?.toJson(),
        "property_unit": propertyUnit?.toJson(),
        "maintenance_details": maintenanceDetails?.toJson(),
        "assigned_vendor": assignedVendor?.toJson(),
        "activity_history": activityHistory?.toJson(),
        "supporting_documents": supportingDocuments?.toJson(),
        "current_status_bar": currentStatusBar?.toJson(),
    };
}

class ActivityHistory {
    String? badge;
    String? title;
    List<Timeline>? timeline;

    ActivityHistory({
        this.badge,
        this.title,
        this.timeline,
    });

    factory ActivityHistory.fromJson(Map<String, dynamic> json) => ActivityHistory(
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
    int? step;
    String? title;
    String? timestamp;
    String? status;

    Timeline({
        this.step,
        this.title,
        this.timestamp,
        this.status,
    });

    factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
        step: json["step"],
        title: json["title"],
        timestamp: json["timestamp"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "step": step,
        "title": title,
        "timestamp": timestamp,
        "status": status,
    };
}

class AssignedVendor {
    String? label;
    String? name;
    String? role;
    String? avatar;

    AssignedVendor({
        this.label,
        this.name,
        this.role,
        this.avatar,
    });

    factory AssignedVendor.fromJson(Map<String, dynamic> json) => AssignedVendor(
        label: json["label"],
        name: json["name"],
        role: json["role"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "name": name,
        "role": role,
        "avatar": avatar,
    };
}

class CurrentStatusBar {
    String? statusLabel;
    String? statusText;
    String? buttonText;
    String? fullHistoryRoute;

    CurrentStatusBar({
        this.statusLabel,
        this.statusText,
        this.buttonText,
        this.fullHistoryRoute,
    });

    factory CurrentStatusBar.fromJson(Map<String, dynamic> json) => CurrentStatusBar(
        statusLabel: json["status_label"],
        statusText: json["status_text"],
        buttonText: json["button_text"],
        fullHistoryRoute: json["full_history_route"],
    );

    Map<String, dynamic> toJson() => {
        "status_label": statusLabel,
        "status_text": statusText,
        "button_text": buttonText,
        "full_history_route": fullHistoryRoute,
    };
}

class Header {
    String? screenTitle;
    String? screenSubtitle;
    String? badgeRequest;
    String? statusBadge;
    String? title;
    String? subtitle;
    String? priority;
    String? raisedOn;
    String? expectedCompletion;
    String? actualCompletion;

    Header({
        this.screenTitle,
        this.screenSubtitle,
        this.badgeRequest,
        this.statusBadge,
        this.title,
        this.subtitle,
        this.priority,
        this.raisedOn,
        this.expectedCompletion,
        this.actualCompletion,
    });

    factory Header.fromJson(Map<String, dynamic> json) => Header(
        screenTitle: json["screen_title"],
        screenSubtitle: json["screen_subtitle"],
        badgeRequest: json["badge_request"],
        statusBadge: json["status_badge"],
        title: json["title"],
        subtitle: json["subtitle"],
        priority: json["priority"],
        raisedOn: json["raised_on"],
        expectedCompletion: json["expected_completion"],
        actualCompletion: json["actual_completion"],
    );

    Map<String, dynamic> toJson() => {
        "screen_title": screenTitle,
        "screen_subtitle": screenSubtitle,
        "badge_request": badgeRequest,
        "status_badge": statusBadge,
        "title": title,
        "subtitle": subtitle,
        "priority": priority,
        "raised_on": raisedOn,
        "expected_completion": expectedCompletion,
        "actual_completion": actualCompletion,
    };
}

class MaintenanceDetails {
    String? badge;
    String? category;
    String? priority;
    String? status;
    String? raisedDate;
    String? expectedCompletion;
    String? actualCompletion;
    String? costReference;
    String? requestReference;

    MaintenanceDetails({
        this.badge,
        this.category,
        this.priority,
        this.status,
        this.raisedDate,
        this.expectedCompletion,
        this.actualCompletion,
        this.costReference,
        this.requestReference,
    });

    factory MaintenanceDetails.fromJson(Map<String, dynamic> json) => MaintenanceDetails(
        badge: json["badge"],
        category: json["category"],
        priority: json["priority"],
        status: json["status"],
        raisedDate: json["raised_date"],
        expectedCompletion: json["expected_completion"],
        actualCompletion: json["actual_completion"],
        costReference: json["cost_reference"],
        requestReference: json["request_reference"],
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "category": category,
        "priority": priority,
        "status": status,
        "raised_date": raisedDate,
        "expected_completion": expectedCompletion,
        "actual_completion": actualCompletion,
        "cost_reference": costReference,
        "request_reference": requestReference,
    };
}

class PropertyUnit {
    String? badge;
    String? unitName;
    String? complexName;
    String? fullLocation;

    PropertyUnit({
        this.badge,
        this.unitName,
        this.complexName,
        this.fullLocation,
    });

    factory PropertyUnit.fromJson(Map<String, dynamic> json) => PropertyUnit(
        badge: json["badge"],
        unitName: json["unit_name"],
        complexName: json["complex_name"],
        fullLocation: json["full_location"],
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "unit_name": unitName,
        "complex_name": complexName,
        "full_location": fullLocation,
    };
}

class RequestInformation {
    String? badge;
    String? title;
    String? subtitle;
    String? description;

    RequestInformation({
        this.badge,
        this.title,
        this.subtitle,
        this.description,
    });

    factory RequestInformation.fromJson(Map<String, dynamic> json) => RequestInformation(
        badge: json["badge"],
        title: json["title"],
        subtitle: json["subtitle"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "title": title,
        "subtitle": subtitle,
        "description": description,
    };
}

class SupportingDocuments {
    String? badge;
    String? title;
    List<FileElement>? files;
    List<Image>? images;
    String? imageNote;

    SupportingDocuments({
        this.badge,
        this.title,
        this.files,
        this.images,
        this.imageNote,
    });

    factory SupportingDocuments.fromJson(Map<String, dynamic> json) => SupportingDocuments(
        badge: json["badge"],
        title: json["title"],
        files: json["files"] == null ? [] : List<FileElement>.from(json["files"]!.map((x) => FileElement.fromJson(x))),
        images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
        imageNote: json["image_note"],
    );

    Map<String, dynamic> toJson() => {
        "badge": badge,
        "title": title,
        "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x.toJson())),
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
        "image_note": imageNote,
    };
}

class FileElement {
    String? title;
    String? fileType;
    String? fileName;
    String? fileSize;
    String? downloadUrl;

    FileElement({
        this.title,
        this.fileType,
        this.fileName,
        this.fileSize,
        this.downloadUrl,
    });

    factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        title: json["title"],
        fileType: json["file_type"],
        fileName: json["file_name"],
        fileSize: json["file_size"],
        downloadUrl: json["download_url"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "file_type": fileType,
        "file_name": fileName,
        "file_size": fileSize,
        "download_url": downloadUrl,
    };
}

class Image {
    String? label;
    String? imageUrl;
    String? placeholder;
    String? status;

    Image({
        this.label,
        this.imageUrl,
        this.placeholder,
        this.status,
    });

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        label: json["label"],
        imageUrl: json["image_url"],
        placeholder: json["placeholder"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "image_url": imageUrl,
        "placeholder": placeholder,
        "status": status,
    };
}
