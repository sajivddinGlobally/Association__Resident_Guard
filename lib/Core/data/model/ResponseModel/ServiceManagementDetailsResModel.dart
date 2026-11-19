// To parse this JSON data, do
//
//     final serviceManagementDetailsResModel = serviceManagementDetailsResModelFromJson(jsonString);

import 'dart:convert';

ServiceManagementDetailsResModel serviceManagementDetailsResModelFromJson(
  String str,
) => ServiceManagementDetailsResModel.fromJson(json.decode(str));

String serviceManagementDetailsResModelToJson(
  ServiceManagementDetailsResModel data,
) => json.encode(data.toJson());

class ServiceManagementDetailsResModel {
  final bool status;
  final String message;
  final Data data;

  ServiceManagementDetailsResModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ServiceManagementDetailsResModel.fromJson(
    Map<String, dynamic> json,
  ) => ServiceManagementDetailsResModel(
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
  final HeroCard heroCard;
  final ServiceInformation serviceInformation;
  final AssignedVendor assignedVendor;
  final ScopeOfWork scopeOfWork;
  final ReportedIssues reportedIssues;
  final ServicePerformance servicePerformance;
  // Naye (vendor ki poori jaankari ek hi screen par). Purana backend na bheje to khaali.
  final VendorDetails vendorDetails;
  final List<RecentRequest> recentRequests;

  Data({
    required this.header,
    required this.heroCard,
    required this.serviceInformation,
    required this.assignedVendor,
    required this.scopeOfWork,
    required this.reportedIssues,
    required this.servicePerformance,
    VendorDetails? vendorDetails,
    List<RecentRequest>? recentRequests,
  }) : vendorDetails = vendorDetails ?? VendorDetails.fromJson(null),
       recentRequests = recentRequests ?? const [];

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    header: Header.fromJson(json["header"]),
    heroCard: HeroCard.fromJson(json["hero_card"]),
    serviceInformation: ServiceInformation.fromJson(
      json["service_information"],
    ),
    assignedVendor: AssignedVendor.fromJson(json["assigned_vendor"]),
    scopeOfWork: ScopeOfWork.fromJson(json["scope_of_work"]),
    reportedIssues: ReportedIssues.fromJson(json["reported_issues"]),
    servicePerformance: ServicePerformance.fromJson(
      json["service_performance"],
    ),
    vendorDetails: VendorDetails.fromJson(
      json["vendor_details"] is Map<String, dynamic>
          ? json["vendor_details"]
          : null,
    ),
    recentRequests: json["recent_requests"] is List
        ? (json["recent_requests"] as List)
              .whereType<Map<String, dynamic>>()
              .map((x) => RecentRequest.fromJson(x))
              .toList()
        : const [],
  );

  Map<String, dynamic> toJson() => {
    "header": header.toJson(),
    "hero_card": heroCard.toJson(),
    "service_information": serviceInformation.toJson(),
    "assigned_vendor": assignedVendor.toJson(),
    "scope_of_work": scopeOfWork.toJson(),
    "reported_issues": reportedIssues.toJson(),
    "service_performance": servicePerformance.toJson(),
  };
}

class AssignedVendor {
  final String title;
  final String providerLabel;
  final String name;
  final String roleDescription;
  final String avatar;
  final String detailUrl;

  AssignedVendor({
    required this.title,
    required this.providerLabel,
    required this.name,
    required this.roleDescription,
    required this.avatar,
    required this.detailUrl,
  });

  factory AssignedVendor.fromJson(Map<String, dynamic> json) => AssignedVendor(
    title: json["title"],
    providerLabel: json["provider_label"],
    name: json["name"],
    roleDescription: json["role_description"],
    avatar: json["avatar"],
    detailUrl: json["detail_url"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "provider_label": providerLabel,
    "name": name,
    "role_description": roleDescription,
    "avatar": avatar,
    "detail_url": detailUrl,
  };
}

class Header {
  final String title;
  final String subtitle;
  final String complexName;

  Header({
    required this.title,
    required this.subtitle,
    required this.complexName,
  });

