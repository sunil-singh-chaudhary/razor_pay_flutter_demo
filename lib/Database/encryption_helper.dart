import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncryptionHelper {
  static Future<String> encrypt(String value) async {
    final iv = IV.fromSecureRandom(16);
    final encryptionKey = await getEncryptionKey();
    final encrypter = Encrypter(AES(encryptionKey));
    final encrypted = encrypter.encrypt(value, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  static Future<String> decrypt(String value) async {
    final encryptionKey = await getEncryptionKey();
    final parts = value.split(':');
    final iv = IV.fromBase64(parts[0]);
    final encrypted = Encrypted.fromBase64(parts[1]);
    final encrypter = Encrypter(AES(encryptionKey));
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

  static Future<Key> getEncryptionKey() async {
    await dotenv.load();
    final encryptionKey = dotenv.env['DB_SECRET_KEY']!;
    return Key.fromUtf8(encryptionKey);
  }
}
