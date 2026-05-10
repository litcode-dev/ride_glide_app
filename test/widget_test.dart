import 'package:flutter_test/flutter_test.dart';
import 'package:ride_app/main.dart';
import 'package:ride_app/injection_container.dart' as di;

void main() {
  setUpAll(() async {
    await di.init();
  });

  testWidgets('Glide app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GlideRoot());
    expect(find.byType(GlideRoot), findsOneWidget);
  });
}
