import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class _AppStorage {
  final _storage = const FlutterSecureStorage();

  getValue(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (error) {
      print(error.toString());
    }
  }

  getAll() async {
    try {
      return await _storage.readAll();
    } catch (error) {
      print(error.toString());
    }
  }

  deleteValue(String key) async {
    try {
      await _storage.delete(key: key);
      print('deleted $key');
    } catch (error) {
      print(error.toString());
    }
  }

  clearAll() async {
    try {
      await _storage.deleteAll();
      print('deleted all');
    } catch (error) {
      print(error.toString());
    }
  }

  write(String key, dynamic value) async {
    try {
      final storedValue = await getValue(key);
      if (storedValue != null) {
        throw Exception('value already exists for $key, deleting it first');
      }
      await _storage.write(key: key, value: value.toString());
    } catch (error) {
      print(error.toString());
    }
  }
}

final appStorage = _AppStorage();
