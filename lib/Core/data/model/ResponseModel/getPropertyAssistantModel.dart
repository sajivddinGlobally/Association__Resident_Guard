// To parse this JSON data, do
//
//     final getPropertyAssistantModel = getPropertyAssistantModelFromJson(jsonString);

import 'dart:convert';

GetPropertyAssistantModel getPropertyAssistantModelFromJson(String str) => GetPropertyAssistantModel.fromJson(json.decode(str));

String getPropertyAssistantModelToJson(GetPropertyAssistantModel data) => json.encode(data.toJson());

class GetPropertyAssistantModel {
    bool? status;
    Data? data;

    GetPropertyAssistantModel({
        this.status,
        this.data,
    });

    factory GetPropertyAssistantModel.fromJson(Map<String, dynamic> json) => GetPropertyAssistantModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    Assistant? assistant;
    Property? property;
    List<String>? suggestedPrompts;
    List<RecentHistory>? recentHistory;

    Data({
        this.assistant,
        this.property,
        this.suggestedPrompts,
        this.recentHistory,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        assistant: json["assistant"] == null ? null : Assistant.fromJson(json["assistant"]),
        property: json["property"] == null ? null : Property.fromJson(json["property"]),
        suggestedPrompts: json["suggested_prompts"] == null ? [] : List<String>.from(json["suggested_prompts"]!.map((x) => x)),
        recentHistory: json["recent_history"] == null ? [] : List<RecentHistory>.from(json["recent_history"]!.map((x) => RecentHistory.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "assistant": assistant?.toJson(),
        "property": property?.toJson(),
        "suggested_prompts": suggestedPrompts == null ? [] : List<dynamic>.from(suggestedPrompts!.map((x) => x)),
        "recent_history": recentHistory == null ? [] : List<dynamic>.from(recentHistory!.map((x) => x.toJson())),
    };
}

class Assistant {
    String? name;
    String? type;
    String? status;
    String? welcomeMessage;

    Assistant({
        this.name,
        this.type,
        this.status,
        this.welcomeMessage,
    });

    factory Assistant.fromJson(Map<String, dynamic> json) => Assistant(
        name: json["name"],
        type: json["type"],
        status: json["status"],
        welcomeMessage: json["welcome_message"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "status": status,
        "welcome_message": welcomeMessage,
    };
}

class Property {
    int? id;
    String? name;
    String? complexName;
    String? status;
    String? package;

    Property({
        this.id,
        this.name,
        this.complexName,
        this.status,
        this.package,
    });

    factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json["id"],
        name: json["name"],
        complexName: json["complex_name"],
        status: json["status"],
        package: json["package"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "complex_name": complexName,
        "status": status,
        "package": package,
    };
}

class RecentHistory {
    int? id;
    int? userId;
    int? propertyId;
    String? query;
    String? aiResponse;
    String? type;
    DateTime? createdAt;
    DateTime? updatedAt;

    RecentHistory({
        this.id,
        this.userId,
        this.propertyId,
        this.query,
        this.aiResponse,
        this.type,
        this.createdAt,
        this.updatedAt,
    });

    factory RecentHistory.fromJson(Map<String, dynamic> json) => RecentHistory(
        id: json["id"],
        userId: json["user_id"],
        propertyId: json["property_id"],
        query: json["query"],
        aiResponse: json["ai_response"],
        type: json["type"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "property_id": propertyId,
        "query": query,
        "ai_response": aiResponse,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
