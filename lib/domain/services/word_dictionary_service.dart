import '../../domain/entities/app_settings.dart';

class WordDictionaryService {
  static Map<String, String> getWordsForLanguages(
    String nativeLanguage,
    String learningLanguage,
  ) {
    final key = '$nativeLanguage-$learningLanguage';
    final reverseKey = '$learningLanguage-$nativeLanguage';
    
    // Try direct match first
    if (_wordDictionaries.containsKey(key)) {
      return _wordDictionaries[key]!;
    }
    
    // Try reverse (swap languages) - useful for non-English native speakers
    if (_wordDictionaries.containsKey(reverseKey)) {
      return _wordDictionaries[reverseKey]!;
    }
    
    // Fallback to English-Spanish
    return _wordDictionaries['English-Spanish']!;
  }

  static final Map<String, Map<String, String>> _wordDictionaries = {
    'English-Spanish': {
      'hello': 'hola|Hello, how are you?',
      'thank you': 'gracias|Thank you for your help.',
      'please': 'por favor|Can you help me, please?',
      'water': 'agua|I need a glass of water.',
      'house': 'casa|This is my house.',
      'friend': 'amigo|He is my best friend.',
      'good': 'bueno|Have a good day!',
      'morning': 'mañana|Good morning!',
      'night': 'noche|Good night!',
      'food': 'comida|The food is delicious.',
      'book': 'libro|I love reading books.',
      'time': 'tiempo|What time is it?',
      'work': 'trabajo|I go to work every day.',
      'school': 'escuela|Children go to school.',
      'family': 'familia|I love my family.',
      'city': 'ciudad|I live in a big city.',
      'country': 'país|Which country are you from?',
      'language': 'idioma|I am learning a new language.',
      'beautiful': 'hermoso|What a beautiful day!',
      'happy': 'feliz|I am very happy today.',
      'sad': 'triste|Don\'t be sad.',
      'love': 'amor|I love learning languages.',
      'help': 'ayuda|Can you help me?',
      'understand': 'entender|I understand now.',
      'speak': 'hablar|I speak English and Spanish.',
    },
    'English-French': {
      'hello': 'bonjour|Hello, how are you?',
      'thank you': 'merci|Thank you for your help.',
      'please': 's\'il vous plaît|Can you help me, please?',
      'water': 'eau|I need a glass of water.',
      'house': 'maison|This is my house.',
      'friend': 'ami|He is my best friend.',
      'good': 'bon|Have a good day!',
      'morning': 'matin|Good morning!',
      'night': 'nuit|Good night!',
      'food': 'nourriture|The food is delicious.',
      'book': 'livre|I love reading books.',
      'time': 'temps|What time is it?',
      'work': 'travail|I go to work every day.',
      'school': 'école|Children go to school.',
      'family': 'famille|I love my family.',
      'city': 'ville|I live in a big city.',
      'country': 'pays|Which country are you from?',
      'language': 'langue|I am learning a new language.',
      'beautiful': 'beau|What a beautiful day!',
      'happy': 'heureux|I am very happy today.',
      'sad': 'triste|Don\'t be sad.',
      'love': 'amour|I love learning languages.',
      'help': 'aide|Can you help me?',
      'understand': 'comprendre|I understand now.',
      'speak': 'parler|I speak English and French.',
    },
    'English-German': {
      'hello': 'hallo|Hello, how are you?',
      'thank you': 'danke|Thank you for your help.',
      'please': 'bitte|Can you help me, please?',
      'water': 'wasser|I need a glass of water.',
      'house': 'haus|This is my house.',
      'friend': 'freund|He is my best friend.',
      'good': 'gut|Have a good day!',
      'morning': 'morgen|Good morning!',
      'night': 'nacht|Good night!',
      'food': 'essen|The food is delicious.',
      'book': 'buch|I love reading books.',
      'time': 'zeit|What time is it?',
      'work': 'arbeit|I go to work every day.',
      'school': 'schule|Children go to school.',
      'family': 'familie|I love my family.',
      'city': 'stadt|I live in a big city.',
      'country': 'land|Which country are you from?',
      'language': 'sprache|I am learning a new language.',
      'beautiful': 'schön|What a beautiful day!',
      'happy': 'glücklich|I am very happy today.',
      'sad': 'traurig|Don\'t be sad.',
      'love': 'liebe|I love learning languages.',
      'help': 'hilfe|Can you help me?',
      'understand': 'verstehen|I understand now.',
      'speak': 'sprechen|I speak English and German.',
    },
    'English-Russian': {
      'hello': 'привет|Hello, how are you?',
      'thank you': 'спасибо|Thank you for your help.',
      'please': 'пожалуйста|Can you help me, please?',
      'water': 'вода|I need a glass of water.',
      'house': 'дом|This is my house.',
      'friend': 'друг|He is my best friend.',
      'good': 'хороший|Have a good day!',
      'morning': 'утро|Good morning!',
      'night': 'ночь|Good night!',
      'food': 'еда|The food is delicious.',
      'book': 'книга|I love reading books.',
      'time': 'время|What time is it?',
      'work': 'работа|I go to work every day.',
      'school': 'школа|Children go to school.',
      'family': 'семья|I love my family.',
      'city': 'город|I live in a big city.',
      'country': 'страна|Which country are you from?',
      'language': 'язык|I am learning a new language.',
      'beautiful': 'красивый|What a beautiful day!',
      'happy': 'счастливый|I am very happy today.',
      'sad': 'грустный|Don\'t be sad.',
      'love': 'любовь|I love learning languages.',
      'help': 'помощь|Can you help me?',
      'understand': 'понимать|I understand now.',
      'speak': 'говорить|I speak English and Russian.',
    },
    'English-Romanian': {
      'hello': 'salut|Hello, how are you?',
      'thank you': 'mulțumesc|Thank you for your help.',
      'please': 'te rog|Can you help me, please?',
      'water': 'apă|I need a glass of water.',
      'house': 'casă|This is my house.',
      'friend': 'prieten|He is my best friend.',
      'good': 'bun|Have a good day!',
      'morning': 'dimineață|Good morning!',
      'night': 'noapte|Good night!',
      'food': 'mâncare|The food is delicious.',
      'book': 'carte|I love reading books.',
      'time': 'timp|What time is it?',
      'work': 'muncă|I go to work every day.',
      'school': 'școală|Children go to school.',
      'family': 'familie|I love my family.',
      'city': 'oraș|I live in a big city.',
      'country': 'țară|Which country are you from?',
      'language': 'limbă|I am learning a new language.',
      'beautiful': 'frumos|What a beautiful day!',
      'happy': 'fericit|I am very happy today.',
      'sad': 'trist|Don\'t be sad.',
      'love': 'iubire|I love learning languages.',
      'help': 'ajutor|Can you help me?',
      'understand': 'înțelege|I understand now.',
      'speak': 'vorbi|I speak English and Romanian.',
    },
  };

  static List<Map<String, String?>> getRandomWords(
    String nativeLanguage,
    String learningLanguage,
    int count,
  ) {
    final key = '$nativeLanguage-$learningLanguage';
    final reverseKey = '$learningLanguage-$nativeLanguage';
    final isReversed = !_wordDictionaries.containsKey(key) && 
                       _wordDictionaries.containsKey(reverseKey);
    
    final words = getWordsForLanguages(nativeLanguage, learningLanguage);
    final wordList = <Map<String, String?>>[];
    
    for (final entry in words.entries) {
      final parts = entry.value.split('|');
      
      // If using reversed dictionary, swap word and translation
      if (isReversed) {
        wordList.add({
          'word': parts[0],  // Translation becomes the word
          'translation': entry.key,  // Original word becomes translation
          'example': parts.length > 1 ? parts[1] : null,
        });
      } else {
        wordList.add({
          'word': entry.key,
          'translation': parts[0],
          'example': parts.length > 1 ? parts[1] : null,
        });
      }
    }

    wordList.shuffle();
    return wordList.take(count).toList();
  }
}

