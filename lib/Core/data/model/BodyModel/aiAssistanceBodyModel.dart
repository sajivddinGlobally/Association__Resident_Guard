// To parse this JSON data, do
//
//     final aiAssistanceBodyModel = aiAssistanceBodyModelFromJson(jsonString);

import 'dart:convert';

AiAssistanceBodyModel aiAssistanceBodyModelFromJson(String str) => AiAssistanceBodyModel.fromJson(json.decode(str));

String aiAssistanceBodyModelToJson(AiAssistanceBodyModel data) => json.encode(data.toJson());

class AiAssistanceBodyModel {
    String? query;

    AiAssistanceBodyModel({
        this.query,
    });

    factory AiAssistanceBodyModel.fromJson(Map<String, dynamic> json) => AiAssistanceBodyModel(
        query: json["query"],
    );

    Map<String, dynamic> toJson() => {
        "query": query,
    };
}
