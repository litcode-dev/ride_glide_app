# Trips, Chat & Interactivity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Trips and Chat tabs with full pages, wire all dead-end buttons with live interactions, and make the FAB pulse during active rides.

**Architecture:** Clean Architecture layers already in place — add new entities/repos/usecases/datasources bottom-up, then cubits, then pages, then a final interactivity pass on existing screens. Each task is independently compilable and `flutter analyze` clean.

**Tech Stack:** Flutter, flutter_bloc (Cubits), get_it (DI), fpdart (Either), flutter_test (unit/widget tests)

---

## File Map

### New files
```
lib/domain/entities/trip.dart
lib/domain/entities/chat_conversation.dart
lib/domain/entities/chat_message.dart
lib/domain/repositories/trip_repository.dart
lib/domain/repositories/chat_repository.dart
lib/domain/usecases/get_trip_history.dart
lib/domain/usecases/get_chat_conversations.dart
lib/domain/usecases/get_chat_messages.dart
lib/data/datasources/local/trip_local_datasource.dart
lib/data/datasources/local/chat_local_datasource.dart
lib/data/repositories/trip_repository_impl.dart
lib/data/repositories/chat_repository_impl.dart
lib/presentation/cubits/trip_history_cubit.dart
lib/presentation/cubits/chat_cubit.dart
lib/presentation/pages/trips_page.dart
lib/presentation/pages/chat_inbox_page.dart
lib/presentation/pages/chat_thread_page.dart
lib/presentation/widgets/tap_scale.dart
lib/presentation/widgets/top_up_sheet.dart
lib/presentation/widgets/glide_toast.dart
lib/presentation/widgets/safety_sheet.dart
test/domain/usecases/get_trip_history_test.dart
test/domain/usecases/get_chat_conversations_test.dart
test/presentation/cubits/trip_history_cubit_test.dart
test/presentation/cubits/chat_cubit_test.dart
```

### Modified files
```
lib/injection_container.dart
lib/presentation/cubits/app_cubit.dart
lib/presentation/flow/glide_flow.dart
lib/presentation/widgets/common_widgets.dart
lib/presentation/pages/home_page.dart
lib/presentation/pages/choose_page.dart
lib/presentation/pages/driver_page.dart
lib/presentation/pages/account_page.dart
```

---

## Task 1: Domain entities

**Files:**
- Create: `lib/domain/entities/trip.dart`
- Create: `lib/domain/entities/chat_conversation.dart`
- Create: `lib/domain/entities/chat_message.dart`

- [ ] **Step 1: Create `trip.dart`**

```dart
// lib/domain/entities/trip.dart
enum RideType { glide, xl, lux, eco }
enum TripStatus { completed, cancelled }

class Trip {
  final String id;
  final String destination;
  final String originAddress;
  final String driverName;
  final int driverAvatarHue;
  final RideType rideType;
  final double price;
  final DateTime date;
  final int durationMinutes;
  final double? rating;
  final TripStatus status;

  const Trip({
    required this.id,
    required this.destination,
    required this.originAddress,
    required this.driverName,
    required this.driverAvatarHue,
    required this.rideType,
    required this.price,
    required this.date,
    required this.durationMinutes,
    this.rating,
    required this.status,
  });
}
```

- [ ] **Step 2: Create `chat_conversation.dart`**

```dart
// lib/domain/entities/chat_conversation.dart
class ChatConversation {
  final String id;
  final String driverName;
  final int driverAvatarHue;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String tripId;

  const ChatConversation({
    required this.id,
    required this.driverName,
    required this.driverAvatarHue,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.tripId,
  });
}
```

- [ ] **Step 3: Create `chat_message.dart`**

```dart
// lib/domain/entities/chat_message.dart
class ChatMessage {
  final String id;
  final String conversationId;
  final String body;
  final bool isFromDriver;
  final DateTime sentAt;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.body,
    required this.isFromDriver,
    required this.sentAt,
  });
}
```

- [ ] **Step 4: Verify**

```bash
flutter analyze lib/domain/entities/
```
Expected: `No issues found.`

- [ ] **Step 5: Commit**

```bash
git add lib/domain/entities/trip.dart lib/domain/entities/chat_conversation.dart lib/domain/entities/chat_message.dart
git commit -m "feat: add Trip, ChatConversation, ChatMessage domain entities"
```

---

## Task 2: Repository interfaces and use cases

**Files:**
- Create: `lib/domain/repositories/trip_repository.dart`
- Create: `lib/domain/repositories/chat_repository.dart`
- Create: `lib/domain/usecases/get_trip_history.dart`
- Create: `lib/domain/usecases/get_chat_conversations.dart`
- Create: `lib/domain/usecases/get_chat_messages.dart`
- Create: `test/domain/usecases/get_trip_history_test.dart`
- Create: `test/domain/usecases/get_chat_conversations_test.dart`

- [ ] **Step 1: Create `trip_repository.dart`**

```dart
// lib/domain/repositories/trip_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../entities/trip.dart';

abstract class TripRepository {
  Future<Either<Failure, List<Trip>>> getHistory();
}
```

- [ ] **Step 2: Create `chat_repository.dart`**

```dart
// lib/domain/repositories/chat_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../entities/chat_conversation.dart';
import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatConversation>>> getConversations();
  Future<Either<Failure, List<ChatMessage>>> getMessages(String conversationId);
}
```

- [ ] **Step 3: Create `get_trip_history.dart`**

```dart
// lib/domain/usecases/get_trip_history.dart
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/trip.dart';
import '../repositories/trip_repository.dart';

class GetTripHistory implements UseCase<List<Trip>, NoParams> {
  final TripRepository _repository;
  GetTripHistory(this._repository);

  @override
  Future<Either<Failure, List<Trip>>> call(NoParams params) =>
      _repository.getHistory();
}
```

- [ ] **Step 4: Create `get_chat_conversations.dart`**

```dart
// lib/domain/usecases/get_chat_conversations.dart
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/chat_conversation.dart';
import '../repositories/chat_repository.dart';

class GetChatConversations implements UseCase<List<ChatConversation>, NoParams> {
  final ChatRepository _repository;
  GetChatConversations(this._repository);

  @override
  Future<Either<Failure, List<ChatConversation>>> call(NoParams params) =>
      _repository.getConversations();
}
```

- [ ] **Step 5: Create `get_chat_messages.dart`**

```dart
// lib/domain/usecases/get_chat_messages.dart
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetChatMessagesParams {
  final String conversationId;
  const GetChatMessagesParams(this.conversationId);
}

class GetChatMessages implements UseCase<List<ChatMessage>, GetChatMessagesParams> {
  final ChatRepository _repository;
  GetChatMessages(this._repository);

  @override
  Future<Either<Failure, List<ChatMessage>>> call(GetChatMessagesParams params) =>
      _repository.getMessages(params.conversationId);
}
```

- [ ] **Step 6: Write failing use case tests**

```dart
// test/domain/usecases/get_trip_history_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ride_app/core/errors/failures.dart';
import 'package:ride_app/core/usecases/usecase.dart';
import 'package:ride_app/domain/entities/trip.dart';
import 'package:ride_app/domain/repositories/trip_repository.dart';
import 'package:ride_app/domain/usecases/get_trip_history.dart';

class _FakeTripRepository implements TripRepository {
  final Either<Failure, List<Trip>> result;
  _FakeTripRepository(this.result);

  @override
  Future<Either<Failure, List<Trip>>> getHistory() async => result;
}

void main() {
  test('returns trips from repository', () async {
    final trip = Trip(
      id: '1', destination: 'Spring St', originAddress: 'Home',
      driverName: 'Joe', driverAvatarHue: 42, rideType: RideType.glide,
      price: 8.40, date: DateTime(2026, 5, 1), durationMinutes: 12,
      rating: 4.9, status: TripStatus.completed,
    );
    final useCase = GetTripHistory(_FakeTripRepository(Right([trip])));
    final result = await useCase(const NoParams());
    expect(result, Right<Failure, List<Trip>>([trip]));
  });

  test('returns failure when repository fails', () async {
    final useCase = GetTripHistory(_FakeTripRepository(Left(ServerFailure())));
    final result = await useCase(const NoParams());
    expect(result.isLeft(), true);
  });
}
```

