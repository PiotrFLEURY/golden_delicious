import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_delicious/golden_delicious.dart';

void main() {
  goldenFileComparator = goldenDeliciousComparator;

  testWidgets('Golden test', (tester) async {
    await tester.pumpWidget(const MyApp());
    await expectLater(
      find.byType(MyApp),
      matchesGoldenFile('goldens/my_app.png'),
    );
  }, tags: ['golden']);

  // Simple golden test for MyApp Widget
}
