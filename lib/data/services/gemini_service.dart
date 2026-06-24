import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Centralised service for all Gemini AI interactions.
///
/// The API key is loaded from the `.env` file via [flutter_dotenv] so it is
/// never hardcoded in source code.  All controllers that need Gemini access
/// should obtain a model through this class.
class GeminiService {
  static const String _modelId = 'gemini-2.5-flash';

  /// Returns the raw API key stored in the .env file.
  /// Throws a [StateError] if the key is missing or empty.
  static String get apiKey {
    final key = dotenv.maybeGet('GEMINI_API_KEY') ?? '';
    if (key.isEmpty || key == 'your_gemini_api_key_here') {
      throw StateError(
        'GEMINI_API_KEY is not set. '
        'Copy .env.example to .env and add your Gemini API key.',
      );
    }
    return key;
  }

  /// Builds and returns a [GenerativeModel] configured for chat/conversation.
  ///
  /// [safetySettings] – optional per-category safety thresholds.
  /// [systemInstruction] – optional system prompt (passed as [Content.system]).
  /// [maxOutputTokens] – limits response length (default 300).
  /// [temperature] – creativity knob 0.0–1.0 (default 0.7).
  static GenerativeModel buildChatModel({
    List<SafetySetting>? safetySettings,
    String? systemInstruction,
    int maxOutputTokens = 300,
    double temperature = 0.7,
  }) {
    return GenerativeModel(
      model: _modelId,
      apiKey: apiKey,
      safetySettings: safetySettings ?? _defaultSafetySettings,
      generationConfig: GenerationConfig(
        maxOutputTokens: maxOutputTokens,
        temperature: temperature,
      ),
      systemInstruction: systemInstruction != null
          ? Content.system(systemInstruction)
          : null,
    );
  }

  /// Builds a lightweight [GenerativeModel] for single-shot content generation
  /// (e.g. daily challenge text).
  static GenerativeModel buildContentModel({
    double temperature = 0.9,
  }) {
    return GenerativeModel(
      model: _modelId,
      apiKey: apiKey,
      safetySettings: _defaultSafetySettings,
      generationConfig: GenerationConfig(temperature: temperature),
    );
  }

  /// Sends a single [prompt] string and returns the AI's text response.
  /// Returns `null` if the response is empty or an error occurs.
  static Future<String?> generateText(String prompt) async {
    try {
      final model = buildContentModel();
      final response =
          await model.generateContent([Content.text(prompt)]);
      final text = response.text;
      return (text != null && text.trim().isNotEmpty) ? text.trim() : null;
    } catch (e) {
      debugPrint('[GeminiService] generateText error: $e');
      return null;
    }
  }

  // ── Default safety settings shared across all models ──────────────────
  static final List<SafetySetting> _defaultSafetySettings = [
    SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
    SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
    SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
    SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
  ];
}
