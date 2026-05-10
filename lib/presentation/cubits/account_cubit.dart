import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile.dart';

class AccountState {
  final UserProfile? profile;
  final bool isLoading;

  const AccountState({this.profile, this.isLoading = true});

  AccountState copyWith({UserProfile? profile, bool? isLoading}) => AccountState(
        profile: profile ?? this.profile,
        isLoading: isLoading ?? this.isLoading,
      );
}

class AccountCubit extends Cubit<AccountState> {
  final GetUserProfile _getUserProfile;

  AccountCubit(this._getUserProfile) : super(const AccountState());

  Future<void> load() async {
    final result = await _getUserProfile(const NoParams());
    result.fold(
      (_) => emit(state.copyWith(isLoading: false)),
      (profile) => emit(state.copyWith(profile: profile, isLoading: false)),
    );
  }
}
