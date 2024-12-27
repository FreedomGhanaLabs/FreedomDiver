part of 'main_activity_cubit.dart';

class MainActivityState extends Equatable {
  const MainActivityState({required this.currentIndex});
  final int currentIndex;

  MainActivityState copyWith({
    int? currentIndex,
  }) {
    return MainActivityState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [currentIndex];
}
