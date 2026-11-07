// To parse this JSON data, do
//
//     final loginBodyModel = loginBodyModelFromJson(jsonString);

import 'dart:convert';

LoginBodyModel loginBodyModelFromJson(String str) => LoginBodyModel.fromJson(json.decode(str));

String loginBodyModelToJson(LoginBodyModel data) => json.encode(data.toJson());

class LoginBodyModel {
    String? login;
    String? password;
    String? role;

    LoginBodyModel({
        this.login,
        this.password,
        this.role,
    });

    factory LoginBodyModel.fromJson(Map<String, dynamic> json) => LoginBodyModel(
        login: json["login"],
        password: json["password"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "login": login,
        "password": password,
        "role": role,
    };
}
