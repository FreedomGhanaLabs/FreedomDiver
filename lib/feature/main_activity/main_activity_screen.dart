import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedomdriver/feature/debt_financial_earnings/view/earnings_screen.dart';
import 'package:freedomdriver/feature/home/view/home_screen.dart';
import 'package:freedomdriver/feature/main_activity/cubit/main_activity_cubit.dart';
import 'package:freedomdriver/feature/profile/view/profile_screen.dart';
import 'package:freedomdriver/feature/rides/view/rides_screen.dart';
import 'package:freedomdriver/shared/api/load_dashboard.dart';
import 'package:freedomdriver/shared/app_config.dart';


class MainActivityScreen extends StatelessWidget {
  const MainActivityScreen({super.key});
  static const routeName = '/main_activity';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainActivityCubit(),
      child: const _MainActivityScreen(),
    );
  }
}

class _MainActivityScreen extends StatelessWidget {
  const _MainActivityScreen();

  @override
  Widget build(BuildContext context) {
    loadDashboard(context);

    return BlocBuilder<MainActivityCubit, MainActivityState>(
      builder: (context, state) {
        final currentIndex = state.currentIndex;
        return Scaffold(
          body: _pages[currentIndex],
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 9,
                  offset: Offset(0, 9),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: (value) {
                context.read<MainActivityCubit>().changeIndex(value);
              },
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xfffc7013),
              selectedLabelStyle: const TextStyle(
                color: Color(0xfffc7013),
                fontSize: smallText,
              ),
              unselectedItemColor: Colors.grey.shade400,
              unselectedLabelStyle: const TextStyle(
                fontSize: smallText,
              ),
              items: List.generate(
                _itemDetailsActive.length,
                (index) {
                  final activeIconData = _itemDetailsActive[index];
                  final inActiveIconData = _itemDetailsInactive[index];
                  return BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: SizedBox(
                      width: 22,
                      height: 22,
                      child: state.currentIndex == index
                          ? SvgPicture.asset(
                              'assets/nav/active_icon/${activeIconData['icon']}',
                            )
                          : SvgPicture.asset(
                              'assets/nav/inactive_icon/${inActiveIconData['icon']}',
                            ),
                    ),
                    label: state.currentIndex == index
                        ? activeIconData['label']
                        : inActiveIconData['label'],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

List<Widget> _pages = [
  const HomeScreen(),
  const EarningsScreen(),
  const RidesScreen(),
  const ProfileScreen(),
];

List<Map<String, String>> _itemDetailsActive = [
  {'icon': 'home_nav_icon_active.svg', 'label': 'Home'},
  {'icon': 'earnings_nav_icon_active.svg', 'label': 'Earnings'},
  {'icon': 'rides_nav_icon_active.svg', 'label': 'Rides'},
  {'icon': 'more_nav_icon_active.svg', 'label': 'More'},
];

List<Map<String, String>> _itemDetailsInactive = [
  {'icon': 'home_nav_icon_inactive.svg', 'label': 'Home'},
  {'icon': 'earnings_nav_icon_inactive.svg', 'label': 'Earnings'},
  {'icon': 'rides_nav_icon_inactive.svg', 'label': 'Rides'},
  {'icon': 'more_nav_icon_inactive.svg', 'label': 'More'},
];
