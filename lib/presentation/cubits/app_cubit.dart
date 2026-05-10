import 'package:flutter_bloc/flutter_bloc.dart';

enum AppScreen { home, whereTo, choose, searching, driver, account, trips, chatInbox, chatThread, call }

class AppState {
  final AppScreen screen;
  final bool darkMode;
  final bool discountNotifications;
  final String? activeConversationId;
  final String? activeDriverName;
  final int? activeDriverHue;

  const AppState({
    this.screen = AppScreen.home,
    this.darkMode = false,
    this.discountNotifications = true,
    this.activeConversationId,
    this.activeDriverName,
    this.activeDriverHue,
  });

  bool get isRideActive => screen == AppScreen.searching || screen == AppScreen.driver;

  AppState copyWith({
    AppScreen? screen,
    bool? darkMode,
    bool? discountNotifications,
    String? activeConversationId,
    String? activeDriverName,
    int? activeDriverHue,
  }) => AppState(
    screen: screen ?? this.screen,
    darkMode: darkMode ?? this.darkMode,
    discountNotifications: discountNotifications ?? this.discountNotifications,
    activeConversationId: activeConversationId ?? this.activeConversationId,
    activeDriverName: activeDriverName ?? this.activeDriverName,
    activeDriverHue: activeDriverHue ?? this.activeDriverHue,
  );
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  void goTo(AppScreen screen) => emit(state.copyWith(screen: screen));
  void toggleDarkMode(bool value) => emit(state.copyWith(darkMode: value));
  void toggleDiscountNotifications(bool value) =>
      emit(state.copyWith(discountNotifications: value));
  void goToChat(String conversationId) => emit(
        AppState(
          screen: AppScreen.chatThread,
          darkMode: state.darkMode,
          discountNotifications: state.discountNotifications,
          activeConversationId: conversationId,
          activeDriverName: state.activeDriverName,
          activeDriverHue: state.activeDriverHue,
        ),
      );
  void goToCall({required String conversationId, required String driverName, required int driverHue}) =>
      emit(AppState(
        screen: AppScreen.call,
        darkMode: state.darkMode,
        discountNotifications: state.discountNotifications,
        activeConversationId: conversationId,
        activeDriverName: driverName,
        activeDriverHue: driverHue,
      ));
}
