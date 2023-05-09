// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:core';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class SecureStorageHelper {
  static String? _dbKeyKey;

  static Future<String> getApiKey() async {
    const storage = FlutterSecureStorage();
    await dotenv.load();
    _dbKeyKey = dotenv.env['DB_SECRET_KEY'];

    String? apiKey = await storage.read(key: _dbKeyKey!);
    if (apiKey == null) {
      apiKey = await generateAndSaveKey();
      print('first time key --> $apiKey');
    }
    print('ALready have key --> $apiKey');

    return apiKey;
  }

  static Future<String> generateAndSaveKey() async {
    String newKey = Keys.generateKey();
    print('key $newKey');
    String hashedKey = crypto.sha256.convert(utf8.encode(newKey)).toString();
    const storage = FlutterSecureStorage();
    await storage.write(
        key: _dbKeyKey!, value: hashedKey); //key value here value is in sha256

    return hashedKey;
  }
}

class Keys {
  static String generateKey() {
    String key = "";
    for (int i = 0; i < 32; i++) {
      key += String.fromCharCode((97 + i % 26));
    }
    return key;
  }
}
