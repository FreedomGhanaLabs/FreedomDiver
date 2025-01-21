import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_driver/feature/authentication/register/cubit/registeration_cubit.dart';
import 'package:freedom_driver/feature/authentication/register/cubit/verify_otp_cubit.dart';
import 'package:freedom_driver/feature/home/cubit/home_cubit.dart';
import 'package:freedom_driver/l10n/l10n.dart';
import 'package:freedom_driver/router/router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      splitScreenMode: true,
      minTextAdapt: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => RegistrationFormCubit()),
          BlocProvider(create: (_) => VerifyOtpCubit()),
          BlocProvider(create: (_) => HomeCubit()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateRoute: onGenerateRoute,
        ),
      ),
    );
  }
}
