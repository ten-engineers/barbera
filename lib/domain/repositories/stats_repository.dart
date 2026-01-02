import '../entities/user_stats.dart';

abstract class StatsRepository {
  Future<UserStats> getStats();
  Future<void> updateStats(UserStats stats);
  Future<void> incrementDailyReview();
  Future<void> updateStreak();
}

