class UserStats {
  final int totalWords;
  final int wordsReviewedToday;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastReviewDate;

  UserStats({
    this.totalWords = 0,
    this.wordsReviewedToday = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    DateTime? lastReviewDate,
  }) : lastReviewDate = lastReviewDate ?? DateTime.now();

  UserStats copyWith({
    int? totalWords,
    int? wordsReviewedToday,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastReviewDate,
  }) {
    return UserStats(
      totalWords: totalWords ?? this.totalWords,
      wordsReviewedToday: wordsReviewedToday ?? this.wordsReviewedToday,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastReviewDate: lastReviewDate ?? this.lastReviewDate,
    );
  }
}

