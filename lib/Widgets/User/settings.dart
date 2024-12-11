import 'package:ai_english_learning/Controllers/speech_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpeechSettingsPage extends StatelessWidget {
  const SpeechSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SpeechController speechController = Get.put(SpeechController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Language Dropdown
            Obx(() {
              return DropdownButton<String>(
                value: speechController.selectedLanguage.value,
                onChanged: (language) {
                  if (language != null) {
                    speechController.changeLanguage(language);
                  }
                },
                items: speechController.availableLanguages
                    .map((lang) => DropdownMenuItem(
                          value: lang,
                          child: Text(lang),
                        ))
                    .toList(),
              );
            }),
            const SizedBox(height: 20),

            // Voice Dropdown
            Obx(() {
              // Ensure the selectedVoice is valid or fallback to null
              final selectedVoice = speechController.availableVoices.any(
                      (voice) =>
                          voice['name'] == speechController.selectedVoice.value)
                  ? speechController.selectedVoice.value
                  : null;

              return DropdownButton<String>(
                value: selectedVoice,
                onChanged: (voiceName) {
                  if (voiceName != null) {
                    final selectedVoiceMap =
                        speechController.availableVoices.firstWhere(
                      (voice) => voice['name'] == voiceName,
                    );
                    speechController.changeVoice(selectedVoiceMap);
                  }
                },
                items: speechController.availableVoices
                    .map((voice) => DropdownMenuItem(
                          value: voice['name'],
                          child: Text(voice['name'] ?? 'Unknown'),
                        ))
                    .toList(),
                hint: const Text('Select a voice'),
              );
            }),

            const SizedBox(height: 40),

            // Test Button
            ElevatedButton(
              onPressed: () {
                speechController.speak(
                    "This is a test of the current voice and language settings.");
              },
              child: const Text('Test Speech'),
            ),
          ],
        ),
      ),
    );
  }
}