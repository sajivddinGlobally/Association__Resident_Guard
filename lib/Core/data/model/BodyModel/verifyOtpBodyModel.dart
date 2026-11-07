// To parse this JSON data, do
//
//     final verifyOtpBodyModel = verifyOtpBodyModelFromJson(jsonString);

import 'dart:convert';

VerifyOtpBodyModel verifyOtpBodyModelFromJson(String str) => VerifyOtpBodyModel.fromJson(json.decode(str));

String verifyOtpBodyModelToJson(VerifyOtpBodyModel data) => json.encode(data.toJson());

class VerifyOtpBodyModel {
    String? email;
    String? otp;

    VerifyOtpBodyModel({
        this.email,
        this.otp,
    });

    factory VerifyOtpBodyModel.fromJson(Map<String, dynamic> json) => VerifyOtpBodyModel(
        email: json["email"],
        otp: json["otp"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "otp": otp,
    };
}
