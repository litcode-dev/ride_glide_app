import 'package:get_it/get_it.dart';
import 'data/datasources/local/chat_local_datasource.dart';
import 'data/datasources/local/driver_local_datasource.dart';
import 'data/datasources/local/location_local_datasource.dart';
import 'data/datasources/local/ride_local_datasource.dart';
import 'data/datasources/local/trip_local_datasource.dart';
import 'data/datasources/local/user_local_datasource.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'data/repositories/driver_repository_impl.dart';
import 'data/repositories/location_repository_impl.dart';
import 'data/repositories/ride_repository_impl.dart';
import 'data/repositories/trip_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/chat_repository.dart';
import 'domain/repositories/driver_repository.dart';
import 'domain/repositories/location_repository.dart';
import 'domain/repositories/ride_repository.dart';
import 'domain/repositories/trip_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/book_ride.dart';
import 'domain/usecases/get_assigned_driver.dart';
import 'domain/usecases/get_chat_conversations.dart';
import 'domain/usecases/get_chat_messages.dart';
import 'domain/usecases/get_ride_options.dart';
import 'domain/usecases/get_trip_history.dart';
import 'domain/usecases/get_user_profile.dart';
import 'domain/usecases/search_locations.dart';
import 'presentation/cubits/account_cubit.dart';
import 'presentation/cubits/app_cubit.dart';
import 'presentation/cubits/chat_cubit.dart';
import 'presentation/cubits/choose_ride_cubit.dart';
import 'presentation/cubits/driver_cubit.dart';
import 'presentation/cubits/trip_history_cubit.dart';
import 'presentation/cubits/where_to_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits — AppCubit is a singleton (owns navigation state)
  sl.registerLazySingleton(() => AppCubit());
  sl.registerFactory(() => ChooseRideCubit(sl()));
  sl.registerFactory(() => WhereToCubit(sl()));
  sl.registerFactory(() => DriverCubit(sl()));
  sl.registerFactory(() => AccountCubit(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetRideOptions(sl()));
  sl.registerLazySingleton(() => SearchLocations(sl()));
  sl.registerLazySingleton(() => GetAssignedDriver(sl()));
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => BookRide(sl()));

  // Repositories — bind abstractions to implementations
  sl.registerLazySingleton<RideRepository>(() => RideRepositoryImpl(sl()));
  sl.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl(sl()));
  sl.registerLazySingleton<DriverRepository>(() => DriverRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  // Datasources
  sl.registerLazySingleton<RideLocalDatasource>(() => RideLocalDatasourceImpl());
  sl.registerLazySingleton<LocationLocalDatasource>(() => LocationLocalDatasourceImpl());
  sl.registerLazySingleton<DriverLocalDatasource>(() => DriverLocalDatasourceImpl());
  sl.registerLazySingleton<UserLocalDatasource>(() => UserLocalDatasourceImpl());

  // Trip feature
  sl.registerFactory(() => TripHistoryCubit(sl()));
  sl.registerLazySingleton(() => GetTripHistory(sl()));
  sl.registerLazySingleton<TripRepository>(() => TripRepositoryImpl(sl()));
  sl.registerLazySingleton<TripLocalDatasource>(() => TripLocalDatasourceImpl());

  // Chat feature
  sl.registerFactory(() => ChatCubit(sl(), sl()));
  sl.registerLazySingleton(() => GetChatConversations(sl()));
  sl.registerLazySingleton(() => GetChatMessages(sl()));
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));
  sl.registerLazySingleton<ChatLocalDatasource>(() => ChatLocalDatasourceImpl());
}
