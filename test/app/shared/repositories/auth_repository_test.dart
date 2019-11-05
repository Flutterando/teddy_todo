import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bloc_pattern/bloc_pattern_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:teddy_todo/app/app_module.dart';
import 'package:teddy_todo/app/shared/constants/api_constant.dart';
import 'package:teddy_todo/app/shared/models/token_model.dart';
import 'package:teddy_todo/app/shared/models/user_model.dart';

import 'package:teddy_todo/app/shared/repositories/auth_repository.dart';
import 'package:teddy_todo/app/shared/services/custom_dio.dart';

import '../../../mock.dart';

void main() {
  MockClient client;
  AuthRepository repository;

  initModule(AppModule(), changeDependencies: [
    Dependency((i) => MockClient() as CustomDio),
  ]);

  setUp(() {
    repository = AppModule.to.get();
    client = AppModule.to.get<CustomDio>();
  });

  group('AuthRepository Test', () {
    test("First Test", () {
      expect(repository, isInstanceOf<AuthRepository>());
      expect(client, isInstanceOf<MockClient>());
    });

    test('Test Login', () async {
      when(client.get(URL_LOGIN, options: anyNamed("options")))
          .thenAnswer((_) async {
        return Response(
          data: {'access_token': 'fdsfsfs', "expires_in": 3600},
          statusCode: 200,
        );
      });

      TokenModel data = await repository.getToken("credencials");
      expect(data.accessToken, 'fdsfsfs');
      expect(data.credentials, "credencials");
    });

    test("Get user from server", () async {
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
      UserModel user = await repository.getUser();
      expect(user, isInstanceOf<UserModel>());
    });
  });
}
