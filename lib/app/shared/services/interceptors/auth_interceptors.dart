import 'package:dio/dio.dart';
import 'package:teddy_todo/app/shared/models/token_model.dart';
import 'package:teddy_todo/app/shared/services/local_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorageService _service;

  AuthInterceptor(this._service);

  @override
  onRequest(RequestOptions options) async {
    TokenModel tokenModel = await _service.get<TokenModel>(LocalStorageService.TOKEN,
        construct: (v) => TokenModel.fromJson(v));
    if (!options.headers.containsKey("Authorization") && tokenModel != null) {
      options.headers["Authorization"] = "Bearer ${tokenModel.accessToken}";
    }
    return options;
  }

  @override
  onResponse(Response response) async {
    return response;
  }

  @override
  onError(DioError e) async {
    return e;
  }
}
