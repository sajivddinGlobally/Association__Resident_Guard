// To parse this JSON data, do
//
//     final verifyOtpResModel = verifyOtpResModelFromJson(jsonString);

import 'dart:convert';

VerifyOtpResModel verifyOtpResModelFromJson(String str) => VerifyOtpResModel.fromJson(json.decode(str));

String verifyOtpResModelToJson(VerifyOtpResModel data) => json.encode(data.toJson());

class VerifyOtpResModel {
    bool? status;
    String? message;
    Data? data;

    VerifyOtpResModel({
        this.status,
        this.message,
        this.data,
    });

    factory VerifyOtpResModel.fromJson(Map<String, dynamic> json) => VerifyOtpResModel(
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
    bool? verified;
    String? resetToken;

    Data({
        this.verified,
        this.resetToken,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        verified: json["verified"],
        resetToken: json["reset_token"],
    );

    Map<String, dynamic> toJson() => {
        "verified": verified,
        "reset_token": resetToken,
    };
}
