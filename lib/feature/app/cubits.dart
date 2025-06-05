import 'package:flutter_bloc/flutter_bloc.dart';

import '../authentication/login/cubit/login_cubit.dart';
import '../authentication/register/cubit/registration_cubit.dart';
import '../authentication/register/cubit/verify_otp_cubit.dart';
import '../debt_financial_earnings/cubit/debt/debt_cubit.dart';
import '../debt_financial_earnings/cubit/earnings/earnings_cubit.dart';
import '../debt_financial_earnings/cubit/finance/financial_cubit.dart';
import '../documents/cubit/document_image.dart';
import '../documents/cubit/driver_document_cubit.dart';
import '../documents/driver_license/cubit/license_cubit.dart';
import '../documents/ghana_card/cubit/ghana_card_cubit.dart';
import '../driver/cubit/driver_cubit.dart';
import '../home/cubit/home_cubit.dart';
import '../kyc/cubit/kyc_cubit.dart';
import '../rides/cubit/ride/ride_cubit.dart';
import '../rides/cubit/ride_history/ride_history_cubit.dart';

List cubitRegistry = [
  BlocProvider(create: (_) => RegistrationFormCubit()),
  BlocProvider(create: (_) => LoginFormCubit()),
  BlocProvider(create: (_) => VerifyOtpCubit()),
  BlocProvider(create: (_) => HomeCubit()),
  BlocProvider(create: (_) => DriverCubit()),
  BlocProvider(create: (_) => DocumentCubit()),
  BlocProvider(create: (_) => DriverLicenseDetailsCubit()),
  BlocProvider(create: (_) => GhanaCardCubit()),
  BlocProvider(create: (_) => DriverImageCubit()),
  BlocProvider(create: (_) => KycCubit()),
  BlocProvider(create: (_) => RideCubit()),
  BlocProvider(create: (_) => RideHistoryCubit()),
  BlocProvider(create: (_) => EarningCubit()),
  BlocProvider(create: (_) => FinancialCubit()),
  BlocProvider(create: (_) => DebtCubit()),
];
