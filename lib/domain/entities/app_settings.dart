class AppSettings {
  final String nativeLanguage;
  final String learningLanguage;

  AppSettings({
    this.nativeLanguage = 'English',
    this.learningLanguage = 'Spanish',
  });

  AppSettings copyWith({
    String? nativeLanguage,
    String? learningLanguage,
  }) {
    return AppSettings(
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      learningLanguage: learningLanguage ?? this.learningLanguage,
    );
  }
}
