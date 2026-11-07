// To parse this JSON data, do
//
//     final residentParcelRespondBodyModel = residentParcelRespondBodyModelFromJson(jsonString);

import 'dart:convert';

ResidentParcelRespondBodyModel residentParcelRespondBodyModelFromJson(
  String str,
) => ResidentParcelRespondBodyModel.fromJson(json.decode(str));

String residentParcelRespondBodyModelToJson(
  ResidentParcelRespondBodyModel data,
) => json.encode(data.toJson());

class ResidentParcelRespondBodyModel {
  String? action;
  String? deliveryMode;
  String? remarks;

  ResidentParcelRespondBodyModel({
    this.action,
    this.deliveryMode,
    this.remarks,
  });

  factory ResidentParcelRespondBodyModel.fromJson(Map<String, dynamic> json) =>
      ResidentParcelRespondBodyModel(
        action: json["action"],
        deliveryMode: json["delivery_mode"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
    "action": action,
    "delivery_mode": deliveryMode,
    "remarks": remarks,
  };
}
