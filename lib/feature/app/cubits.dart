import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomdriver/feature/messaging/message_cubit.dart';

import 'package:freedomdriver/feature/authentication/login/cubit/login_cubit.dart';
import 'package:freedomdriver/feature/authentication/register/cubit/registration_cubit.dart';
import 'package:freedomdriver/feature/authentication/register/cubit/verify_otp_cubit.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/debt/debt_cubit.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/earnings/earnings_cubit.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/cubit/finance/financial_cubit.dart';
import 'package:freedomdriver/feature/documents/cubit/document_image.dart';
import 'package:freedomdriver/feature/documents/cubit/driver_document_cubit.dart';
import 'package:freedomdriver/feature/documents/driver_license/cubit/license_cubit.dart';
import 'package:freedomdriver/feature/documents/ghana_card/cubit/ghana_card_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/home/cubit/home_cubit.dart';
import 'package:freedomdriver/feature/kyc/cubit/kyc_cubit.dart';
import 'package:freedomdriver/feature/rides_and_delivery/cubit/ride/ride_cubit.dart';
import 'package:freedomdriver/feature/rides_and_delivery/cubit/ride_history/ride_history_cubit.dart';

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
  BlocProvider(create: (_) => MessageCubit()),
];
