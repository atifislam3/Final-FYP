import 'package:hive/hive.dart';

part 'chat_message_model.g.dart';

@HiveType(typeId: 7)
class ChatMessageModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String text;

  @HiveField(2)
  bool isUser;

  @HiveField(3)
  DateTime timestamp;

  @HiveField(4)
  bool isBlocked; // UC-41: true when this message was blocked by safety filters

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isBlocked = false,
  });
}
