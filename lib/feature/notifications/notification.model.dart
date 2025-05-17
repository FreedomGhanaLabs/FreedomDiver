class AppNotification {

  AppNotification({
    required this.id,
    required this.recipient,
    required this.recipientType,
    required this.title,
    required this.body,
    required this.data,
    required this.isRead,
    required this.createdAt,
    this.readAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['_id'] as String,
      recipient: json['recipient'] as String,
      recipientType: json['recipientType'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      data: NotificationData.fromJson(json['data']  as Map<String, dynamic>),
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'].toString()),
      readAt: json['readAt'] != null ? DateTime.tryParse(json['readAt'].toString()) : null,
    );
  }
  final String id;
  final String recipient;
  final String recipientType;
  final String title;
  final String body;
  final NotificationData data;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'recipient': recipient,
      'recipientType': recipientType,
      'title': title,
      'body': body,
      'data': data.toJson(),
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
    };
  }
}

class NotificationData {

  NotificationData({
    required this.type,
    required this.rideId,
    required this.status,
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.etaToPickup,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      type: json['type'] as String,
      rideId: json['rideId'] as String,
      status: json['status'] as String,
      driverId: json['driverId'] as String,
      driverName: json['driverName'] as String,
      driverPhone: json['driverPhone'] as String,
      etaToPickup: EtaToPickup.fromJson(json['etaToPickup'] as Map<String, dynamic>),
    );
  }
  final String type;
  final String rideId;
  final String status;
  final String driverId;
  final String driverName;
  final String driverPhone;
  final EtaToPickup etaToPickup;

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'rideId': rideId,
      'status': status,
      'driverId': driverId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'etaToPickup': etaToPickup.toJson(),
    };
  }
}

class EtaToPickup {

  EtaToPickup({
    required this.value,
    required this.text,
  });

  factory EtaToPickup.fromJson(Map<String, dynamic> json) {
    return EtaToPickup(
      value: json['value'] as int,
      text: json['text'] as String,
    );
  }
  final int value; // seconds
  final String text;

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'text': text,
    };
  }
}
