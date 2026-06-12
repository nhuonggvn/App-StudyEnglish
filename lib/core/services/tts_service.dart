import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.4);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.1);

      // Set voice to a native English speaker
      List<dynamic> voices = await _flutterTts.getVoices;
      for (var voice in voices) {
        if (voice is Map) {
          String voiceName = voice['name']?.toString() ?? '';
          String locale = voice['locale']?.toString() ?? '';
          if (locale.startsWith('en-US') && voiceName.contains('female')) {
            await _flutterTts.setVoice({
              'name': voiceName,
              'locale': locale,
            });
            break;
          }
        }
      }

      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
    }
  }

  Future<void> speak(String text) async {
    try {
      await _flutterTts.stop();
      await _flutterTts.speak(text);
    } catch (e) {
      // Silently fail - TTS not critical
    }
  }

  Future<void> speakSlow(String text) async {
    try {
      await _flutterTts.setSpeechRate(0.25);
      await _flutterTts.stop();
      await _flutterTts.speak(text);
      // Reset to normal speed after speaking
      await Future.delayed(const Duration(seconds: 2));
      await _flutterTts.setSpeechRate(0.4);
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      // Silently fail
    }
  }

  void dispose() {
    _flutterTts.stop();
  }
}
