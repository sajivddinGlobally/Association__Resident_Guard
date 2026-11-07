// // To parse this JSON data, do
// //
// //     final getComplaintTrackingModel = getComplaintTrackingModelFromJson(jsonString);

// import 'dart:convert';

// GetComplaintTrackingModel getComplaintTrackingModelFromJson(String str) =>
//     GetComplaintTrackingModel.fromJson(json.decode(str));

// String getComplaintTrackingModelToJson(GetComplaintTrackingModel data) =>
//     json.encode(data.toJson());

// class GetComplaintTrackingModel {
//   bool? status;
//   String? message;
//   Data? data;

//   GetComplaintTrackingModel({this.status, this.message, this.data});

//   factory GetComplaintTrackingModel.fromJson(Map<String, dynamic> json) =>
//       GetComplaintTrackingModel(
//         status: json["status"],
//         message: json["message"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "data": data?.toJson(),
//   };
// }

// class Data {
//   Header? header;
//   ComplaintTokenCard? complaintTokenCard;
//   ComplaintProgress? complaintProgress;
//   CurrentStatusBanner? currentStatusBanner;
//   Resolution? resolution;

//   Data({
//     this.header,
//     this.complaintTokenCard,
//     this.complaintProgress,
//     this.currentStatusBanner,
//     this.resolution,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     header: json["header"] == null ? null : Header.fromJson(json["header"]),
//     complaintTokenCard: json["complaint_token_card"] == null
//         ? null
//         : ComplaintTokenCard.fromJson(json["complaint_token_card"]),
//     complaintProgress: json["complaint_progress"] == null
//         ? null
//         : ComplaintProgress.fromJson(json["complaint_progress"]),
//     currentStatusBanner: json["current_status_banner"] == null
//         ? null
//         : CurrentStatusBanner.fromJson(json["current_status_banner"]),
//     resolution: json["resolution"] == null
//         ? null
//         : Resolution.fromJson(json["resolution"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "header": header?.toJson(),
//     "complaint_token_card": complaintTokenCard?.toJson(),
//     "complaint_progress": complaintProgress?.toJson(),
//     "current_status_banner": currentStatusBanner?.toJson(),
//     "resolution": resolution?.toJson(),
//   };
// }

// class ComplaintProgress {
//   String? title;
//   int? currentStep;
//   int? totalSteps;
//   List<Timeline>? timeline;

//   ComplaintProgress({
//     this.title,
//     this.currentStep,
//     this.totalSteps,
//     this.timeline,
//   });

//   factory ComplaintProgress.fromJson(Map<String, dynamic> json) =>
//       ComplaintProgress(
//         title: json["title"],
//         currentStep: json["current_step"],
//         totalSteps: json["total_steps"],
//         timeline: json["timeline"] == null
//             ? []
//             : List<Timeline>.from(
//                 json["timeline"]!.map((x) => Timeline.fromJson(x)),
//               ),
//       );

//   Map<String, dynamic> toJson() => {
//     "title": title,
//     "current_step": currentStep,
//     "total_steps": totalSteps,
//     "timeline": timeline == null
//         ? []
//         : List<dynamic>.from(timeline!.map((x) => x.toJson())),
//   };
// }

// class Timeline {
//   int? stepNumber;
//   String? title;
//   String? description;
//   bool? isCompleted;
//   bool? isCurrent;
//   String? statusState;

//   Timeline({
//     this.stepNumber,
//     this.title,
//     this.description,
//     this.isCompleted,
//     this.isCurrent,
//     this.statusState,
//   });

//   factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
//     stepNumber: json["step_number"],
//     title: json["title"],
//     description: json["description"],
//     isCompleted: json["is_completed"],
//     isCurrent: json["is_current"],
//     statusState: json["status_state"],
//   );

//   Map<String, dynamic> toJson() => {
//     "step_number": stepNumber,
//     "title": title,
//     "description": description,
//     "is_completed": isCompleted,
//     "is_current": isCurrent,
//     "status_state": statusState,
//   };
// }

