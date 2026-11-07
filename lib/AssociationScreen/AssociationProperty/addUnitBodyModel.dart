// // To parse this JSON data, do
// //
// //     final addUnitBodyModel = addUnitBodyModelFromJson(jsonString);

// import 'dart:convert';

// AddUnitBodyModel addUnitBodyModelFromJson(String str) => AddUnitBodyModel.fromJson(json.decode(str));

// String addUnitBodyModelToJson(AddUnitBodyModel data) => json.encode(data.toJson());

// class AddUnitBodyModel {
//     String? unitNumber;
//     String? location;
//     String? floor;
//     String? area;
//     String? bedrooms;
//     String? block;

//     AddUnitBodyModel({
//         this.unitNumber,
//         this.location,
//         this.floor,
//         this.area,
//         this.bedrooms,
//         this.block,
//     });

//     factory AddUnitBodyModel.fromJson(Map<String, dynamic> json) => AddUnitBodyModel(
//         unitNumber: json["unit_number"],
//         location: json["location"],
//         floor: json["floor"],
//         area: json["area"],
//         bedrooms: json["bedrooms"],
//         block: json["block"],
//     );

//     Map<String, dynamic> toJson() => {
//         "unit_number": unitNumber,
//         "location": location,
//         "floor": floor,
//         "area": area,
//         "bedrooms": bedrooms,
//         "block": block,
//     };
// }

// To parse this JSON data, do
//
//     final addUnitBodyModel = addUnitBodyModelFromJson(jsonString);

import 'dart:convert';

AddUnitBodyModel addUnitBodyModelFromJson(String str) => AddUnitBodyModel.fromJson(json.decode(str));

String addUnitBodyModelToJson(AddUnitBodyModel data) => json.encode(data.toJson());

class AddUnitBodyModel {
    String? unitNumber;
    String? block; // "Block A", "Block B" ... (complex ke blocks mein se)
    String? location;
    String? floor;
    String? area;
    String? bedrooms;

    AddUnitBodyModel({
        this.unitNumber,
        this.block,
        this.location,
        this.floor,
        this.area,
        this.bedrooms,
    });

    factory AddUnitBodyModel.fromJson(Map<String, dynamic> json) => AddUnitBodyModel(
        unitNumber: json["unit_number"],
        block: json["block"],
        location: json["location"],
        floor: json["floor"],
        area: json["area"],
        bedrooms: json["bedrooms"],
    );

    Map<String, dynamic> toJson() => {
        "unit_number": unitNumber,
        "block": block,
        "location": location,
        "floor": floor,
        "area": area,
        "bedrooms": bedrooms,
    };
}