```dart
// test/domain/usecases/get_chat_conversations_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ride_app/core/errors/failures.dart';
import 'package:ride_app/core/usecases/usecase.dart';
import 'package:ride_app/domain/entities/chat_conversation.dart';
import 'package:ride_app/domain/entities/chat_message.dart';
import 'package:ride_app/domain/repositories/chat_repository.dart';
import 'package:ride_app/domain/usecases/get_chat_conversations.dart';

class _FakeChatRepository implements ChatRepository {
  final Either<Failure, List<ChatConversation>> result;
  _FakeChatRepository(this.result);

  @override
  Future<Either<Failure, List<ChatConversation>>> getConversations() async => result;

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(String id) async =>
      const Right([]);
}

void main() {
  test('returns conversations from repository', () async {
    final conv = ChatConversation(
      id: 'c1', driverName: 'Joe', driverAvatarHue: 42,
      lastMessage: 'On my way', lastMessageTime: DateTime(2026, 5, 1),
      unreadCount: 2, tripId: 't1',
    );
    final useCase = GetChatConversations(_FakeChatRepository(Right([conv])));
    final result = await useCase(const NoParams());
    expect(result, Right<Failure, List<ChatConversation>>([conv]));
  });

  test('returns failure when repository fails', () async {
    final useCase = GetChatConversations(_FakeChatRepository(Left(ServerFailure())));
    final result = await useCase(const NoParams());
    expect(result.isLeft(), true);
  });
}
```

- [ ] **Step 7: Run tests (expect pass — pure logic, no Flutter needed)**

```bash
flutter test test/domain/usecases/
```
Expected: `All tests passed!`

- [ ] **Step 8: Verify analyze**

```bash
flutter analyze lib/domain/
```
Expected: `No issues found.`

- [ ] **Step 9: Commit**

```bash
git add lib/domain/repositories/ lib/domain/usecases/get_trip_history.dart lib/domain/usecases/get_chat_conversations.dart lib/domain/usecases/get_chat_messages.dart test/domain/
git commit -m "feat: add TripRepository, ChatRepository interfaces and use cases"
```

---

## Task 3: In-memory datasources

**Files:**
- Create: `lib/data/datasources/local/trip_local_datasource.dart`
- Create: `lib/data/datasources/local/chat_local_datasource.dart`

- [ ] **Step 1: Create `trip_local_datasource.dart`**

```dart
// lib/data/datasources/local/trip_local_datasource.dart
import '../../../domain/entities/trip.dart';

abstract class TripLocalDatasource {
  Future<List<Trip>> getHistory();
}

class TripLocalDatasourceImpl implements TripLocalDatasource {
  @override
  Future<List<Trip>> getHistory() async => [
        Trip(
          id: 't1', destination: '47 Spring St', originAddress: '128 Mt Prospect Ave',
          driverName: 'Joe Smith', driverAvatarHue: 42, rideType: RideType.glide,
          price: 8.40, date: DateTime(2026, 5, 8, 14, 23), durationMinutes: 12,
          rating: 4.9, status: TripStatus.completed,
        ),
        Trip(
          id: 't2', destination: 'JFK Airport · Term 4', originAddress: '128 Mt Prospect Ave',
          driverName: 'Maria Lopez', driverAvatarHue: 200, rideType: RideType.xl,
          price: 54.20, date: DateTime(2026, 5, 5, 7, 10), durationMinutes: 48,
          rating: 5.0, status: TripStatus.completed,
        ),
        Trip(
          id: 't3', destination: 'Newark Penn Station', originAddress: '47 Spring St',
          driverName: 'Chris Park', driverAvatarHue: 310, rideType: RideType.eco,
          price: 11.80, date: DateTime(2026, 5, 2, 18, 45), durationMinutes: 19,
          rating: 4.7, status: TripStatus.completed,
        ),
        Trip(
          id: 't4', destination: 'Reservoir Park', originAddress: '128 Mt Prospect Ave',
          driverName: 'Sam Reed', driverAvatarHue: 90, rideType: RideType.glide,
          price: 6.20, date: DateTime(2026, 5, 1, 9, 0), durationMinutes: 8,
          status: TripStatus.cancelled,
        ),
        Trip(
          id: 't5', destination: 'Work — Studio', originAddress: '128 Mt Prospect Ave',
          driverName: 'Joe Smith', driverAvatarHue: 42, rideType: RideType.glide,
          price: 9.10, date: DateTime(2026, 4, 28, 8, 30), durationMinutes: 14,
          rating: 4.9, status: TripStatus.completed,
        ),
        Trip(
          id: 't6', destination: '47 Spring St', originAddress: 'Reservoir Park',
          driverName: 'Maria Lopez', driverAvatarHue: 200, rideType: RideType.lux,
          price: 16.80, date: DateTime(2026, 4, 22, 20, 15), durationMinutes: 22,
          rating: 5.0, status: TripStatus.completed,
        ),
        Trip(
          id: 't7', destination: 'Newark Penn Station', originAddress: '128 Mt Prospect Ave',
          driverName: 'Chris Park', driverAvatarHue: 310, rideType: RideType.eco,
          price: 12.40, date: DateTime(2026, 4, 15, 17, 0), durationMinutes: 21,
          rating: 4.6, status: TripStatus.completed,
        ),
        Trip(
          id: 't8', destination: 'JFK Airport · Term 4', originAddress: '47 Spring St',
          driverName: 'Sam Reed', driverAvatarHue: 90, rideType: RideType.xl,
          price: 48.50, date: DateTime(2026, 4, 10, 6, 0), durationMinutes: 55,
          rating: 4.8, status: TripStatus.completed,
        ),
      ];
}
```

- [ ] **Step 2: Create `chat_local_datasource.dart`**

