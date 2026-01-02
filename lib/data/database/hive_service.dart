import 'package:hive_flutter/hive_flutter.dart';
import '../models/flashcard_model.dart';
import '../models/user_stats_model.dart';
import '../models/app_settings_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(FlashcardModelAdapter());
    Hive.registerAdapter(UserStatsModelAdapter());
    Hive.registerAdapter(AppSettingsModelAdapter());
  }
}

