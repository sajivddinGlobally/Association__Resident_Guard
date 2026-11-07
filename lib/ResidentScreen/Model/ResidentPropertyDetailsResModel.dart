// To parse this JSON data, do
//
//     final residentPropertyDetailsResModel = residentPropertyDetailsResModelFromJson(jsonString);

import 'dart:convert';

ResidentPropertyDetailsResModel residentPropertyDetailsResModelFromJson(
  String str,
) => ResidentPropertyDetailsResModel.fromJson(json.decode(str));

String residentPropertyDetailsResModelToJson(
  ResidentPropertyDetailsResModel data,
) => json.encode(data.toJson());

class ResidentPropertyDetailsResModel {
  final bool status;
  final String message;
  final Data data;

  ResidentPropertyDetailsResModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ResidentPropertyDetailsResModel.fromJson(Map<String, dynamic> json) =>
      ResidentPropertyDetailsResModel(
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
  final MyProperty myProperty;
  final PropertyOverview propertyOverview;
  final PropertyInformation propertyInformation;
  final ActionButtons actionButtons;

  Data({
    required this.header,
    required this.myProperty,
    required this.propertyOverview,
    required this.propertyInformation,
    required this.actionButtons,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    header: Header.fromJson(json["header"]),
    myProperty: MyProperty.fromJson(json["my_property"]),
    propertyOverview: PropertyOverview.fromJson(json["property_overview"]),
    propertyInformation: PropertyInformation.fromJson(
      json["property_information"],
    ),
    actionButtons: ActionButtons.fromJson(json["action_buttons"]),
  );

  Map<String, dynamic> toJson() => {
    "header": header.toJson(),
    "my_property": myProperty.toJson(),
    "property_overview": propertyOverview.toJson(),
    "property_information": propertyInformation.toJson(),
    "action_buttons": actionButtons.toJson(),
  };
}

class ActionButtons {
  final AddComplain addComplain;
  final AddComplain complainTrackStatus;

  ActionButtons({required this.addComplain, required this.complainTrackStatus});

  factory ActionButtons.fromJson(Map<String, dynamic> json) => ActionButtons(
    addComplain: AddComplain.fromJson(json["add_complain"]),
    complainTrackStatus: AddComplain.fromJson(json["complain_track_status"]),
  );

  Map<String, dynamic> toJson() => {
    "add_complain": addComplain.toJson(),
    "complain_track_status": complainTrackStatus.toJson(),
  };
}

class AddComplain {
  final String label;
  final String type;
  final String endpoint;
  final String method;

  AddComplain({
    required this.label,
    required this.type,
    required this.endpoint,
    required this.method,
  });

  factory AddComplain.fromJson(Map<String, dynamic> json) => AddComplain(
    label: json["label"],
    type: json["type"],
    endpoint: json["endpoint"],
    method: json["method"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "type": type,
    "endpoint": endpoint,
    "method": method,
  };
}

class Header {
  final String title;
  final String subtitle;

  Header({required this.title, required this.subtitle});

  factory Header.fromJson(Map<String, dynamic> json) =>
      Header(title: json["title"], subtitle: json["subtitle"]);

  Map<String, dynamic> toJson() => {"title": title, "subtitle": subtitle};
}

class MyProperty {
  final String tag;
  final String title;
  final String subtitle;
  final String image;
  final String? occupancyType;
  final String? residentType;
  final String? residentTypeBadge;
  final String? residentTypeKey;
  final bool? isHouseOwner;

  MyProperty({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.image,
    this.occupancyType,
    this.residentType,
    this.residentTypeBadge,
    this.residentTypeKey,
    this.isHouseOwner,
  });

  factory MyProperty.fromJson(Map<String, dynamic> json) => MyProperty(
    tag: json["tag"] ?? "",
    title: json["title"] ?? "",
    subtitle: json["subtitle"] ?? "",
    image: json["image"] ?? "",
    occupancyType: json["occupancy_type"] ??
        json["resident_type_badge"] ??
        json["resident_type"] ??
        json["occupant_type"],
    residentType: json["resident_type"],
    residentTypeBadge: json["resident_type_badge"],
    residentTypeKey: json["resident_type_key"],
    isHouseOwner: json["is_house_owner"],
  );

  Map<String, dynamic> toJson() => {
    "tag": tag,
    "title": title,
    "subtitle": subtitle,
    "image": image,
    "occupancy_type": occupancyType,
    "resident_type": residentType,
    "resident_type_badge": residentTypeBadge,
    "resident_type_key": residentTypeKey,
    "is_house_owner": isHouseOwner,
  };
}

class PropertyInformation {
  final String sectionTitle;
  final Cards cards;

  PropertyInformation({required this.sectionTitle, required this.cards});

  factory PropertyInformation.fromJson(Map<String, dynamic> json) =>
      PropertyInformation(
        sectionTitle: json["section_title"],
        cards: Cards.fromJson(json["cards"]),
      );

  Map<String, dynamic> toJson() => {
    "section_title": sectionTitle,
    "cards": cards.toJson(),
  };
}

class Cards {
  final Ass associatedComplex;
  final Ass assignedCaretaker;

  Cards({required this.associatedComplex, required this.assignedCaretaker});

  factory Cards.fromJson(Map<String, dynamic> json) => Cards(
    associatedComplex: Ass.fromJson(json["associated_complex"]),
    assignedCaretaker: Ass.fromJson(json["assigned_caretaker"]),
  );

  Map<String, dynamic> toJson() => {
    "associated_complex": associatedComplex.toJson(),
    "assigned_caretaker": assignedCaretaker.toJson(),
  };
}

class Ass {
  final String icon;
  final String name;
  final String label;
  final String? phone;

  Ass({
    required this.icon,
    required this.name,
    required this.label,
    this.phone,
  });

  factory Ass.fromJson(Map<String, dynamic> json) => Ass(
    icon: json["icon"],
    name: json["name"],
    label: json["label"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "name": name,
    "label": label,
    "phone": phone,
  };
}

class PropertyOverview {
  final String sectionTitle;
  final bool viewAllLink;
  final List<Specification> specifications;

  PropertyOverview({
    required this.sectionTitle,
    required this.viewAllLink,
    required this.specifications,
  });

  factory PropertyOverview.fromJson(Map<String, dynamic> json) =>
      PropertyOverview(
        sectionTitle: json["section_title"],
        viewAllLink: json["view_all_link"],
        specifications: List<Specification>.from(
          json["specifications"].map((x) => Specification.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "section_title": sectionTitle,
    "view_all_link": viewAllLink,
    "specifications": List<dynamic>.from(specifications.map((x) => x.toJson())),
  };
}

class Specification {
  final String key;
  final String label;
  final String value;

  Specification({required this.key, required this.label, required this.value});

  factory Specification.fromJson(Map<String, dynamic> json) => Specification(
    key: json["key"],
    label: json["label"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {"key": key, "label": label, "value": value};
}