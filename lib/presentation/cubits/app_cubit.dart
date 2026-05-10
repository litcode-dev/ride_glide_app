import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/preferences_service.dart';

enum AppScreen { home, whereTo, choose, searching, driver, account, trips, chatInbox, chatThread, call, profile, search }

class AppState {
  final AppScreen screen;
  final bool darkMode;
  final bool discountNotifications;
  final bool focusPickup;
  final String? pickupAddress;
  final double? pickupLat;
  final double? pickupLng;
  final String? activeConversationId;
  final String? activeDriverName;
  final int? activeDriverHue;

  const AppState({
    this.screen = AppScreen.home,
    this.darkMode = false,
    this.discountNotifications = true,
    this.focusPickup = false,
    this.pickupAddress,
    this.pickupLat,
    this.pickupLng,
    this.activeConversationId,
    this.activeDriverName,
    this.activeDriverHue,
  });

  bool get isRideActive => screen == AppScreen.searching || screen == AppScreen.driver;

  AppState copyWith({
    AppScreen? screen,
    bool? darkMode,
    bool? discountNotifications,
    bool? focusPickup,
    String? pickupAddress,
    double? pickupLat,
    double? pickupLng,
    String? activeConversationId,
    String? activeDriverName,
    int? activeDriverHue,
  }) => AppState(
    screen: screen ?? this.screen,
    darkMode: darkMode ?? this.darkMode,
    discountNotifications: discountNotifications ?? this.discountNotifications,
    focusPickup: focusPickup ?? this.focusPickup,
    pickupAddress: pickupAddress ?? this.pickupAddress,
    pickupLat: pickupLat ?? this.pickupLat,
    pickupLng: pickupLng ?? this.pickupLng,
    activeConversationId: activeConversationId ?? this.activeConversationId,
    activeDriverName: activeDriverName ?? this.activeDriverName,
    activeDriverHue: activeDriverHue ?? this.activeDriverHue,
  );
}

class AppCubit extends Cubit<AppState> {
  final PreferencesService _prefs;

  AppCubit(this._prefs) : super(AppState(
    darkMode: _prefs.darkMode,
    discountNotifications: _prefs.discountNotifications,
  ));

  void goTo(AppScreen screen) => emit(state.copyWith(screen: screen));

  void toggleDarkMode(bool value) {
    _prefs.setDarkMode(value);
    emit(state.copyWith(darkMode: value));
  }

  void toggleDiscountNotifications(bool value) {
    _prefs.setDiscountNotifications(value);
    emit(state.copyWith(discountNotifications: value));
  }
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

  void goToWhereTo({bool focusPickup = false}) => emit(state.copyWith(
        screen: AppScreen.whereTo,
        focusPickup: focusPickup,
      ));

  void setPickup(String address) => emit(state.copyWith(
        pickupAddress: address,
        focusPickup: false,
      ));

  void setPickupLocation({required double lat, required double lng, String label = 'Current Location'}) =>
      emit(state.copyWith(
        pickupAddress: label,
        pickupLat: lat,
        pickupLng: lng,
        focusPickup: false,
      ));
}
