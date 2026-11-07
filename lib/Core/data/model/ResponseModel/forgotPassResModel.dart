// To parse this JSON data, do
//
//     final forgotPassResModel = forgotPassResModelFromJson(jsonString);

import 'dart:convert';

ForgotPassResModel forgotPassResModelFromJson(String str) => ForgotPassResModel.fromJson(json.decode(str));

String forgotPassResModelToJson(ForgotPassResModel data) => json.encode(data.toJson());

class ForgotPassResModel {
    bool? status;
    String? message;
    Data? data;

    ForgotPassResModel({
        this.status,
        this.message,
        this.data,
    });

    factory ForgotPassResModel.fromJson(Map<String, dynamic> json) => ForgotPassResModel(
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
    String? email;
    bool? otpSent;
    String? demoOtp;

    Data({
        this.email,
        this.otpSent,
        this.demoOtp,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        email: json["email"],
        otpSent: json["otp_sent"],
        demoOtp: json["demo_otp"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "otp_sent": otpSent,
        "demo_otp": demoOtp,
    };
}
