import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';
import '../data/models/chat_message_model.dart';
import '../data/services/gemini_service.dart';
import '../data/services/hive_service.dart';
import '../data/services/safety_rules_service.dart';

class ChatController extends GetxController {
  var messages = <ChatMessageModel>[].obs;
  var isLoading = false.obs;
  var isInitialized = false.obs;
  var initError = ''.obs;

  GenerativeModel? _model;
  ChatSession? _chat;

  // UC-41 / SRS-133 / SRS-134: client-side safety pre-filter
  final SafetyRulesService _safetyRules = SafetyRulesService();

  @override
  void onInit() {
    super.onInit();
    _loadChatHistory();
    _initGemini();
    // SRS-134: Start listening for backend rule updates so changes take
    // effect on the next message without requiring an app update.
    _safetyRules.startListening();
  }

  @override
  void onClose() {
    _safetyRules.stopListening();
    super.onClose();
  }

  void _loadChatHistory() {
    try {
      final history = HiveService.getAllChatMessages();
      messages.value = history;
    } catch (e) {
      debugPrint('[ChatController] Failed to load chat history: $e');
    }
  }

  void _initGemini() {
    try {
      _model = GeminiService.buildChatModel(
        systemInstruction:
            "You are a friendly, concise health assistant for a personal medicine reminder app called MedCare. "
            "Help users with medication questions, dosage reminders, health tips, and general wellness advice. "
            "Always be empathetic and clear. "
            "IMPORTANT: Never provide emergency medical diagnosis — always advise consulting a doctor for serious concerns. "
            "Keep responses under 120 words unless the user explicitly asks for more detail.",
      );

      _chat = _model!.startChat();
      isInitialized.value = true;
      initError.value = '';

      // Greet only if no existing history
      if (messages.isEmpty) {
        _addBotMessage(
          "👋 Hello! I'm your MedCare health assistant. "
          "Ask me anything about your medicines, health tips, or appointments!",
        );
      }
    } catch (e) {
      debugPrint('[ChatController] Gemini init error: $e');
      isInitialized.value = false;
      initError.value = 'Failed to initialize AI assistant.';
    }
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    // Ensure Gemini is ready
    if (_chat == null) {
      _initGemini();
      if (_chat == null) {
        _addBotMessage(
            "⚠️ AI assistant is unavailable. Please check your internet connection and try again.");
        return;
      }
    }

    // 1. Add user message immediately
    final userMsg = ChatMessageModel(
      id: const Uuid().v4(),
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMsg);
    _persistMessage(userMsg);
    isLoading.value = true;

    // UC-41 Steps 2-6: Intercept message and check against safety rules
    // before forwarding to the Gemini backend (SRS-133).
    if (_safetyRules.isBlocked(trimmed)) {
      isLoading.value = false;
      _addBotMessage(
        "🚨 I cannot answer this query. "
        "If this is an emergency, please call 911 or your local emergency "
        "services immediately. "
        "For mental health support, please reach out to a qualified "
        "healthcare professional.",
        isBlocked: true,
      );
      return;
    }

    try {
      // 2. Send to Gemini
      final response = await _chat!
          .sendMessage(Content.text(trimmed))
          .timeout(const Duration(seconds: 30));

      final responseText = response.text;
      if (responseText != null && responseText.isNotEmpty) {
        _addBotMessage(responseText);
      } else {
        _addBotMessage(
            "I'm not sure how to respond to that. Could you rephrase?");
      }
    } on GenerativeAIException catch (e) {
      debugPrint('[ChatController] GenerativeAI error: $e');
      final msg = e.message.toLowerCase();
      if (msg.contains('safety') || msg.contains('blocked')) {
        _addBotMessage(
            "⚠️ That topic is outside my safety guidelines. Please ask something health-related.");
      } else if (msg.contains('api key') ||
          msg.contains('401') ||
          msg.contains('403') ||
          msg.contains('permission')) {
        _addBotMessage(
            "⚠️ API authentication error. Please contact the app developer.");
      } else if (msg.contains('quota') || msg.contains('429')) {
        _addBotMessage(
            "⚠️ API quota exceeded. Please try again later.");
      } else {
        _addBotMessage(
            "⚠️ Something went wrong: ${e.message}. Please try again.");
      }
      // Re-create chat session to reset state after error
      _restartChatSession();
    } catch (e) {
      debugPrint('[ChatController] Unexpected error: $e');
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('timeout') || errStr.contains('socketexception') ||
          errStr.contains('network') || errStr.contains('connection')) {
        _addBotMessage(
            "⚠️ Network error. Please check your internet connection and try again.");
      } else {
        _addBotMessage(
            "⚠️ Unexpected error. Please try again in a moment.");
      }
      _restartChatSession();
    } finally {
      isLoading.value = false;
    }
  }

  void _restartChatSession() {
    try {
      if (_model != null) {
        _chat = _model!.startChat();
      }
    } catch (e) {
      debugPrint('[ChatController] Failed to restart chat session: $e');
    }
  }

  void _addBotMessage(String text, {bool isBlocked = false}) {
    final botMsg = ChatMessageModel(
      id: const Uuid().v4(),
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
      isBlocked: isBlocked,
    );
    messages.add(botMsg);
    _persistMessage(botMsg);
  }

  void _persistMessage(ChatMessageModel msg) {
    HiveService.saveChatMessage(msg).catchError((e) {
      debugPrint('[ChatController] Failed to persist message: $e');
    });
  }

  Future<void> clearHistory() async {
    try {
      await HiveService.clearChatHistory();
    } catch (e) {
      debugPrint('[ChatController] Failed to clear history: $e');
    }
    messages.clear();
    _restartChatSession();
    _addBotMessage(
      "👋 Chat cleared! I'm your MedCare health assistant. How can I help you today?",
    );
  }
}
