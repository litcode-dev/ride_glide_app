import 'package:flutter_bloc/flutter_bloc.dart';

enum AppScreen { home, whereTo, choose, searching, driver, account, trips, chatInbox, chatThread }

class AppState {
  final AppScreen screen;
  final bool darkMode;
  final String? activeConversationId;

  const AppState({
    this.screen = AppScreen.home,
    this.darkMode = false,
    this.activeConversationId,
  });

  bool get isRideActive => screen == AppScreen.searching || screen == AppScreen.driver;

  AppState copyWith({AppScreen? screen, bool? darkMode, String? activeConversationId}) =>
      AppState(
        screen: screen ?? this.screen,
        darkMode: darkMode ?? this.darkMode,
        activeConversationId: activeConversationId ?? this.activeConversationId,
      );
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  void goTo(AppScreen screen) => emit(state.copyWith(screen: screen));
  void toggleDarkMode(bool value) => emit(state.copyWith(darkMode: value));
  void goToChat(String conversationId) => emit(
        AppState(
          screen: AppScreen.chatThread,
          darkMode: state.darkMode,
          activeConversationId: conversationId,
        ),
      );
}
