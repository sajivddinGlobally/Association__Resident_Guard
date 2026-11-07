// To parse this JSON data, do
//
//     final changePasswordBodyModel = changePasswordBodyModelFromJson(jsonString);

import 'dart:convert';

ChangePasswordBodyModel changePasswordBodyModelFromJson(String str) => ChangePasswordBodyModel.fromJson(json.decode(str));

String changePasswordBodyModelToJson(ChangePasswordBodyModel data) => json.encode(data.toJson());

class ChangePasswordBodyModel {
    String? currentPassword;
    String? newPassword;
    String? confirmNewPassword;

    ChangePasswordBodyModel({
        this.currentPassword,
        this.newPassword,
        this.confirmNewPassword,
    });

    factory ChangePasswordBodyModel.fromJson(Map<String, dynamic> json) => ChangePasswordBodyModel(
        currentPassword: json["current_password"],
        newPassword: json["new_password"],
        confirmNewPassword: json["confirm_new_password"],
    );

    Map<String, dynamic> toJson() => {
        "current_password": currentPassword,
        "new_password": newPassword,
        "confirm_new_password": confirmNewPassword,
    };
}
