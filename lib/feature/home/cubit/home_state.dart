part of 'home_cubit.dart';

enum ActivityType { ride, delivery }

enum ActivityStatus { pending, completed }

enum TransitStatus {
  initial,
  searching,
  found,
  accepted,
  declined,
  started,
  completed,
  cancelled
}

class HomeState extends Equatable {
  const HomeState({
    this.activities = const [],
    this.rideStatus = TransitStatus.initial,
  });

  final List<Activity> activities;
  final TransitStatus rideStatus;

  HomeState copyWith({
    List<Activity>? activities,
    TransitStatus? rideStatus,
  }) {
    return HomeState(
      activities: activities ?? this.activities,
      rideStatus: rideStatus ?? this.rideStatus,
    );
  }

  @override
  List<Object> get props => [activities, rideStatus];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeState &&
          runtimeType == other.runtimeType &&
          activities == other.activities &&
          rideStatus == other.rideStatus;

  @override
  int get hashCode => activities.hashCode ^ rideStatus.hashCode;
}

class Activity {
  const Activity({
    required this.title,
    required this.type,
    required this.image,
    required this.pickUpLocation,
    required this.destination,
    required this.status,
  });
  final String title;
  final ActivityType type;
  final String image;
  final String pickUpLocation;
  final String destination;
  final ActivityStatus status;
}

List<Activity> historyList = [
  const Activity(
    title: 'Ride',
    type: ActivityType.ride,
    image: 'assets/app_images/rider2.png',
    pickUpLocation: 'Pickup Location',
    destination: 'Destination',
    status: ActivityStatus.pending,
  ),
  const Activity(
    title: 'Delivery',
    type: ActivityType.delivery,
    image: 'assets/app_images/rider2.png',
    pickUpLocation: 'Pickup Location',
    destination: 'Destination',
    status: ActivityStatus.completed,
  ),
];
