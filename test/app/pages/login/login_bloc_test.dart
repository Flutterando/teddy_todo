import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';
import 'package:mockito/mockito.dart';
import 'package:teddy_todo/app/app_module.dart';

import 'package:teddy_todo/app/pages/login/login_bloc.dart';
import 'package:teddy_todo/app/pages/login/login_module.dart';
import 'package:teddy_todo/app/shared/constants/api_constant.dart';
import 'package:teddy_todo/app/shared/services/custom_dio.dart';

import '../../../mock.dart';

void main() {
  initModule(AppModule(), changeDependencies: [
    Dependency((i) => MockClient() as CustomDio),
  ]);
  initModule(LoginModule());
  LoginBloc bloc;
  MockClient client;

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    bloc = LoginModule.to.bloc<LoginBloc>();
    client = AppModule.to.get<CustomDio>();
  });

  group('LoginBloc Test', () {
    test("First Test", () {
      expect(bloc, isInstanceOf<LoginBloc>());
    });

    test("Login init", () {
      expect(bloc.loginStatus, emitsInOrder([
        LoginStatus.IDLE,
        LoginStatus.LOADING,
        LoginStatus.GET_USER,
        LoginStatus.SUCCESS,
      ]));

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
      
      when(client.get('$URL_LOGIN', options: anyNamed("options"))).thenAnswer((_) async => Response(data: {
            'access_token': 'fdsfsfs',
            "token_type": "bearer",
            "expires_in": 86400
          }, statusCode: 200));

      bloc.email = "jacob@moura.com.br";
      bloc.pass = "123";
      bloc.login();
      
    });
  });
}
