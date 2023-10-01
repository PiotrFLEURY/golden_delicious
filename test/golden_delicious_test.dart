import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:golden_delicious/golden_delicious.dart';

void main() {
  group('goldenDeliciousComparator', () {
    test('Same picture', () async {
      LocalFileComparator comparator = goldenDeliciousComparator;

      // current path
      final currentPath = Directory.current.path;

      final filePath = '$currentPath/test/goldens/my_app.png';

      final bytes = File(filePath).readAsBytesSync();

      final result = await comparator.compare(bytes, Uri.parse(filePath));

      expect(result, true);
    });
    group('Totally different picture', () {
      test('without tolerance', () async {
        LocalFileComparator comparator = goldenDeliciousComparator;

        // current path
        final currentPath = Directory.current.path;

        final goldenPath = '$currentPath/test/goldens/my_app.png';

        final comparingPath = '$currentPath/test/goldens/my_golden_app.png';

        final bytes = File(comparingPath).readAsBytesSync();

        await expectLater(
          comparator.compare(bytes, Uri.parse(goldenPath)),
          throwsFlutterError,
        );
      });
      test('2% tolerance with 3.357986111111111% diff', () async {
        GoldenDeliciousComparator comparator = goldenDeliciousComparator;
        // 100% tolerance
        comparator.tolerance = 0.02;

        // current path
        final currentPath = Directory.current.path;

        final goldenPath = '$currentPath/test/goldens/my_app.png';

        final comparingPath = '$currentPath/test/goldens/my_app_diff.png';

        final bytes = File(comparingPath).readAsBytesSync();

        await expectLater(
          comparator.compare(bytes, Uri.parse(goldenPath)),
          throwsFlutterError,
        );
      });
      test('5% tolerance with 3.357986111111111% diff', () async {
        GoldenDeliciousComparator comparator = goldenDeliciousComparator;
        // 100% tolerance
        comparator.tolerance = 0.05;

        // current path
        final currentPath = Directory.current.path;

        final goldenPath = '$currentPath/test/goldens/my_app.png';

        final comparingPath = '$currentPath/test/goldens/my_app_diff.png';

        final bytes = File(comparingPath).readAsBytesSync();

        final result = await comparator.compare(bytes, Uri.parse(goldenPath));

        expect(result, true);
      });
      test('100% tolerance', () async {
        GoldenDeliciousComparator comparator = goldenDeliciousComparator;
        // 100% tolerance
        comparator.tolerance = 1;

        // current path
        final currentPath = Directory.current.path;

        final goldenPath = '$currentPath/test/goldens/my_app.png';

        final comparingPath = '$currentPath/test/goldens/my_golden_app.png';

        final bytes = File(comparingPath).readAsBytesSync();

        final result = await comparator.compare(bytes, Uri.parse(goldenPath));

        expect(result, true);
      });
    });
  });
}
