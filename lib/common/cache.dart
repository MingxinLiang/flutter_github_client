import "package:dio/dio.dart";
import "dart:collection";
import "package:flutter/material.dart";
import 'package:flutter_github_client/common/global.dart';

class CacheObject {
  Response? response;
  int? timeStamp;

  CacheObject(this.response)
      : timeStamp = DateTime.now().millisecondsSinceEpoch;

  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response!.realUri.hashCode;
}

class NetCache extends Interceptor {
  // 缓存对象， 保证迭代器顺序和时间一致
  var cache = LinkedHashMap<String, CacheObject>();

  // 发出请求的处理
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!Global.profile.cache!.enable) {
      return handler.next(options);
    }
    // 下拉刷新， 不再使用缓存
    bool refresh = options.extra["refresh"] == true;

    if (refresh) {
      if (options.extra["list"] == true) {
        //若是列表，则只要url中包含当前path的缓存全部删除（简单实现，并不精准）
        cache.remove((key, v) => key.contains(options.path));
      } else {
        // 如果不是列表，则只删除uri相同的缓存
        cache.remove(options.uri.toString());
      }

      return handler.next(options);
    }

    // 使用缓存
    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == "get") {
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      var ob = cache[key];
      if (ob != null) {
        // 判断缓存时间
        if ((DateTime.now().millisecondsSinceEpoch - ob.timeStamp) / 1000 <
            Global.profile.cache!.maxAge) {
          return handler.resolve(ob.response!);
        } else {
          cache.remove(key);
        }
      }
    }

    handler.next(options);
  }

  // 收到请求时候的处理
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (Global.profile.cache!.enable) {
      _saveCache(response);
    }
    handler.next(response);
  }

  _saveCache(Response object) {
    RequestOptions options = object.requestOptions;
    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == "get") {
      // 如果缓存数量超过最大数量限制，则先移除最早的一条记录
      if (cache.length == Global.profile.cache!.maxCount) {
        // ignore: collection_methods_unrelated_type
        cache.remove(cache[cache.keys.first]);
      }
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      cache[key] = CacheObject(object);
    }
  }
}
