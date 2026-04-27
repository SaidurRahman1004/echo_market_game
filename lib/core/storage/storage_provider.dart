import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_storage_service.dart';

// Root provider holding the LocalStorage interface. It has no value initially (Throws exception)
// It is intentionally overridden in main.dart exactly once initialization happens before rendering
final localStorageProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError(
    'localStorageProvider must be overridden in main.dart initialization loop',
  );
});
