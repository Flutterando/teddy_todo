import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teddy_todo/app/shared/models/token_model.dart';
import 'package:teddy_todo/app/shared/services/local_storage_service.dart';

void main() {
  LocalStorageService service;

  setUpAll(() {
    BlocProvider.isTest = true;
    WidgetsFlutterBinding.ensureInitialized();
    service = LocalStorageService();
  });

  group('LocalStorageService Test', () {
    test("init instance", () {
      expect(service, isInstanceOf<LocalStorageService>());
      expect(service.instance.future, completion(isInstanceOf<SharedPreferences>()));
    });
    test("set value in dataBase", () {
      var isPut = service.put(
          LocalStorageService.TOKEN,
          TokenModel(accessToken: "jacob", expiresIn: 36000, tokenType: "jwt")
              .toJson());
      expect(isPut, completion(true));
    });
    test("get value in dataBase", () async {
      TokenModel isGet = await service.get(LocalStorageService.TOKEN,
          construct: (data) => TokenModel.fromJson(data));
      expect(isGet, isInstanceOf<TokenModel>());
    });

    test("Remove value", () async {
      await service.put(
          LocalStorageService.TOKEN,
          TokenModel(accessToken: "jacob", expiresIn: 36000, tokenType: "jwt")
              .toJson());
      await service.remove(LocalStorageService.TOKEN);
      expect(await service.get(LocalStorageService.TOKEN), null);
    });

    test("Remove all", () async {
      await service.put(
          LocalStorageService.TOKEN,
          TokenModel(accessToken: "jacob", expiresIn: 36000, tokenType: "jwt")
              .toJson());
      await service.put("Teste", {"Teste" : "Teste"});
      await service.removeAll();
      expect(await service.get(LocalStorageService.TOKEN), null);
      expect(await service.get("Teste"), null);
    });
  });

}