  factory Header.fromJson(Map<String, dynamic> json) => Header(
    title: json["title"],
    subtitle: json["subtitle"],
    complexName: json["complex_name"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "subtitle": subtitle,
    "complex_name": complexName,
  };
}

class HeroCard {
  final String badgeStatus;
  final String category;
  final String title;
  final String subtitle;
  final String icon;
  final Metrics metrics;

  HeroCard({
    required this.badgeStatus,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.metrics,
  });

  factory HeroCard.fromJson(Map<String, dynamic> json) => HeroCard(
    badgeStatus: json["badge_status"],
    category: json["category"],
    title: json["title"],
    subtitle: json["subtitle"],
    icon: json["icon"],
    metrics: Metrics.fromJson(json["metrics"]),
  );

  Map<String, dynamic> toJson() => {
    "badge_status": badgeStatus,
    "category": category,
    "title": title,
    "subtitle": subtitle,
    "icon": icon,
    "metrics": metrics.toJson(),
  };
}

class Metrics {
  final String schedule;
  final String serviceSince;
  final String issues;

  Metrics({
    required this.schedule,
    required this.serviceSince,
    required this.issues,
  });

  factory Metrics.fromJson(Map<String, dynamic> json) => Metrics(
    schedule: json["schedule"],
    serviceSince: json["service_since"],
    issues: json["issues"],
  );

  Map<String, dynamic> toJson() => {
    "schedule": schedule,
    "service_since": serviceSince,
    "issues": issues,
  };
}

class ReportedIssues {
  final String badge;
  final String title;
  final String subtitle;
  final String route;

