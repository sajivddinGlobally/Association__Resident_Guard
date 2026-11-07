// To parse this JSON data, do
//
//     final forgotPassBodyModel = forgotPassBodyModelFromJson(jsonString);

import 'dart:convert';

ForgotPassBodyModel forgotPassBodyModelFromJson(String str) => ForgotPassBodyModel.fromJson(json.decode(str));

String forgotPassBodyModelToJson(ForgotPassBodyModel data) => json.encode(data.toJson());

class ForgotPassBodyModel {
    String? email;

    ForgotPassBodyModel({
        this.email,
    });

    factory ForgotPassBodyModel.fromJson(Map<String, dynamic> json) => ForgotPassBodyModel(
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
    };
}