```dart
// lib/data/datasources/local/chat_local_datasource.dart
import '../../../domain/entities/chat_conversation.dart';
import '../../../domain/entities/chat_message.dart';

abstract class ChatLocalDatasource {
  Future<List<ChatConversation>> getConversations();
  Future<List<ChatMessage>> getMessages(String conversationId);
}

class ChatLocalDatasourceImpl implements ChatLocalDatasource {
  static final _conversations = [
    ChatConversation(
      id: 'c1', driverName: 'Joe Smith', driverAvatarHue: 42,
      lastMessage: 'See you in 2 minutes!', lastMessageTime: DateTime(2026, 5, 8, 14, 21),
      unreadCount: 2, tripId: 't1',
    ),
    ChatConversation(
      id: 'c2', driverName: 'Maria Lopez', driverAvatarHue: 200,
      lastMessage: 'Have a great flight!', lastMessageTime: DateTime(2026, 5, 5, 7, 8),
      unreadCount: 0, tripId: 't2',
    ),
    ChatConversation(
      id: 'c3', driverName: 'Chris Park', driverAvatarHue: 310,
      lastMessage: 'Thanks! 5 stars for sure.', lastMessageTime: DateTime(2026, 5, 2, 19, 2),
      unreadCount: 0, tripId: 't3',
    ),
  ];

  static final _messages = {
    'c1': [
      ChatMessage(id: 'm1', conversationId: 'c1', body: 'Hi, I\'m on my way!', isFromDriver: true, sentAt: DateTime(2026, 5, 8, 14, 10)),
      ChatMessage(id: 'm2', conversationId: 'c1', body: 'On my way', isFromDriver: false, sentAt: DateTime(2026, 5, 8, 14, 11)),
      ChatMessage(id: 'm3', conversationId: 'c1', body: 'I\'m the white Tesla, plate NJ 7M3 K42', isFromDriver: true, sentAt: DateTime(2026, 5, 8, 14, 15)),
      ChatMessage(id: 'm4', conversationId: 'c1', body: 'Got it, thanks!', isFromDriver: false, sentAt: DateTime(2026, 5, 8, 14, 16)),
      ChatMessage(id: 'm5', conversationId: 'c1', body: 'I\'ll be at the corner in 2 min', isFromDriver: true, sentAt: DateTime(2026, 5, 8, 14, 20)),
      ChatMessage(id: 'm6', conversationId: 'c1', body: 'See you in 2 minutes!', isFromDriver: true, sentAt: DateTime(2026, 5, 8, 14, 21)),
    ],
    'c2': [
      ChatMessage(id: 'm7', conversationId: 'c2', body: 'Good morning! Ready when you are.', isFromDriver: true, sentAt: DateTime(2026, 5, 5, 7, 0)),
      ChatMessage(id: 'm8', conversationId: 'c2', body: '5 minutes away', isFromDriver: false, sentAt: DateTime(2026, 5, 5, 7, 1)),
      ChatMessage(id: 'm9', conversationId: 'c2', body: 'No rush, I\'m right outside terminal 2', isFromDriver: true, sentAt: DateTime(2026, 5, 5, 7, 3)),
      ChatMessage(id: 'm10', conversationId: 'c2', body: 'Which terminal are you parked at?', isFromDriver: false, sentAt: DateTime(2026, 5, 5, 7, 4)),
      ChatMessage(id: 'm11', conversationId: 'c2', body: 'Terminal 4 departure drop-off', isFromDriver: true, sentAt: DateTime(2026, 5, 5, 7, 6)),
      ChatMessage(id: 'm12', conversationId: 'c2', body: 'Have a great flight!', isFromDriver: true, sentAt: DateTime(2026, 5, 5, 7, 8)),
    ],
    'c3': [
      ChatMessage(id: 'm13', conversationId: 'c3', body: 'Arrived at Penn Station, have a good evening!', isFromDriver: true, sentAt: DateTime(2026, 5, 2, 19, 0)),
      ChatMessage(id: 'm14', conversationId: 'c3', body: 'Thanks!', isFromDriver: false, sentAt: DateTime(2026, 5, 2, 19, 1)),
      ChatMessage(id: 'm15', conversationId: 'c3', body: 'Great ride, very smooth', isFromDriver: false, sentAt: DateTime(2026, 5, 2, 19, 1)),
      ChatMessage(id: 'm16', conversationId: 'c3', body: 'Appreciate it! Safe travels.', isFromDriver: true, sentAt: DateTime(2026, 5, 2, 19, 2)),
      ChatMessage(id: 'm17', conversationId: 'c3', body: 'Thanks! 5 stars for sure.', isFromDriver: false, sentAt: DateTime(2026, 5, 2, 19, 2)),
    ],
  };

  @override
  Future<List<ChatConversation>> getConversations() async => _conversations;

  @override
  Future<List<ChatMessage>> getMessages(String conversationId) async =>
      _messages[conversationId] ?? [];
}
```

- [ ] **Step 3: Verify**

```bash
flutter analyze lib/data/datasources/
```
Expected: `No issues found.`

- [ ] **Step 4: Commit**

```bash
git add lib/data/datasources/local/trip_local_datasource.dart lib/data/datasources/local/chat_local_datasource.dart
git commit -m "feat: add trip and chat in-memory datasources with seed data"
```

---

## Task 4: Repository implementations and DI wiring

**Files:**
- Create: `lib/data/repositories/trip_repository_impl.dart`
- Create: `lib/data/repositories/chat_repository_impl.dart`
- Modify: `lib/injection_container.dart`

- [ ] **Step 1: Create `trip_repository_impl.dart`**

```dart
// lib/data/repositories/trip_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/trip.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/local/trip_local_datasource.dart';

class TripRepositoryImpl implements TripRepository {
  final TripLocalDatasource _datasource;
  TripRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<Trip>>> getHistory() async {
    try {
      return Right(await _datasource.getHistory());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
```

- [ ] **Step 2: Create `chat_repository_impl.dart`**

```dart
// lib/data/repositories/chat_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/local/chat_local_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDatasource _datasource;
  ChatRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<ChatConversation>>> getConversations() async {
    try {
      return Right(await _datasource.getConversations());
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(String conversationId) async {
    try {
      return Right(await _datasource.getMessages(conversationId));
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
```

- [ ] **Step 3: Add registrations to `injection_container.dart`**

Add these imports at the top (after existing imports):
```dart
import 'data/datasources/local/chat_local_datasource.dart';
import 'data/datasources/local/trip_local_datasource.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'data/repositories/trip_repository_impl.dart';
import 'domain/repositories/chat_repository.dart';
import 'domain/repositories/trip_repository.dart';
import 'domain/usecases/get_chat_conversations.dart';
import 'domain/usecases/get_chat_messages.dart';
import 'domain/usecases/get_trip_history.dart';
import 'presentation/cubits/chat_cubit.dart';
import 'presentation/cubits/trip_history_cubit.dart';
```

Add these registrations inside `init()` after the existing ones:
```dart
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
```

- [ ] **Step 4: Verify (TripHistoryCubit and ChatCubit stubs needed — analyze will fail until Task 5; skip for now)**

```bash
flutter analyze lib/data/repositories/
```
Expected: `No issues found.`

- [ ] **Step 5: Commit**

```bash
git add lib/data/repositories/trip_repository_impl.dart lib/data/repositories/chat_repository_impl.dart lib/injection_container.dart
git commit -m "feat: add trip/chat repository implementations and DI wiring"
```

---

## Task 5: AppCubit navigation extensions

**Files:**
- Modify: `lib/presentation/cubits/app_cubit.dart`

- [ ] **Step 1: Replace `app_cubit.dart` content**

```dart
// lib/presentation/cubits/app_cubit.dart
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
```

- [ ] **Step 2: Verify**

```bash
flutter analyze lib/presentation/cubits/app_cubit.dart
```
Expected: `No issues found.`

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/cubits/app_cubit.dart
git commit -m "feat: extend AppCubit with trips/chat screens and goToChat"
```

---

## Task 6: TripHistoryCubit and ChatCubit

**Files:**
- Create: `lib/presentation/cubits/trip_history_cubit.dart`
- Create: `lib/presentation/cubits/chat_cubit.dart`
- Create: `test/presentation/cubits/trip_history_cubit_test.dart`
- Create: `test/presentation/cubits/chat_cubit_test.dart`

- [ ] **Step 1: Create `trip_history_cubit.dart`**

```dart
// lib/presentation/cubits/trip_history_cubit.dart
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
```

- [ ] **Step 2: Create `chat_cubit.dart`**

```dart
// lib/presentation/cubits/chat_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/get_chat_conversations.dart';
import '../../domain/usecases/get_chat_messages.dart';

class ChatState {
  final List<ChatConversation> conversations;
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.conversations = const [],
    this.messages = const [],
    this.isLoading = true,
    this.error,
  });

  ChatState copyWith({
    List<ChatConversation>? conversations,
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) =>
      ChatState(
        conversations: conversations ?? this.conversations,
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}

class ChatCubit extends Cubit<ChatState> {
  final GetChatConversations _getConversations;
  final GetChatMessages _getMessages;

  ChatCubit(this._getConversations, this._getMessages) : super(const ChatState());

  Future<void> loadConversations() async {
    final result = await _getConversations(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (conversations) => emit(state.copyWith(conversations: conversations, isLoading: false)),
    );
  }

  Future<void> loadMessages(String conversationId) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getMessages(GetChatMessagesParams(conversationId));
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (messages) => emit(state.copyWith(messages: messages, isLoading: false)),
    );
  }

  void sendMessage(String body) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: '',
      body: body,
      isFromDriver: false,
      sentAt: DateTime.now(),
    );
    emit(state.copyWith(messages: [...state.messages, message]));
  }
}
```

- [ ] **Step 3: Write cubit tests**

```dart
// test/presentation/cubits/trip_history_cubit_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ride_app/core/errors/failures.dart';
import 'package:ride_app/core/usecases/usecase.dart';
import 'package:ride_app/domain/entities/trip.dart';
import 'package:ride_app/domain/repositories/trip_repository.dart';
import 'package:ride_app/domain/usecases/get_trip_history.dart';
import 'package:ride_app/presentation/cubits/trip_history_cubit.dart';

