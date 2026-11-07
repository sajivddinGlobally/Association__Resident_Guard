import 'dart:convert';

RecentVehicleSearchesResModel recentVehicleSearchesResModelFromJson(
        String str) =>
    RecentVehicleSearchesResModel.fromJson(json.decode(str));

String recentVehicleSearchesResModelToJson(
        RecentVehicleSearchesResModel data) =>
    json.encode(data.toJson());

class RecentVehicleSearchesResModel {
  bool? status;
  String? message;
  List<RecentVehicleItem>? data;

  RecentVehicleSearchesResModel({
    this.status,
    this.message,
    this.data,
  });

  factory RecentVehicleSearchesResModel.fromJson(Map<String, dynamic> json) {
    List<RecentVehicleItem> list = [];
    if (json["data"] is List) {
      list = (json["data"] as List)
          .map((x) =>
              RecentVehicleItem.fromJson(x is Map<String, dynamic> ? x : {}))
          .toList();
    }
    return RecentVehicleSearchesResModel(
      status: json["status"] is bool
          ? json["status"]
          : (json["status"] == 1 || json["status"] == "true"),
      message: json["message"]?.toString(),
      data: list,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class RecentVehicleItem {
  dynamic id;
  String? vehicleNumber;
  String? ownerName;
  String? flatNumber;
  String? vehicleType;
  String? searchedAt;

  RecentVehicleItem({
    this.id,
    this.vehicleNumber,
    this.ownerName,
    this.flatNumber,
    this.vehicleType,
    this.searchedAt,
  });

  factory RecentVehicleItem.fromJson(Map<String, dynamic> json) =>
      RecentVehicleItem(
        id: json["id"],
        vehicleNumber: json["vehicle_number"] ?? json["vehicle"] ?? json["plate_number"],
        ownerName: json["owner_name"] ?? json["name"],
        flatNumber: json["flat_number"] ?? json["flat"] ?? json["apartment"],
        vehicleType: json["vehicle_type"] ?? json["type"] ?? "Car",
        searchedAt: json["searched_at"] ?? json["time"] ?? json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_number": vehicleNumber,
        "owner_name": ownerName,
        "flat_number": flatNumber,
        "vehicle_type": vehicleType,
        "searched_at": searchedAt,
      };
}
