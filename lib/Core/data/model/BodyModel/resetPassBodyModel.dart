// To parse this JSON data, do
//
//     final resetPassBodyModel = resetPassBodyModelFromJson(jsonString);

import 'dart:convert';

ResetPassBodyModel resetPassBodyModelFromJson(String str) => ResetPassBodyModel.fromJson(json.decode(str));

String resetPassBodyModelToJson(ResetPassBodyModel data) => json.encode(data.toJson());

class ResetPassBodyModel {
    String? newPassword;
    String? confirmPassword;
    String? email;

    ResetPassBodyModel({
        this.newPassword,
        this.confirmPassword,
        this.email,
    });

    factory ResetPassBodyModel.fromJson(Map<String, dynamic> json) => ResetPassBodyModel(
        newPassword: json["new_password"],
        confirmPassword: json["confirm_password"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "new_password": newPassword,
        "confirm_password": confirmPassword,
        "email": email,
    };
}