  ReportedIssues({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  factory ReportedIssues.fromJson(Map<String, dynamic> json) => ReportedIssues(
    badge: json["badge"],
    title: json["title"],
    subtitle: json["subtitle"],
    route: json["route"],
  );

  Map<String, dynamic> toJson() => {
    "badge": badge,
    "title": title,
    "subtitle": subtitle,
    "route": route,
  };
}

class ScopeOfWork {
  final String title;
  final List<ChecklistItem> checklistItems;

  ScopeOfWork({required this.title, required this.checklistItems});

  factory ScopeOfWork.fromJson(Map<String, dynamic> json) => ScopeOfWork(
    title: json["title"] ?? '',
    checklistItems: json["checklist_items"] == null
        ? []
        : List<ChecklistItem>.from(
            (json["checklist_items"] as List).map(
              (x) => ChecklistItem.fromJson(x is Map<String, dynamic> ? x : {}),
            ),
          ),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "checklist_items": List<dynamic>.from(
      checklistItems.map((x) => x.toJson()),
    ),
  };
}

class ChecklistItem {
  final String task;
  final bool isCompleted;

  ChecklistItem({required this.task, required this.isCompleted});

  factory ChecklistItem.fromJson(Map<String, dynamic> json) =>
      ChecklistItem(task: json["task"], isCompleted: json["is_completed"]);

  Map<String, dynamic> toJson() => {"task": task, "is_completed": isCompleted};
}

class ServiceInformation {
  final String title;
  final String serviceType;
  final String currentStatus;
  final String serviceSchedule;
  final String serviceTime;
  final String lastService;
  final String nextReview;

  ServiceInformation({
    required this.title,
    required this.serviceType,
    required this.currentStatus,
    required this.serviceSchedule,
    required this.serviceTime,
    required this.lastService,
    required this.nextReview,
  });

  factory ServiceInformation.fromJson(Map<String, dynamic> json) =>
      ServiceInformation(
        title: json["title"],
        serviceType: json["service_type"],
        currentStatus: json["current_status"],
        serviceSchedule: json["service_schedule"],
        serviceTime: json["service_time"],
        lastService: json["last_service"],
        nextReview: json["next_review"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "service_type": serviceType,
    "current_status": currentStatus,
    "service_schedule": serviceSchedule,
    "service_time": serviceTime,
    "last_service": lastService,
    "next_review": nextReview,
  };
}

class ServicePerformance {
  final String title;
  final int score;
  final String formatted;
  final String headline;
  final String currentPerformance;

  ServicePerformance({
    required this.title,
    required this.score,
    required this.formatted,
    required this.headline,
    required this.currentPerformance,
  });

  factory ServicePerformance.fromJson(Map<String, dynamic> json) =>
      ServicePerformance(
        title: json["title"],
        score: json["score"],
        formatted: json["formatted"],
        headline: json["headline"],
        currentPerformance: json["current_performance"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "score": score,
    "formatted": formatted,
    "headline": headline,
    "current_performance": currentPerformance,
  };
}

/// Null / koi bhi type aaye to String (kabhi crash nahi)
String _str(dynamic v) => v == null ? '' : v.toString();

/// Vendor ki asli jaankari (GET /services/{id} -> vendor_details). Khaali field = ''.
class VendorDetails {
  final String name;
  final String category;
  final String providerCode;
  final String providerType;
  final String status;
  final String contactPerson;
  final String contactRole;
  final String phone;
  final String email;
  final String workingHours;
  final String schedule;
  final String planLabel;
  final String planStart;
  final String planExpiry;
  final String planStatus;
  final String avatar;
  final List<VendorDocument> documents;

  VendorDetails({
    required this.name,
    required this.category,
    required this.providerCode,
    required this.providerType,
    required this.status,
    required this.contactPerson,
    required this.contactRole,
    required this.phone,
    required this.email,
    required this.workingHours,
    required this.schedule,
    required this.planLabel,
    required this.planStart,
    required this.planExpiry,
    required this.planStatus,
    required this.avatar,
    required this.documents,
  });

  factory VendorDetails.fromJson(Map<String, dynamic>? json) => VendorDetails(
    name: _str(json?["name"]),
    category: _str(json?["category"]),
    providerCode: _str(json?["provider_code"]),
    providerType: _str(json?["provider_type"]),
    status: _str(json?["status"]),
    contactPerson: _str(json?["contact_person"]),
    contactRole: _str(json?["contact_role"]),
    phone: _str(json?["phone"]),
    email: _str(json?["email"]),
    workingHours: _str(json?["working_hours"]),
    schedule: _str(json?["schedule"]),
    planLabel: _str(json?["plan_label"]),
    planStart: _str(json?["plan_start"]),
    planExpiry: _str(json?["plan_expiry"]),
    planStatus: json?["plan_status"] == null
        ? 'none'
        : _str(json?["plan_status"]),
    avatar: _str(json?["avatar"]),
    documents: json?["documents"] is List
        ? (json!["documents"] as List)
              .whereType<Map<String, dynamic>>()
              .map((x) => VendorDocument.fromJson(x))
              .where((d) => d.url.isNotEmpty)
              .toList()
        : const [],
  );
}

class VendorDocument {
  final String title;
  final String url;

  VendorDocument({required this.title, required this.url});

  factory VendorDocument.fromJson(Map<String, dynamic> json) => VendorDocument(
    title: _str(json["title"] ?? json["name"] ?? json["document_name"]).isEmpty
        ? 'Document'
        : _str(json["title"] ?? json["name"] ?? json["document_name"]),
    url: _str(json["url"] ?? json["file_url"] ?? json["document_url"]),
  );
}

/// Is vendor ki service request (recent_requests)
class RecentRequest {
  final int id;
  final String ticketNumber;
  final String title;
  final String date;
  final String status;
  final bool isDone;

  RecentRequest({
    required this.id,
    required this.ticketNumber,
    required this.title,
    required this.date,
    required this.status,
    required this.isDone,
  });

  factory RecentRequest.fromJson(Map<String, dynamic> json) => RecentRequest(
    id: json["id"] is int ? json["id"] : int.tryParse(_str(json["id"])) ?? 0,
    ticketNumber: _str(json["ticket_number"]),
    title: _str(json["title"]).isEmpty
        ? 'Service request'
        : _str(json["title"]),
    date: _str(json["date"]),
    status: _str(json["status"]),
    isDone: json["is_done"] == true,
  );
}
