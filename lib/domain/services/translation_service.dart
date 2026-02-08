import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  /// Translates text from source language to target language using MyMemory API
  /// Returns null if translation fails
  static Future<String?> translate({
    required String text,
    required String from,
    required String to,
  }) async {
    try {
      // MyMemory Translation API - free, no API key required for basic usage
      final encodedText = Uri.encodeComponent(text);
      final url = Uri.parse(
        'https://api.mymemory.translated.net/get?q=$encodedText&langpair=${from.toLowerCase()}|${to.toLowerCase()}',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = data['responseData'] as Map<String, dynamic>?;
        if (responseData != null) {
          final translatedText = responseData['translatedText'] as String?;
          // MyMemory sometimes returns the original text if translation fails
          // Check if it's actually different from the original
          if (translatedText != null && 
              translatedText.isNotEmpty && 
              translatedText.toLowerCase() != text.toLowerCase()) {
            return translatedText;
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Maps language names to language codes used by LibreTranslate
  static String getLanguageCode(String languageName) {
    const languageMap = {
      'English': 'en',
      'Romanian': 'ro',
      'Spanish': 'es',
      'French': 'fr',
      'German': 'de',
      'Italian': 'it',
      'Portuguese': 'pt',
      'Russian': 'ru',
      'Japanese': 'ja',
      'Chinese': 'zh',
      'Korean': 'ko',
      'Arabic': 'ar',
      'Hindi': 'hi',
      'Dutch': 'nl',
      'Polish': 'pl',
      'Turkish': 'tr',
    };
    return languageMap[languageName] ?? 'en';
  }
}
