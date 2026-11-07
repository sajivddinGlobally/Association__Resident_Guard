// To parse this JSON data, do
//
//     final resetPassResModel = resetPassResModelFromJson(jsonString);

import 'dart:convert';

ResetPassResModel resetPassResModelFromJson(String str) => ResetPassResModel.fromJson(json.decode(str));

String resetPassResModelToJson(ResetPassResModel data) => json.encode(data.toJson());

class ResetPassResModel {
    bool? status;
    String? message;
    Data? data;

    ResetPassResModel({
        this.status,
        this.message,
        this.data,
    });

    factory ResetPassResModel.fromJson(Map<String, dynamic> json) => ResetPassResModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    User? user;

    Data({
        this.user,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
    };
}

class User {
    int? id;
    String? name;
    String? email;

    User({
        this.id,
        this.name,
        this.email,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
    };
}
