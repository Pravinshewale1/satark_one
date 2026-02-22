import 'package:flutter_test/flutter_test.dart';
import 'package:satark_one/main.dart';

void main() {
  testWidgets('App launches', (tester) async {
    await tester.pumpWidget(const SatarkOneApp());
    expect(find.byType(SatarkOneApp), findsOneWidget);
  });
}
