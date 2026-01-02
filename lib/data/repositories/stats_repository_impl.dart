import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/repositories/stats_repository.dart';
import '../models/user_stats_model.dart';

class StatsRepositoryImpl implements StatsRepository {
  static const String _boxName = 'user_stats';
  static const String _statsKey = 'stats';

  Future<Box<UserStatsModel>> get _box async =>
      await Hive.openBox<UserStatsModel>(_boxName);

  @override
  Future<UserStats> getStats() async {
    final box = await _box;
    final model = box.get(_statsKey);
    
    if (model == null) {
      final defaultStats = UserStats();
      await updateStats(defaultStats);
      return defaultStats;
    }
    
    return model.toEntity();
  }

  @override
  Future<void> updateStats(UserStats stats) async {
    final box = await _box;
    await box.put(_statsKey, UserStatsModel.fromEntity(stats));
  }

  @override
  Future<void> incrementDailyReview() async {
    final stats = await getStats();
    final today = DateTime.now();
    final lastReview = stats.lastReviewDate;
    
    int wordsReviewedToday = stats.wordsReviewedToday;
    
    if (today.year != lastReview.year ||
        today.month != lastReview.month ||
        today.day != lastReview.day) {
      wordsReviewedToday = 1;
    } else {
      wordsReviewedToday += 1;
    }
    
    await updateStats(stats.copyWith(
      wordsReviewedToday: wordsReviewedToday,
      lastReviewDate: today,
    ));
  }

  @override
  Future<void> updateStreak() async {
    final stats = await getStats();
    final today = DateTime.now();
    final lastReview = stats.lastReviewDate;
    
    final daysDifference = today.difference(lastReview).inDays;
    
    int currentStreak = stats.currentStreak;
    
    if (daysDifference == 0) {
      return;
    } else if (daysDifference == 1) {
      currentStreak += 1;
    } else {
      currentStreak = 1;
    }
    
    final longestStreak = currentStreak > stats.longestStreak
        ? currentStreak
        : stats.longestStreak;
    
    await updateStats(stats.copyWith(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
    ));
  }
}

