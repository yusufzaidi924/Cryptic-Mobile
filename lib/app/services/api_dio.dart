import 'dart:collection';
import 'package:dio/dio.dart';

enum Method { post, put, patch, delete, get }

const int PAGE_SIZE = 20;

Map<String, dynamic> pageParams(int page, int pageSize,
    {Map<String, dynamic>? params}) {
  if (params != null) {
    return params..addAll({"page": page, "limit": pageSize});
  }
  return {"page": page, "limit": pageSize};
}

bool isDialogOpen = false;

class Api {
  final dio = Dio();

  Future<Response> request(
    url,
    Method method, {
    body,
    Map<String, dynamic>? params,
    useIDToken = true,
    headersOverwrite,
    customContentType,
    Map<String, dynamic>? customHeader,
    Map<String, dynamic>? headerAddition,
    Function(int, int)? onSendProgress,
    Options? cacheOptions,
    bool addLocaleToHeader = false,
  }) async {
    Map headers = {
      // 'cache-control': 'cache',
      // 'Content-Type': customContentType ?? 'application/json',
      // 'Connection': 'keep-alive'
    };

    var combinedMap = headers;
    if (headersOverwrite != null) {
      var mapList = [headers, headersOverwrite];
      combinedMap = mapList.reduce((map1, map2) => map1..addAll(map2));
    }
    Map<String, dynamic> header = customHeader ?? HashMap.from(combinedMap);
    if (headerAddition != null) {
      header.addAll(headerAddition);
    }
    try {
      if (method == Method.post) {
        return await dio.post(url,
            data: body,
            options: Options(
              headers: header,
            ),
            queryParameters: params,
            onSendProgress: onSendProgress);
      } else if (method == Method.put) {
        return await dio.put(
          url,
          data: body,
          options: Options(headers: header),
          queryParameters: params,
          onSendProgress: onSendProgress,
        );
      } else if (method == Method.patch) {
        return await dio.patch(url,
            data: body,
            options: Options(headers: header),
            queryParameters: params);
      } else if (method == Method.delete) {
        return await dio.delete(url,
            options: Options(headers: header),
            data: body,
            queryParameters: params);
      }

      return await dio.get(url,
          options: cacheOptions != null
              ? cacheOptions.copyWith(headers: header)
              : Options(headers: header),
          queryParameters: params);
    } catch (e) {
      print("📕 error at api: $url");

      rethrow;
    }
  }
}
