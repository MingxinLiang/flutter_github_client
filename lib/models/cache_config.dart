import 'dart:convert';

CacheConfig cacheConfigFromJson(String str) =>
    CacheConfig.fromJson(json.decode(str));

String cacheConfigToJson(CacheConfig data) => json.encode(data.toJson());

class CacheConfig {
  final bool enable;
  final int maxAge;
  final int maxCount;

  const CacheConfig({
    this.enable = true,
    this.maxAge = 1000,
    this.maxCount = 100,
  });

  factory CacheConfig.fromJson(Map<String, dynamic> json) => CacheConfig(
        enable: json["enable"],
        maxAge: json["maxAge"],
        maxCount: json["maxCount"],
      );

  Map<String, dynamic> toJson() => {
        "enable": enable,
        "maxAge": maxAge,
        "maxCount": maxCount,
      };
}
