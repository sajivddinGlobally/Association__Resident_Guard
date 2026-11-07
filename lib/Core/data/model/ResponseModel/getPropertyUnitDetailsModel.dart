// To parse this JSON data, do
//
//     final getPropertyUnitDetailsModel = getPropertyUnitDetailsModelFromJson(jsonString);

import 'dart:convert';

GetPropertyUnitDetailsModel getPropertyUnitDetailsModelFromJson(String str) =>
    GetPropertyUnitDetailsModel.fromJson(json.decode(str));

String getPropertyUnitDetailsModelToJson(GetPropertyUnitDetailsModel data) =>
    json.encode(data.toJson());

class GetPropertyUnitDetailsModel {
  bool? status;
  Data? data;

  GetPropertyUnitDetailsModel({this.status, this.data});

  factory GetPropertyUnitDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetPropertyUnitDetailsModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  Header? header;
  Banner? banner;
  StatsCards? statsCards;
  List<PropertyInformation>? propertyInformation;
  AssignedPropertyOwner? assignedPropertyOwner;
  AssignedPropertyOwner? currentOccupant;
  List<RecentPropertyActivity>? recentPropertyActivity;
  List<PropertyRecord>? propertyRecords;

  Data({
    this.header,
    this.banner,
    this.statsCards,
    this.propertyInformation,
    this.assignedPropertyOwner,
    this.currentOccupant,
    this.recentPropertyActivity,
    this.propertyRecords,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    header: json["header"] == null ? null : Header.fromJson(json["header"]),
    banner: json["banner"] == null ? null : Banner.fromJson(json["banner"]),
    statsCards: json["stats_cards"] == null
        ? null
        : StatsCards.fromJson(json["stats_cards"]),
    propertyInformation: json["property_information"] == null
        ? []
        : List<PropertyInformation>.from(
            json["property_information"]!.map(
              (x) => PropertyInformation.fromJson(x),
            ),
          ),
    assignedPropertyOwner: json["assigned_property_owner"] == null
        ? null
        : AssignedPropertyOwner.fromJson(json["assigned_property_owner"]),
    currentOccupant: json["current_occupant"] == null
        ? (json["tenant"] == null
              ? null
              : AssignedPropertyOwner.fromJson(json["tenant"]))
        : AssignedPropertyOwner.fromJson(json["current_occupant"]),
    recentPropertyActivity: json["recent_property_activity"] == null
        ? []
        : List<RecentPropertyActivity>.from(
            json["recent_property_activity"]!.map(
              (x) => RecentPropertyActivity.fromJson(x),
            ),
          ),
    propertyRecords: json["property_records"] == null
        ? []
        : List<PropertyRecord>.from(
            json["property_records"]!.map((x) => PropertyRecord.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "header": header?.toJson(),
    "banner": banner?.toJson(),
    "stats_cards": statsCards?.toJson(),
    "property_information": propertyInformation == null
        ? []
        : List<dynamic>.from(propertyInformation!.map((x) => x.toJson())),
    "assigned_property_owner": assignedPropertyOwner?.toJson(),
    "recent_property_activity": recentPropertyActivity == null
        ? []
        : List<dynamic>.from(recentPropertyActivity!.map((x) => x.toJson())),
    "property_records": propertyRecords == null
        ? []
        : List<dynamic>.from(propertyRecords!.map((x) => x.toJson())),
  };
}

class AssignedPropertyOwner {
  String? name;
  String? avatar;
  String? tag;
  String? roleLabel;
  bool? isVerified;
  String? contact;
  String? fullContact;
  String? propertyOwnership;

  AssignedPropertyOwner({
    this.name,
    this.avatar,
    this.tag,
    this.roleLabel,
    this.isVerified,
    this.contact,
    this.fullContact,
    this.propertyOwnership,
  });

  factory AssignedPropertyOwner.fromJson(Map<String, dynamic> json) =>
      AssignedPropertyOwner(
        name: json["name"]?.toString(),
        avatar: json["avatar"]?.toString(),
        tag: json["tag"]?.toString(),
        roleLabel: json["role_label"]?.toString(),
        isVerified:
            json["is_verified"] == true ||
            json["is_verified"] == 1 ||
            json["is_verified"]?.toString() == "true",
        contact: json["contact"]?.toString(),
        fullContact: json["full_contact"]?.toString(),
        propertyOwnership: json["property_ownership"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "avatar": avatar,
    "tag": tag,
    "role_label": roleLabel,
    "is_verified": isVerified,
    "contact": contact,
    "full_contact": fullContact,
    "property_ownership": propertyOwnership,
  };
}

class Banner {
  String? tag;
  String? title;
  String? subtitle;
  String? image;
  String? status;
  bool? isActive;

  Banner({
    this.tag,
    this.title,
    this.subtitle,
    this.image,
    this.status,
    this.isActive,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    tag: json["tag"]?.toString(),
    title: json["title"]?.toString(),
    subtitle: json["subtitle"]?.toString(),
    image: json["image"]?.toString(),
    status: json["status"]?.toString(),
    isActive:
        json["is_active"] == true ||
        json["is_active"] == 1 ||
        json["is_active"]?.toString() == "true",
  );

  Map<String, dynamic> toJson() => {
    "tag": tag,
    "title": title,
    "subtitle": subtitle,
    "image": image,
    "status": status,
    "is_active": isActive,
  };
}

class Header {
  String? title;
  String? subtitle;

  Header({this.title, this.subtitle});

  factory Header.fromJson(Map<String, dynamic> json) =>
      Header(title: json["title"], subtitle: json["subtitle"]);

  Map<String, dynamic> toJson() => {"title": title, "subtitle": subtitle};
}

class PropertyInformation {
  String? key;
  String? title;
  String? value;
  String? icon;
  String? actionText;

  PropertyInformation({
    this.key,
    this.title,
    this.value,
    this.icon,
    this.actionText,
  });

  factory PropertyInformation.fromJson(Map<String, dynamic> json) =>
      PropertyInformation(
        key: json["key"]?.toString(),
        title: json["title"]?.toString(),
        value: json["value"]?.toString(),
        icon: json["icon"]?.toString(),
        actionText: json["action_text"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "key": key,
    "title": title,
    "value": value,
    "icon": icon,
    "action_text": actionText,
  };
}

class PropertyRecord {
  String? id;
  String? title;
  String? subtitle;
  String? actionText;
  String? actionRoute;
  String? icon;

  PropertyRecord({
    this.id,
    this.title,
    this.subtitle,
    this.actionText,
    this.actionRoute,
    this.icon,
  });

  factory PropertyRecord.fromJson(Map<String, dynamic> json) => PropertyRecord(
    id: json["id"]?.toString(),
    title: json["title"]?.toString(),
    subtitle: json["subtitle"]?.toString(),
    actionText: json["action_text"]?.toString(),
    actionRoute: json["action_route"]?.toString(),
    icon: json["icon"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "subtitle": subtitle,
    "action_text": actionText,
    "action_route": actionRoute,
    "icon": icon,
  };
}

class RecentPropertyActivity {
  dynamic id;
  String? activityType;
  String? icon;
  String? title;
  String? subtitle;
  String? status;
  String? date;
  String? category;
  String? resolutionNotes;
  List<ActivityAttachment>? attachments;
  int? sequence;

  RecentPropertyActivity({
    this.id,
    this.activityType,
    this.icon,
    this.title,
    this.subtitle,
    this.status,
    this.date,
    this.category,
    this.resolutionNotes,
    this.attachments,
    this.sequence,
  });

  factory RecentPropertyActivity.fromJson(Map<String, dynamic> json) =>
      RecentPropertyActivity(
        id: json["id"]?.toString(),
        activityType: json["activity_type"]?.toString(),
        icon: json["icon"]?.toString(),
        title: json["title"]?.toString(),
        subtitle: json["subtitle"]?.toString(),
        status: json["status"]?.toString(),
        date: json["date"]?.toString(),
        category: json["category"]?.toString(),
        resolutionNotes: json["resolution_notes"]?.toString(),
        attachments: json["attachments"] == null
            ? []
            : List<ActivityAttachment>.from(
                json["attachments"]!.map((x) => ActivityAttachment.fromJson(x)),
              ),
        sequence: json["sequence"] != null
            ? int.tryParse(json["sequence"].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "activity_type": activityType,
    "icon": icon,
    "title": title,
    "subtitle": subtitle,
    "status": status,
    "date": date,
    "category": category,
    "resolution_notes": resolutionNotes,
    "attachments": attachments == null
        ? []
        : List<dynamic>.from(attachments!.map((x) => x.toJson())),
    "sequence": sequence,
  };
}

class ActivityAttachment {
  String? type;
  String? title;
  String? url;

  ActivityAttachment({
    this.type,
    this.title,
    this.url,
  });

  factory ActivityAttachment.fromJson(Map<String, dynamic> json) =>
      ActivityAttachment(
        type: json["type"]?.toString(),
        title: json["title"]?.toString(),
        url: json["url"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "type": type,
    "title": title,
    "url": url,
  };
}

class StatsCards {
  PropertyType? unitNumber;
  PropertyType? propertyType;
  PropertyScore? propertyScore;
  PropertyType? occupancyStatus;
  PropertyType? maintenanceStatus;

  StatsCards({
    this.unitNumber,
    this.propertyType,
    this.propertyScore,
    this.occupancyStatus,
    this.maintenanceStatus,
  });

  factory StatsCards.fromJson(Map<String, dynamic> json) => StatsCards(
    unitNumber: json["unit_number"] == null
        ? null
        : PropertyType.fromJson(json["unit_number"]),
    propertyType: json["property_type"] == null
        ? null
        : PropertyType.fromJson(json["property_type"]),
    propertyScore: json["property_score"] == null
        ? null
        : PropertyScore.fromJson(json["property_score"]),
    occupancyStatus: json["occupancy_status"] == null
        ? (json["status"] == null
              ? null
              : PropertyType.fromJson(json["status"]))
        : PropertyType.fromJson(json["occupancy_status"]),
    maintenanceStatus: json["maintenance_status"] == null
        ? null
        : PropertyType.fromJson(json["maintenance_status"]),
  );

  Map<String, dynamic> toJson() => {
    "unit_number": unitNumber?.toJson(),
    "property_type": propertyType?.toJson(),
    "property_score": propertyScore?.toJson(),
    "occupancy_status": occupancyStatus?.toJson(),
    "maintenance_status": maintenanceStatus?.toJson(),
  };
}

class PropertyScore {
  dynamic value;
  String? label;
  String? icon;

  PropertyScore({this.value, this.label, this.icon});

  factory PropertyScore.fromJson(Map<String, dynamic> json) => PropertyScore(
    value: json["value"],
    label: json["label"]?.toString(),
    icon: json["icon"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
    "icon": icon,
  };
}

class PropertyType {
  String? value;
  String? label;
  String? icon;

  PropertyType({this.value, this.label, this.icon});

  factory PropertyType.fromJson(Map<String, dynamic> json) => PropertyType(
    value: json["value"]?.toString(),
    label: json["label"]?.toString(),
    icon: json["icon"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "label": label,
    "icon": icon,
  };
}
