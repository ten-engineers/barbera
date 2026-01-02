import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../models/app_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const String _boxName = 'app_settings';
  static const String _settingsKey = 'settings';

  Future<Box<AppSettingsModel>> get _box async =>
      await Hive.openBox<AppSettingsModel>(_boxName);

  @override
  Future<AppSettings> getSettings() async {
    final box = await _box;
    final model = box.get(_settingsKey);
    
    if (model == null) {
      final defaultSettings = AppSettings();
      await saveSettings(defaultSettings);
      return defaultSettings;
    }
    
    return model.toEntity();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final box = await _box;
    await box.put(_settingsKey, AppSettingsModel.fromEntity(settings));
  }
}