class _FakeTripRepository implements TripRepository {
  final Either<Failure, List<Trip>> result;
  _FakeTripRepository(this.result);
  @override
  Future<Either<Failure, List<Trip>>> getHistory() async => result;
}

void main() {
  final trip = Trip(
    id: '1', destination: 'Spring St', originAddress: 'Home',
    driverName: 'Joe', driverAvatarHue: 42, rideType: RideType.glide,
    price: 8.40, date: DateTime(2026, 5, 1), durationMinutes: 12,
    rating: 4.9, status: TripStatus.completed,
  );

  test('emits trips on successful load', () async {
    final cubit = TripHistoryCubit(GetTripHistory(_FakeTripRepository(Right([trip]))));
    await cubit.load();
    expect(cubit.state.trips, [trip]);
    expect(cubit.state.isLoading, false);
    expect(cubit.state.error, isNull);
  });

  test('emits error on failure', () async {
    final cubit = TripHistoryCubit(GetTripHistory(_FakeTripRepository(Left(ServerFailure()))));
    await cubit.load();
    expect(cubit.state.trips, isEmpty);
    expect(cubit.state.isLoading, false);
    expect(cubit.state.error, 'Server error');
  });
}
```

```dart
// test/presentation/cubits/chat_cubit_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ride_app/core/errors/failures.dart';
import 'package:ride_app/core/usecases/usecase.dart';
import 'package:ride_app/domain/entities/chat_conversation.dart';
import 'package:ride_app/domain/entities/chat_message.dart';
import 'package:ride_app/domain/repositories/chat_repository.dart';
import 'package:ride_app/domain/usecases/get_chat_conversations.dart';
import 'package:ride_app/domain/usecases/get_chat_messages.dart';
import 'package:ride_app/presentation/cubits/chat_cubit.dart';

class _FakeChatRepository implements ChatRepository {
  @override
  Future<Either<Failure, List<ChatConversation>>> getConversations() async => Right([
        ChatConversation(
          id: 'c1', driverName: 'Joe', driverAvatarHue: 42,
          lastMessage: 'Hi', lastMessageTime: DateTime(2026, 5, 1),
          unreadCount: 1, tripId: 't1',
        ),
      ]);

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(String id) async => Right([
        ChatMessage(id: 'm1', conversationId: id, body: 'Hello', isFromDriver: true, sentAt: DateTime(2026, 5, 1)),
      ]);
}

void main() {
  ChatCubit makeCubit() {
    final repo = _FakeChatRepository();
    return ChatCubit(GetChatConversations(repo), GetChatMessages(repo));
  }

  test('loads conversations', () async {
    final cubit = makeCubit();
    await cubit.loadConversations();
    expect(cubit.state.conversations.length, 1);
    expect(cubit.state.isLoading, false);
  });

  test('loads messages for a conversation', () async {
    final cubit = makeCubit();
    await cubit.loadMessages('c1');
    expect(cubit.state.messages.length, 1);
    expect(cubit.state.messages.first.body, 'Hello');
  });

  test('sendMessage appends to messages list', () async {
    final cubit = makeCubit();
    await cubit.loadMessages('c1');
    cubit.sendMessage('Thanks!');
    expect(cubit.state.messages.length, 2);
    expect(cubit.state.messages.last.body, 'Thanks!');
    expect(cubit.state.messages.last.isFromDriver, false);
  });
}
```

- [ ] **Step 4: Run tests**

```bash
flutter test test/presentation/cubits/
```
Expected: `All tests passed!`

- [ ] **Step 5: Verify analyze**

```bash
flutter analyze lib/presentation/cubits/
```
Expected: `No issues found.`

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/cubits/trip_history_cubit.dart lib/presentation/cubits/chat_cubit.dart test/presentation/
git commit -m "feat: add TripHistoryCubit and ChatCubit with tests"
```

---

## Task 7: GlideFlow and GlideTabBar updates

**Files:**
- Modify: `lib/presentation/flow/glide_flow.dart`
- Modify: `lib/presentation/widgets/common_widgets.dart`

- [ ] **Step 1: Replace `glide_flow.dart`**

```dart
// lib/presentation/flow/glide_flow.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart' as di;
import '../cubits/app_cubit.dart';
import '../cubits/chat_cubit.dart';
import '../pages/account_page.dart';
import '../pages/chat_inbox_page.dart';
import '../pages/chat_thread_page.dart';
import '../pages/choose_page.dart';
import '../pages/driver_page.dart';
import '../pages/home_page.dart';
import '../pages/searching_page.dart';
import '../pages/trips_page.dart';
import '../pages/where_to_page.dart';

class GlideFlow extends StatelessWidget {
  const GlideFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        SystemChrome.setSystemUIOverlayStyle(
          state.darkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        );

        final Widget page = switch (state.screen) {
          AppScreen.whereTo => const WhereToPage(key: ValueKey('whereto')),
          AppScreen.choose => const ChoosePage(key: ValueKey('choose')),
          AppScreen.searching => const SearchingPage(key: ValueKey('searching')),
          AppScreen.driver => const DriverPage(key: ValueKey('driver')),
          AppScreen.account => const AccountPage(key: ValueKey('account')),
          AppScreen.trips => const TripsPage(key: ValueKey('trips')),
          AppScreen.chatInbox => BlocProvider(
              key: const ValueKey('chatInbox'),
              create: (_) => di.sl<ChatCubit>()..loadConversations(),
              child: const ChatInboxPage(),
            ),
          AppScreen.chatThread => BlocProvider(
              key: ValueKey('chatThread-${state.activeConversationId}'),
              create: (_) => di.sl<ChatCubit>()..loadMessages(state.activeConversationId ?? ''),
              child: const ChatThreadPage(),
            ),
          AppScreen.home => const HomePage(key: ValueKey('home')),
        };

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slide, child: child),
            );
          },
          child: page,
        );
      },
    );
  }
}
```

- [ ] **Step 2: Update `GlideTabBar` in `common_widgets.dart`**

Replace the `GlideTabBar` class and `GlideFAB` class with these versions (find them in the file and replace each):

```dart
// Replace GlideFAB class
class GlideFAB extends StatefulWidget {
  final bool isRideActive;
  final double size;

  const GlideFAB({super.key, this.size = 56, this.isRideActive = false});

  @override
  State<GlideFAB> createState() => _GlideFABState();
}

class _GlideFABState extends State<GlideFAB> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    if (widget.isRideActive) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(GlideFAB old) {
    super.didUpdateWidget(old);
    if (widget.isRideActive && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.isRideActive && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final scale = widget.isRideActive ? 1.0 + _pulse.value * 0.08 : 1.0;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kAccent,
          boxShadow: [
            BoxShadow(color: kAccent.withValues(alpha: 0.20), blurRadius: 0, spreadRadius: 6),
            BoxShadow(color: kAccent.withValues(alpha: 0.40), blurRadius: 18),
            const BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: const Icon(Icons.local_taxi_rounded, color: kAccentInk, size: 26),
      ),
    );
  }
}
```

