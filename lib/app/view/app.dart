import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/feature/authentication/login/cubit/login_cubit.dart';
import 'package:freedomdriver/feature/authentication/register/cubit/registration_cubit.dart';
import 'package:freedomdriver/feature/authentication/register/cubit/verify_otp_cubit.dart';
import 'package:freedomdriver/feature/documents/cubit/document_image.dart';
import 'package:freedomdriver/feature/documents/cubit/driver_document_cubit.dart';
import 'package:freedomdriver/feature/documents/driver_license/cubit/license_cubit.dart';
import 'package:freedomdriver/feature/driver/cubit/driver_cubit.dart';
import 'package:freedomdriver/feature/earnings/cubit/earnings_cubit.dart';
import 'package:freedomdriver/feature/home/cubit/home_cubit.dart';
import 'package:freedomdriver/feature/kyc/cubit/kyc_cubit.dart';
import 'package:freedomdriver/feature/rides/cubit/ride/rides_cubit.dart';
import 'package:freedomdriver/feature/rides/cubit/ride_history/ride_history_cubit.dart';
import 'package:freedomdriver/feature/splash/splash_screen.dart';
import 'package:freedomdriver/router/router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';

class App extends StatelessWidget {
  const App({super.key});

  static final GlobalKey _loaderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      splitScreenMode: true,
      minTextAdapt: true,
      child: GlobalLoaderOverlay(
        key: _loaderKey,
        switchInCurve: Curves.bounceIn,
        overlayColor: Colors.white,
        transitionBuilder: (p0, p1) {
          return FadeTransition(opacity: p1, child: p0);
        },
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => RegistrationFormCubit()),
            BlocProvider(create: (_) => LoginFormCubit()),
            BlocProvider(create: (_) => VerifyOtpCubit()),
            BlocProvider(create: (_) => HomeCubit()),
            BlocProvider(create: (_) => DriverCubit()),
            BlocProvider(create: (_) => DocumentUploadCubit()),
            BlocProvider(create: (_) => DriverLicenseDetailsCubit()),
            BlocProvider(create: (_) => DriverLicenseImageCubit()),
            BlocProvider(create: (_) => KycCubit()),
            BlocProvider(create: (_) => RideCubit()),
            BlocProvider(create: (_) => RideHistoryCubit()),
            BlocProvider(create: (_) => EarningCubit()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: GoogleFonts.poppins().fontFamily,
              scaffoldBackgroundColor: Colors.white,
              splashColor: Colors.white,
              colorSchemeSeed: Colors.white,
            ),
            // localizationsDelegates: AppLocalizations.localizationsDelegates,
            // supportedLocales: AppLocalizations.supportedLocales,
            onGenerateRoute: onGenerateRoute,
            initialRoute: SplashScreen.routeName,
          ),
        ),
      ),
    );
  }
}
