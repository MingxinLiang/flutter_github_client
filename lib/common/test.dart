import 'package:dio/dio.dart';
import 'dart:io';

void main() async {
  Dio dio = Dio();

  // 自定义 onHttpClientCreate
  dio.httpClientAdapter.onHttpClientCreate = (client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      // 允许所有证书（用于跳过 SSL 验证）
      print('Allowing all certificates');
      return true; // 跳过证书验证
    };
    return client;
  };

  try {
    final response = await dio.get('https://example.com');
    print(response.data);
  } catch (e) {
    print('Error: $e');
  }
}