```dart
// Replace GlideTabBar class
class GlideTabBar extends StatelessWidget {
  final String active;
  final GlideTokens tokens;
  final VoidCallback? onHome;
  final VoidCallback? onSettings;
  final VoidCallback? onTrips;
  final VoidCallback? onChat;
  final bool isRideActive;

  const GlideTabBar({
    super.key,
    this.active = 'home',
    required this.tokens,
    this.onHome,
    this.onSettings,
    this.onTrips,
    this.onChat,
    this.isRideActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: const [0.0, 0.55, 1.0],
          colors: [tokens.bg, tokens.bg, tokens.bg.withValues(alpha: 0)],
        ),
      ),
      padding: EdgeInsets.only(
        bottom: bottomPad > 0 ? bottomPad : 22,
        left: 16,
        right: 16,
        top: 18,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 76,
            decoration: BoxDecoration(
              color: tokens.card,
              borderRadius: BorderRadius.circular(28),
              boxShadow: tokens.shadowMd,
            ),
            child: Row(
              children: [
                _TabItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  active: active == 'home',
                  tokens: tokens,
                  onTap: onHome,
                ),
                _TabItem(
                  icon: Icons.access_time_rounded,
                  label: 'Trips',
                  active: active == 'history',
                  tokens: tokens,
                  onTap: onTrips,
                ),
                Expanded(flex: 6, child: const SizedBox()),
                _TabItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Chat',
                  active: active == 'chat',
                  tokens: tokens,
                  onTap: onChat,
                ),
                _TabItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings_rounded,
                  label: 'Account',
                  active: active == 'settings',
                  tokens: tokens,
                  onTap: onSettings,
                ),
              ],
            ),
          ),
          Positioned(top: -28, child: GlideFAB(isRideActive: isRideActive)),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Verify**

```bash
flutter analyze lib/presentation/flow/ lib/presentation/widgets/common_widgets.dart
```
Expected: `No issues found.`

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/flow/glide_flow.dart lib/presentation/widgets/common_widgets.dart
git commit -m "feat: wire trips/chat screens in GlideFlow, add FAB pulse and tab callbacks"
```

---

## Task 8: Shared interactive widgets (TapScale, TopUpSheet, GlideToast, SafetySheet)

**Files:**
- Create: `lib/presentation/widgets/tap_scale.dart`
- Create: `lib/presentation/widgets/top_up_sheet.dart`
- Create: `lib/presentation/widgets/glide_toast.dart`
- Create: `lib/presentation/widgets/safety_sheet.dart`

- [ ] **Step 1: Create `tap_scale.dart`**

```dart
// lib/presentation/widgets/tap_scale.dart
import 'package:flutter/material.dart';

class TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const TapScale({super.key, required this.child, this.onTap});

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(scale: _scale.value, child: child),
        child: widget.child,
      ),
    );
  }
}
```

- [ ] **Step 2: Create `glide_toast.dart`**

```dart
// lib/presentation/widgets/glide_toast.dart
import 'package:flutter/material.dart';
import '../theme/glide_tokens.dart';

void showGlideToast(BuildContext context, String message, GlideTokens tokens) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => _GlideToastOverlay(
      message: message,
      tokens: tokens,
      onDone: () => entry.remove(),
    ),
  );

  overlay.insert(entry);
}

class _GlideToastOverlay extends StatefulWidget {
  final String message;
  final GlideTokens tokens;
  final VoidCallback onDone;

  const _GlideToastOverlay({
    required this.message,
    required this.tokens,
    required this.onDone,
  });

  @override
  State<_GlideToastOverlay> createState() => _GlideToastOverlayState();
}

class _GlideToastOverlayState extends State<_GlideToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) _ctrl.reverse().then((_) => widget.onDone());
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Positioned(
      left: 24,
      right: 24,
      bottom: bottomPad + 110,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _opacity,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: widget.tokens.ink,
                borderRadius: BorderRadius.circular(16),
                boxShadow: widget.tokens.shadowMd,
              ),
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.tokens.bg,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Create `top_up_sheet.dart`**

```dart
// lib/presentation/widgets/top_up_sheet.dart
import 'package:flutter/material.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';
import 'glide_toast.dart';

void showTopUpSheet(BuildContext context, GlideTokens tokens) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _TopUpSheet(tokens: tokens),
  );
}

class _TopUpSheet extends StatefulWidget {
  final GlideTokens tokens;
  const _TopUpSheet({required this.tokens});

  @override
  State<_TopUpSheet> createState() => _TopUpSheetState();
}

class _TopUpSheetState extends State<_TopUpSheet> {
  int _selectedIndex = 1;
  final _amounts = [10, 25, 50];

