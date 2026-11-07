import 'dart:convert';

UpdateTicketStatusBodyModel updateTicketStatusBodyModelFromJson(String str) =>
    UpdateTicketStatusBodyModel.fromJson(json.decode(str));

String updateTicketStatusBodyModelToJson(UpdateTicketStatusBodyModel data) =>
    json.encode(data.toJson());

class UpdateTicketStatusBodyModel {
  final String status;

  UpdateTicketStatusBodyModel({
    required this.status,
  });

  factory UpdateTicketStatusBodyModel.fromJson(Map<String, dynamic> json) =>
      UpdateTicketStatusBodyModel(
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
