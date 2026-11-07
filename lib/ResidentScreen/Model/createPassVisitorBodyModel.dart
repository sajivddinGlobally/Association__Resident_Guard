// To parse this JSON data, do
//
//     final createVisitorPassBodyModdel = createVisitorPassBodyModdelFromJson(jsonString);

import 'dart:convert';

CreateVisitorPassBodyModdel createVisitorPassBodyModdelFromJson(String str) => CreateVisitorPassBodyModdel.fromJson(json.decode(str));

String createVisitorPassBodyModdelToJson(CreateVisitorPassBodyModdel data) => json.encode(data.toJson());

class CreateVisitorPassBodyModdel {
    String? visitorName;
    String? mobileNumber;
    String? visitorType;
    String? visitDate;
    String? visitTime;
    String? purposeOfVisit;
    bool? isFrequent;
    String? frequentRole;

    CreateVisitorPassBodyModdel({
        this.visitorName,
        this.mobileNumber,
        this.visitorType,
        this.visitDate,
        this.visitTime,
        this.purposeOfVisit,
        this.isFrequent,
        this.frequentRole,
    });

    factory CreateVisitorPassBodyModdel.fromJson(Map<String, dynamic> json) => CreateVisitorPassBodyModdel(
        visitorName: json["visitor_name"],
        mobileNumber: json["mobile_number"],
        visitorType: json["visitor_type"],
        visitDate: json["visit_date"],
        visitTime: json["visit_time"],
        purposeOfVisit: json["purpose_of_visit"],
        isFrequent: json["is_frequent"] == true || json["is_frequent"] == 1,
        frequentRole: json["frequent_role"],
    );

    Map<String, dynamic> toJson() => {
        "visitor_name": visitorName,
        "mobile_number": mobileNumber,
        "visitor_type": visitorType,
        "visit_date": visitDate,
        "visit_time": visitTime,
        "purpose_of_visit": purposeOfVisit,
        if (isFrequent == true) "is_frequent": 1,
        if (isFrequent == true && frequentRole != null && frequentRole!.isNotEmpty)
          "frequent_role": frequentRole,
    };
}
