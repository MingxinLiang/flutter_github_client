import "dart:async";
import "dart:convert";
import "dart:io";
//import "package:dio/adapter.dart";
import "package:dio/dio.dart";
import 'package:dio/src/adapters/io_adapter.dart';
import "package:flutter/material.dart";
import 'package:flutter_github_client/common/global.dart';

class Git {
  BuildContext? context;
  late Options _options;
  static Dio dio =
      Dio(BaseOptions(baseUrl: 'https://api.github.com/', headers: {
    HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
        "application/vnd.github.symmetra-preview+json",
  }));

  // 网络请求过程中，可能会用到context信息
  Git([this.context]) {
    _options = Options(extra: {"context": context});
  }

  static void init() {
    // 缓存插件
    dio.interceptors.add(Global.netCache);
    // 设置用户token（可能为null，代表未登录）
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;

    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    if (!Global.isRelease) {
      // 使用 onHttpClientCreate 自定义 HttpClient
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        // client.findProxy = (uri) {
        //   return 'PROXY 192.168.50.154:8888';
        // };
        //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return null;
      };
    }
  }
}
