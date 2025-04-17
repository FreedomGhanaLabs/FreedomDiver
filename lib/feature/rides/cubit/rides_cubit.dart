import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'rides_state.dart';

class RidesCubit extends Cubit<RidesState> {
  RidesCubit() : super(RidesInitial());
}