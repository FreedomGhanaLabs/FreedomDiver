import 'dart:convert';

class MessageModel {
  final String userId;
  final String riderId;
  final String content;
  final DateTime timestamp;

  MessageModel({
    required this.userId,
    required this.riderId,
    required this.content,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      userId: json['userId'],
      riderId: json['riderId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
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