  GlideTokens get t => widget.tokens;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(22, 14, 22, bottomPad + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SheetHandle(tokens: t),
          const SizedBox(height: 16),
          Text(
            'Top Up Wallet',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: t.ink,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose an amount to add',
            style: TextStyle(fontSize: 13, color: t.muted),
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(_amounts.length, (i) {
              final selected = i == _selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.only(right: i < _amounts.length - 1 ? 10 : 0),
                    height: 54,
                    decoration: BoxDecoration(
                      color: selected ? t.accent : t.subtle,
                      borderRadius: BorderRadius.circular(16),
                      border: selected
                          ? null
                          : Border.all(color: t.hair2, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '£${_amounts[i]}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: selected ? t.accentInk : t.ink,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              final amount = _amounts[_selectedIndex];
              Navigator.of(context).pop();
              showGlideToast(context, '£$amount added to your wallet ✓', t);
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: t.accent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: t.accent.withValues(alpha: 0.40),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'Add to wallet',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: t.accentInk,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Create `safety_sheet.dart`**

```dart
// lib/presentation/widgets/safety_sheet.dart
import 'package:flutter/material.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';

void showSafetySheet(BuildContext context, GlideTokens tokens) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _SafetySheet(tokens: tokens),
  );
}

class _SafetySheet extends StatelessWidget {
  final GlideTokens tokens;
  const _SafetySheet({required this.tokens});

  static const _contacts = [
    (name: 'Emergency Services', phone: '911', hue: 0),
    (name: 'Sarah Hales', phone: '+1 (555) 248-1132', hue: 160),
    (name: 'Marcus Johnson', phone: '+1 (555) 879-4400', hue: 240),
  ];

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(22, 14, 22, bottomPad + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SheetHandle(tokens: t),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: t.cancelBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.verified_user_outlined, color: t.cancelInk, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                'Safety',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: t.ink,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Emergency contacts',
            style: TextStyle(fontSize: 13, color: t.muted),
          ),
          const SizedBox(height: 16),
          ..._contacts.map((c) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: t.subtle,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    GlideAvatar(size: 42, hue: c.hue, cardColor: t.card),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: t.ink,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Text(c.phone, style: TextStyle(fontSize: 12, color: t.muted)),
                        ],
                      ),
                    ),
                    GlideIconPill(
                      icon: Icons.phone_rounded,
                      tokens: t,
                      bgColor: t.accent,
                      iconColor: t.accentInk,
                      iconSize: 16,
                      size: 38,
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: t.subtle,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: t.hair2),
              ),
              alignment: Alignment.center,
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: t.ink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Verify**

```bash
flutter analyze lib/presentation/widgets/tap_scale.dart lib/presentation/widgets/top_up_sheet.dart lib/presentation/widgets/glide_toast.dart lib/presentation/widgets/safety_sheet.dart
```
Expected: `No issues found.`

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/widgets/tap_scale.dart lib/presentation/widgets/top_up_sheet.dart lib/presentation/widgets/glide_toast.dart lib/presentation/widgets/safety_sheet.dart
git commit -m "feat: add TapScale, TopUpSheet, GlideToast, SafetySheet widgets"
```

---

## Task 9: TripsPage

**Files:**
- Create: `lib/presentation/pages/trips_page.dart`

- [ ] **Step 1: Create `trips_page.dart`**

```dart
// lib/presentation/pages/trips_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/trip.dart';
import '../../injection_container.dart' as di;
import '../cubits/app_cubit.dart';
import '../cubits/trip_history_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';
import '../widgets/tap_scale.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<TripHistoryCubit>()..load(),
      child: const _TripsView(),
    );
  }
}

class _TripsView extends StatefulWidget {
  const _TripsView();

  @override
  State<_TripsView> createState() => _TripsViewState();
}

class _TripsViewState extends State<_TripsView> {
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppCubit>().state;
    final tripState = context.watch<TripHistoryCubit>().state;
    final t = GlideTokens(dark: appState.darkMode);
    final appCubit = context.read<AppCubit>();
    final topPad = MediaQuery.of(context).padding.top;

    // Group trips by month
    final grouped = <String, List<Trip>>{};
    for (final trip in tripState.trips) {
      final key = DateFormat('MMMM yyyy').format(trip.date).toUpperCase();
      grouped.putIfAbsent(key, () => []).add(trip);
    }

    // Summary stats for current month
    final now = DateTime.now();
    final thisMonthKey = DateFormat('MMMM yyyy').format(now).toUpperCase();
    final thisMonthTrips = grouped[thisMonthKey] ?? [];
    final thisMonthSpend = thisMonthTrips
        .where((t) => t.status == TripStatus.completed)
        .fold(0.0, (sum, t) => sum + t.price);

    // 4-week data for chart (last 4 weeks)
    final weekSpend = List.generate(4, (i) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + (3 - i) * 7));
      final weekEnd = weekStart.add(const Duration(days: 6));
      return tripState.trips
          .where((trip) =>
              trip.status == TripStatus.completed &&
              !trip.date.isBefore(weekStart) &&
              !trip.date.isAfter(weekEnd))
          .fold(0.0, (sum, trip) => sum + trip.price);
    });

    final sections = grouped.entries.toList();

    return Container(
      color: t.bg,
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 0),
            child: Row(
              children: [
                GlideBackButton(onTap: () => appCubit.goTo(AppScreen.home), tokens: t),
                Expanded(
                  child: Center(
                    child: Text(
                      'Trips',
                      style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700,
                        color: t.ink, letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: tripState.isLoading
                ? const SizedBox()
                : ListView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 110,
                    ),
                    children: [
                      // Summary card
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: t.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: t.accent.withValues(alpha: 0.3), width: 1),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('MMMM yyyy').format(now).toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11, fontWeight: FontWeight.w700,
                                            color: t.muted, letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '\$${thisMonthSpend.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 28, fontWeight: FontWeight.w800,
                                            color: t.ink, letterSpacing: -0.5,
                                          ),
                                        ),
                                        Text(
                                          '${thisMonthTrips.length} trips this month',
                                          style: TextStyle(fontSize: 13, color: t.muted),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _SpendChart(weekSpend: weekSpend, tokens: t),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Grouped trip lists
                      for (final section in sections) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
                          child: Text(
                            section.key,
                            style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700,
                              color: t.muted, letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        for (final trip in section.value)
                          _TripRow(
                            trip: trip,
                            tokens: t,
                            expanded: _expandedId == trip.id,
                            onTap: () => setState(() =>
                                _expandedId = _expandedId == trip.id ? null : trip.id),
                            onBookAgain: () => appCubit.goTo(AppScreen.whereTo),
                          ),
                      ],
                    ],
                  ),
          ),

          GlideTabBar(
            active: 'history',
            tokens: t,
            onHome: () => appCubit.goTo(AppScreen.home),
            onSettings: () => appCubit.goTo(AppScreen.account),
            onTrips: () {},
            onChat: () => appCubit.goTo(AppScreen.chatInbox),
            isRideActive: appState.isRideActive,
          ),
        ],
      ),
    );
  }
}

class _TripRow extends StatelessWidget {
  final Trip trip;
  final GlideTokens tokens;
  final bool expanded;
  final VoidCallback onTap;
  final VoidCallback onBookAgain;

  const _TripRow({
    required this.trip,
    required this.tokens,
    required this.expanded,
    required this.onTap,
    required this.onBookAgain,
  });

  IconData get _rideIcon => switch (trip.rideType) {
        RideType.xl => Icons.airport_shuttle_rounded,
        RideType.lux => Icons.star_rounded,
        RideType.eco => Icons.eco_rounded,
        _ => Icons.local_taxi_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    final isCancelled = trip.status == TripStatus.cancelled;
    final dateStr = DateFormat('MMM d · h:mm a').format(trip.date);

    return TapScale(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
        child: Container(
          decoration: BoxDecoration(
            color: t.card,
            borderRadius: BorderRadius.circular(20),
            boxShadow: t.shadowSm,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Avatar + ride type badge
                    Stack(
                      children: [
                        GlideAvatar(size: 46, hue: trip.driverAvatarHue, cardColor: t.card),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: t.card,
                              shape: BoxShape.circle,
                              border: Border.all(color: t.hair, width: 1),
                            ),
                            child: Icon(_rideIcon, size: 10, color: t.ink),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.destination,
                            style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700,
                              color: t.ink, letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$dateStr · ${trip.durationMinutes} min',
                            style: TextStyle(fontSize: 12, color: t.muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (isCancelled)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: t.cancelBg,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Cancelled',
                              style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w700, color: t.cancelInk,
                              ),
                            ),
                          )
                        else ...[
                          Text(
                            '\$${trip.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700,
                              color: t.ink, letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          _StarDots(rating: trip.rating ?? 0, tokens: t),
                        ],
                        const SizedBox(height: 4),
                        Icon(
                          expanded ? Icons.keyboard_arrow_up_rounded : Icons.chevron_right_rounded,
                          color: t.muted, size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Expandable detail
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: expanded
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: t.hair)),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        child: Column(
                          children: [
                            // Mini route
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 10, height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: t.accent, width: 2.5),
                                      ),
                                    ),
                                    Container(width: 2, height: 24, color: t.hair2),
                                    Container(
                                      width: 10, height: 10,
                                      decoration: BoxDecoration(
                                        color: t.ink,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trip.originAddress,
                                        style: TextStyle(fontSize: 13, color: t.ink, fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        trip.destination,
                                        style: TextStyle(fontSize: 13, color: t.ink, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            GestureDetector(
                              onTap: onBookAgain,
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: t.accent,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: t.accent.withValues(alpha: 0.35),
                                      blurRadius: 12, offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Book again',
                                  style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w800,
                                    color: t.accentInk, letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StarDots extends StatelessWidget {
  final double rating;
  final GlideTokens tokens;

  const _StarDots({required this.rating, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) => Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Container(
          width: 6, height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < rating.round() ? tokens.accent : tokens.hair2,
          ),
        ),
      )),
    );
  }
}

class _SpendChart extends StatelessWidget {
  final List<double> weekSpend;
  final GlideTokens tokens;

  const _SpendChart({required this.weekSpend, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final maxVal = weekSpend.reduce((a, b) => a > b ? a : b).clamp(1.0, double.infinity);
    return SizedBox(
      width: 80, height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(weekSpend.length, (i) {
          final h = (weekSpend[i] / maxVal) * 40;
          final isCurrent = i == weekSpend.length - 1;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: i > 0 ? 4 : 0),
              child: Container(
                height: h.clamp(4, 40),
                decoration: BoxDecoration(
                  color: isCurrent ? tokens.accent : tokens.hair2,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
```

- [ ] **Step 2: Add `intl` to `pubspec.yaml`**

```yaml
  intl: ^0.19.0
```
Add it under the existing dependencies and run:
```bash
flutter pub get
```

- [ ] **Step 3: Verify**

```bash
flutter analyze lib/presentation/pages/trips_page.dart
```
Expected: `No issues found.`

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/pages/trips_page.dart pubspec.yaml pubspec.lock
git commit -m "feat: add TripsPage with summary card, grouped list and expandable rows"
```

---

## Task 10: ChatInboxPage and ChatThreadPage

**Files:**
- Create: `lib/presentation/pages/chat_inbox_page.dart`
- Create: `lib/presentation/pages/chat_thread_page.dart`

- [ ] **Step 1: Create `chat_inbox_page.dart`**

```dart
// lib/presentation/pages/chat_inbox_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/app_cubit.dart';
import '../cubits/chat_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';
import '../widgets/tap_scale.dart';

class ChatInboxPage extends StatelessWidget {
  const ChatInboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppCubit>().state;
    final chatState = context.watch<ChatCubit>().state;
    final t = GlideTokens(dark: appState.darkMode);
    final appCubit = context.read<AppCubit>();
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      color: t.bg,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Messages',
                style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800,
                  color: t.ink, letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          Expanded(
            child: chatState.isLoading
                ? const SizedBox()
                : chatState.conversations.isEmpty
                    ? Center(
                        child: Text(
                          'No messages yet',
                          style: TextStyle(fontSize: 15, color: t.muted),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom + 110,
                        ),
                        itemCount: chatState.conversations.length,
                        itemBuilder: (_, i) {
                          final conv = chatState.conversations[i];
                          final timeStr = DateFormat('MMM d').format(conv.lastMessageTime);
                          return TapScale(
                            onTap: () => appCubit.goToChat(conv.id),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                decoration: BoxDecoration(
                                  color: t.card,
                                  border: Border(bottom: BorderSide(color: t.hair)),
                                ),
                                child: Row(
                                  children: [
                                    GlideAvatar(size: 48, hue: conv.driverAvatarHue, cardColor: t.card),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            conv.driverName,
                                            style: TextStyle(
                                              fontSize: 15, fontWeight: FontWeight.w700,
                                              color: t.ink, letterSpacing: -0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            conv.lastMessage,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 13, color: t.muted),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(timeStr, style: TextStyle(fontSize: 11, color: t.muted)),
                                        const SizedBox(height: 4),
                                        if (conv.unreadCount > 0)
                                          Container(
                                            width: 20, height: 20,
                                            decoration: BoxDecoration(
                                              color: t.accent,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${conv.unreadCount}',
                                              style: TextStyle(
                                                fontSize: 11, fontWeight: FontWeight.w800,
                                                color: t.accentInk,
                                              ),
                                            ),
                                          )
                                        else
                                          const SizedBox(width: 20, height: 20),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          GlideTabBar(
            active: 'chat',
            tokens: t,
            onHome: () => appCubit.goTo(AppScreen.home),
            onSettings: () => appCubit.goTo(AppScreen.account),
            onTrips: () => appCubit.goTo(AppScreen.trips),
            onChat: () {},
            isRideActive: appState.isRideActive,
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Create `chat_thread_page.dart`**

```dart
// lib/presentation/pages/chat_thread_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/chat_message.dart';
import '../cubits/app_cubit.dart';
import '../cubits/chat_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';
import '../widgets/tap_scale.dart';

class ChatThreadPage extends StatefulWidget {
  const ChatThreadPage({super.key});

  @override
  State<ChatThreadPage> createState() => _ChatThreadPageState();
}

class _ChatThreadPageState extends State<ChatThreadPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send(ChatCubit cubit, String body) {
    cubit.sendMessage(body);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppCubit>().state;
    final chatState = context.watch<ChatCubit>().state;
    final t = GlideTokens(dark: appState.darkMode);
    final appCubit = context.read<AppCubit>();
    final chatCubit = context.read<ChatCubit>();
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    final conv = chatState.conversations.where(
      (c) => c.id == appState.activeConversationId,
    ).firstOrNull;

    return Container(
      color: t.bg,
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: EdgeInsets.fromLTRB(16, topPad + 14, 16, 12),
            child: Row(
              children: [
                GlideBackButton(
                  onTap: () => appCubit.goTo(AppScreen.chatInbox),
                  tokens: t,
                ),
                const SizedBox(width: 12),
                if (conv != null) ...[
                  GlideAvatar(size: 34, hue: conv.driverAvatarHue, cardColor: t.card),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    conv?.driverName ?? 'Driver',
                    style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700,
                      color: t.ink, letterSpacing: -0.3,
                    ),
                  ),
                ),
                GlideIconPill(
                  icon: Icons.phone_rounded,
                  tokens: t,
                  bgColor: t.accent,
                  iconColor: t.accentInk,
                  iconSize: 18,
                  onTap: () => HapticFeedback.mediumImpact(),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: chatState.isLoading
                ? const SizedBox()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: chatState.messages.length,
                    itemBuilder: (_, i) {
                      final msg = chatState.messages[i];
                      final isLast = i == chatState.messages.length - 1;
                      final showTime = isLast ||
                          chatState.messages[i + 1].isFromDriver != msg.isFromDriver;
                      return _MessageBubble(
                        message: msg,
                        showTime: showTime,
                        tokens: t,
                      );
                    },
                  ),
          ),

          // Quick replies + input
          Container(
            decoration: BoxDecoration(
              color: t.card,
              border: Border(top: BorderSide(color: t.hair)),
            ),
            padding: EdgeInsets.fromLTRB(16, 10, 16, bottomPad + 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick reply chips
                Wrap(
                  spacing: 8,
                  children: ['On my way', '5 minutes away', 'Thanks!'].map((reply) {
                    return TapScale(
                      onTap: () => _send(chatCubit, reply),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: t.subtle,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: t.hair2),
                        ),
                        child: Text(
                          reply,
                          style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600, color: t.ink,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                // Input row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: t.subtle,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: t.hair2),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'Type a message…',
                          style: TextStyle(fontSize: 14, color: t.muted),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TapScale(
                      onTap: () => _send(chatCubit, 'Hey, just checking in!'),
                      child: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: t.accent,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: t.accent.withValues(alpha: 0.35),
                              blurRadius: 10, offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(Icons.send_rounded, color: t.accentInk, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool showTime;
  final GlideTokens tokens;

  const _MessageBubble({
    required this.message,
    required this.showTime,
    required this.tokens,
  });

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tokens;
    final isDriver = widget.message.isFromDriver;
    final body = widget.message.body;
    final sentAt = widget.message.sentAt;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(scale: _scale.value, child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Column(
          crossAxisAlignment: isDriver ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDriver ? t.card : t.accent,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isDriver ? 4 : 18),
                  bottomRight: Radius.circular(isDriver ? 18 : 4),
                ),
                boxShadow: t.shadowSm,
              ),
              child: Text(
                body,
                style: TextStyle(
                  fontSize: 14,
                  color: isDriver ? t.ink : t.accentInk,
                ),
              ),
            ),
            if (widget.showTime) ...[
              const SizedBox(height: 4),
              Text(
                DateFormat('h:mm a').format(sentAt),
                style: TextStyle(fontSize: 11, color: t.muted),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Verify**

```bash
flutter analyze lib/presentation/pages/chat_inbox_page.dart lib/presentation/pages/chat_thread_page.dart
```
Expected: `No issues found.`

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/pages/chat_inbox_page.dart lib/presentation/pages/chat_thread_page.dart
git commit -m "feat: add ChatInboxPage and ChatThreadPage with send animation and quick replies"
```

---

## Task 11: Interactivity pass — HomePage and AccountPage

**Files:**
- Modify: `lib/presentation/pages/home_page.dart`
- Modify: `lib/presentation/pages/account_page.dart`

- [ ] **Step 1: Update `home_page.dart` — wire `+` button and tab callbacks**

In `home_page.dart`, make these targeted changes:

**Add imports at top:**
```dart
import '../widgets/tap_scale.dart';
import '../widgets/top_up_sheet.dart';
```

**Replace the `+` button Container with:**
```dart
TapScale(
  onTap: () => showTopUpSheet(context, t),
  child: Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: t.accent,
    ),
    child: const Icon(Icons.add_rounded, color: kAccentInk, size: 16),
  ),
),
```

**Replace the `GlideTabBar` call with:**
```dart
GlideTabBar(
  active: 'home',
  tokens: t,
  onHome: () {},
  onSettings: () => appCubit.goTo(AppScreen.account),
  onTrips: () => appCubit.goTo(AppScreen.trips),
  onChat: () => appCubit.goTo(AppScreen.chatInbox),
  isRideActive: appState.isRideActive,
),
```

- [ ] **Step 2: Update `account_page.dart` — wire Top Up, TapScale on settings rows, tab callbacks**

**Add imports:**
```dart
import 'package:flutter/services.dart';
import '../widgets/tap_scale.dart';
import '../widgets/top_up_sheet.dart';
```

**Replace the "Top up" button GestureDetector with:**
```dart
TapScale(
  onTap: () => showTopUpSheet(context, t),
  child: Container(
    height: 36,
    padding: const EdgeInsets.symmetric(horizontal: 14),
    decoration: BoxDecoration(
      color: t.accent,
      borderRadius: BorderRadius.circular(999),
    ),
    alignment: Alignment.center,
    child: Text(
      'Top up',
      style: TextStyle(
        fontSize: 13, fontWeight: FontWeight.w700, color: t.accentInk,
      ),
    ),
  ),
),
```

**Replace `_SettingsRow` widget class with:**
```dart
class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final GlideTokens tokens;
  final bool showDivider;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.tokens,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    return TapScale(
      onTap: () => HapticFeedback.selectionClick(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: showDivider ? Border(top: BorderSide(color: t.hair)) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: t.subtle, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: t.ink, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600,
                  color: t.ink, letterSpacing: -0.2,
                ),
              ),
            ),
            Text('›', style: TextStyle(fontSize: 18, color: t.muted)),
          ],
        ),
      ),
    );
  }
}
```

**Replace the `GlideTabBar` call in `_AccountView.build` with:**
```dart
GlideTabBar(
  active: 'settings',
  tokens: t,
  onHome: () => appCubit.goTo(AppScreen.home),
  onSettings: () {},
  onTrips: () => appCubit.goTo(AppScreen.trips),
  onChat: () => appCubit.goTo(AppScreen.chatInbox),
  isRideActive: appState.isRideActive,
),
```

- [ ] **Step 3: Verify**

```bash
flutter analyze lib/presentation/pages/home_page.dart lib/presentation/pages/account_page.dart
```
Expected: `No issues found.`

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/pages/home_page.dart lib/presentation/pages/account_page.dart
git commit -m "feat: wire TopUpSheet and TapScale into Home and Account pages"
```

---

## Task 12: Interactivity pass — ChoosePage and DriverPage

**Files:**
- Modify: `lib/presentation/pages/choose_page.dart`
- Modify: `lib/presentation/pages/driver_page.dart`

- [ ] **Step 1: Update `choose_page.dart` — confirm button shimmer**

**Add imports:**
```dart
import '../widgets/tap_scale.dart';
```

In `_ChooseView`, add a `_confirming` bool to the state (convert to `StatefulWidget`):

Replace `class _ChooseView extends StatelessWidget` with the following. The existing `build` method body moves unchanged into `_ChooseViewState.build`:
```dart
class _ChooseView extends StatefulWidget {
  const _ChooseView();

  @override
  State<_ChooseView> createState() => _ChooseViewState();
}

class _ChooseViewState extends State<_ChooseView> {
  bool _confirming = false;

  // Move the entire existing build() method here, then apply the confirm button change below.
```

Then replace the confirm `GestureDetector` block with:
```dart
TapScale(
  onTap: _confirming
      ? null
      : () async {
          setState(() => _confirming = true);
          await Future.delayed(const Duration(milliseconds: 150));
          if (mounted) appCubit.goTo(AppScreen.searching);
        },
  child: AnimatedOpacity(
    opacity: _confirming ? 0.6 : 1.0,
    duration: const Duration(milliseconds: 100),
    child: Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: t.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: t.accent.withValues(alpha: 0.40),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        chooseState.options.isEmpty
            ? 'Confirm'
            : 'Confirm ${chooseState.options[chooseState.selectedIndex].name}',
        style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w800,
          color: t.accentInk, letterSpacing: -0.2,
        ),
      ),
    ),
  ),
),
```

- [ ] **Step 2: Update `driver_page.dart` — animated progress bar, SafetySheet, ShareToast**

**Add imports:**
```dart
import 'package:flutter/services.dart';
import '../widgets/glide_toast.dart';
import '../widgets/safety_sheet.dart';
import '../widgets/tap_scale.dart';
```

Convert `_DriverView` to `StatefulWidget` and add an `AnimationController`:

Replace `class _DriverView extends StatelessWidget` with:
```dart
class _DriverView extends StatefulWidget {
  const _DriverView();

  @override
  State<_DriverView> createState() => _DriverViewState();
}

class _DriverViewState extends State<_DriverView> with SingleTickerProviderStateMixin {
  late final AnimationController _progress;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..animateTo(0.72, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }
```

Replace the hardcoded progress bar `FractionallySizedBox(widthFactor: 0.72, ...)` with:
```dart
AnimatedBuilder(
  animation: _progress,
  builder: (context, _) => FractionallySizedBox(
    widthFactor: _progress.value,
    child: Container(color: t.accent),
  ),
),
```

Replace the three `MiniButton` widgets with:
```dart
TapScale(
  onTap: () => showSafetySheet(context, t),
  child: _MiniButtonContent(
    icon: Icons.verified_user_outlined,
    label: 'Safety',
    tokens: t,
  ),
),
const SizedBox(width: 8),
TapScale(
  onTap: () {
    Clipboard.setData(const ClipboardData(
      text: 'https://glide.app/track/abc123',
    ));
    showGlideToast(context, 'Trip link copied', t);
  },
  child: _MiniButtonContent(
    icon: Icons.ios_share_rounded,
    label: 'Share trip',
    tokens: t,
  ),
),
const SizedBox(width: 8),
TapScale(
  onTap: () => appCubit.goTo(AppScreen.home),
  child: _MiniButtonContent(
    icon: Icons.close_rounded,
    label: 'Cancel',
    tokens: t,
    isCancel: true,
  ),
),
```

Add this private widget class at the bottom of `driver_page.dart`:
```dart
class _MiniButtonContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final GlideTokens tokens;
  final bool isCancel;

  const _MiniButtonContent({
    required this.icon,
    required this.label,
    required this.tokens,
    this.isCancel = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    return Expanded(
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isCancel ? t.cancelBg : t.card,
          borderRadius: BorderRadius.circular(14),
          border: isCancel ? null : Border.all(color: t.hair, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isCancel ? t.cancelInk : t.ink, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isCancel ? t.cancelInk : t.ink,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

Also remove the `MiniButton` imports from `driver_page.dart` if it was using the one from `common_widgets.dart` (the new `_MiniButtonContent` replaces it locally).

- [ ] **Step 3: Verify**

```bash
flutter analyze lib/presentation/pages/choose_page.dart lib/presentation/pages/driver_page.dart
```
Expected: `No issues found.`

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/pages/choose_page.dart lib/presentation/pages/driver_page.dart
git commit -m "feat: add confirm shimmer, progress animation, SafetySheet and ShareToast to Choose/Driver pages"
```

---

## Task 13: Full verify and smoke test

- [ ] **Step 1: Run all tests**

```bash
flutter test
```
Expected: `All tests passed!`

- [ ] **Step 2: Run full analyze**

```bash
flutter analyze lib/
```
Expected: `No issues found.`

- [ ] **Step 3: Build for iOS simulator (compile check)**

```bash
flutter build ios --simulator --debug 2>&1 | tail -5
```
Expected: `Build complete.` (or `Installed build/ios/...`)

- [ ] **Step 4: Final commit**

```bash
git add -A
git commit -m "feat: trips, chat, and interactivity layer complete"
```
