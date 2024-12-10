import 'package:ai_english_learning/Widgets/notification_message.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class SpeechController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final isSpeaking = false.obs; // Observable to track the speaking state
  int currentChunkIndex = 0; // Track the current chunk being spoken
  List<String> textChunks = []; // List of text chunks to speak

  final isActive = true.obs; // Observable to track if the controller is active

  // Dynamic settings
  final availableLanguages = <String>[].obs; // Supported languages
  final availableVoices = <Map<String, String>>[].obs; // Supported voices
  final selectedLanguage = 'en-US'.obs; // Default language
  final selectedVoice = ''.obs; // Default voice name

  @override
  void onInit() {
    super.onInit();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    try {
      // Set default settings
      flutterTts.setPitch(1.1);
      flutterTts.setSpeechRate(0.4);
      flutterTts.setVolume(1);

      // Load supported languages
      List<dynamic> languages = await flutterTts.getLanguages;
      availableLanguages.value = languages.map((lang) => lang.toString()).toList();

      // Load supported voices (if available)
      List<dynamic>? voices = await flutterTts.getVoices;
      if (voices != null) {
        availableVoices.value = voices.map((voice) {
          return Map<String, String>.from(voice as Map);
        }).toSet().toList();
      }

      // Set default handlers
      flutterTts.setStartHandler(() {
        isSpeaking.value = true;
      });

      flutterTts.setCompletionHandler(() {
        isSpeaking.value = false;
        if (isActive.value) {
          _speakNextChunk(); // Move to the next chunk if still active
        }
      });

      flutterTts.setErrorHandler((message) {
        isSpeaking.value = false;
        notify("error", "Speech Error: $message");
      });

      notify("info", "TTS initialized successfully");
    } catch (e) {
      notify("error", "Error initializing TTS: $e");
    }
  }

  void speak(String text) {
    _splitTextIntoChunks(text);
    currentChunkIndex = 0;
    isActive.value = true; // Mark controller as active
    _speakNextChunk();
  }

  void stopSpeaking() {
    flutterTts.stop();
    isSpeaking.value = false;
    isActive.value = false; // Mark controller as inactive
    currentChunkIndex = 0; // Reset chunk index
  }

  void _splitTextIntoChunks(String text, {int chunkSize = 1000}) {
  // Clean and replace characters
  String cleanedText = text
      .replaceAll(RegExp(r'#+'), '') // Remove hashes
      .replaceAll('*', ',') // Replace commas with asterisks
      .replaceAll('-', ' ') // Replace spaces with hyphens
      .replaceAll("____", "dash")
      .trim();

  textChunks = []; // Clear previous chunks

  // Split the text into chunks
  RegExp regex = RegExp(".{1,$chunkSize}(\\s|\\b|\$)", multiLine: true);
  regex.allMatches(cleanedText).forEach((match) {
    textChunks.add(match.group(0)!.trim());
  });
}


  Future<void> _speakNextChunk() async {
    while (isActive.value && currentChunkIndex < textChunks.length) {
      final currentChunk = textChunks[currentChunkIndex];
      print("Speaking chunk ${currentChunkIndex + 1}: $currentChunk");

      // Speak the current chunk
      await flutterTts.speak(currentChunk);

      // Estimate the duration required for the current chunk
      final estimatedDuration = _estimateSpeechDuration(currentChunk);

      // Wait for the estimated duration
      await Future.delayed(estimatedDuration);

      // Increment the chunk index if still active
      if (isActive.value) {
        currentChunkIndex++;
      }
    }

    // Set speaking status to false when all chunks are spoken
    if (!isActive.value || currentChunkIndex >= textChunks.length) {
      isSpeaking.value = false;
      print("Finished speaking all chunks.");
    }
  }

Duration _estimateSpeechDuration(String text) {
  const averageLettersPerSecond = 12; // Adjust based on TTS speed settings
  final letterCount = text.length;
  final estimatedSeconds = letterCount / averageLettersPerSecond;
  return Duration(seconds: estimatedSeconds.ceil());
}

  void changeLanguage(String language) {
    selectedLanguage.value = language;
    flutterTts.setLanguage(language);
  }

  void changeVoice(Map<String, String> voice) {
    selectedVoice.value = voice['name'] ?? '';
    flutterTts.setVoice(voice);
  }

  @override
  void onClose() {
    isActive.value = false; // Mark controller as inactive
    flutterTts.stop(); // Stop any ongoing speech
    super.onClose();
  }
}
