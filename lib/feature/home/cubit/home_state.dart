part of 'home_cubit.dart';

enum ActivityType { ride, delivery }

enum ActivityStatus { pending, completed }

enum RideStatus { initial, searching, found, accepted, declined }

class HomeState extends Equatable {
  const HomeState({
    this.activities = const [],
    this.rideStatus = RideStatus.initial,
  });

  final List<Activity> activities;
  final RideStatus rideStatus;

  HomeState copyWith({
    List<Activity>? activities,
    RideStatus? rideStatus,
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
