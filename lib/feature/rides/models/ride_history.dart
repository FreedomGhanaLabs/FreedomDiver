class RideHistory {
  final bool success;
  final int count;
  final int totalPages;
  final int currentPage;
  final double totalEarnings;
  final double totalCommission;
  final List<Ride> data;

  RideHistory({
    required this.success,
    required this.count,
    required this.totalPages,
    required this.currentPage,
    required this.totalEarnings,
    required this.totalCommission,
    required this.data,
  });

  factory RideHistory.fromJson(Map<String, dynamic> json) {
    return RideHistory(
      success: json['success'],
      count: json['count'],
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
      totalEarnings: (json['totalEarnings'] ?? 0).toDouble(),
      totalCommission: (json['totalCommission'] ?? 0).toDouble(),
      data: List<Ride>.from(json['data'].map((x) => Ride.fromJson(x))),
    );
  }
}

class Ride {
  final String id;
  final Map<String, dynamic> estimatedDistance;
  final Map<String, dynamic> estimatedDuration;
  final Map<String, dynamic> weatherConditions;
  final Map<String, dynamic> user;
  final Location pickupLocation;
  final Location dropoffLocation;
  final bool isMultiStop;
  final double baseFare;
  final double distanceFare;
  final double timeFare;
  final double multiStopFare;
  final double waitingTimeFare;
  final int waitingTime;
  final double surgeMultiplier;
  final double discount;
  final String currency;
  final double platformCommission;
  final double driverEarnings;
  final String demandLevel;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final String? cancelledBy;
  final List<Location> stopLocations;
  final List<Message> messages;
  final DateTime requestedAt;
  final double totalFare;
  final int version;
  final DateTime? acceptedAt;
  final String driver;
  final Map<String, dynamic>? etaToPickup;
  final DateTime? arrivedAt;
  final Map<String, dynamic>? etaToDropoff;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? paymentCompletedAt;
  final Rating? userRating;
  final Rating? driverRating;

  Ride({
    required this.id,
    required this.estimatedDistance,
    required this.estimatedDuration,
    required this.weatherConditions,
    required this.user,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.isMultiStop,
    required this.baseFare,
    required this.distanceFare,
    required this.timeFare,
    required this.multiStopFare,
    required this.waitingTimeFare,
    required this.waitingTime,
    required this.surgeMultiplier,
    required this.discount,
    required this.currency,
    required this.platformCommission,
    required this.driverEarnings,
    required this.demandLevel,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    this.cancelledBy,
    required this.stopLocations,
    required this.messages,
    required this.requestedAt,
    required this.totalFare,
    required this.version,
    this.acceptedAt,
    required this.driver,
    this.etaToPickup,
    this.arrivedAt,
    this.etaToDropoff,
    this.startedAt,
    this.completedAt,
    this.paymentCompletedAt,
    this.userRating,
    this.driverRating,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['_id'],
      estimatedDistance: json['estimatedDistance'] ?? {},
      estimatedDuration: json['estimatedDuration'] ?? {},
      weatherConditions: json['weatherConditions'] ?? {},
      user: json['user'] ?? {},
      pickupLocation: Location.fromJson(json['pickupLocation']),
      dropoffLocation: Location.fromJson(json['dropoffLocation']),
      isMultiStop: json['isMultiStop'],
      baseFare: (json['baseFare'] ?? 0).toDouble(),
      distanceFare: (json['distanceFare'] ?? 0).toDouble(),
      timeFare: (json['timeFare'] ?? 0).toDouble(),
      multiStopFare: (json['multiStopFare'] ?? 0).toDouble(),
      waitingTimeFare: (json['waitingTimeFare'] ?? 0).toDouble(),
      waitingTime: json['waitingTime'] ?? 0,
      surgeMultiplier: (json['surgeMultiplier'] ?? 1.0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'GHS',
      platformCommission: (json['platformCommission'] ?? 0).toDouble(),
      driverEarnings: (json['driverEarnings'] ?? 0).toDouble(),
      demandLevel: json['demandLevel'],
      status: json['status'],
      paymentStatus: json['paymentStatus'],
      paymentMethod: json['paymentMethod'],
      cancelledBy: json['cancelledBy'],
      stopLocations: List<Location>.from(
        (json['stopLocations'] ?? []).map((x) => Location.fromJson(x)),
      ),
      messages: List<Message>.from(
        (json['messages'] ?? []).map((x) => Message.fromJson(x)),
      ),
      requestedAt: DateTime.parse(json['requestedAt']),
      totalFare: (json['totalFare'] ?? 0).toDouble(),
      version: json['__v'],
      acceptedAt:
          json['acceptedAt'] != null
              ? DateTime.parse(json['acceptedAt'])
              : null,
      driver: json['driver'],
      etaToPickup: json['etaToPickup'],
      arrivedAt:
          json['arrivedAt'] != null ? DateTime.parse(json['arrivedAt']) : null,
      etaToDropoff: json['etaToDropoff'],
      startedAt:
          json['startedAt'] != null ? DateTime.parse(json['startedAt']) : null,
      completedAt:
          json['completedAt'] != null
              ? DateTime.parse(json['completedAt'])
              : null,
      paymentCompletedAt:
          json['paymentCompletedAt'] != null
              ? DateTime.parse(json['paymentCompletedAt'])
              : null,
      userRating:
          json['userRating'] != null
              ? Rating.fromJson(json['userRating'])
              : null,
      driverRating:
          json['driverRating'] != null
              ? Rating.fromJson(json['driverRating'])
              : null,
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;
  final String address;
  final String? id;

  Location({
    required this.type,
    required this.coordinates,
    required this.address,
    this.id,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? 'Point',
      coordinates: List<double>.from(
        json['coordinates'].map((x) => x.toDouble()),
      ),
      address: json['address'] ?? '',
      id: json['_id'],
    );
  }
}

class Message {
  final String sender;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final String id;

  Message({
    required this.sender,
    required this.text,
    required this.timestamp,
    required this.isRead,
    required this.id,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? true,
      id: json['_id'],
    );
  }
}

class Rating {
  final int rating;
  final String comment;
  final DateTime timestamp;
  final String id;

  Rating({
    required this.rating,
    required this.comment,
    required this.timestamp,
    required this.id,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rating: json['rating'],
      comment: json['comment'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      id: json['_id'],
    );
  }
}
