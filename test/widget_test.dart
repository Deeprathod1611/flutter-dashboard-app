import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dashboard_app/main.dart';

void main() {
  testWidgets('Dashboard app test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MyApp), findsOneWidget);
  });
}