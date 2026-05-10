import 'package:flutter_bloc/flutter_bloc.dart';

enum AppScreen { home, whereTo, choose, searching, driver, account }

class AppState {
  final AppScreen screen;
  final bool darkMode;

  const AppState({
    this.screen = AppScreen.home,
    this.darkMode = false,
  });

  AppState copyWith({AppScreen? screen, bool? darkMode}) => AppState(
        screen: screen ?? this.screen,
        darkMode: darkMode ?? this.darkMode,
      );
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  void goTo(AppScreen screen) => emit(state.copyWith(screen: screen));
  void toggleDarkMode(bool value) => emit(state.copyWith(darkMode: value));
}
