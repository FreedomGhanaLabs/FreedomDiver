import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'earnings_state.dart';

class EarningsCubit extends Cubit<EarningsState> {
  EarningsCubit() : super(EarningsLoading());
}
