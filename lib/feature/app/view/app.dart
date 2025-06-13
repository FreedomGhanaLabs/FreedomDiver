import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedomdriver/feature/app/cubits.dart';
import 'package:freedomdriver/feature/splash/splash_screen.dart';
import 'package:freedomdriver/router/router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        switchInCurve: Curves.easeIn,
        overlayColor: Colors.white,
        transitionBuilder: (p0, p1) {
          return FadeTransition(opacity: p1, child: p0);
        },
        child: MultiBlocProvider(
          providers: [...cubitRegistry],
          child: MaterialApp(
            title: 'Freedom Driver',
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: GoogleFonts.poppins().fontFamily,
              scaffoldBackgroundColor: Colors.white,
              splashColor: Colors.white,
              colorSchemeSeed: Colors.white,
            ),
            onGenerateRoute: onGenerateRoute,
            initialRoute: SplashScreen.routeName,
          ),
        ),
      ),
    );
  }
}
