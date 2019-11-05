import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class CredentialsService {

  String returnCredencial(String email, String pass) {
    String credentials = "$email:${_encryptPass(pass)}";
    return "${base64Encode(credentials.codeUnits)}";
  }

  String _encryptPass(String plainText) {
    final key = Key.fromUtf8('dw5f6deef4dwqfeIJFOfjeijOFJiefjo');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }
}
