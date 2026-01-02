import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../data/repositories/settings_repository_impl.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl();
});

final appSettingsProvider = FutureProvider<AppSettings>((ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  return await repository.getSettings();
});

final appSettingsNotifierProvider =
    StateNotifierProvider<AppSettingsNotifier, AsyncValue<AppSettings>>((ref) {
  return AppSettingsNotifier(ref);
});

class AppSettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  final Ref _ref;

  AppSettingsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final repository = _ref.read(settingsRepositoryProvider);
      final settings = await repository.getSettings();
      state = AsyncValue.data(settings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateSettings(AppSettings settings) async {
    final repository = _ref.read(settingsRepositoryProvider);
    await repository.saveSettings(settings);
    _loadSettings();
  }
}

