# Glide — Trips, Chat & Interactivity Design

**Date:** 2026-05-10  
**Status:** Approved  
**Scope:** Add Trips tab, Chat inbox + thread, and a full interactivity pass across existing screens.

---

## 1. Domain Layer

### New Entities (pure Dart, no Flutter imports)

**`Trip`**
```
id, destination, originAddress, driverName, driverAvatarHue,
rideType (enum: glide | xl | lux | eco),
price, date, durationMinutes,
rating (double?, null = unrated),
status (enum: completed | cancelled)
```

**`ChatConversation`**
```
id, driverName, driverAvatarHue,
lastMessage, lastMessageTime, unreadCount, tripId
```

**`ChatMessage`**
```
id, conversationId, body, isFromDriver, sentAt
```

### Repository Interfaces (abstract classes)

- `TripRepository` → `getHistory(): Future<Either<Failure, List<Trip>>>`
- `ChatRepository` → `getConversations(): Future<Either<Failure, List<ChatConversation>>>`, `getMessages(conversationId): Future<Either<Failure, List<ChatMessage>>>`

### Use Cases

- `GetTripHistory(TripRepository)` — `NoParams`
- `GetChatConversations(ChatRepository)` — `NoParams`
- `GetChatMessages(ChatRepository)` — `GetChatMessagesParams(conversationId)`

### In-Memory Datasources

- `TripLocalDatasource` / `TripLocalDatasourceImpl` — 8 seed trips across 2 months (April + May 2026), mix of completed and 1 cancelled
- `ChatLocalDatasource` / `ChatLocalDatasourceImpl` — 3 conversations, each with 5–6 messages alternating driver/user

### DI Registration (`injection_container.dart`)

New cubits (factory), use cases (lazy singleton), repositories (lazy singleton bound to interface), datasources (lazy singleton).

---

## 2. Navigation

`AppScreen` enum gains: `trips`, `chatInbox`, `chatThread`

`AppState` gains: `activeConversationId` (String?, null = no thread open)

`AppCubit` gains:
- `goToChat(String conversationId)` — sets screen to `chatThread` + stores `activeConversationId`

`GlideFlow` switch case handles the two new root tabs and the thread view.

`GlideTabBar` gains `onTrips` and `onChat` callback parameters. All pages that render a tab bar pass these through.

---

## 3. Trips Page

**`TripsPage`** — outer BlocProvider creates `TripHistoryCubit` and calls `load()`.

**`TripHistoryCubit`** state: `{ trips: List<Trip>, isLoading, error }`

**Layout:**
1. Summary card (full-width, accent-tinted background): month name, total trips, total spent, 4-week spend bar chart (simple `CustomPaint` — 4 bars, current week highlighted in accent, others in hair2)
2. `ListView` with sticky month-group headers (`APRIL 2026` in muted caps, 12px)
3. Each trip row:
   - Left: `GlideAvatar` (driver hue) stacked with a small ride-type icon badge
   - Center: destination bold (15px w700), `originAddress · date · duration` muted (12px)
   - Right: price bold (15px) + star rating row (5 small dots, filled = accent, empty = hair2); cancelled trips show `Cancelled` pill (cancelBg / cancelInk)
   - Far right: `›` chevron
4. Tap row → `AnimatedSize` expands inline detail card:
   - Mini route: pickup dot (accent ring) → vertical line → dropoff square (ink), address labels alongside
   - "Book again" button (accent, full-width inside the card)
   - Tapping "Book again" navigates to `AppScreen.whereTo`

---

## 4. Chat Pages

### `ChatInboxPage`

**`ChatCubit`** state: `{ conversations: List<ChatConversation>, messages: List<ChatMessage>, isLoading, error }` — `getMessages` is called lazily when entering a thread (not pre-loaded for all conversations)

Layout:
- Header: "Messages" (17px w700), no back button (root tab)
- `ListView` of conversation rows:
  - `GlideAvatar` (driver hue)
  - Driver name bold, last message preview muted (1 line, ellipsis)
  - Timestamp right-aligned (muted, 11px)
  - Unread badge (accent circle, accentInk text, hidden if 0)
- Tap row → `appCubit.goToChat(conversation.id)`

### `ChatThreadPage`

Provided with `activeConversationId` from `AppState`.

