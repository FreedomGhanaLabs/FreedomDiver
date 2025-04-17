part of 'earnings_cubit.dart';

sealed class EarningsState extends Equatable {
  const EarningsState();

  @override
  List<Object> get props => [];
}

final class EarningsLoading extends EarningsState {}

final class EarningsLoaded extends EarningsState {
  const EarningsLoaded({this.rideCount = 0});
  final int rideCount;
  @override
  List<Object> get props => [rideCount];

  EarningsLoaded copyWith({
    int? rideCount,
  }) {
    return EarningsLoaded(
      rideCount: rideCount ?? this.rideCount,
    );
  }
}