// class ComplaintTokenCard {
//   String? tokenLabel;
//   String? tokenTitle;
//   String? tokenCode;
//   String? statusBadge;
//   String? statusBadgeColor;
//   String? issueTitle;
//   List<Detail>? details;
//   bool? isOverdue;
//   String? deadline;

//   ComplaintTokenCard({
//     this.tokenLabel,
//     this.tokenTitle,
//     this.tokenCode,
//     this.statusBadge,
//     this.statusBadgeColor,
//     this.issueTitle,
//     this.details,
//     this.isOverdue,
//     this.deadline,
//   });

//   factory ComplaintTokenCard.fromJson(Map<String, dynamic> json) {
//     final statusStr = json["status_badge"]?.toString() ?? "";
//     final deadlineStr =
//         json["deadline"] ?? json["sla_target_date"] ?? json["target_date"];
//     bool overdue =
//         json["is_overdue"] == true ||
//         json["is_overdue"] == 1 ||
//         statusStr.toLowerCase().contains("overdue") ||
//         statusStr.toLowerCase().contains("emergency");

//     if (!overdue && deadlineStr != null) {
//       final dt = DateTime.tryParse(deadlineStr.toString());
//       final st = statusStr.toLowerCase();
//       if (dt != null &&
//           DateTime.now().isAfter(dt) &&
//           !st.contains("resolved") &&
//           !st.contains("completed") &&
//           !st.contains("closed")) {
//         overdue = true;
//       }
//     }

//     return ComplaintTokenCard(
//       tokenLabel: json["token_label"],
//       tokenTitle: json["token_title"],
//       tokenCode: json["token_code"],
//       statusBadge: json["status_badge"],
//       statusBadgeColor: json["status_badge_color"],
//       issueTitle: json["issue_title"],
//       details: json["details"] == null
//           ? []
//           : List<Detail>.from(json["details"]!.map((x) => Detail.fromJson(x))),
//       isOverdue: overdue,
//       deadline: deadlineStr?.toString(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     "token_label": tokenLabel,
//     "token_title": tokenTitle,
//     "token_code": tokenCode,
//     "status_badge": statusBadge,
//     "status_badge_color": statusBadgeColor,
//     "issue_title": issueTitle,
//     "details": details == null
//         ? []
//         : List<dynamic>.from(details!.map((x) => x.toJson())),
//     "is_overdue": isOverdue,
//     "deadline": deadline,
//   };
// }

// class Detail {
//   String? label;
//   String? value;
//   String? type;

//   Detail({this.label, this.value, this.type});

//   factory Detail.fromJson(Map<String, dynamic> json) =>
//       Detail(label: json["label"], value: json["value"], type: json["type"]);

//   Map<String, dynamic> toJson() => {
//     "label": label,
//     "value": value,
//     "type": type,
//   };
// }

// class Resolution {
//   String? photo;
//   String? notes;
//   String? resolvedAt;

//   Resolution({this.photo, this.notes, this.resolvedAt});

//   factory Resolution.fromJson(Map<String, dynamic> json) => Resolution(
//     photo: json["photo"],
//     notes: json["notes"],
//     resolvedAt: json["resolved_at"],
//   );

//   Map<String, dynamic> toJson() => {
//     "photo": photo,
//     "notes": notes,
//     "resolved_at": resolvedAt,
//   };
// }

// class CurrentStatusBanner {
//   String? icon;
//   String? label;
//   String? message;
//   String? bgColor;
//   String? textColor;

//   CurrentStatusBanner({
//     this.icon,
//     this.label,
//     this.message,
//     this.bgColor,
//     this.textColor,
//   });

//   factory CurrentStatusBanner.fromJson(Map<String, dynamic> json) =>
//       CurrentStatusBanner(
//         icon: json["icon"],
//         label: json["label"],
//         message: json["message"],
//         bgColor: json["bg_color"],
//         textColor: json["text_color"],
//       );

//   Map<String, dynamic> toJson() => {
//     "icon": icon,
//     "label": label,
//     "message": message,
//     "bg_color": bgColor,
//     "text_color": textColor,
//   };
// }