Layout:
- Top bar: `GlideBackButton` (→ `AppScreen.chatInbox`), avatar + driver name centered, phone `GlideIconPill` right (haptic on tap)
- Message list (`ListView` with `reverse: false`, auto-scrolls to bottom on load and on new message):
  - Driver bubbles: left-aligned, card background, ink text, 14px
  - User bubbles: right-aligned, accent background, accentInk text, 14px
  - Timestamp label below each group (muted, 11px)
- Quick reply chips (horizontal `Wrap` above input): "On my way", "5 minutes away", "Thanks!" — tapping appends as sent message with scale-in animation
- Bottom bar: static text field (non-editable placeholder "Type a message…"), send button (accent) — tapping appends "You: [placeholder text]" bubble

**Send animation:** new bubble starts at `scale: 0.8, opacity: 0`, animates to `scale: 1.0, opacity: 1` over 200ms.

---

## 5. Interactivity Layer

### `_TapScale` wrapper widget
Stateful widget wrapping any tappable child. On `onTapDown`: animates to `scale: 0.95` (80ms). On `onTapUp`/`onTapCancel`: springs back (120ms). Applied to: all back buttons, ride tiles, list rows, action pills, settings rows.

### Home screen
- Balance `+` button: `_TapScale` + shows `_TopUpSheet` bottom sheet

### `_TopUpSheet` (shared bottom sheet widget)
- Three amount buttons: £10, £25, £50 (outlined cards, selected = accent fill)
- "Add to wallet" confirm button → dismisses sheet + shows `_GlideToast`
- Used by both Home `+` button and Account "Top up" button

### `_GlideToast`
- Overlay entry, appears at bottom above tab bar, slides up + fades in (200ms), auto-dismisses after 2s, slides down + fades out
- Text: "£{amount} added to your wallet ✓" (or custom message for other uses)

### Choose screen
- Confirm button: on tap, shows 150ms shimmer/opacity pulse on the button itself before navigating

### Driver screen
- Progress bar: `AnimationController` runs 0→0.72 over 800ms with `Curves.easeOut` on mount (replaces hardcoded `widthFactor: 0.72`)
- "Safety" button: shows `_SafetySheet` — fake emergency contacts list (3 entries with avatars + phone numbers), close button
- "Share trip" button: writes fake URL to `Clipboard`, shows `_GlideToast("Trip link copied")`

### Account screen
- "Top up" button: shows `_TopUpSheet`
- Settings rows: `_TapScale` + `HapticFeedback.selectionClick()` on tap

### FAB (in `GlideTabBar`)
- `AppCubit` state watched via `context.watch` inside `GlideTabBar` (or passed as `isRideActive` bool param)
- When `isRideActive` (`screen == searching || screen == driver`): `AnimationController` repeating scale 1.0→1.08→1.0 over 2s, `Curves.easeInOut`
- When not active: static (controller stopped)

### Tab bar wiring
- `GlideTabBar` new params: `onTrips`, `onChat` (both `VoidCallback?`)
- `HomePage` and `AccountPage` pass: `onTrips: () => appCubit.goTo(AppScreen.trips)`, `onChat: () => appCubit.goTo(AppScreen.chatInbox)`
- `TripsPage` and `ChatInboxPage` also render `GlideTabBar` with same wiring

---

## 6. File Plan

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
```

### Modified files
```
lib/domain/usecases/get_chat_messages.dart   (params class)
lib/injection_container.dart                  (register new deps)
lib/presentation/cubits/app_cubit.dart        (new screens, goToChat, isRideActive)
lib/presentation/flow/glide_flow.dart         (new switch cases)
lib/presentation/widgets/common_widgets.dart  (GlideTabBar: onTrips/onChat/isRideActive params, FAB pulse animation)
lib/presentation/pages/home_page.dart         (TopUpSheet, tab wiring)
lib/presentation/pages/choose_page.dart       (confirm shimmer)
lib/presentation/pages/driver_page.dart       (progress animation, SafetySheet, ShareToast)
lib/presentation/pages/account_page.dart      (TopUpSheet, tap scale on settings rows, tab wiring)
lib/presentation/pages/trips_page.dart        (new)
lib/presentation/pages/chat_inbox_page.dart   (new)
lib/presentation/pages/chat_thread_page.dart  (new)
```

---

## 7. Out of Scope

- Real network calls or persistent storage
- Actual clipboard on all platforms (best-effort, wrapped in try/catch)
- Push notifications
- Keyboard handling on the Chat thread input (static placeholder only)
