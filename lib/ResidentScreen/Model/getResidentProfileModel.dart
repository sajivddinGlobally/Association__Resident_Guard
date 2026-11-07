// To parse this JSON data, do
//
//     final getResidentProfileModel = getResidentProfileModelFromJson(jsonString);

import 'dart:convert';

GetResidentProfileModel getResidentProfileModelFromJson(String str) => GetResidentProfileModel.fromJson(json.decode(str));

String getResidentProfileModelToJson(GetResidentProfileModel data) => json.encode(data.toJson());

class GetResidentProfileModel {
    bool? status;
    Data? data;

    GetResidentProfileModel({
        this.status,
        this.data,
    });

    factory GetResidentProfileModel.fromJson(Map<String, dynamic> json) => GetResidentProfileModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? name;
    String? email;
    String? role;
    String? phone;
    String? avatar;
    String? status;
    String? subscriptionStatus;
    dynamic fcmToken;
    dynamic emailVerifiedAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? unitId;
    String? avatarUrl;
    String? subtitle;
    String? roleDisplay;
    String? statusBadge;
    String? statusPill;
    CurrentAccess? currentAccess;
    String? communityName;
    String? building;
    String? apartment;
    String? unitNumber;
    MyResidence? myResidence;
    Community? community;
    String? residentType;
    bool? isHouseOwner;
    MmcStatus? mmcStatus;

    Data({
        this.id,
        this.name,
        this.email,
        this.role,
        this.phone,
        this.avatar,
        this.status,
        this.subscriptionStatus,
        this.fcmToken,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.unitId,
        this.avatarUrl,
        this.subtitle,
        this.roleDisplay,
        this.statusBadge,
        this.statusPill,
        this.currentAccess,
        this.communityName,
        this.building,
        this.apartment,
        this.unitNumber,
        this.myResidence,
        this.community,
        this.residentType,
        this.isHouseOwner,
        this.mmcStatus,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        phone: json["phone"],
        avatar: json["avatar"],
        status: json["status"],
        subscriptionStatus: json["subscription_status"],
        fcmToken: json["fcm_token"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        unitId: json["unit_id"],
        avatarUrl: json["avatar_url"],
        subtitle: json["subtitle"],
        roleDisplay: json["role_display"],
        statusBadge: json["status_badge"],
        statusPill: json["status_pill"],
        currentAccess: json["current_access"] == null ? null : CurrentAccess.fromJson(json["current_access"]),
        communityName: json["community_name"],
        building: json["building"],
        apartment: json["apartment"],
        unitNumber: json["unit_number"],
        myResidence: json["my_residence"] == null ? null : MyResidence.fromJson(json["my_residence"]),
        community: json["community"] == null ? null : Community.fromJson(json["community"]),
        residentType: json["resident_type"],
        isHouseOwner: json["is_house_owner"],
        mmcStatus: json["mmc_status"] == null ? null : MmcStatus.fromJson(json["mmc_status"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "phone": phone,
        "avatar": avatar,
        "status": status,
        "subscription_status": subscriptionStatus,
        "fcm_token": fcmToken,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "unit_id": unitId,
        "avatar_url": avatarUrl,
        "subtitle": subtitle,
        "role_display": roleDisplay,
        "status_badge": statusBadge,
        "status_pill": statusPill,
        "current_access": currentAccess?.toJson(),
        "community_name": communityName,
        "building": building,
        "apartment": apartment,
        "unit_number": unitNumber,
        "my_residence": myResidence?.toJson(),
        "community": community?.toJson(),
        "resident_type": residentType,
        "is_house_owner": isHouseOwner,
        "mmc_status": mmcStatus?.toJson(),
    };
}

class Community {
    String? name;
    MmcStatus? mmcStatus;

    Community({
        this.name,
        this.mmcStatus,
    });

    factory Community.fromJson(Map<String, dynamic> json) => Community(
        name: json["name"],
        mmcStatus: json["mmc_status"] == null ? null : MmcStatus.fromJson(json["mmc_status"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "mmc_status": mmcStatus?.toJson(),
    };
}

class MmcStatus {
    bool? isApplicable;
    String? badge;
    String? badgeColor;
    int? amount;
    String? notApplicableReason;

    MmcStatus({
        this.isApplicable,
        this.badge,
        this.badgeColor,
        this.amount,
        this.notApplicableReason,
    });

    factory MmcStatus.fromJson(Map<String, dynamic> json) => MmcStatus(
        isApplicable: json["is_applicable"],
        badge: json["badge"],
        badgeColor: json["badge_color"],
        amount: json["amount"],
        notApplicableReason: json["not_applicable_reason"],
    );

    Map<String, dynamic> toJson() => {
        "is_applicable": isApplicable,
        "badge": badge,
        "badge_color": badgeColor,
        "amount": amount,
        "not_applicable_reason": notApplicableReason,
    };
}

class CurrentAccess {
    String? accountStatus;
    String? status;
    String? community;
    String? property;
    String? building;
    String? apartment;
    String? unitNumber;
    String? role;

    CurrentAccess({
        this.accountStatus,
        this.status,
        this.community,
        this.property,
        this.building,
        this.apartment,
        this.unitNumber,
        this.role,
    });

    factory CurrentAccess.fromJson(Map<String, dynamic> json) => CurrentAccess(
        accountStatus: json["account_status"],
        status: json["status"],
        community: json["community"],
        property: json["property"],
        building: json["building"],
        apartment: json["apartment"],
        unitNumber: json["unit_number"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "account_status": accountStatus,
        "status": status,
        "community": community,
        "property": property,
        "building": building,
        "apartment": apartment,
        "unit_number": unitNumber,
        "role": role,
    };
}

class MyResidence {
    String? residentType;
    bool? isHouseOwner;
    String? tag;
    String? complexName;
    String? unitBadge;
    String? residentTypeBadge;
    String? residentTypeKey;

    MyResidence({
        this.residentType,
        this.isHouseOwner,
        this.tag,
        this.complexName,
        this.unitBadge,
        this.residentTypeBadge,
        this.residentTypeKey,
    });

    factory MyResidence.fromJson(Map<String, dynamic> json) => MyResidence(
        residentType: json["resident_type"],
        isHouseOwner: json["is_house_owner"],
        tag: json["tag"],
        complexName: json["complex_name"],
        unitBadge: json["unit_badge"],
        residentTypeBadge: json["resident_type_badge"],
        residentTypeKey: json["resident_type_key"],
    );

    Map<String, dynamic> toJson() => {
        "resident_type": residentType,
        "is_house_owner": isHouseOwner,
        "tag": tag,
        "complex_name": complexName,
        "unit_badge": unitBadge,
        "resident_type_badge": residentTypeBadge,
        "resident_type_key": residentTypeKey,
    };
}
