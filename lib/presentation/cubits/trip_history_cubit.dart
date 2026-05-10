import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/entities/trip.dart';
import '../../domain/usecases/get_trip_history.dart';

class TripHistoryState {
  final List<Trip> trips;
  final bool isLoading;
  final String? error;

  const TripHistoryState({
    this.trips = const [],
    this.isLoading = true,
    this.error,
  });

  TripHistoryState copyWith({List<Trip>? trips, bool? isLoading, String? error}) =>
      TripHistoryState(
        trips: trips ?? this.trips,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}

class TripHistoryCubit extends Cubit<TripHistoryState> {
  final GetTripHistory _getTripHistory;

  TripHistoryCubit(this._getTripHistory) : super(const TripHistoryState());

  Future<void> load() async {
    final result = await _getTripHistory(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (trips) => emit(state.copyWith(trips: trips, isLoading: false)),
    );
  }
}
