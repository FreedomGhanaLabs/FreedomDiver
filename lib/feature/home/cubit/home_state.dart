part of 'home_cubit.dart';

enum ActivityType { ride, delivery }

enum ActivityStatus { pending, completed }

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeActivity extends HomeState {
  const HomeActivity({this.activities = const []});
  final List<Activity> activities;
  @override
  List<Object> get props => [];
}

class Activity {
  const Activity(
      {required this.title,
      required this.type,
      required this.image,
      required this.pickUpLocation,
      required this.destination,
      required this.status});
  final String title;
  final ActivityType type;
  final String image;
  final String pickUpLocation;
  final String destination;
  final ActivityStatus status;
}
