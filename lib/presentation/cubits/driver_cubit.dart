import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/entities/driver.dart';
import '../../domain/usecases/get_assigned_driver.dart';

class DriverState {
  final Driver? driver;
  final bool isLoading;

  const DriverState({this.driver, this.isLoading = true});

  DriverState copyWith({Driver? driver, bool? isLoading}) => DriverState(
        driver: driver ?? this.driver,
        isLoading: isLoading ?? this.isLoading,
      );
}

class DriverCubit extends Cubit<DriverState> {
  final GetAssignedDriver _getAssignedDriver;

  DriverCubit(this._getAssignedDriver) : super(const DriverState());

  Future<void> load() async {
    final result = await _getAssignedDriver(const NoParams());
    result.fold(
      (_) => emit(state.copyWith(isLoading: false)),
      (driver) => emit(state.copyWith(driver: driver, isLoading: false)),
    );
  }
}
