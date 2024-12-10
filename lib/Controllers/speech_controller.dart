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
      flutterTts.setSpeechRate(0.35);
      flutterTts.setVolume(1);

      // Load supported languages
      List<dynamic> languages = await flutterTts.getLanguages;
      availableLanguages.value =
          languages.map((lang) => lang.toString()).toList();

      // Load supported voices (if available)
      List<dynamic>? voices = await flutterTts.getVoices;
      if (voices != null) {
        availableVoices.value = voices
            .map((voice) {
              return Map<String, String>.from(voice as Map);
            })
            .toSet()
            .toList();
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
    isActive.value = false; // Mark as inactive
    currentChunkIndex = 0; // Reset chunk index
    print("Stopped speaking.");
  }

  void _splitTextIntoChunks(String text, {int chunkSize = 1000}) {
    // Clean and replace characters
    String cleanedText = text
        .replaceAll("/", ", , ")
        .replaceAll(RegExp(r'#+'), '') // Remove hashes
        .replaceAll('** ', ', , ') // Replace commas with asterisks
        .replaceAll('-', ' ') // Replace spaces with hyphens
        .replaceAll("________", "Blank, ")
        .replaceAll("____", "Blank, ")
        .trim();

    textChunks = []; // Clear previous chunks

    // Split the text into chunks
    RegExp regex = RegExp(".{1,$chunkSize}(\\s|\\b|\$)", multiLine: true);
    regex.allMatches(cleanedText).forEach((match) {
      textChunks.add(match.group(0)!.trim());
    });
    textChunks = textChunks.where((chunk) => chunk.isNotEmpty).toList();
  }

  Future<void> _speakNextChunk() async {
    // if (isSpeaking.value ||
    //     currentChunkIndex >= textChunks.length ||
    //     !isActive.value) {
    //   return; // Prevent overlapping or redundant calls
    // }

    final currentChunk = textChunks[currentChunkIndex];
    print("Speaking chunk ${currentChunkIndex + 1}: $currentChunk");

    isSpeaking.value = true; // Mark as speaking
    await flutterTts.speak(currentChunk);

    // Listen for completion instead of waiting for an estimated delay
    flutterTts.setCompletionHandler(() {
      isSpeaking.value = false; // Mark as not speaking
      currentChunkIndex++;
      if (currentChunkIndex < textChunks.length && isActive.value) {
        _speakNextChunk(); // Speak next chunk
      } else {
        print("Finished speaking all chunks.");
      }
    });
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
