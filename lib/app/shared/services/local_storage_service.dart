import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Completer<SharedPreferences> instance = Completer<SharedPreferences>();

  LocalStorageService() {
    _initLocalStorage();
  }

  _initLocalStorage() async {
    if (BlocProvider.isTest) {
      SharedPreferences.setMockInitialValues({});
    }

    SharedPreferences share = await SharedPreferences.getInstance();

    if (!instance.isCompleted) instance.complete(share);
  }

  Future<bool> put(String key, Map<String, dynamic> json) async {
    try {
      SharedPreferences share = await instance.future;
      share.setString(key, jsonEncode(json));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future get<S>(String key, {S Function(Map) construct}) async {
    try {
      SharedPreferences share = await instance.future;
      String value = share.getString(key);
      Map<String, dynamic> json = jsonDecode(value);
      if (construct == null) {
        return json;
      } else {
        return construct(json);
      }
    } catch (e) {
      return null;
    }
  }

  Future remove(String key) async {
    SharedPreferences share = await instance.future;
    return share.remove(key);
  }

  Future removeAll() async {
    SharedPreferences share = await instance.future;
    return share.clear();
  }

  //statics
  static String TOKEN = "TOKEN";
  static String USER = "USER";
}
