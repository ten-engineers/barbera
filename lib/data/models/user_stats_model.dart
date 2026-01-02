import 'package:hive/hive.dart';
import '../../domain/entities/user_stats.dart';

part 'user_stats_model.g.dart';

@HiveType(typeId: 1)
class UserStatsModel extends HiveObject {
  @HiveField(0)
  final int totalWords;

  @HiveField(1)
  final int wordsReviewedToday;

  @HiveField(2)
  final int currentStreak;

  @HiveField(3)
  final int longestStreak;

  @HiveField(4)
  final DateTime lastReviewDate;

  UserStatsModel({
    this.totalWords = 0,
    this.wordsReviewedToday = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.lastReviewDate,
  });

  factory UserStatsModel.fromEntity(UserStats stats) {
    return UserStatsModel(
      totalWords: stats.totalWords,
      wordsReviewedToday: stats.wordsReviewedToday,
      currentStreak: stats.currentStreak,
      longestStreak: stats.longestStreak,
      lastReviewDate: stats.lastReviewDate,
    );
  }

  UserStats toEntity() {
    return UserStats(
      totalWords: totalWords,
      wordsReviewedToday: wordsReviewedToday,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastReviewDate: lastReviewDate,
    );
  }
}

