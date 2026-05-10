import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/location.dart';
import '../../domain/usecases/search_locations.dart';

class WhereToState {
  final List<Location> suggestions;
  final bool isLoading;

  const WhereToState({this.suggestions = const [], this.isLoading = true});

  WhereToState copyWith({List<Location>? suggestions, bool? isLoading}) =>
      WhereToState(
        suggestions: suggestions ?? this.suggestions,
        isLoading: isLoading ?? this.isLoading,
      );
}

class WhereToCubit extends Cubit<WhereToState> {
  final SearchLocations _searchLocations;

  WhereToCubit(this._searchLocations) : super(const WhereToState());

  Future<void> load() async {
    final result = await _searchLocations(const SearchLocationsParams(''));
    result.fold(
      (_) => emit(state.copyWith(isLoading: false)),
      (suggestions) => emit(state.copyWith(suggestions: suggestions, isLoading: false)),
    );
  }
}
