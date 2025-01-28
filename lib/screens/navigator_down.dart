import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muserpol_pvt/model/files_model.dart';
import 'package:muserpol_pvt/utils/nav.dart';

class NavigationDown extends StatelessWidget {
  final StateAplication stateApp;
  final int currentIndex;
  final Function(int) onTap;
  final GlobalKey keyBottomNavigation1;
  final GlobalKey keyBottomNavigation2;
  final GlobalKey keyBottomNavigation3;
  const NavigationDown(
      {super.key,
      required this.stateApp,
      required this.currentIndex,
      required this.onTap,
      required this.keyBottomNavigation1,
      required this.keyBottomNavigation2,
      required this.keyBottomNavigation3});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                  child: Center(
                child: SizedBox(
                  key: keyBottomNavigation1,
                  height: 40,
                  width: MediaQuery.of(context).size.width / 4,
                ),
              )),
              Expanded(
                  child: Center(
                child: SizedBox(
                  key: keyBottomNavigation2,
                  height: 40,
                  width: MediaQuery.of(context).size.width / 4,
                ),
              )),
              Expanded(
                child: Center(
                  child: SizedBox(
                    key: keyBottomNavigation3,
                    height: 40,
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                ),
              ),
            ],
          ),
        ),
        CurvedNavigationBar(
          items: [
            if (stateApp == StateAplication.complement)
              CurvedNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/newProcedure.svg',
                      height: 25.sp,
                      colorFilter: ColorFilter.mode(
                          AdaptiveTheme.of(context).mode.isDark
                              ? Colors.white
                              : currentIndex == 0
                                  ? Colors.black
                                  : Colors.white,
                          BlendMode.srcIn)),
                  label: "Solicitud de Pago"),
            if (stateApp == StateAplication.complement)
              CurvedNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/historyProcedure.svg',
                      height: 25.sp,
                      colorFilter: ColorFilter.mode(
                          AdaptiveTheme.of(context).mode.isDark
                              ? Colors.white
                              : currentIndex == 1
                                  ? Colors.black
                                  : Colors.white,
                          BlendMode.srcIn)),
                  label: "Trámites Históricos"),
            if (stateApp == StateAplication.virtualOficine)
              CurvedNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/newProcedure.svg',
                      height: 25.sp,
                      colorFilter: ColorFilter.mode(
                          AdaptiveTheme.of(context).mode.isDark
                              ? Colors.white
                              : currentIndex == 0
                                  ? Colors.black
                                  : Colors.white,
                          BlendMode.srcIn)),
                  label: "Aportes"),
            if (stateApp == StateAplication.virtualOficine)
              CurvedNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/requisites.svg',
                    height: 25.sp,
                    colorFilter: ColorFilter.mode(
                        AdaptiveTheme.of(context).mode.isDark
                            ? Colors.white
                            : currentIndex == 1
                                ? Colors.black
                                : Colors.white,
                        BlendMode.srcIn),
                  ),
                  label: "Préstamos"),
            if (stateApp == StateAplication.virtualOficine)
              CurvedNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/calculator.svg',
                    height: 25.sp,
                    colorFilter: ColorFilter.mode(
                        AdaptiveTheme.of(context).mode.isDark
                            ? Colors.white
                            : currentIndex == 2
                                ? Colors.black
                                : Colors.white,
                        BlendMode.srcIn),
                  ),
                  label: "Calculadora"),
          ],
          animationCurve: Curves.fastOutSlowIn,
          onTap: (i) => onTap(i),
          letIndexChange: (index) => true,
        ),
      ],
    );
  }
}
