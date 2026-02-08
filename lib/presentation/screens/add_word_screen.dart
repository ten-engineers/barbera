import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/services/word_dictionary_service.dart';
import '../../domain/services/translation_service.dart';
import '../providers/flashcard_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/version_badge.dart';

class AddWordScreen extends ConsumerStatefulWidget {
  const AddWordScreen({super.key});

  @override
  ConsumerState<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends ConsumerState<AddWordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _wordController = TextEditingController();
  final _translationController = TextEditingController();
  final _exampleController = TextEditingController();
  bool _isTranslating = false;

  @override
  void dispose() {
    _wordController.dispose();
    _translationController.dispose();
    _exampleController.dispose();
    super.dispose();
  }

  void _saveFlashcard() {
    if (_formKey.currentState!.validate()) {
      final flashcard = Flashcard(
        word: _wordController.text.trim(),
        translation: _translationController.text.trim(),
        example: _exampleController.text.trim().isEmpty
            ? null
            : _exampleController.text.trim(),
      );

      ref.read(flashcardNotifierProvider.notifier).addFlashcard(flashcard);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Word added successfully!')),
      );

      _wordController.clear();
      _translationController.clear();
      _exampleController.clear();
    }
  }

  Future<void> _translateWord() async {
    final word = _wordController.text.trim();
    if (word.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a word first')),
      );
      return;
    }

    final settings = await ref.read(appSettingsProvider.future);

    // Only show translation for English -> Romanian
    if (settings.nativeLanguage != 'English' || settings.learningLanguage != 'Romanian') {
      return;
    }

    setState(() {
      _isTranslating = true;
    });

    try {
      final translation = await TranslationService.translate(
        text: word,
        from: TranslationService.getLanguageCode(settings.nativeLanguage),
        to: TranslationService.getLanguageCode(settings.learningLanguage),
      );

      if (mounted) {
        if (translation != null && translation.isNotEmpty) {
          setState(() {
            _translationController.text = translation;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Translation completed!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Translation failed. Please try again.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Translation error: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTranslating = false;
        });
      }
    }
  }

  Future<void> _generateRandomWords() async {
    // Watch settings to get latest values
    final settingsAsync = await ref.read(appSettingsProvider.future);
    
    final words = WordDictionaryService.getRandomWords(
      settingsAsync.nativeLanguage,
      settingsAsync.learningLanguage,
      3,
    );

    if (words.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No words available for ${settingsAsync.nativeLanguage} → ${settingsAsync.learningLanguage}. Try English → ${settingsAsync.learningLanguage} or add words manually.'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    final notifier = ref.read(flashcardNotifierProvider.notifier);
    int addedCount = 0;

    for (final wordData in words) {
      final flashcard = Flashcard(
        word: wordData['word']!,
        translation: wordData['translation']!,
        example: wordData['example'],
      );
      notifier.addFlashcard(flashcard);
      addedCount++;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$addedCount random word${addedCount > 1 ? 's' : ''} added successfully!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Word'),
        elevation: 0,
        actions: const [
          VersionBadge(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _wordController,
                decoration: const InputDecoration(
                  labelText: 'Word',
                  hintText: 'Enter the word to learn',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a word';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.none,
              ),
              const SizedBox(height: 16),
              settingsAsync.when(
                data: (settings) {
                  final showTranslateButton = 
                      settings.nativeLanguage == 'English' && 
                      settings.learningLanguage == 'Romanian';
                  
                  return TextFormField(
                    controller: _translationController,
                    decoration: InputDecoration(
                      labelText: 'Translation',
                      hintText: 'Enter the translation',
                      border: const OutlineInputBorder(),
                      suffixIcon: showTranslateButton
                          ? IconButton(
                              icon: _isTranslating
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.auto_awesome, color: Colors.blue),
                              onPressed: _isTranslating ? null : _translateWord,
                              tooltip: 'Auto-translate',
                            )
                          : null,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a translation';
                      }
                      return null;
                    },
                  );
                },
                loading: () => TextFormField(
                  controller: _translationController,
                  decoration: const InputDecoration(
                    labelText: 'Translation',
                    hintText: 'Enter the translation',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a translation';
                    }
                    return null;
                  },
                ),
                error: (_, __) => TextFormField(
                  controller: _translationController,
                  decoration: const InputDecoration(
                    labelText: 'Translation',
                    hintText: 'Enter the translation',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a translation';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _exampleController,
                decoration: const InputDecoration(
                  labelText: 'Example (optional)',
                  hintText: 'Enter an example sentence',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: _generateRandomWords,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate 3 Random Words'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.blue.shade300),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveFlashcard,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Add Word',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

