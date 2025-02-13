// To parse this JSON data, do
//
//     final proFile = proFileFromJson(jsonString);

import 'dart:convert';
import 'package:flutter_github_client/models/cache_config.dart';
import 'package:flutter_github_client/models/user.dart';

Profile proFileFromJson(String str) => Profile.fromJson(json.decode(str));

String proFileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  User? user;
  CacheConfig? cache;
  String? token;
  int? theme;
  String? lastLogin;
  String? locale;

  Profile({
    this.user,
    this.token = "",
    this.theme = 0,
    this.cache = const CacheConfig(),
    this.lastLogin = "",
    this.locale = "",
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        user: json["user?"],
        token: json["token?"],
        theme: json["theme"],
        cache: json["cache?"],
        lastLogin: json["lastLogin?"],
        locale: json["locale?"],
      );

  Map<String, dynamic> toJson() => {
        "user?": user,
        "token?": token,
        "theme": theme,
        "cache?": cache,
        "lastLogin?": lastLogin,
        "locale?": locale,
      };
}
