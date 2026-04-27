import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provides the SharedPreferences instance synchronously (must be initialized in main())
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(),
);

// Re-wrap SharedPreferences into our own interface (Optional but helpful for mocking)
class LocalStorageService {
  final SharedPreferences _prefs;
  LocalStorageService(this._prefs);

  String? getString(String key) => _prefs.getString(key);
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);
  Future<void> clearAll() => _prefs.clear();
}

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService(ref.watch(sharedPreferencesProvider));
});

class SaveRepository {
  final LocalStorageService _storageService;
  static const int currentSaveVersion = 1;

  SaveRepository(this._storageService);

  void save(String key, Map<String, dynamic> data) {
    try {
      final envelope = {'version': currentSaveVersion, 'data': data};
      final jsonString = jsonEncode(envelope);
      _storageService.setString('save_$key', jsonString);
    } catch (e) {
      debugPrint('SaveRepository error saving $key: $e');
    }
  }

  Map<String, dynamic>? load(String key) {
    try {
      final jsonString = _storageService.getString('save_$key');
      if (jsonString == null) return null;

      final envelope = jsonDecode(jsonString) as Map<String, dynamic>;

      // final version = envelope['version'] as int? ?? 1; // Future migration use

      return envelope['data'] as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('SaveRepository error loading $key: $e');
      return null;
    }
  }

  void clearAll() {
    _storageService.clearAll();
  }
}

final saveRepositoryProvider = Provider<SaveRepository>((ref) {
  return SaveRepository(ref.watch(localStorageServiceProvider));
});
