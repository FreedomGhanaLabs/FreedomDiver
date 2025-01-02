import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'kyc_state.dart';

class KycCubit extends Cubit<KycState> {
  KycCubit() : super(KycInitial());
}
