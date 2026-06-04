import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  final _storage=const FlutterSecureStorage();

  static const String _keyPin = "user_pin";

  // Save token
  Future<String?> savePin(String token) async {
    await _storage.write(key: _keyPin, value: token);
  }

  // Get token
  Future<String?> getPin() async {
    return await _storage.read(key: _keyPin);
  }


  // Delete specific key
  Future<void> delete() async {
    await _storage.delete(key: _keyPin);
  }
}