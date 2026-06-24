import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/chat_controller.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with TickerProviderStateMixin {
  Brightness _b = Brightness.dark;

  late AnimationController bgCtrl;
  late AnimationController entryCtrl;
  late Animation<double> entryAnim;

  final ChatController controller = Get.put(ChatController());
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    entryAnim = CurvedAnimation(parent: entryCtrl, curve: Curves.easeOutCubic);

    ever(controller.messages, (_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    bgCtrl.dispose();
    entryCtrl.dispose();
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2D2060),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          "Clear Chat",
          style: TextStyle(color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to clear all messages?",
          style: TextStyle(color: AppThemeColors.secondaryText(_b)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: TextStyle(color: AppThemeColors.secondaryText(_b)),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
              controller.clearHistory();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Clear",
                style: TextStyle(color: AppThemeColors.primaryText(_b), fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = AppThemeColors.brightnessOf(context);
    _b = b;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppThemeColors.navBarBg(b),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppThemeColors.primaryText(b)),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.40),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.smart_toy_rounded, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "AI Health Assistant",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white),
                ),
                Obx(() => Text(
                      controller.isLoading.value
                          ? "Typing..."
                          : controller.isInitialized.value
                              ? "Online"
                              : "Offline",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: controller.isInitialized.value
                            ? const Color(0xFF34D399)
                            : const Color(0xFFF87171),
                      ),
                    )),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep_outlined, color: AppThemeColors.secondaryText(_b)),
            tooltip: "Clear chat",
            onPressed: _showClearDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(decoration: AppThemeColors.backgroundDecoration(b)),
          // Animated orbs
          AnimatedBuilder(
            animation: bgCtrl,
            builder: (_, __) => CustomPaint(
              painter: OrbPainter(
                t: bgCtrl.value,
                alphaMultiplier: AppThemeColors.orbAlpha(b),
              ),
              size: Size.infinite,
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Error banner if init failed
                Obx(() {
                  if (!controller.isInitialized.value &&
                      controller.initError.value.isNotEmpty &&
                      controller.messages.isEmpty) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppThemeColors.glassBg(_b),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF87171).withValues(alpha: 0.40)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Color(0xFFF87171)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              controller.initError.value,
                              style: TextStyle(color: AppThemeColors.secondaryText(_b), fontSize: 13),
                            ),
                          ),
                          TextButton(
                            onPressed: controller.clearHistory,
                            child: const Text("Retry", style: TextStyle(color: Color(0xFF818CF8))),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Messages area
                Expanded(
                  child: Obx(() {
                    if (controller.messages.isEmpty && !controller.isInitialized.value) {
                      return _buildOfflineState();
                    }
                    if (controller.messages.isEmpty) {
                      return _buildEmptyState();
                    }
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        return _MessageBubble(message: controller.messages[index]);
                      },
                    );
                  }),
                ),

                // Typing indicator
                Obx(() => controller.isLoading.value
                    ? const _TypingIndicator()
                    : const SizedBox.shrink()),

                // Input bar
                _InputBar(controller: controller, textController: textController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: FadeTransition(
        opacity: entryAnim,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppThemeColors.glassBg(_b),
                shape: BoxShape.circle,
                border: Border.all(color: AppThemeColors.glassBorder(_b), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.30),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.smart_toy_rounded, size: 64, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              "AI Health Assistant",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              "Powered by Gemini AI",
              style: TextStyle(fontSize: 13, color: Color(0xFF818CF8), fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Text(
              "Ask about medicines, health tips,\nor anything wellness-related.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppThemeColors.secondaryText(_b), fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: const [
                _SuggestionChip(text: "💊 What should I eat with medicines?"),
                _SuggestionChip(text: "🏃 Daily health tips"),
                _SuggestionChip(text: "💤 Tips for better sleep"),
                _SuggestionChip(text: "🩺 When to see a doctor?"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppThemeColors.glassBg(_b),
                shape: BoxShape.circle,
                border: Border.all(color: AppThemeColors.glassBorder(_b), width: 1.2),
              ),
              child: const Icon(Icons.wifi_off_rounded, size: 52, color: Color(0xFFF87171)),
            ),
            const SizedBox(height: 20),
            const Text(
              "AI Unavailable",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              "Could not connect to Gemini AI.\nPlease check your internet connection.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppThemeColors.secondaryText(_b)),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: controller.clearHistory,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.40),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Retry", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Message Bubble ───────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final dynamic message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final _b = AppThemeColors.brightnessOf(context);
    final isUser = message.isUser as bool;
    final isBlocked = (message.isBlocked as bool?) ?? false;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 12 * (1 - value)),
        child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser) ...[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: isBlocked
                      ? const LinearGradient(
                          colors: [Color(0xFFF87171), Color(0xFFDC2626)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                        ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isBlocked
                      ? Icons.shield_rounded
                      : Icons.smart_toy_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      gradient: isUser
                          ? const LinearGradient(
                              colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      // UC-41: blocked messages get a distinctive red tint
                      color: isUser
                          ? null
                          : isBlocked
                              ? const Color(0xFFF87171).withValues(alpha: 0.15)
                              : AppThemeColors.glassDivider(_b),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isUser ? 20 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 20),
                      ),
                      border: isUser
                          ? null
                          : Border.all(
                              color: isBlocked
                                  ? const Color(0xFFF87171).withValues(alpha: 0.45)
                                  : AppThemeColors.glassBorder(_b),
                              width: 1.2,
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: (isUser
                                  ? const Color(0xFF6366F1)
                                  : isBlocked
                                      ? const Color(0xFFF87171)
                                      : const Color(0xFF312E81))
                              .withValues(alpha: 0.20),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      message.text as String,
                      style: TextStyle(color: AppThemeColors.primaryText(_b), fontSize: 15, height: 1.45),
                    ),
                  ),
                  // UC-41: Safety filter label beneath a blocked message
                  if (isBlocked) ...[
                    const SizedBox(height: 4),
                    Semantics(
                      label: 'Safety filter applied. Content was blocked.',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.security_rounded,
                            size: 11,
                            color: const Color(0xFFF87171).withValues(alpha: 0.75),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Safety filter applied',
                            style: TextStyle(
                              fontSize: 11,
                              color: const Color(0xFFF87171).withValues(alpha: 0.75),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Typing Indicator ─────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> with TickerProviderStateMixin {
  late List<AnimationController> _dotCtrls;
  Brightness _b = Brightness.dark;

  @override
  void initState() {
    super.initState();
    _dotCtrls = List.generate(3, (i) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      Future.delayed(Duration(milliseconds: i * 160), () {
        if (mounted) ctrl.repeat(reverse: true);
      });
      return ctrl;
    });
  }

  @override
  void dispose() {
    for (final c in _dotCtrls) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _b = AppThemeColors.brightnessOf(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF818CF8), Color(0xFF6366F1)]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_rounded, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppThemeColors.glassDivider(_b),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppThemeColors.glassBorder(_b), width: 1.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _dotCtrls[i],
                  builder: (_, __) => Container(
                    margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.40 + 0.60 * _dotCtrls[i].value),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Input Bar ────────────────────────────────────────────────
class _InputBar extends StatelessWidget {
  final ChatController controller;
  final TextEditingController textController;

  const _InputBar({required this.controller, required this.textController});

  void _send() {
    final text = textController.text.trim();
    if (text.isNotEmpty) {
      controller.sendMessage(text);
      textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _b = AppThemeColors.brightnessOf(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border(top: BorderSide(color: AppThemeColors.glassDivider(_b))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppThemeColors.glassBg(_b),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppThemeColors.glassBorder(_b), width: 1.2),
              ),
              child: TextField(
                controller: textController,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(color: AppThemeColors.primaryText(_b), fontSize: 15),
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: "Ask a health question...",
                  hintStyle: TextStyle(color: AppThemeColors.hintText(_b), fontSize: 15),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  prefixIcon: const Icon(Icons.auto_awesome_outlined, color: Color(0xFF818CF8), size: 20),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(() => GestureDetector(
                onTap: controller.isLoading.value ? null : _send,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: controller.isLoading.value
                        ? null
                        : const LinearGradient(
                            colors: [Color(0xFF818CF8), Color(0xFF6366F1), Color(0xFF4F46E5)],
                          ),
                    color: controller.isLoading.value ? AppThemeColors.glassDivider(_b) : null,
                    shape: BoxShape.circle,
                    boxShadow: controller.isLoading.value
                        ? null
                        : [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withValues(alpha: 0.40),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: controller.isLoading.value
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppThemeColors.secondaryText(_b),
                          ),
                        )
                      : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                ),
              )),
        ],
      ),
    );
  }
}

// ─── Suggestion Chip ──────────────────────────────────────────
class _SuggestionChip extends StatelessWidget {
  final String text;
  const _SuggestionChip({required this.text});

  @override
  Widget build(BuildContext context) {
    final _b = AppThemeColors.brightnessOf(context);
    return GestureDetector(
      onTap: () => Get.find<ChatController>().sendMessage(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppThemeColors.glassBg(_b),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF818CF8).withValues(alpha: 0.60),
            width: 1.2,
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: 13, color: AppThemeColors.primaryText(_b))),
      ),
    );
  }
}
