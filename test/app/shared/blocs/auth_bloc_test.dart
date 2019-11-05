import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';
import 'package:mockito/mockito.dart';

import 'package:teddy_todo/app/shared/blocs/auth_bloc.dart';
import 'package:teddy_todo/app/app_module.dart';
import 'package:teddy_todo/app/shared/constants/api_constant.dart';
import 'package:teddy_todo/app/shared/models/token_model.dart';
import 'package:teddy_todo/app/shared/models/user_model.dart';
import 'package:teddy_todo/app/shared/services/custom_dio.dart';
import 'package:teddy_todo/app/shared/services/local_storage_service.dart';

import '../../../mock.dart';

void main() {
  initModule(AppModule(), changeDependencies: [
    Dependency((i) => MockClient() as CustomDio),
  ]);

  AuthBloc bloc;
  MockClient client;
  WidgetsFlutterBinding.ensureInitialized();

  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{
        LocalStorageService.TOKEN:
            jsonEncode(TokenModel(accessToken: "fdsfsfs").toJson()),
        LocalStorageService.USER: jsonEncode(UserModel(
                email: "jacob@moura.com.br",
                id: 1,
                githubUsername: null,
                name: "Jacob Moura")
            .toJson()),
      }; // set initial values here if desired
    }
    return null;
  });

  setUpAll(() {
    bloc = AppModule.to.bloc();
    client = AppModule.to.get<CustomDio>();
  });

  group('AuthBloc Test', () {
    test("First Test", () {
      expect(bloc, isInstanceOf<AuthBloc>());
    });

    test("Get token from server and save", () async {
      when(client.get(URL_LOGIN, options: anyNamed("options"))).thenAnswer(
        (_) async => Response(
            data: {'access_token': 'fdsfsfs', "expires_in": 86400},
            statusCode: 200),
      );
      expect(bloc.login("user@flutterando.com.br", "123"), completion(true));
    });

    test("Save token in local storage", () async {
      var token = TokenModel(accessToken: "fdsfsfs");
      expect(bloc.saveToken(token), completion(true));
    });

    test("get token in local storage", () async {
      TokenModel tokenR = await bloc.loadToken();
      expect(tokenR, isInstanceOf<TokenModel>());
    });

    test("Refresh Token", () {
      when(client.get(URL_LOGIN, options: anyNamed("options"))).thenAnswer(
          (_) async => Response(
              data: {'access_token': 'fdsfsfs', "expires_in": 86400},
              statusCode: 200));
      bloc.refreshToken();
      expect(bloc.refreshToken(), completion(isInstanceOf<TokenModel>()));
    });

    test("get user", () async {
      when(client.get(URL_GET_ME)).thenAnswer((_) async {
        return Response(
          data: {
            'email': 'user@flutterando.com',
            "name": "User",
            "github_username": null,
            "id": 1
          },
          statusCode: 200,
        );
      });
      await bloc.getUser();
      expect(bloc.userOut, emits(isInstanceOf<UserModel>()));
    });

    test("get user local", () async {
      expect(bloc.userOut, emits(isInstanceOf<UserModel>()));
    });

    test("logoff", () async {
      await bloc.logoff();
      expect(bloc.userOut, emits(null));
      expect(bloc.isLogin, emits(false));
    });

    test("login flux with distinct", () async {
      expect(bloc.isLogin, emitsInOrder([false, true, false]));
      bloc.loginFlux.add(true);
      bloc.loginFlux.add(true);
      bloc.loginFlux.add(false);
      bloc.loginFlux.add(false);
    });
  });
}
