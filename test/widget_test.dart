import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jawalingo/main.dart';

void main() {
  testWidgets('App boots to splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: JawaLingoApp()));
    await tester.pump();

    expect(find.text('JAWALINGO'), findsOneWidget);
  });
}