// class Header {
//   String? subtitle;
//   String? title;

//   Header({this.subtitle, this.title});

//   factory Header.fromJson(Map<String, dynamic> json) =>
//       Header(subtitle: json["subtitle"], title: json["title"]);

//   Map<String, dynamic> toJson() => {"subtitle": subtitle, "title": title};
// }


// To parse this JSON data, do
//
//     final getComplaintTrackingModel = getComplaintTrackingModelFromJson(jsonString);

import 'dart:convert';

GetComplaintTrackingModel getComplaintTrackingModelFromJson(String str) =>
    GetComplaintTrackingModel.fromJson(json.decode(str));

String getComplaintTrackingModelToJson(GetComplaintTrackingModel data) =>
    json.encode(data.toJson());

class GetComplaintTrackingModel {
  bool? status;
  String? message;
  Data? data;

  GetComplaintTrackingModel({this.status, this.message, this.data});

  factory GetComplaintTrackingModel.fromJson(Map<String, dynamic> json) =>
      GetComplaintTrackingModel(
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
  ComplaintTokenCard? complaintTokenCard;
  ComplaintProgress? complaintProgress;
  CurrentStatusBanner? currentStatusBanner;
  Resolution? resolution;
  Map<String, dynamic>? actions;

  bool get canMarkCompleted => actions?['can_mark_completed'] == true;

  Data({
    this.header,
    this.complaintTokenCard,
    this.complaintProgress,
    this.currentStatusBanner,
    this.resolution,
    this.actions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    header: json["header"] == null ? null : Header.fromJson(json["header"]),
    complaintTokenCard: json["complaint_token_card"] == null
        ? null
        : ComplaintTokenCard.fromJson(json["complaint_token_card"]),
    complaintProgress: json["complaint_progress"] == null
        ? null
        : ComplaintProgress.fromJson(json["complaint_progress"]),
    currentStatusBanner: json["current_status_banner"] == null
        ? null
        : CurrentStatusBanner.fromJson(json["current_status_banner"]),
    resolution: json["resolution"] == null
        ? null
        : Resolution.fromJson(json["resolution"]),
    actions: json["actions"] is Map<String, dynamic>
        ? json["actions"] as Map<String, dynamic>
        : null,
  );

  Map<String, dynamic> toJson() => {
    "header": header?.toJson(),
    "complaint_token_card": complaintTokenCard?.toJson(),
    "complaint_progress": complaintProgress?.toJson(),
    "current_status_banner": currentStatusBanner?.toJson(),
    "resolution": resolution?.toJson(),
  };
}

class ComplaintProgress {
  String? title;
  int? currentStep;
  int? totalSteps;
  List<Timeline>? timeline;

  ComplaintProgress({
    this.title,
    this.currentStep,
    this.totalSteps,
    this.timeline,
  });

  factory ComplaintProgress.fromJson(Map<String, dynamic> json) =>
      ComplaintProgress(
        title: json["title"],
        currentStep: json["current_step"],
        totalSteps: json["total_steps"],
        timeline: json["timeline"] == null
            ? []
            : List<Timeline>.from(
                json["timeline"]!.map((x) => Timeline.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "current_step": currentStep,
    "total_steps": totalSteps,
    "timeline": timeline == null
        ? []
        : List<dynamic>.from(timeline!.map((x) => x.toJson())),
  };
}

class Timeline {
  int? stepNumber;
  String? title;
  String? description;
  bool? isCompleted;
  bool? isCurrent;
  String? statusState;

  Timeline({
    this.stepNumber,
    this.title,
    this.description,
    this.isCompleted,
    this.isCurrent,
    this.statusState,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
    stepNumber: json["step_number"],
    title: json["title"],
    description: json["description"],
    isCompleted: json["is_completed"],
    isCurrent: json["is_current"],
    statusState: json["status_state"],
  );

  Map<String, dynamic> toJson() => {
    "step_number": stepNumber,
    "title": title,
    "description": description,
    "is_completed": isCompleted,
    "is_current": isCurrent,
    "status_state": statusState,
  };
}

class ComplaintTokenCard {
  String? tokenLabel;
  String? tokenTitle;
  String? tokenCode;
  String? statusBadge;
  String? statusBadgeColor;
  String? issueTitle;
  List<Detail>? details;
  bool? isOverdue;
  String? deadline;

  ComplaintTokenCard({
    this.tokenLabel,
    this.tokenTitle,
    this.tokenCode,
    this.statusBadge,
    this.statusBadgeColor,
    this.issueTitle,
    this.details,
    this.isOverdue,
    this.deadline,
  });

  factory ComplaintTokenCard.fromJson(Map<String, dynamic> json) {
    final statusStr = json["status_badge"]?.toString() ?? "";
    final deadlineStr =
        json["deadline"] ?? json["sla_target_date"] ?? json["target_date"];
    bool overdue =
        json["is_overdue"] == true ||
        json["is_overdue"] == 1 ||
        statusStr.toLowerCase().contains("overdue") ||
        statusStr.toLowerCase().contains("emergency");

    if (!overdue && deadlineStr != null) {
      final dt = DateTime.tryParse(deadlineStr.toString());
      final st = statusStr.toLowerCase();
      if (dt != null &&
          DateTime.now().isAfter(dt) &&
          !st.contains("resolved") &&
          !st.contains("completed") &&
          !st.contains("closed")) {
        overdue = true;
      }
    }

    return ComplaintTokenCard(
      tokenLabel: json["token_label"],
      tokenTitle: json["token_title"],
      tokenCode: json["token_code"],
      statusBadge: json["status_badge"],
      statusBadgeColor: json["status_badge_color"],
      issueTitle: json["issue_title"],
      details: json["details"] == null
          ? []
          : List<Detail>.from(json["details"]!.map((x) => Detail.fromJson(x))),
      isOverdue: overdue,
      deadline: deadlineStr?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "token_label": tokenLabel,
    "token_title": tokenTitle,
    "token_code": tokenCode,
    "status_badge": statusBadge,
    "status_badge_color": statusBadgeColor,
    "issue_title": issueTitle,
    "details": details == null
        ? []
        : List<dynamic>.from(details!.map((x) => x.toJson())),
    "is_overdue": isOverdue,
    "deadline": deadline,
  };
}

class Detail {
  String? label;
  String? value;
  String? type;

  Detail({this.label, this.value, this.type});

  factory Detail.fromJson(Map<String, dynamic> json) =>
      Detail(label: json["label"], value: json["value"], type: json["type"]);

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
    "type": type,
  };
}

class Resolution {
  String? photo;
  String? notes;
  String? resolvedAt;

  Resolution({this.photo, this.notes, this.resolvedAt});

  factory Resolution.fromJson(Map<String, dynamic> json) => Resolution(
    photo: json["photo"],
    notes: json["notes"],
    resolvedAt: json["resolved_at"],
  );

  Map<String, dynamic> toJson() => {
    "photo": photo,
    "notes": notes,
    "resolved_at": resolvedAt,
  };
}

class CurrentStatusBanner {
  String? icon;
  String? label;
  String? message;
  String? bgColor;
  String? textColor;

  CurrentStatusBanner({
    this.icon,
    this.label,
    this.message,
    this.bgColor,
    this.textColor,
  });

  factory CurrentStatusBanner.fromJson(Map<String, dynamic> json) =>
      CurrentStatusBanner(
        icon: json["icon"],
        label: json["label"],
        message: json["message"],
        bgColor: json["bg_color"],
        textColor: json["text_color"],
      );

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "label": label,
    "message": message,
    "bg_color": bgColor,
    "text_color": textColor,
  };
}

class Header {
  String? subtitle;
  String? title;

  Header({this.subtitle, this.title});

  factory Header.fromJson(Map<String, dynamic> json) =>
      Header(subtitle: json["subtitle"], title: json["title"]);

  Map<String, dynamic> toJson() => {"subtitle": subtitle, "title": title};
}
