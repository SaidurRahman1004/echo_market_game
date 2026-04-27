import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/save_repository.dart';
import '../models/currency_state.dart';

class CurrencyNotifier extends Notifier<CurrencyState> {
  static const _saveKey = 'save_currency';

  @override
  CurrencyState build() {
    final repo = ref.read(saveRepositoryProvider);
    final data = repo.load(_saveKey);
    return data != null ? CurrencyState.fromJson(data) : const CurrencyState();
  }

  void addRunRewards({int shards = 0, int coins = 0}) {
    final newState = state.copyWith(
      timeShards: state.timeShards + shards,
      echoCoins: state.echoCoins + coins,
    );
    state = newState;
    ref.read(saveRepositoryProvider).save(_saveKey, newState.toJson());
  }

  bool trySpendCoins(int amount) {
    if (amount <= 0) return true;
    if (state.echoCoins < amount) return false;

    // Deduct
    final newState = state.copyWith(echoCoins: state.echoCoins - amount);
    state = newState;
    ref.read(saveRepositoryProvider).save(_saveKey, newState.toJson());
    return true;
  }

  bool trySpendShards(int amount) {
    if (amount <= 0) return true;
    if (state.timeShards < amount) return false;

    // Deduct
    final newState = state.copyWith(timeShards: state.timeShards - amount);
    state = newState;
    ref.read(saveRepositoryProvider).save(_saveKey, newState.toJson());
    return true;
  }
}

final currencyProvider = NotifierProvider<CurrencyNotifier, CurrencyState>(
  () => CurrencyNotifier(),
);
