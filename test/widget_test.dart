import 'package:flutter_test/flutter_test.dart';
import 'package:ride_app/main.dart';

void main() {
  testWidgets('Glide app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GlideRoot());
    expect(find.byType(GlideRoot), findsOneWidget);
  });
}
