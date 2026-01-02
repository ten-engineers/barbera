import 'package:hive/hive.dart';
import '../../domain/entities/app_settings.dart';

part 'app_settings_model.g.dart';

@HiveType(typeId: 2)
class AppSettingsModel extends HiveObject {
  @HiveField(0)
  final String nativeLanguage;

  @HiveField(1)
  final String learningLanguage;

  AppSettingsModel({
    required this.nativeLanguage,
    required this.learningLanguage,
  });

  factory AppSettingsModel.fromEntity(AppSettings settings) {
    return AppSettingsModel(
      nativeLanguage: settings.nativeLanguage,
      learningLanguage: settings.learningLanguage,
    );
  }

  AppSettings toEntity() {
    return AppSettings(
      nativeLanguage: nativeLanguage,
      learningLanguage: learningLanguage,
    );
  }
}
