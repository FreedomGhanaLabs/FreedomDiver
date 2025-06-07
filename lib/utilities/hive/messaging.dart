import 'dart:convert';

import 'package:hive/hive.dart';

import '../../feature/messaging/models/message.dart';

const String messagingKey = 'messages';
const String messageBoxKey = 'messaging';

Future<String?> getMessagesFromHive() async {
  final box = await Hive.openBox(messageBoxKey);
  return box.get(messagingKey) as String?;
}

Future<void> addMessagesToHive(String messages) async {
  final box = await Hive.openBox(messageBoxKey);
  await box.put(messagingKey, messages);
}

Future<void> deleteMessagesFromHive() async {
  await Hive.box(messageBoxKey).delete(messagingKey);
}

Future<void> addMessageToHive(MessageModel newMessage) async {
  final box = await Hive.openBox(messageBoxKey);

  // Get current messages as JSON string
  final existing = box.get(messagingKey) as String?;

  List<Map<String, dynamic>> messagesList = [];

  if (existing != null) {
    // Decode existing string into List<Map>
    final decoded = jsonDecode(existing);
    if (decoded is List) {
      messagesList = List<Map<String, dynamic>>.from(decoded);
    }
  }

  // Append new message
  messagesList.add(newMessage.toJson());

  // Save updated list
  await box.put(messagingKey, jsonEncode(messagesList));
}

Future<List<MessageModel>> getMessagesList() async {
  final jsonString = await getMessagesFromHive();
  if (jsonString == null) return [];

  final List decoded = jsonDecode(jsonString);
  return decoded.map((e) => MessageModel.fromJson(e)).toList();
}
