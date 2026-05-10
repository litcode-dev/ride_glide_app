import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/app_cubit.dart';
import '../pages/account_page.dart';
import '../pages/choose_page.dart';
import '../pages/driver_page.dart';
import '../pages/home_page.dart';
import '../pages/searching_page.dart';
import '../pages/where_to_page.dart';

class GlideFlow extends StatelessWidget {
  const GlideFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        SystemChrome.setSystemUIOverlayStyle(
          state.darkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        );

        final Widget page = switch (state.screen) {
          AppScreen.whereTo => const WhereToPage(key: ValueKey('whereto')),
          AppScreen.choose => const ChoosePage(key: ValueKey('choose')),
          AppScreen.searching => const SearchingPage(key: ValueKey('searching')),
          AppScreen.driver => const DriverPage(key: ValueKey('driver')),
          AppScreen.account => const AccountPage(key: ValueKey('account')),
          AppScreen.home => const HomePage(key: ValueKey('home')),
        };

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slide, child: child),
            );
          },
          child: page,
        );
      },
    );
  }
}
