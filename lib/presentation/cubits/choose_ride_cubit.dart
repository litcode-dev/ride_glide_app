import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/entities/ride_option.dart';
import '../../domain/usecases/get_ride_options.dart';

class ChooseRideState {
  final List<RideOption> options;
  final int selectedIndex;
  final bool isLoading;
  final String? error;

  const ChooseRideState({
    this.options = const [],
    this.selectedIndex = 1,
    this.isLoading = true,
    this.error,
  });

  ChooseRideState copyWith({
    List<RideOption>? options,
    int? selectedIndex,
    bool? isLoading,
    String? error,
  }) =>
      ChooseRideState(
        options: options ?? this.options,
        selectedIndex: selectedIndex ?? this.selectedIndex,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}

class ChooseRideCubit extends Cubit<ChooseRideState> {
  final GetRideOptions _getRideOptions;

  ChooseRideCubit(this._getRideOptions) : super(const ChooseRideState());

  Future<void> load() async {
    final result = await _getRideOptions(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (options) => emit(state.copyWith(options: options, isLoading: false)),
    );
  }

  void selectRide(int index) => emit(state.copyWith(selectedIndex: index));
}
