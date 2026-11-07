// To parse this JSON data, do
//
//     final getUnAssignedResModel = getUnAssignedResModelFromJson(jsonString);

import 'dart:convert';

GetUnAssignedResModel getUnAssignedResModelFromJson(String str) => GetUnAssignedResModel.fromJson(json.decode(str));

String getUnAssignedResModelToJson(GetUnAssignedResModel data) => json.encode(data.toJson());

class GetUnAssignedResModel {
    bool? status;
    String? message;
    List<Datum>? data;

    GetUnAssignedResModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetUnAssignedResModel.fromJson(Map<String, dynamic> json) => GetUnAssignedResModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? name;
    String? address;
    int? totalUnits;
    List<String>? facilities;
    dynamic associationHeadId;
    dynamic caretaker;

    Datum({
        this.id,
        this.name,
        this.address,
        this.totalUnits,
        this.facilities,
        this.associationHeadId,
        this.caretaker,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        totalUnits: json["total_units"],
        facilities: json["facilities"] == null ? [] : List<String>.from(json["facilities"]!.map((x) => x)),
        associationHeadId: json["association_head_id"],
        caretaker: json["caretaker"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "total_units": totalUnits,
        "facilities": facilities == null ? [] : List<dynamic>.from(facilities!.map((x) => x)),
        "association_head_id": associationHeadId,
        "caretaker": caretaker,
    };
}
