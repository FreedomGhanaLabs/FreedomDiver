import 'dart:convert';

class MessageModel {

  MessageModel({
    required this.sender,
    required this.userId,
    required this.riderId,
    required this.content,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sender: json['sender'],
      userId: json['userId'],
      riderId: json['riderId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
  final String sender;
  final String userId;
  final String riderId;
  final String content;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'sender': sender,
    'userId': userId,
    'riderId': riderId,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };
  static List<MessageModel> fromJsonList(String jsonString) {
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((item) => MessageModel.fromJson(item)).toList();
  }

  static String toJsonList(List<MessageModel> messages) {
    return jsonEncode(messages.map((m) => m.toJson()).toList());
  }
}
